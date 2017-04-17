import unicodedata
from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
cursor = db.orders.aggregate([{"$group": {"_id":"$productID","count":{"$sum":1}}}])
#db.ecommerce.aggregate([{$group: {_id:"productID",total:{$sum:"quantity"}}}])
# for i in cursor:
#     print i
item = []
whole = {}
for i in db.orders.find():
    for b in db.business_customers.find():
        for da in db.business_category.find():
            if da["business_categoryID"] == b["business_categoryID"] and b["customerID"] == i["customerID"]:
                item.append(da["business_category_name"])
                item.append(i["year"])
                item.append(i["month"])
                item.append(i["date"])
                temp2 = int(i["quantity"])
                item = " ".join(item)
                if item in whole.keys():
                    whole[item] += temp2
                    item = []
                else:
                    whole[item] = temp2
                    item = []

print whole
for keys in whole.keys():
    s = keys
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore')
    mylist = s.split()
    db.bcategory_date_sales.insert_one({"business_category":mylist[0],"year":mylist[1],"month":mylist[2],"day":mylist[3],"sales":whole[keys]})

