from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

num = 0
item  = []
for i in db.home_customers.find():
    for j in db.orders.find():
        if i["customerID"] == j["customerID"]:
            s = i["customerID"]
            if s not in item:
                item.append(i["customerID"])
db.Homec_count.insert_one({"count":len(item)})


#registered customers
num2 = 0
for i in db.business_customers.find():
    num2 += 1
db.Homec_count_r.insert_one({"count":num2})

