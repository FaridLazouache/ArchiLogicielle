sudo pip-3 install uvicorn 
sudo pip-3 install fastapi
sudo pip-3 install psycopg2-binary
export PATH=$PATH/usr/local/bin:
curl https://raw.githubusercontent.com/FaridLazouache/ArchiLogici
elle/develop/postgres/init.sql >> init.sql
sudo yum update -y 
sudo amazon-linux-extras install postgresql10 
psql -h $DB_HOST -U postgres -f init.sql
uvicorn main:app --reload --host $DB_HOST --port 5964
