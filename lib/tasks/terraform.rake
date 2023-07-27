require 'io/console'
namespace :terraform do   
    ENV['HOST_IP'] = @config['server']['ip_address']
    ENV['SSH_USER'] = @config['server']['user']

    desc 'Initialize the Terraform configuration'
    task :init do
        Dir.chdir('terraform') { sh 'terraform init' }
    end
  
    desc 'Apply the Terraform configuration'
    task :apply => [:init] do
        password = $stdin.getpass('Enter your SSH password: ')
        ENV['PASSWORD'] = password.chomp
        Dir.chdir('terraform') { sh "terraform apply -var='host_ip=#{ENV['HOST_IP']}' -var='ssh_user=#{ENV['SSH_USER']}' -var='ssh_password=#{ENV['PASSWORD']}'" }
    end

    desc 'Destroy the Terraform infrastructure'
    task :destroy do
        password = $stdin.getpass('Enter your SSH password: ')
        ENV['PASSWORD'] = password.chomp
        Dir.chdir('terraform') { sh "terraform destroy -var='host_ip=#{ENV['HOST_IP']}' -var='ssh_user=#{ENV['SSH_USER']}' -var='ssh_password=#{ENV['PASSWORD']}' " }
    end

    desc 'Install Terraform'
    task :install do
        sh 'curl -LO https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip'
        sh 'unzip terraform_1.0.4_linux_amd64.zip -d /tmp'
        sh 'sudo mv /tmp/terraform /usr/local/bin/'
        sh 'sudo rm terraform_1.0.4_linux_amd64.zip'
    end
end