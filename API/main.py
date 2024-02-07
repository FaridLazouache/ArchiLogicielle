from typing import Union
from fastapi import FastAPI
import psycopg2
import os
from starlette.responses import FileResponse

app = FastAPI()
DB_HOST = os.environ.get("DB_HOST")
conn = psycopg2.connect(database="magasin", user="postgres", host=DB_HOST, password="postgresroot")

# Launch login page
@app.get("/login")
def read_login():
    return FileResponse('../frontpage/index.html')

# article(id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL, price MONEY, stock INT, item_desc VARCHAR(100))

# Display the selected article
@app.get("/item/{item_id}")
def get_item(item_id: int):
    cur = conn.cursor()
    cur.execute("SELECT * FROM article WHERE id = %s;", (item_id,))
    output = cur.fetchall()
    cur.close()
    return {"data": output}
   
# Display every articles
@app.get("/items")
def display_all():
    cur = conn.cursor()
    cur.execute("SELECT * FROM article;")
    output = cur.fetchall()
    cur.close()
    return {"data": output}

# Add an article to the database
# @app.get("/add/{name}")
# def add_item(name: string):
#     cur = conn.cursor()
#     cur.execute("INSERT INTO article(id, name)"
