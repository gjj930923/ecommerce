import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

item = []
whole = {}
for i in db.orders.find():
    for j in db.business_customers.find():
        for k in db.products.find():
            if i["customerID"] == j["customerID"] and i["productID"] == k["productID"]:
                item.append(k["product_name"])
                item.append(j["company_name"])
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
    db.pname_cname_sales.insert_one({"Pname":name,"Cname":mylist[-3],"Year":mylist[-2],"Month":mylist[-1],"Quantity":whole[keys]})
    mylist = []
