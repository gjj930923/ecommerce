import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
#cursor = db.orders.aggregate([{"$group": {"_id":"$productID","count":{"$sum":1}}}])
#db.ecommerce.aggregate([{$group: {_id:"productID",total:{$sum:"quantity"}}}])
# for i in cursor:
#     print i
item = []
whole = {}
for i in db.orders.find():
    for j in db.home_customers.find():
        for k in db.products.find():
            if i["customerID"] == j["customerID"] and i["productID"] == k["productID"]:
                item.append(k["product_name"])
                item.append(j["nick_name"])
                item.append(i["year"])
                item.append(i["month"])
                temp = int(i["quantity"])
                str = " ".join(item)
                if str in whole.keys():
                    whole[str] += temp
                    item = []
                else:
                    whole[str] = temp
                    item = []
print whole
for keys in whole.keys():
    s = keys
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore')
    mylist = s.split()
    name = mylist[0:-3]
    name = " ".join(name)
    print name
    db.productN_nickN.insert_one({"Product_name":name,"Nick_name":mylist[-3],"Year":mylist[-2],"Month":mylist[-1],"Quantity":whole[keys]})
    mylist = []
