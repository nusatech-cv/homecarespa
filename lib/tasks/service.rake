namespace :service do
    ENV['APP_DOMAIN'] = @config['app']['domain']
    @switch = Proc.new do |args, start, stop|
        case args.command
        when 'start'
            start.call
        when 'stop'
            stop.call
        when 'restart'
            stop.call
            start.call
        else
            puts "unknown command #{args.command}"
        end
    end

    desc 'Run Traefik (reverse-proxy)'
    task :proxy, [:command] do |task, args|
        args.with_defaults(:command => 'start')

        def start
            puts '----- Starting the proxy -----'
            File.new('config/acme.json', File::CREAT, 0600) unless File.exist? 'config/acme.json'
            sh 'docker-compose up -d proxy gateway'
        end

        def stop
            puts '----- Stopping the proxy -----'
            sh 'docker-compose rm -fs proxy gateway'
        end

        @switch.call(args, method(:start), method(:stop))
    end

    desc 'Run backend (vault db rabbitmq)'
    task :backend, [:command] do |task, args|
        args.with_defaults(:command => 'start')

        def start
            puts '----- Starting dependencies -----'
            sh 'docker-compose up -d vault db rabbitmq socket'
            sleep 7
        end

        def stop
            puts '----- Stopping dependencies -----'
            sh 'docker-compose rm -fs vault db rabbitmq socket'
        end
        @switch.call(args, method(:start), method(:stop))
    end

    desc 'Run setup vault for application'
    task :setup, [:command] => ['vault:setup', 'vault:load_policies'] do |task, args|
        if args.command != 'stop'
            Rake::Task["render:config"].execute
            puts '----- Running hooks -----'
            sh 'docker-compose run --rm api bash -c "rake db:setup"'
        end
    end

    desc 'Run the application'
    task :app, [:command] do |task, args|
      @app = %w[mailer notification api admin]
  
      args.with_defaults(:command => 'start')
  
      def start
        puts '----- Starting the application -----'
        sh "docker-compose up -d #{@app.join(' ')}"
      end
  
      def stop
        puts '----- Stopping the application -----'
        sh "docker-compose up -d #{@app.join(' ')}"
      end
  
      @switch.call(args, method(:start), method(:stop))
    end

    desc 'Set up and start all services'
    task :all, [:command] => ['render:config'] do |task, args|
        args.with_defaults(:command => 'start')
        def start
            Rake::Task["service:proxy"].invoke('start')
            Rake::Task["service:backend"].invoke('start')
            Rake::Task["service:setup"].invoke('start')
            Rake::Task["service:app"].invoke('start')
        end

        def stop
            Rake::Task["service:proxy"].invoke('stop')
            Rake::Task["service:backend"].invoke('stop')
            Rake::Task["service:setup"].invoke('stop')
            Rake::Task["service:app"].invoke('stop')
        end
        @switch.call(args, method(:start), method(:stop))
    end
  end
