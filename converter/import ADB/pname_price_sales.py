import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

item = []
whole = {}
for i in db.orders.find():
    for k in db.products.find():
        if i["productID"] == k["productID"]:
            item.append(k["product_name"])
            item.append(i["price"])
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
    print s
    mylist = s.split()
    name = mylist[0:-1]
    name = " ".join(name)
    print name
    db.pname_price_sales.insert_one({"Pname":name,"price":mylist[-1],"sales":whole[keys]})
    mylist = []