import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

item = []
whole = {}

for i in db.orders.find():
    for k in db.products.find():
        for m in db.business_category.find():
            for n in db.business_customers.find():
                if i["productID"] == k["productID"] and n["customerID"] == i["customerID"] and m["business_categoryID"] == n["business_categoryID"]:
                    item.append(k["product_name"])
                    item.append(m["business_category_name"])
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
    db.pname_bcategory_sales.insert_one({"Pname":name,"Bcategory":mylist[-1],"sales":whole[keys]})
    mylist = []
