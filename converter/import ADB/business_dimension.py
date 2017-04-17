from pymongo import MongoClient
client = MongoClient()
db = client.ecommerce
for i in db.business_customers.find():
	for j in db.business_category.find():
		if i["business_categoryID"] == j["business_categoryID"]:
			db.business_dimension.insert_one({"cid":i["customerID"],"Cname":i["company_name"],"annual_income":i["annual_income"],"business_category":j["business_category_name"]})
