import json
import sys
import pymongo
import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
#cursor = db.orders.aggregate([{"$group": {"_id":"$productID","count":{"$sum":1}}}])
#db.ecommerce.aggregate([{$group: {_id:"productID",total:{$sum:"quantity"}}}])
# for i in cursor:
#     print i
num = 0
for i in db.home_customers.find():
    num += 1
db.Homec_count.insert_one({"count":num})


