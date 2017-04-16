#brand, quantity
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

dict_for_brandQ = {}
for i in db.products.find():
    for j in db.orders.find():
        if i["productID"] == j["productID"]:
            temp = i["brand"]
            temp2 = int(j["quantity"])
            if temp in dict_for_brandQ.keys():
                dict_for_brandQ[temp] += int(temp2)
                #print dict_for_brandQ
            else:
                dict_for_brandQ[temp]  = int(temp2)
                #print dict_for_brandQ
print dict_for_brandQ

for keys in dict_for_brandQ.keys():
    db.brand_n_quantity.insert_one({"brand":keys,"quantity":dict_for_brandQ[keys]})
