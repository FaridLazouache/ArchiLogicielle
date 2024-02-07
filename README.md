# ArchiLogicielle
Documentation RDS : https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html

# Repository
## Terraform
- Most of the changes were made in 04-network.tf
- The file project.tf got a bit modified
## API
- The project file is the API/main.py 
- The shell script just runs the uvicorn command
## Exercises
- Practical exercises are located in the folder teraform-labs-flazouac

# Terraform
- Go to the terraform folder
- Make sure to have your AWS credentials written in the ~/.aws/credentials file
- If you don't have an API Workspace, create one : ```terraform workspace new API```
- To launch the terraform process, use this command : ```terraform apply```

# Local Database
- Go to the postgres folder
- Launch the script launch_server.sh using : ```./launch_server.sh```
- Create the database using this command : ``` psql -h localhost -U postgres -f init.sql```. The DB's password can be seen inside the script.

# API
- Make sure the database is running (locally or remotely)
- Go to the folder API
- Run the script launch_server.sh using the command : ```./launch_server.sh```
- The API uses the port 5964
- Future login page will be at `/login` url
- The documentation is available at `/docs`
## Installing API in AWS
- To connect to bastion from external and to EC2 from bastion use the command below : <br>```ssh ec2-user@[DESTINATION_IP] -i "[KEY_PATH]```
- Now, connect to EC2 using the command below : <br>
```ssh ec2-user@[EC2_IP] -i "~/.ssh/[EC2_KEY]```
- Create frontpage and API folder, then go to API <br>
`mkdir -p frontpage API && cd API`
- get code using the commands below : <br>
```curl https://raw.githubusercontent.com/FaridLazouache/ArchiLogicielle/develop/API/main.py >> main.py``` <br>
```curl https://raw.githubusercontent.com/FaridLazouache/ArchiLogicielle/develop/API/launch_server_AWS_EC2.sh >> launch_server.sh```
- Get the DB ip address using `host [DB Terminal point]`
- Add the DB ip address using `export DB_HOST=[IP_ADDRESS]`
- launch the script : `./launch_server.sh`

## Setting up port Forwarding
- Inside Bastion EC2, run the command ```sudo iptables -t nat -A PREROUTING -p tcp --dport 5964 -j DNAT --to-destination [API EC2's IP]:5964``` to forward request to the API, then run the command ```sudo iptables-save``` to save the port forwarding in case of a reboot
- Install apache webserver for HTTP request forwarding : <br>
`sudo yum update -y`<br>
`sudo yum install httpd.x86_64 -y`<br>
`sudo systemctl start httpd`<br><br>
:warning: <b> yet, HTTP Forwarding (using httpd), seems not working </b> :warning: <br><br>
- Create a HTTP Forwarding using Apache VirtualHost : <br>
```sudo curl https://raw.githubusercontent.com/FaridLazouache/ArchiLogicielle/develop/API/virtualhost.conf >> /etc/httpd/conf.d/virtualhost.conf && sudo systemctl restart httpd``` <br>


<br>

# key

<b>:warning: MAKE SURE TO CHMOD 400 THE KEY FILE :warning:</b>

-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAvsgXUXwZBpJnmNaAGexZXxl/GL176yfju7VMaouV7sEjxN469AhI
ola7KI0X4qGOTpH63cDk3VJ6AkO0fNP3c0M8jr3HpC0qU+INXkVWOFjO0MNFoCzbDrpdZK
l90hv88egZDd8p33WoSz5PhhdSboUPpA+DCyyz1vrowlxw0CMy388VxSPXCBY2e9dVIISu
6vjbTUKqcXdepXjj1ECgtwWNVUljNqPd/88MCJv1777GYio1p+ao7nBPYqvsNhX6SbiQ3q
O4RuGHRTRXD4sWKSQy/K1kXZG3hY3YquMobWaAQNsM+OBrnCGfzTvSI5QS/iyGqKjOFdr4
Em71Wn2GtwAAA8jAEL9awBC/WgAAAAdzc2gtcnNhAAABAQC+yBdRfBkGkmeY1oAZ7FlfGX
8YvXvrJ+O7tUxqi5XuwSPE3jr0CEiiVrsojRfioY5OkfrdwOTdUnoCQ7R80/dzQzyOvcek
LSpT4g1eRVY4WM7Qw0WgLNsOul1kqX3SG/zx6BkN3ynfdahLPk+GF1JuhQ+kD4MLLLPW+u
jCXHDQIzLfzxXFI9cIFjZ711UghK7q+NtNQqpxd16leOPUQKC3BY1VSWM2o93/zwwIm/Xv
vsZiKjWn5qjucE9iq+w2FfpJuJDeo7hG4YdFNFcPixYpJDL8rWRdkbeFjdiq4yhtZoBA2w
z44GucIZ/NO9IjlBL+LIaoqM4V2vgSbvVafYa3AAAAAwEAAQAAAQAGYMwexkZT6OsbufgY
ZcVrH4AXRKZy6yd67Am8+iOuErjuaPuRkwFSpBGnvmfRBNOsHsdDSKKeH5bCop7TGYcJTH
Mm1oNpIrVqjoEh6LGEOrvXUN/wBe/g4ywiJGR3dMYVFExaIV7WAKn6sf+YnQj9dudZ9cbM
xdbRVhwX+10uKCA4uQeiULh0rrU4TMNiK8N1hcUhD0fXYUVi5Cpvb8qnF+gF52B2IjkJfY
lZyS4AfMsjsnWjvWaZT9OqeciT5mEhOsmica3ZmHbYcIFA/aEwq+Z19WMONP8LGfX+3dGe
g/kIDCaFVP4k5WtNeVokoUaYzgDu1Bwoz0qemKyzPl5pAAAAgQDzW6ZX2l1TU8DszQ+Z4X
ZFIynJbCxEp99wB5afhLrqbOmurwWiI+GKSEIILJUCZcaw4JkPowb0j/SI1gBxL++X8qg/
lPQtwnKrzpHYCYZpjpIFejgfEuKVcgRSuFUWmSj6e0CzrUUonlFMscI3R7T0uEqyD9FhWh
zdwPZrEF2DHwAAAIEA97yk4kr6bjDbVLsd4v3fKMY4jkYA61oKZo4kZpLfXpdl6Vsoe7f8
4ruxGdBr6FcrvmV+1XEQojkhxQg8TmRbFjf08ANfeCxEXcOubm7SK+hcTaTTCZAwhOt8KA
M8CrtA49LsO05eweWex0KVTdbQk+tYsGHEz1v9WE6G1sQyjjMAAACBAMUlHy0gnqDgrNBX
r40iKXs+bffe5gmPLNmxfxkrJ0teEYwp3rqvS5dmZsHPM7MzEBhngnEiCJQ8rS9MXMx53s
H/UBZ9LCWMf27N5YVfEikyDFmAEHNi7lAmvvRxdcCItz+noaMbUMR7jp+m92p63f4wFaZG
TSdldBDhjNTenBltAAAAEmE3OTMyNDlAV0wtNlNWUUZCMw==
-----END OPENSSH PRIVATE KEY-----