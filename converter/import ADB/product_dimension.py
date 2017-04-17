import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

for i in db.products.find():
    db.product_dimension.insert_one({"pid":i["productID"],"Pname":i["product_name"],"brand":i["brand"],"weight":i["weight"]})