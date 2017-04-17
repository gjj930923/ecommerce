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
                item.append(j["last_name"])
                item.append(j["first_name"])
                item.append(j["nick_name"])
                item.append(j["gender"])
                item.append(j["age"])
                item.append(j["income"])
                item.append(j["marriage_status"])
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
    name = mylist[0:-9]
    name = " ".join(name)
    print name
    db.pname_nname_sales.insert_one({"Pname":name,"Nname":mylist[-7],"Lname":mylist[-9],"Fname":mylist[-8],"gender":mylist[-6],"age":mylist[-5],"income":mylist[-4],"marriage_status":mylist[-3],"year":mylist[-2],"month":mylist[-1],"sales":whole[keys]})
    mylist = []
