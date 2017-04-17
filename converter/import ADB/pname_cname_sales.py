import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce

item = []
whole = {}

for i in db.orders.find():
    for j in db.business_dimension.find():
        for k in db.products.find():
            if i["customerID"] == j["cid"] and i["productID"] == k["productID"]:
                item.append(k["product_name"])
                item.append(j["Cname"])
                item.append(j["annual_income"])
                item.append(j["business_category"])
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
    name = mylist[0:-6]
    name = " ".join(name)
    print name
    name2 = mylist[-6:-4]
    name2 = " ".join(name2)
    db.pname_cname_sales.insert_one({"Pname":name,"Cname":name2,"annual_income":mylist[-4],"business_category":mylist[-3],"year":mylist[-2],"month":mylist[-1],"sales":whole[keys]})
    mylist = []
