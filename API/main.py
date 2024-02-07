from typing import Union, Optional
from fastapi import FastAPI, HTTPException
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

# Add an article
@app.post("/add/{name}")
def create_item(name: str):
    try:
        cur = conn.cursor()
        cur.execute("INSERT INTO article (name) VALUES (%s);", (name,))
        conn.commit()
        cur.close()
        return {"message": "Item created successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))

# Modify an article    
@app.put("/modify/{item_id}/")
def modify_item(item_id: int, name: Optional[str] = None, price: Optional[float] = None, stock: Optional[int] = None, item_desc: Optional[str] = None):
    try:
        cur = conn.cursor()
        query = "UPDATE article SET "
        params = []
        if name is not None:
            query += "name = %s, "
            params.append(name)
        if price is not None:
            query += "price = %s, "
            params.append(price)
        if stock is not None:
            query += "stock = %s, "
            params.append(stock)
        if item_desc is not None:
            query += "item_desc = %s, "
            params.append(item_desc)
        query = query.rstrip(', ')
        query += " WHERE id = %s;"
        params.append(item_id)
        
        cur.execute(query, params)
        conn.commit()
        cur.close()
        return {"message": "Item modified successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    
# Delete an article
@app.delete("/delete/{item_id}")
def delete_item(item_id: str):
    try:
        cur = conn.cursor()
        cur.execute("DELETE FROM article WHERE id=%s;", (item_id,))
        conn.commit()
        cur.close()
        return {"message": "Item deleted successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    
# Delete every articles    
@app.delete("/purge")
def purge_database():
    try:
        cur = conn.cursor()
        cur.execute("DELETE FROM article;")
        conn.commit()
        cur.close()
        return {"message": "Database successfully purged"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
