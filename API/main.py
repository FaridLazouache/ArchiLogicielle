from typing import Union
from fastapi import FastAPI
import psycopg2
from starlette.responses import FileResponse

app = FastAPI()
conn = psycopg2.connect("dbname=magasin user=postgres host=localhost password=root ")

# Launch login page
@app.get("/login")
def read_login():
    return FileResponse('../frontpage/index.html')

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
