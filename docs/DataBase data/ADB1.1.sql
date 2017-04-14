USE `ecommerce`;/* Choose database */

set global event_scheduler=1; /* open schedule function*/

/* Create table fact_memory to record the current row load in Fact table */
Drop table if exists `fact_memory`;
create table `fact_memory`(
	`current_row` int not null,
	primary key(current_row));

/* initial table fact_memory */
insert into `fact_memory` values (0);

/* Create Fact table called Sales*/

DROP TABLE IF EXISTS `Sales`;
CREATE TABLE `Sales` (
  `cid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `year` int(4)  NOT NULL,
  `month` int(4) NOT NULL,
  `day` int(4) NOT NULL,
  `price` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

/* Load data into Fact table function  */

drop  procedure IF EXISTS update_fact;
delimiter //
create procedure update_fact()
begin
	declare start_row int;
	declare end_row int;
	declare dist int;
	/*Truncate table `Sales`;*/
	set start_row=(select * from fact_memory);
	set end_row=(select count(1) from orders);
	set dist=end_row-start_row;
	insert into Sales(cid,pid,`year`,`month`,`day`, price, sales)
	select customerID, productID, `year`, `month`, `date`, price, sum(quantity)
		from orders
		group by customerID, productID, `year`, `month`, `date`, price
		limit start_row, dist;
	update fact_memory
		set current_row=end_row
		where current_row=start_row;
end//
delimiter ;

call update_fact();
#select * from fact_memory;*/
/*select * from Sales*/

/* ************** */

/* Create table Hdimension_memory to record the current row load in Homec_Dimension table */
Drop table if exists `Hdimension_memory`;
create table `Hdimension_memory`(
	`current_row` int not null,
	primary key(current_row));
/* initial table fact_memory */
insert into `Hdimension_memory` values (0);

/* create Home dimension table */
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

/* Load data into Homec_Dimension table function  */

drop  procedure IF EXISTS update_Hdimension;
delimiter //
create procedure update_Hdimension()
begin
	declare start_row int;
	declare end_row int;
	declare dist int;
	/*Truncate table `Sales`;*/
	set start_row=(select * from Hdimension_memory);
	set end_row=(select count(1) from home_customers);
	set dist=end_row-start_row;
	insert into Homec_Dimension(cid,Fname,Lname,Nname,gender,age,income,marriage_status)
		select `customerID`, `first_name`, `last_name`, `nick_name`, `gender`, `age`, `income`, `marriage_status`
		from home_customers
		limit start_row, dist;
	update Hdimension_memory
		set current_row=end_row
		where current_row=start_row;
end//
delimiter ;
call update_Hdimension();
#select * from Homec_Dimension;
#select * from Hdimension_memory

/* ************** */
/* Create table Bdimension_memory to record the current row load in Businessc_dimension table */
Drop table if exists `Bdimension_memory`;
create table `Bdimension_memory`(
	`current_row` int not null,
	primary key(current_row));
/* initial table fact_memory */
insert into `Bdimension_memory` values (0);

/* create Business dimension table */
DROP TABLE IF EXISTS `Businessc_dimension`;
CREATE TABLE `Businessc_Dimension` (
  `cid` int(11) NOT NULL,
  `Cname` varchar(45) NOT NULL,
  `annual_income` int(11)  NOT NULL,
  `business_category` varchar(45) NOT NULL
) ;
/* Load data into Homec_Dimension table function  */
drop  procedure IF EXISTS update_Bdimension;
delimiter //
create procedure update_Bdimension()
begin
	declare start_row int;
	declare end_row int;
	declare dist int;
	/*Truncate table `Sales`;*/
	set start_row=(select * from Bdimension_memory);
	set end_row=(select count(1) from business_customers);
	set dist=end_row-start_row;
	insert into Businessc_dimension(cid,`Cname`,`annual_income`,`business_category`)
		select b1.`customerID`, b1.`company_name`, b1.`annual_income`, b2.business_category_name
			from business_customers b1, business_category b2
			where b1.business_categoryID=b2.business_categoryID
			limit start_row, dist;
	update Bdimension_memory
		set current_row=end_row
		where current_row=start_row;
end//
delimiter ;

call update_Bdimension();
#select * from Bdimension_memory;
#select * from Businessc_dimension;

/* ************** */
/* Create table Pdimension_memory to record the current row load in Product_Dimension table */
Drop table if exists `Pdimension_memory`;
create table `Pdimension_memory`(
	`current_row` int not null,
	primary key(current_row));
/* initial table fact_memory */
insert into `Pdimension_memory` values (0);

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
drop  procedure IF EXISTS update_Pdimension;
delimiter //
create procedure update_Pdimension()
begin
	declare start_row int;
	declare end_row int;
	declare dist int;
	/*Truncate table `Sales`;*/
	set start_row=(select * from Pdimension_memory);
	set end_row=(select count(1) from products);
	set dist=end_row-start_row;
	insert into Product_Dimension(pid,Pname,brand,weight)
		select productID, product_name, brand, weight
		from products
		limit start_row, dist;
	update Pdimension_memory
		set current_row=end_row
		where current_row=start_row;
end//
delimiter ;

call update_Pdimension();
#select * from Pdimension_memory;
#select * from Product_Dimension;


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

/* ************** */
/* ************** */
/* ************** */

# create brand date sales table;
DROP TABLE IF EXISTS `Brand_date_sales`;
CREATE TABLE `Brand_date_sales` (
  `brand` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `day` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;
#initial load data into Brand_date_sales with old data
drop  procedure IF EXISTS load_brand_date_sales;
delimiter //
create procedure load_brand_date_sales()
begin
	Truncate table `brand_date_sales`;
	insert into brand_date_sales(brand,`year`,`month`,`day`,`sales`)
		select pd.brand, s.`year`, s.`month`, s.`day`, sum(sales)as sales
			from product_dimension pd, sales s
			where pd.pid=s.pid
			group by pd.brand, s.`year`, s.`month`, s.`day`;
end//
delimiter ;
call load_brand_date_sales();

/* create function for everyday update*/
drop  procedure IF EXISTS update_brand_date_sales;
delimiter //
create procedure update_brand_date_sales()
begin
	declare dt date;
	set dt=current_date;
	set dt=date_sub(dt,interval 1 day);
	#Truncate table `brand_date_sales`;
	insert into brand_date_sales(brand,`year`,`month`,`day`,`sales`)
		select pd.brand, s.`year`, s.`month`, s.`day`, sum(sales)as sales
			from product_dimension pd, sales s
			where pd.pid=s.pid and s.`year`=year(dt) and s.`month`=month(dt) and s.`day`=day(dt)
			group by pd.brand, s.`year`, s.`month`, s.`day`;
end//
delimiter ;
#call update_brand_date_sales();
#select * from brand_date_sales

/* create pname date sales table */
DROP TABLE IF EXISTS `Pname_date_sales`;
CREATE TABLE `Pname_date_sales` (
  `Pname` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `day` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

#initial load data into pname_date_sales with old data
drop  procedure IF EXISTS load_pname_date_sales;
delimiter //
create procedure load_pname_date_sales()
begin
	Truncate table `Pname_date_sales`;
	insert into Pname_date_sales(Pname,`year`,`month`,`day`,`sales`)
		select pd.Pname, s.`year`, s.`month`, s.`day`, sum(s.sales) as sales
			from product_dimension pd, sales s
			where pd.pid=s.pid
			group by pd.Pname, s.`year`, s.`month`, s.`day`;
end//
delimiter ;
call load_pname_date_sales();

/* create function for everyday update*/
drop  procedure IF EXISTS update_pname_date_sales;
delimiter //
create procedure update_pname_date_sales()
begin
	declare dt date;
	set dt=current_date;
	set dt=date_sub(dt,interval 1 day);
	#Truncate table `brand_date_sales`;
	insert into Pname_date_sales(Pname,`year`,`month`,`day`,`sales`)
		select pd.Pname, s.`year`, s.`month`, s.`day`, sum(s.sales) as sales
			from product_dimension pd, sales s
			where pd.pid=s.pid and s.`year`=year(dt) and s.`month`=month(dt) and s.`day`=day(dt)
			group by pd.Pname, s.`year`, s.`month`, s.`day`;
end//
delimiter ;
#call update_pname_date_sales();
#select * from Pname_date_sales


/* create table brand_sales */
DROP TABLE IF EXISTS `Brand_sales`;
CREATE TABLE `Brand_sales` (
  `brand` varchar(45) NOT NULL,
  `sales` int(11) NOT NULL
) ;

/* create function to load data */
drop  procedure IF EXISTS update_brand_sales;
delimiter //
create procedure update_brand_sales()
begin
	Truncate table `Brand_sales`;
	insert into Brand_sales(brand,`sales`)
		select brand, sum(sales) as sales
			from Brand_date_sales
			group by brand;
end//
delimiter ;

call update_brand_sales();
#select * from Brand_sales;

DROP TABLE IF EXISTS `Total_sales`;
CREATE TABLE `Total_sales` (
  `sales` int(11) NOT NULL
) ;
# create function to load data
drop  procedure IF EXISTS update_total_sales;
delimiter //
create procedure update_total_sales()
begin
	Truncate table `Total_sales`;
	insert into Total_sales(`sales`)
		select sum(sales) as sales
		from Brand_sales;
end//
delimiter ;

call update_total_sales();
#select * from Total_sales;
############################################
#create table Bcategory_date_sales
DROP TABLE IF EXISTS `Bcategory_date_sales`;
CREATE TABLE `Bcategory_date_sales` (
  `Bcategory` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11)  NOT NULL,
  `day` int(11) NOT NULL,
  `sales` int(11) NOT NULL
) ;

#initial load data into pname_date_sales with old data
drop  procedure IF EXISTS load_bcategory_date_sales;
delimiter //
create procedure load_bcategory_date_sales()
begin
	Truncate table `Bcategory_date_sales`;
	insert into Bcategory_date_sales(`Bcategory`,`year`,`month`,`day`,`sales`)
		select b.business_category, s.`year`, s.`month`, s.`day`,sum(s.sales) as sales
			from sales s, Businessc_Dimension b
			where s.cid=b.cid
			group by b.business_category,s.`year`, s.`month`, s.`day`;
end//
delimiter ;
call load_bcategory_date_sales();

/* create function for everyday update*/
drop  procedure IF EXISTS update_bcategory_date_sales;
delimiter //
create procedure update_bcategory_date_sales()
begin
	declare dt date;
	set dt=current_date;
	set dt=date_sub(dt,interval 1 day);
	#Truncate table `brand_date_sales`;
	insert into Bcategory_date_sales(`Bcategory`,`year`,`month`,`day`,`sales`)
		select b.business_category, s.`year`, s.`month`, s.`day`,sum(s.sales) as sales
			from sales s, Businessc_Dimension b
			where s.cid=b.cid and s.`year`=year(dt) and s.`month`=month(dt) and s.`day`=day(dt)
			group by b.business_category,s.`year`, s.`month`, s.`day`;
end//
delimiter ;

#call update_bcategory_date_sales();
#select * from Bcategory_date_sales;

###############################
################################
################################

DROP TABLE IF EXISTS `Pname_Bcategory_sales`;
CREATE TABLE `Pname_Bcategory_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Bcategory` varchar(45) NOT NULL,
    `sales` int(11) NOT NULL
) ;

/* create function for everyday update*/
drop  procedure IF EXISTS update_pname_bcategory_sales;
delimiter //
create procedure update_pname_bcategory_sales()
begin
	Truncate table `Pname_Bcategory_sales`;
	insert into Pname_Bcategory_sales(`Pname`,`Bcategory`,`sales`)
		select p.Pname, b.business_category,sum(s.sales) as sales
			from sales s, Businessc_Dimension b,product_dimension p
			where s.cid=b.cid and p.pid=s.pid
			group by p.Pname, b.business_category;
end//
delimiter ;

call update_pname_bcategory_sales();
#select * from Pname_Bcategory_sales;

DROP TABLE IF EXISTS `Pname_price_sales`;
CREATE TABLE `Pname_price_sales` (
	`Pname` varchar(45) NOT NULL,  
	`price` float NOT NULL,
	`sales` int(11) NOT NULL
) ;

/* create function for everyday update*/
drop  procedure IF EXISTS update_pname_price_sales;
delimiter //
create procedure update_pname_price_sales()
begin
	Truncate table `Pname_price_sales`;
	insert into Pname_price_sales(`Pname`,`price`,`sales`)
		select p.Pname, s.price,sum(s.sales) as sales
			from sales s, product_dimension p
			where p.pid=s.pid
			group by p.Pname, s.price;
end//
delimiter ;

call update_pname_price_sales();
#select * from Pname_price_sales;
#####################
DROP TABLE IF EXISTS `Pname_Cname_sales`;
CREATE TABLE `Pname_Cname_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Cname` varchar(45) NOT NULL,
	`month` int(11) NOT NULL,
	`year` int(11) NOT NULL,
	`sales` int(11) NOT NULL
) ;
/* create function for everyday update*/
drop  procedure IF EXISTS update_pname_Cname_sales;
delimiter //
create procedure update_pname_Cname_sales()
begin
	Truncate table `Pname_Cname_sales`;
	insert into Pname_Cname_sales(`Pname`,`Cname`,`year`,`month`,`sales`)
		select p.Pname, b.Cname,s.`year`,s.`month`,sum(s.sales) as sales
			from sales s, Businessc_Dimension b,product_dimension p
			where s.cid=b.cid and p.pid=s.pid
			group by p.Pname, b.Cname,s.`month`,s.`year`
			having sales>2;
end//
delimiter ;

call update_pname_Cname_sales();
#select * from Pname_Cname_sales;



DROP TABLE IF EXISTS `Pname_Nname_sales`;
CREATE TABLE `Pname_Nname_sales` (
	`Pname` varchar(45) NOT NULL,  
	`Nname` varchar(45) NOT NULL,
	`month` int(11) NOT NULL,
	`year` int(11) NOT NULL,
	`sales` int(11) NOT NULL
) ;
/* create function for everyday update*/
drop  procedure IF EXISTS update_pname_nname_sales;
delimiter //
create procedure update_pname_nname_sales()
begin
	Truncate table `Pname_Nname_sales`;
	insert into Pname_Nname_sales(`Pname`,`Nname`,`year`,`month`,`sales`)
		select p.Pname, h.Nname,s.`year`,s.`month`,sum(s.sales) as sales
			from sales s, Homec_Dimension h,product_dimension p
			where s.cid=h.cid and p.pid=s.pid
			group by p.Pname, h.Nname,s.`month`,s.`year`
			having sales>2;
end//
delimiter ;

call update_pname_nname_sales();
#select * from Pname_Nname_sales;


DROP TABLE IF EXISTS `Homec_count`;
CREATE TABLE `Homec_count` (
	`count` int(11) NOT NULL
) ;
/* create function for everyday update*/
drop  procedure IF EXISTS update_homec_count;
delimiter //
create procedure update_homec_count()
begin
	Truncate table `Homec_count`;
		insert into Homec_count(`count`)
			select count(*) as count
				from (select h.cid
						from sales s, Homec_Dimension h
							where s.cid=h.cid 
							group by h.cid) as temp;
end//
delimiter ;
call update_homec_count();
#select * from Homec_count;

DROP TABLE IF EXISTS `Businessc_count`;
CREATE TABLE `Businessc_count` (
	`count` int(11) NOT NULL
) ;
/* create function for everyday update*/
drop  procedure IF EXISTS update_businessc_count;
delimiter //
create procedure update_businessc_count()
begin
	Truncate table `Businessc_count`;
		insert into Businessc_count(`count`)
			select count(*) as count
			from (select b.cid
					from sales s, Businessc_Dimension b
					where s.cid=b.cid 
					group by b.cid) as temp;

end//
delimiter ;
call update_businessc_count();
#select * from Businessc_count;


DROP TABLE IF EXISTS `Businessc_count_r`;
CREATE TABLE `Businessc_count_r` (
	`count` int(11) NOT NULL
) ;
drop  procedure IF EXISTS update_businessc_count_r;
delimiter //
create procedure update_businessc_count_r()
begin
	Truncate table `Businessc_count_r`;
		insert into Businessc_count_r(`count`)
			select count(*) as count
				from Business_customers;

end//
delimiter ;

call update_businessc_count_r();
#select * from Businessc_count_r;

DROP TABLE IF EXISTS `Homec_count_r`;
CREATE TABLE `Homec_count_r` (
	`count` int(11) NOT NULL
) ;

drop  procedure IF EXISTS update_homec_count_r;
delimiter //
create procedure update_homec_count_r()
begin
	Truncate table `Homec_count_r`;
		insert into Homec_count_r(`count`)
			select count(*) as count
				from Home_customers;

end//
delimiter ;

call update_homec_count_r();
#select * from Homec_count_r;


Drop table if exists `top5`;
create table `top5`(
	`Pname` varchar(45) NOT NULL,
	`year` int(4) Not null,
	`month` int(4) not null,
	`day` int(4) not null,
	`sales` int(11) not null
);

/* ****************** */
/* ****************** */
drop  procedure IF EXISTS load_top5;
delimiter //
create procedure load_top5()
begin

	declare start_dt date;
	declare end_dt date;
	declare dt date;
	truncate table `top5`;

	set start_dt=str_to_date('01/04/2017','%d/%m/%Y');
	set end_dt=current_date;
	set dt=start_dt;
	while dt<=end_dt do
	insert into top5(`Pname`,`year`,`month`,`day`,`sales`)
		select `Pname`,`year`,`month`,`day`,`sales` 
			from Pname_date_sales
			where `year`=year(dt) and `month`=month(dt) and `day`=day(dt)
			order by sales desc
			limit 5;
	set dt=DATE_ADD(dt,interval 1 day);
	end while;
end//
delimiter ;

call load_top5();
#select * from top5;

drop  procedure IF EXISTS update_top5;
delimiter //
create procedure update_top5()
begin

	declare dt date;
	#truncate table `top5`;
	set dt=current_date;
	set dt=date_sub(dt, interval 1 day);

	insert into top5(`Pname`,`year`,`month`,`day`,`sales`)
		select `Pname`,`year`,`month`,`day`,`sales` 
			from Pname_date_sales
			where `year`=year(dt) and `month`=month(dt) and `day`=day(dt)
			order by sales desc
			limit 5;
end//
delimiter ;
#call update_top5();
#select * from top5
##########################
Drop table if exists `bottom5`;
create table `bottom5`(
	`Pname` varchar(45) NOT NULL,
	`year` int(4) Not null,
	`month` int(4) not null,
	`day` int(4) not null,
	`sales` int(11) not null
);

/* ****************** */
/* ****************** */
drop  procedure IF EXISTS load_bottom5;
delimiter //
create procedure load_bottom5()
begin

	declare start_dt date;
	declare end_dt date;
	declare dt date;
	truncate table `bottom5`;

	set start_dt=str_to_date('01/04/2017','%d/%m/%Y');
	set end_dt=current_date;
	set dt=start_dt;
	while dt<=end_dt do
	insert into bottom5(`Pname`,`year`,`month`,`day`,`sales`)
		select `Pname`,`year`,`month`,`day`,`sales` 
			from Pname_date_sales
			where `year`=year(dt) and `month`=month(dt) and `day`=day(dt)
			order by sales asc
			limit 5;
	set dt=DATE_ADD(dt,interval 1 day);
	end while;
end//
delimiter ;

call load_bottom5();
#select * from bottom5;

drop  procedure IF EXISTS update_bottom5;
delimiter //
create procedure update_bottom5()
begin

	declare dt date;
	#truncate table `bottom5`;
	set dt=current_date;
	set dt=date_sub(dt, interval 1 day);

	insert into bottom5(`Pname`,`year`,`month`,`day`,`sales`)
		select `Pname`,`year`,`month`,`day`,`sales` 
			from Pname_date_sales
			where `year`=year(dt) and `month`=month(dt) and `day`=day(dt)
			order by sales asc
			limit 5;
end//
delimiter ;
#call update_bottom5();
#select * from bottom5
/* ****************** */

/* set time to load data*/
drop event if exists myevent;
delimiter //
create event IF NOT EXISTS  myevent
on schedule every 1 day starts '2017-01-01 01:00:00'
DO begin
call update_fact();
call update_Hdimension();
call update_Bdimension();
call update_Pdimension();
call update_brand_date_sales();
call update_pname_date_sales();
call update_brand_sales();
call update_total_sales();
call update_bcategory_date_sales();
call update_pname_bcategory_sales();
call update_pname_price_sales();
call update_pname_Cname_sales();
call update_pname_nname_sales();
call update_homec_count();
call update_businessc_count();
call update_businessc_count_r();
call update_homec_count_r();
call update_top5();
call update_bottom5();
end//
delimiter ;

