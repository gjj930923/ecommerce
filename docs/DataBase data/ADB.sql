USE `ecommerce`;
DROP TABLE IF EXISTS `Sales`;
CREATE TABLE `Sales` (
  `cid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `year` int(4)  NOT NULL,
  `month` int(4) NOT NULL,
  `date` int(4) NOT NULL,
  `price` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Sales(cid,pid,`year`,`month`,`date`, price, sales)
select customerID, productID, `year`, `month`, `date`, price, sum(quantity)
	from orders
	group by customerID, productID, `year`, `month`, `date`, price;

/*select * from Sales*/

DROP TABLE IF EXISTS `Homec_Dimension`;
CREATE TABLE `Homec_Dimension` (
  `cid` int(11) NOT NULL,
  `Fname` varchar(45) NOT NULL,
  `Lname` varchar(45)  NOT NULL,
  `Nname` varchar(45) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `age` int(11) NOT NULL,
  `income` int(11) NOT NULL,
  `marriage_status` varchar(20) 
) ;

insert into Homec_Dimension(cid,Fname,Lname,Nname,gender,age,income,marriage_status)
select `customerID`, `first_name`, `last_name`, `nick_name`, `gender`, `age`, `income`, `marriage_status`
	from home_customers;

select * from Homec_Dimension;

DROP TABLE IF EXISTS `Businessc_dimension`;
CREATE TABLE `Businessc_Dimension` (
  `cid` int(11) NOT NULL,
  `Cname` varchar(45) NOT NULL,
  `annual_income` int(11)  NOT NULL,
  `business_category` varchar(45) NOT NULL
) ;

insert into Businessc_dimension(cid,`Cname`,`annual_income`,`business_category`)
select b1.`customerID`, b1.`company_name`, b1.`annual_income`, b2.business_category_name
	from business_customers b1, business_category b2
	where b1.business_categoryID=b2.business_categoryID;

select * from Businessc_dimension;

DROP TABLE IF EXISTS `Product_Dimension`;
CREATE TABLE `Product_Dimension` (
  `pid` int(11) NOT NULL,
  `Pname` varchar(45) NOT NULL,
  `brand` varchar(45)  NOT NULL,
  `weight` float NOT NULL
/*
  `CPU` varchar(45) NOT NULL,
  `Graphics_coprocessor` varchar(45) NOT NULL,
  `RAM_size` varchar(45) NOT NULL,
  `Screen_size` varchar(45) NOT NULL,
  `Hard_disk_description` varchar(45) NOT NULL,
  `Hard_drive_size` varchar(45) NOT NULL,
  `Operation _system` varchar(45) NOT NULL,
  `Display_resolution_maximum` varchar(45) NOT NULL
*/
) ;

insert into Product_Dimension(pid,Pname,brand,weight)
select productID, product_name, brand, weight
	from products;

/*
insert into Product_Dimension(pid,Pname,brand,weight,`CPU`,`Graphics_coprocessor`,`RAM_size`,`Screen_size`,`Hard_disk_description`,`Hard_drive_size`,`Operation _system`,`Display_resolution_maximum`)
select p1.productID, p1.product_name, p1.brand,p1.weight, h1.hardware_name, h2.hardware_name, h3.hardware_name, 
	   h4.hardware_name, h5.hardware_name, h6.hardware_name, h7.hardware_name, h8.hardware_name  
	from products p1, products p2, products p3, products p4, products p5, products p6, products p7, products p8,
		 hardwares h1, hardwares h2, hardwares h3, hardwares h4, hardwares h5, hardwares h6, hardwares h7, hardwares h8,
		 products_have_hardware pp1, products_have_hardware pp2,products_have_hardware pp3, products_have_hardware pp4,
		 products_have_hardware pp5, products_have_hardware pp6,products_have_hardware pp7, products_have_hardware pp8
	where h1.hardware_categoryID=1 and h2.hardware_categoryID=2 and h3.hardware_categoryID=3 and h4.hardware_categoryID=4
		and h5.hardware_categoryID=5 and h6.hardware_categoryID=6 and h7.hardware_categoryID=7 and h8.hardware_categoryID=8
        and h1.hardwareID=pp1.hardwareID and h2.hardwareID=pp2.hardwareID and h3.hardwareID=pp3.hardwareID and h4.hardwareID=pp4.hardwareID
        and h5.hardwareID=pp5.hardwareID and h6.hardwareID=pp6.hardwareID and h7.hardwareID=pp7.hardwareID and h8.hardwareID=pp8.hardwareID
        and p1.productID=pp1.productID and p2.productID=pp2.productID and p3.productID=pp3.productID and p4.productID=pp4.productID
        and p5.productID=pp5.productID and p6.productID=pp6.productID and p7.productID=pp7.productID and p8.productID=pp8.productID
		and p1.productID=p2.productID and p2.productID=p3.productID and p3.productID=p4.productID and p4.productID=p5.productID
        and p5.productID=p6.productID and p6.productID=p7.productID and p7.productID=p8.productID;
*/
/*
select *
	from products p1, products p2,
		 hardwares h1, hardwares h2, 
		 products_have_hardware pp1, products_have_hardware pp2
	where h1.hardware_categoryID=1 and h2.hardware_categoryID=2 
        and h1.hardwareID=pp1.hardwareID and h2.hardwareID=pp2.hardwareID 
        and p1.productID=pp1.productID and p2.productID=pp2.productID 
		and p1.productID=p2.productID 
*/

select * from Product_Dimension;





DROP TABLE IF EXISTS `Brand_date_sales`;
CREATE TABLE `Brand_date_sales` (
  `brand` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `date` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Brand_date_sales(brand,`year`,`month`,`date`,`sales`)
select pd.brand, s.`year`, s.`month`, s.`date`, sum(sales)as sales
	from product_dimension pd, sales s
	where pd.pid=s.pid
	group by pd.brand, s.`year`, s.`month`, s.`date`, s.`sales`;

select * from Brand_date_sales;

DROP TABLE IF EXISTS `Pname_date_sales`;
CREATE TABLE `Pname_date_sales` (
  `Pname` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `date` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Pname_date_sales(Pname,`year`,`month`,`date`,`sales`)
select pd.Pname, s.`year`, s.`month`, s.`date`, sum(s.sales) as sales
	from product_dimension pd, sales s
	where pd.pid=s.pid
	group by pd.brand, s.`year`, s.`month`, s.`date`, s.`sales`;

select * from Pname_date_sales;


DROP TABLE IF EXISTS `Brand_sales`;
CREATE TABLE `Brand_sales` (
  `brand` varchar(45) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Brand_sales(brand,`sales`)
select brand, sum(sales) as sales
	from Brand_date_sales
	group by brand;

select * from Brand_sales;

DROP TABLE IF EXISTS `Total_sales`;
CREATE TABLE `Total_sales` (
  `sales` int(11) NOT NULL
) ;

insert into Total_sales(`sales`)
select sum(sales) as sales
	from Brand_sales;


select * from Total_sales;


DROP TABLE IF EXISTS `Bcategory_date_sales`;
CREATE TABLE `Bcategory_date_sales` (
  `Bcategory` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `date` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Bcategory_date_sales(`Bcategory`,`year`,`month`,`date`,`sales`)
select b.business_category, s.`year`, s.`month`, s.`date`,sum(s.sales) as sales
	from sales s, Businessc_Dimension b
	where s.cid=b.cid
	group by b.business_category,s.`year`, s.`month`, s.`date`;

select * from Bcategory_date_sales;

DROP TABLE IF EXISTS `Pname_Bcategory_sales`;
CREATE TABLE `Pname_Bcategory_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Bcategory` varchar(45) NOT NULL,
  `sales` int(11) NOT NULL
) ;

insert into Pname_Bcategory_sales(`Pname`,`Bcategory`,`sales`)
select p.Pname, b.business_category,sum(s.sales) as sales
	from sales s, Businessc_Dimension b,product_dimension p
	where s.cid=b.cid and p.pid=s.pid
	group by p.Pname, b.business_category;

select * from Pname_Bcategory_sales;



DROP TABLE IF EXISTS `Pname_price_sales`;
CREATE TABLE `Pname_price_sales` (
	`Pname` varchar(45) NOT NULL,  
	`price` float NOT NULL,
	`sales` int(11) NOT NULL
) ;

insert into Pname_price_sales(`Pname`,`price`,`sales`)
select p.Pname, s.price,sum(s.sales) as sales
	from sales s, product_dimension p
	where p.pid=s.pid
	group by p.Pname, s.price;

select * from Pname_price_sales;



DROP TABLE IF EXISTS `Pname_Cname_sales`;
CREATE TABLE `Pname_Cname_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Cname` varchar(45) NOT NULL,
	`month` int(11) NOT NULL,
	`sales` int(11) NOT NULL
) ;

insert into Pname_Cname_sales(`Pname`,`Cname`,`month`,`sales`)
select p.Pname, b.Cname,s.`month`,sum(s.sales) as sales
	from sales s, Businessc_Dimension b,product_dimension p
	where s.cid=b.cid and p.pid=s.pid
	group by p.Pname, b.Cname,s.`month`
	having sales>2;

select * from Pname_Cname_sales;


DROP TABLE IF EXISTS `Pname_Nname_sales`;
CREATE TABLE `Pname_Nname_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Nname` varchar(45) NOT NULL,
	`month` int(11) NOT NULL,
	`sales` int(11) NOT NULL
) ;

insert into Pname_Nname_sales(`Pname`,`Nname`,`month`,`sales`)
select p.Pname, h.Nname,s.`month`,sum(s.sales) as sales
	from sales s, Homec_Dimension h,product_dimension p
	where s.cid=h.cid and p.pid=s.pid
	group by p.Pname, h.Nname,s.`month`
	having sales>0;

select * from Pname_Nname_sales;

DROP TABLE IF EXISTS `Homec_count`;
CREATE TABLE `Homec_count` (
	`count` int(11) NOT NULL
) ;

insert into Homec_count(`count`)
select count(*) as count
	from (select h.cid
			from sales s, Homec_Dimension h
			where s.cid=h.cid 
			group by h.cid) as temp;

select * from Homec_count;

DROP TABLE IF EXISTS `Businessc_count`;
CREATE TABLE `Businessc_count` (
	`count` int(11) NOT NULL
) ;

insert into Businessc_count(`count`)
select count(*) as count
	from (select b.cid
			from sales s, Businessc_Dimension b
			where s.cid=b.cid 
			group by b.cid) as temp;

select * from Businessc_count;

DROP TABLE IF EXISTS `Businessc_count_r`;
CREATE TABLE `Businessc_count_r` (
	`count` int(11) NOT NULL
) ;

insert into Businessc_count_r(`count`)
select count(*) as count
	from Business_customers;

select * from Businessc_count_r;

DROP TABLE IF EXISTS `Homec_count_r`;
CREATE TABLE `Homec_count_r` (
	`count` int(11) NOT NULL
) ;

insert into Homec_count_r(`count`)
select count(*) as count
	from Home_customers;

select * from Homec_count_r;

/* ****************** */
/* ****************** */
/* ****************** */
drop  procedure IF EXISTS update_fact;
delimiter //
create procedure update_fact(out result int)
begin
	Truncate table `Sales`;
	insert into Sales(cid,pid,`year`,`month`,`date`, price, sales)
	select customerID, productID, `year`, `month`, `date`, price, sum(quantity)
		from orders
		group by customerID, productID, `year`, `month`, `date`, price;
	set result=1;

end//

delimiter ;
call update_fact(@result);
select * from Sales;

set global event_scheduler=1;
delimiter //
create event IF NOT EXISTS  myevent
on schedule every 10 second starts '2010-12-18 01:00:00'
DO begin
call update_fact(@result);
end//
delimiter ;

select year(current_date), month(current_date),day(current_date);