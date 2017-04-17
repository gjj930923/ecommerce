from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

sum = 0
for i in db.orders.find():
    num = int(i["quantity"])
    sum += num

db.total_sales.insert_one({"sales":sum})