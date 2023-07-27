# HomeCareSPA

HomeCareSPA is an extensive, scalable software architecture, providing an adaptable platform for developing intricate software applications. This project offers a vast span of features, including configurations, templates, scripts, and libraries that aid in building and managing complex applications.

## Project Structure

The project contains several key directories and files:

- `Gemfile` and `Gemfile.lock`: They're used by Bundler to manage the Ruby gem dependencies for the project.
- `Rakefile`: Contains various tasks that are used to manage and run different parts of the application.
- `bin`: Holds executables. The `install.sh`, `gen_key.sh`, and `start.sh` scripts handle project setup and initialization.
- `compose`: Contains Docker Compose configuration files.
- `config`: Holds the application's configuration files like environment variables, API keys, etc.
- `lib`: Contains application-specific libraries that carry out tasks like rendering and vault management.
- `templates`: Features template files (`*.erb`) used by Ruby to dynamically produce configurations.
- `terraform`: Contains files necessary for handling infrastructure management using Terraform.

## Usage

There is 3 ways to build the application on server using this project:

### 1. Using SHELL Scripts

#### Installation

1. Clone the project repository to your remote server.
2. Navigate into the directory containing the project.
3. Make sure to change `config/app.example.yml` into `config/app.yml` and fill with the actual data.
4. Run the generator key script: `./bin/gen_key.sh`
5. Run the install script: `./bin/install.sh`

#### Starting the Application

After installation is completed, you can run the application using the start script: `./bin/start.sh`

### 2. Using Tasks of Rake

#### Leveraging Rake Tasks

The project encapsulates a series of Rake tasks that enable smooth project management. These tasks are invoked through the `rake` command followed by the respective task name. Here is a brief overview of the tasks:

- `rake render:config`: Renders configuration files and keys by collating data specified in the compose files.

- `rake service:all[command]`, `rake service:app[command]`, `rake service:backend[command]`, `rake service:proxy[command]`, `rake service:setup[command]`: These tasks manage different architectural components, including the application, backend services, the Traefik reverse proxy, and Vault setup. They take a command argument that can be `start`, `stop`, `restart`, etc.

- `rake terraform:apply`, `rake terraform:destroy`, `rake terraform:init`, `rake terraform:install`: These tasks allow comprehensive management of the application's infrastructure using Terraform.

- `rake vault:setup`: It initializes, unseals and sets secrets for Vault, enabling secure secret management for the application. 

To probe further into the specifics of each task, explore the `Rakefile` as well as the individual `*.rake` task files inside the `lib/tasks` directory.

#### Running the Services

1. Clone the project repository to your remote server.
2. Navigate into the directory containing the project.
3. Make sure to change `config/app.example.yml` into `config/app.yml` and fill with the actual data.
4. Run the generator key script: `./bin/gen_key.sh`

You can start all the components of the application using the Rake task `service:all`. This command will initiate all services including the application, backend services, and the Traefik reverse proxy.

```bash
$ rake service:all[start]
```

The `[start]` argument signifies that you want to start the services. You can replace `start` with `stop` to stop the services, or `restart` to restart the services. If your Vault requires setup, you can run:

```bash
$ rake service:setup[start]
```

### 3. Using Terraform for Infrastructure Management

#### Build the Platform

The project infrastructure is managed using Terraform. In order to utilize Terraform for setting up your infrastructure, follow these steps:

1. Clone the project repository to your local machine.
2. Navigate into the directory containing the project.
3. Make sure to change `config/app.example.yml` into `config/app.yml` and fill with the actual data.
4. Run the generator key script: `./bin/gen_key.sh`

5. First, install Terraform: 

```bash
$ rake terraform:install
```

6. Then initialize your Terraform configuration:

```bash
$ rake terraform:init
```
  
This will initialize your working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration.

7. You can preview the changes to be applied using: 

```bash
$ rake terraform:plan
```

This command will determine what actions are necessary to achieve the desired state specified in the configuration files.

8. To implement the changes, you can run:

```bash
$ rake terraform:apply
```
  
With this, Terraform will apply the changes required to reach the desired state of the configuration.

If at any point you want to destroy the Terraform-managed infrastructure, run:

```bash
$ rake terraform:destroy
```

Remember, working with Terraform requires knowledge about cloud resources. If you need to manage the infrastructure in a different cloud environment or need a different setup for your resources, make sure to update the Terraform files in the `terraform` directory accordingly.

## Conclusion

HomeCareSPA provides a flexible and adaptable foundation for developing complex solutions. With services encapsulated as Rake tasks, it offers a high level of abstraction to perform the common tasks necessary to manage a web project – from handling infrastructure using Terraform to managing Dockerized services with individual tasks. Having a solid understanding of these tools is vital for maximizing the efficiency and smooth operation of the project.

For more information, feel free to explore the codebase, or raise an issue in the project's repository. Happy coding!