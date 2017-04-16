from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
for i in db.home_customers.find():
    db.home_D.insert_one({"cid":i["customerID"],"Fname":i["first_name"],"Lname":i["last_name"],"Nname":i["nick_name"],"Gender":i["gender"],"age":i["age"],"income":i["income"],"marriage_status":i["marriage_status"]})
