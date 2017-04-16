#brand, time, quantity
import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

temp = []
whole = {}
for i in db.products.find():
    for j in db.orders.find():
        if i["productID"] == j["productID"]:
            #print i["brand"],j["year"],j["month"],j["date"],j["quantity"]
            item = i["brand"]
            item.encode('ascii', 'ignore')
            temp.append(item)
            temp.append(j["year"])
            temp.append(j["month"])
            temp.append(j["date"])
            temp2 = int(j["quantity"])
            str = " ".join(temp)
            if str in whole.keys():
                whole[str] += temp2
                temp = []
            else:
                whole[str] = temp2
                temp = []
print whole
mylist = []
for keys in whole.keys():
    s = keys
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore')
    mylist = s.split()
    #print mylist
    db.brand_date_sales.insert_one({"brand":mylist[0],"Year":mylist[1],"Month":mylist[2],"Date":mylist[3],"Quantity":whole[keys]})
    mylist = []

