use ecommerce;
DROP trigger IF EXISTS `checkZip_code`;
delimiter //
CREATE trigger checkZip_code before INSERT on ecommerce.address
  for each row
BEGIN
  DECLARE msg VARCHAR (200);
  if new.zip_code>=10000 && new.zip_code<=99999 THEN
    INSERT INTO ecommerce.address VALUES (new.state,new.city,new.street,new.zip_code);
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
    INSERT INTO ecommerce.billinginfo VALUES (new.billingID,new.creditcard_number,new.expire_month,new.expire_year);
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
    INSERT INTO ecommerce.business_customers VALUES (new.customerID,new.username,new.password,new.company_name,new.email,new.annual_income,new.business_categoryID);
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
    INSERT INTO ecommerce.cart VALUES (new.customerID,new.productID,new.quantity);
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
      INSERT INTO ecommerce.cart VALUES (new.customerID, new.username,new.password,new.first_name,new.last_name,new.nick_name,new.email,new.gender,new.age,new.income,new.marriage_status);
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
      INSERT INTO ecommerce.cart VALUES (new.productID, new.inventory_amount,new.product_name,new.price,new.home_discount,new.business_discount,new.status,new.sales_volume);
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