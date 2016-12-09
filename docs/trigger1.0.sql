use ecommerce;
DROP trigger IF EXISTS `checkZip_code`;
delimiter //
CREATE trigger checkZip_code before INSERT on ecommerce.address
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.zip_code>=10000 && new.zip_code<=99999 THEN
    set @state=@state+new.state;
	set @city=@state+new.city;
	set @street=@state+new.street;
	set @zip_code=@state+new.zip_code;
  ELSE
    SET msg="wrong zipcode number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger IF EXISTS `checkMonth`;
delimiter //
CREATE trigger checkMonth before INSERT on ecommerce.billinginfo
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.expire_month >=1 && new.expire_month<=12 THEN
	set @creditcard_number=@creditcard_number+new.creditcard_number;
	set @expire_month=@expire_month+new.expire_month;
	set @expire_year=@expire_year+new.expire_year;
  ELSE
    SET msg="wrong expire_month number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger IF EXISTS `checkAnnual_income`;
delimiter //
CREATE trigger checkAnnual_income before INSERT on ecommerce.business_customers
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.annual_income >=0   THEN
	set @customerID=@customerID+new.customerID;
	set @username=@username+new.username;
	set @`password`=@`password`+new.`password`;
	set @company_name=@company_name+new.company_name;
	set @email=@email+new.email;
	set @annual_income=@annual_income+new.annual_income;
	set @annual_income=@annual_income+new.annual_income;
  ELSE
    SET msg="wrong annual income number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger IF EXISTS `checkCart`;
delimiter //
CREATE trigger checkCart before INSERT on ecommerce.cart
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.quantity >0  THEN
    set @customerID=@customerID+new.customerID;
	set @productID=@productID+new.productID;
	set @quantity=@quantity+new.quantity;
  ELSE
    SET msg="wrong quantity number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger IF EXISTS `checkHome_customers`;
delimiter //
CREATE trigger checkHome_customers before INSERT on ecommerce.home_customers
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.age >=0  THEN
    if new.income >=0 THEN
		set @customerID=@customerID+new.customerID;
		set @username=@username+new.username;
		set @`password`=@`password`+new.`password`;
		set @first_name=@first_name+new.first_name;
		set @last_name=@last_name+new.last_name;
		set @nick_name=@nick_name+new.nick_name;
		set @email=@email+new.email;
		set @gender=@gender+new.gender;
		set @age=@age+new.age;
		set @income=@income+new.income;
		set @marriage_status=@marriage_status+new.marriage_status;
    ELSE
     SET msg="wrong income number";
      signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
    end if;
  ELSE
    SET msg="wrong age number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger IF EXISTS `checkProducts`;
delimiter //
CREATE trigger checkProducts before INSERT on ecommerce.products
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.inventory_amount >=0  THEN
    if new.home_discount >0 && new.home_discount<=100 THEN
      if new.business_discount>0 && new.business_discount<=100 THEN
		set @productID=@productID+new.productID;
		set @inventory_amount=@inventory_amount+new.inventory_amount;
		set @product_name=@product_name+new.product_name;
		set @price=@price+new.price;
		set @home_discount=@home_discount+new.home_discount;
		set @business_discount=@business_discount+new.business_discount;
		set @sales_volume=@sales_volume+new.sales_volume;
      ELSE
        SET msg="wrong business discount number";
        signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
      end if;
    ELSE
     SET msg="wrong home discount number";
      signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
    end if;
  ELSE
    SET msg="wrong inventory amount number";
    signal SQLSTATE "99999" SET MESSAGE_TEXT =msg;
  end if;
END //
delimiter ;

DROP trigger if exists  `updatSales_volume`;
delimiter //
create trigger updatSales_volume after insert on ecommerce.orders
	for each row
begin
	update ecommerce.products set sales_volume=sales_volume+new.quantity where ecommerce.products.productID=new.productID;
end//
delimiter ;

