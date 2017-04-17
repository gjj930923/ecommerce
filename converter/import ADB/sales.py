import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

item = []
whole = {}
for i in db.orders.find():
    item.append(i["customerID"])
    item.append(i["productID"])
    item.append(i["year"])
    item.append(i["month"])
    item.append(i["date"])
    item.append(i["price"])
    temp = i["quantity"]
    str = " ".join(item)
    if str in whole.keys():
        whole[str] += temp
        item = []
    else:
        whole[str] = temp
        item = []
print whole

for k in whole.keys():
    s = k
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore')
    mylist = s.split()
    db.sales.insert_one({"cid":mylist[-6],"pid":mylist[-5],"year":mylist[-4],"month":mylist[-3],"day":mylist[-2],"price":mylist[-1],"sales":whole[k]})
    mylist = []
#db.Sales.insert_one({"cid":i["customerID"],"pid":i["productID"],"year":i["year"],"month":i["month"],"day":i["date"],"price":i["price"],})
