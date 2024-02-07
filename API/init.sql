CREATE DATABASE magasin;
\c magasin
CREATE TABLE article(id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL, price MONEY, stock INT, item_desc VARCHAR(100));
INSERT INTO article(name, price, stock, item_desc) VALUES(0001, 'banane', 0.67, 654, 'Fruit jaune poussant sur un bananier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0002, 'pomme', 0.54, 654, 'Fruit rouge poussant sur un pommier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0003, 'ananas', 0.68, 654, 'Fruit jaune poussant sur un bananier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0004, 'kiwi', 0.69, 654, 'Fruit jaune poussant sur un bananier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0005, 'cerise', 0.59, 654, 'Fruit jaune poussant sur un bananier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0006, 'raisin', 0.67, 654, 'Fruit jaune poussant sur un bananier');
INSERT INTO article(name, price, stock, item_desc) VALUES(0007, 'orange', 0.67, 654, 'Fruit jaune poussant sur un bananier');