# MySQL + Flask Boilerplate Project

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 

## Project Description
Our project is an personal finance management application we call Pocket Protectors, the group members are Donny Le, Trayna Bui, Tisya Sharma, and Jasmine McCoy.

Although we did not have to create a login page and could have made separate homepages for each user, we believe the usability and personalisation of the application from our starting page, the Dashboard, is equally as useful for each of our personas. As such, we opted to build out a login that would allow us to keep track of the user and their information as they navigate the site.

For ease of presentation here is an existing email and password to login as a user:

**Email** user1@example.com
**Password** password123

From there, the user is able to keep track of what they bought by creating a receipt, create and join groups, track their investments, and create spending goals.

## We have an email and password for each one of our personas:

User Persona 1: Busy Professional Sophia
Email: sophia@example.com
Password: sophia_password

User Persona 2: Conscious College Student David
Email: david@example.edu
Password: david_password

User Persona 3: Stay at home mom Maria
Email: maria@example.com
Password: maria_password

User Persona 4: Retired Man John
Email: john@example.com
Password: john_password

