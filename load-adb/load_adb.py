from py2neo import Graph, Node, Relationship
import csv
import os

##config
user = "php"
password = "php"
db_file_folder = os.getcwd()
###

graph = Graph("bolt://localhost:7687/",user=user,password=password)
graph.delete_all()

business_category_nodes = {}
hardware_category_node = {}
address_node = {}
billinginfo_node = {}
products_node = {}
orders_node = {}


def log(section):
    def wrapper(fn):
        def _inner(*args,**kwargs):
            print("start loading [{0}]...".format(section))
            fn(*args,**kwargs)
            print("finished loading [{0}]...".format(section))
            print()
        return _inner
    return wrapper

@log("business_category")
def load_business_category(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            business_categoryID = row[0]
            business_category_name = row[1]
            node = Node("business_category", business_categoryID=business_categoryID, business_category_name=business_category_name)
            business_category_nodes[business_categoryID] = node
            ctx.create(node)
            counter=0
            counter += 1
            if counter == 1000:
                counter = 0
                print("processed {0} items", counter)
                ctx.process()
        ctx.commit()


@log("business_customers")
def load_business_customers(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            customerID = row[0]
            business_categoryID=row[6]
            business_customers_node = Node("business_customers", customerID=customerID, username=row[1], password=row[2], company_name=row[3], email=row[4], annual_income=row[5],business_categoryID=row[6])
            business_customers_to_business_category = Relationship(business_customers_node, "TO", business_category_nodes[business_categoryID])

            ctx.create(business_customers_node)
            ctx.create(business_customers_to_business_category)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

@log("hardware_category")
def load_hardware_category(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            hardware_categoryID = row[0]
            hardware_category_name = row[1]
            node = Node("hardware_category", hardware_categoryID=hardware_categoryID, hardware_category_name=hardware_category_name)
            hardware_category_node[hardware_categoryID] = node
            ctx.create(node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

@log("hardwares")
def load_hardwares(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            hardware_categoryID = row[3]
            hardwares_node = Node("hardwares", hardwareID=row[0], hardware_name=row[1], hardware_company=row[2], hardware_categoryID=hardware_categoryID)
            hardwares_to_hardware_category = Relationship(hardwares_node, "TO", hardware_category_node[hardware_categoryID])
            ctx.create(hardwares_node)
            ctx.create(hardwares_to_hardware_category)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()


@log("address")
def  load_address(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            addressID = row[0]
            node = Node("address", addressID=addressID, state=row[1], city=row[2], street=row[3], zip_code=row[4])
            address_node[addressID] = node
            ctx.create(node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("billinginfo")
def load_billinginfo(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            billingID = row[0]
            node = Node("billinginfo", billingID=billingID, creditcard_number=row[1], expire_month=row[2], expire_year=row[3])
            billinginfo_node[billingID] = node
            ctx.create(node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("products")
def load_products(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            productID = row[0]
            node = Node("products", productID=productID, inventory_amount=row[1], product_name=row[2], price=row[3], home_discount=row[4],business_discount=row[5], status=row[6], sales_volume=row[7],brand=row[8],weight=row[9])
            products_node[productID] = node
            ctx.create(node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("orders")
def load_orders(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            productID = row[1]
            billingID = row[3]
            ship_addressID = row[4]
            billing_addressID = row[5]
            node = Node("orders", orderID=row[0], productID=productID, customerID=row[2], billingID=billingID, ship_addressID=ship_addressID, billing_addressID=billing_addressID, year=row[6], month=row[7], date=row[8], quantity=row[9], price=row[10], status=row[11])
            orders_node[ship_addressID] = node
            orders_node[billing_addressID] = node
            orders_node[billingID] = node
            orders_node[productID] = node
            orders_shipaddress_to_address = Relationship(orders_node[ship_addressID], "To", address_node[ship_addressID])
            orders_billingaddress_to_address = Relationship(orders_node[billing_addressID], "To", address_node[billing_addressID])
            orders_billingID_to_billinginfo = Relationship(orders_node[billingID], "To", billinginfo_node[billingID])
            orders_productsID_to_products = Relationship(orders_node[productID], "To", products_node[productID])
            ctx.create(node)
            ctx.create(orders_shipaddress_to_address)
            ctx.create(orders_billingID_to_billinginfo)
            ctx.create(orders_billingID_to_billinginfo)
            ctx.create(orders_productsID_to_products)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("home_customers")
def load_home_customers(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            home_customers_node = Node("home_customers", customerID=row[0], username=row[1], password=row[2], first_name=row[3], last_name=row[4], nick_name=row[5], email=row[6], gender=row[7], age=row[8], income=row[9], marriage_status=row[10])
            ctx.create(home_customers_node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("admin")
def load_admin(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            admin_node = Node("admin", adminID=row[0], first_name=row[1], last_name=row[2], username=row[3], password=row[4], email=row[5])
            ctx.create(admin_node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("cart")
def load_cart(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            cart_node = Node("cart", customerID=row[0], productID=row[1], quantity=row[2])
            ctx.create(cart_node)
            counter += 1
            if counter == 3000:
                counter = 0
                progress +=1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("customers_have_address")
def load_customers_have_address(filename):
     with open(filename, encoding='latin-1') as adb_file:
         reader = csv.reader(adb_file, delimiter=",", quotechar='"')
         ctx = graph.begin()
         counter = 0
         progress = 0
         for row in reader:
             customers_have_address_node = Node("customers_have_address", addressID=row[0], customerID=row[1])
             ctx.create(customers_have_address_node)
             counter +=1
             if counter == 3000:
                 counter = 0
                 progress+=1
                 print("process {0} items".format(progress * 3000))
                 ctx.process()
         ctx.commit()



log("customers_have_billinginfo")
def load_customers_have_billinginfo(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            customers_have_billinginfo_node = Node("customers_have_billinginfo", billingID=row[0], customerID=row[1])
            ctx.create(customers_have_billinginfo_node)
            counter +=1
            if counter == 3000:
                counter = 0
                progress += 1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("products_have_hardware")
def load_products_have_hardware(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            products_have_hardware_node = Node("products_have_hardware", productID=row[0], hardwareID=row[1])
            ctx.create(products_have_hardware_node)
            counter +=1
            if counter == 3000:
                counter = 0
                progress += 1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()

log("manage")
def load_manage(filename):
    with open(filename, encoding='latin-1') as adb_file:
        reader = csv.reader(adb_file, delimiter=",", quotechar='"')
        ctx = graph.begin()
        counter = 0
        progress = 0
        for row in reader:
            magage_node = Node("manage", since=row[0], adminID=row[1], productID=row[2])
            ctx.create(magage_node)
            counter +=1
            if counter == 3000:
                counter = 0
                progress += 1
                print("processed {0} items".format(progress * 3000))
                ctx.process()
        ctx.commit()


load_business_category(os.path.join(db_file_folder, "business_category.csv"))
load_business_customers(os.path.join(db_file_folder, "business_customers.csv"))
load_hardware_category(os.path.join(db_file_folder, "hardware_category.csv"))
load_hardwares(os.path.join(db_file_folder, "hardwares.csv"))
load_address(os.path.join(db_file_folder, "address.csv"))
load_billinginfo(os.path.join(db_file_folder, "billinginfo.csv"))
load_products(os.path.join(db_file_folder, "products.csv"))
load_orders(os.path.join(db_file_folder, "orders.csv"))
load_home_customers(os.path.join(db_file_folder, "home_customers.csv"))
load_admin(os.path.join(db_file_folder, "admin.csv"))
load_cart(os.path.join(db_file_folder, "cart.csv"))
load_customers_have_address(os.path.join(db_file_folder, "customers_have_address.csv"))
load_customers_have_billinginfo(os.path.join(db_file_folder, "customers_have_billinginfo.csv"))
load_products_have_hardware(os.path.join(db_file_folder, "products_have_hardware.csv"))
load_manage(os.path.join(db_file_folder, "manage.csv")) 
