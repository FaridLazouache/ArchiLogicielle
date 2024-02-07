sudo docker stop database && sudo docker rm database
#sudo docker image rm database_image
sudo docker build -t database_image .
#sudo docker run -d -e POSTGRES_PASSWORD=root -p 5432:5432 --name database database_image
sudo docker run -d -e POSTGRES_PASSWORD=postgresroot -p 5432:5432 --name database postgres
#sudo docker cp init.sql database:/tmp/
#sudo docker exec database /bin/bash psql -h localhost -U postgres -f init.sql
