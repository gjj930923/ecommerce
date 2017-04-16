from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
for i in db.business_customers.find():
    db.business_dimension.insert_one({"cid":i["customerID"],"Cname":i["company_name"],"Annual_income":i["annual_income"],"Business_Category":i["business_categoryID"]})
