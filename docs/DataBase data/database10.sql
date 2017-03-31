-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2016-12-05 21:59:51
-- 服务器版本： 10.0.27-MariaDB-0ubuntu0.16.04.1
-- PHP Version: 7.0.8-0ubuntu0.16.04.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce`
--
CREATE DATABASE IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ecommerce`;

-- --------------------------------------------------------

--
-- 表的结构 `address`
--

DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
  `addressID` int(11) NOT NULL,
  `state` varchar(20)  NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `zip_code` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `address`
--

INSERT INTO `address` (`addressID`, `state`, `city`, `street`, `zip_code`) VALUES
(100, 'PA', 'Pittsburgh', '4720 Centre Ave, Apt 4E', 15213),
(102, 'PA', 'Pittsburgh', '6602 Northumberland', 15217);
-- --------------------------------------------------------

--
-- 表的结构 `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `adminID` int(15) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `admin`
--

INSERT INTO `admin` (`adminID`, `first_name`, `last_name`, `username`, `password`, `email`) VALUES
(1, 'DONALD', 'TRUMP', 'President', 'donaldtrump', 'dt@whitehouse.gov'),
(3, 'Zhaoji', 'Huang', 'admin', '8888', 'zhh34@pitt.edu');

-- --------------------------------------------------------

--
-- 表的结构 `billinginfo`
--

DROP TABLE IF EXISTS `billinginfo`;
CREATE TABLE `billinginfo` (
  `billingID` int(11) NOT NULL,
  `creditcard_number` varchar(20)NOT NULL,
  `expire_month` int(11) NOT NULL,
  `expire_year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `billinginfo`
--

INSERT INTO `billinginfo` (`billingID`, `creditcard_number`, `expire_month`, `expire_year`) VALUES
(2, '88888888888888888', 12, 2019),
(4, '66666666666666666', 9, 2018);

-- --------------------------------------------------------

--
-- 表的结构 `business_category`
--

DROP TABLE IF EXISTS `business_category`;
CREATE TABLE `business_category` (
  `business_categoryID` int(11) NOT NULL,
  `business_category_name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(1,'Manufacture');
INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(3,'Business');
INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(5,'Finance');
INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(7,'Service');
INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(9,'Retail');
INSERT INTO `business_category`(`business_categoryID`,`business_category_name`) VALUES
(11,'Ecommerce');
-- --------------------------------------------------------

--
-- 表的结构 `business_customers`
--

DROP TABLE IF EXISTS `business_customers`;
CREATE TABLE `business_customers` (
  `customerID` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `company_name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `annual_income` int(11) NOT NULL DEFAULT '0',
  `business_categoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `business_customers` (`customerID`, `username`,`password`,`company_name`,`email`,`annual_income`,`business_categoryID`) VALUES
(10000, 'zhaoji','1234','ZJ company','1234@zj.com',1000000,5);
-- --------------------------------------------------------

--
-- 表的结构 `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `customerID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `customers_have_address`
--

DROP TABLE IF EXISTS `customers_have_address`;
CREATE TABLE `customers_have_address` (
  `addressID` int(11) NOT NULL,
  `customerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `customers_have_address`
--

INSERT INTO `customers_have_address` (`addressID`, `customerID`) VALUES
(100, 10001),
(102, 10000);

-- --------------------------------------------------------

--
-- 表的结构 `customers_have_billinginfo`
--

DROP TABLE IF EXISTS `customers_have_billinginfo`;
CREATE TABLE `customers_have_billinginfo` (
  `billingID` int(11) NOT NULL,
  `customerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- 转存表中的数据 `customers_have_billinginfo`
--

INSERT INTO `customers_have_billinginfo` (`billingID`, `customerID`) VALUES
(2, 10001),
(4, 10000);

-- --------------------------------------------------------

--
-- 表的结构 `hardwares`
--

DROP TABLE IF EXISTS `hardwares`;
CREATE TABLE `hardwares` (
  `hardwareID` int(11) NOT NULL,
  `hardware_name` varchar(45) NOT NULL,
  `hardware_company` varchar(45) NOT NULL,
  `hardware_categoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `hardwares`
--

INSERT INTO `hardwares` (`hardwareID`, `hardware_name`, `hardware_company`, `hardware_categoryID`) VALUES
(1, 'i7', 'Intel', 1),
(2, 'i5', 'Intel', 1),
(3, 'i3', 'Intel', 1),
(4, 'Intel HD Graphics 5500', 'Intel', 2),
(5, 'Intel HD Graphics', 'Intel', 2),
(6, 'Intel HD Graphics 520', 'Intel', 2),
(7, 'Intel HD Graphics 620', 'Intel', 2),
(8, 'AMD Radeon HD 6490M', 'AMD', 2),
(9, '4 GB', 'Kingston', 3),
(10, '6 GB', 'Samsung', 3),
(11, '8 GB', 'Samsung', 3),
(12, '13 inch', 'Samsung', 4),
(13, '13.3 inch', 'Samsung', 4),
(14, '14 inch', 'Samsung', 4),
(15, '15.4 inch', 'Samsung', 4),
(16, '15.6 inch', 'Samsung', 4),
(17, '21.5 inch', 'LG', 4),
(18, 'SSD', 'Kingston', 5),
(19, 'HDD', 'Kingston', 5),
(20, '128 GB', 'Kingston', 6),
(21, '256 GB', 'Kingston', 6),
(22, '500 GB', 'Kingston', 6),
(23, '1T', 'Kingston', 6),
(24, 'Windows 10', 'Windows', 7),
(25, 'Mac OS X', 'Apple', 7),
(26, '1366 x 768', 'Samsung', 8),
(27, '1440x900', 'Samsung', 8),
(28, '1920x1080', 'Samsung', 8);
-- --------------------------------------------------------

--
-- 表的结构 `hardware_category`
--

DROP TABLE IF EXISTS `hardware_category`;
CREATE TABLE `hardware_category` (
  `hardware_categoryID` int(11) NOT NULL,
  `hardware_category_name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `hardware_category`
--

INSERT INTO `hardware_category` (`hardware_categoryID`, `hardware_category_name`) VALUES
(1, 'CPU'),
(2, 'Graphics Coprocessor'),
(3, 'RAM Size'),
(4, 'Screen size'),
(5, 'Hard disk Description'),
(6, 'Hard-Drive Size'),
(7, 'Operation System'),
(8, 'Display Resolution Maximum');



-- --------------------------------------------------------

--
-- 表的结构 `home_customers`
--

DROP TABLE IF EXISTS `home_customers`;
CREATE TABLE `home_customers` (
  `customerID` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `nick_name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `age` int(11) NOT NULL DEFAULT '0',
  `income` int(11) DEFAULT '0',
  `marriage_status` varchar(20) DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `home_customers`
--

INSERT INTO `home_customers` (`customerID`, `username`, `password`, `first_name`, `last_name`, `nick_name`, `email`, `gender`, `age`, `income`, `marriage_status`) VALUES
(10001, 'gjj', '1234', 'Junjia', 'Guo', 'Jeff', 'jug44@pitt.edu', 'male', 24, 11, 'no');

-- --------------------------------------------------------

--
-- 表的结构 `manage`
--

DROP TABLE IF EXISTS `manage`;
CREATE TABLE `manage` (
  `since` datetime NOT NULL,
  `adminID` int(11) NOT NULL,
  `productID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `manage`
--

INSERT INTO `manage` (`since`, `adminID`, `productID`) VALUES
('2016-12-05 00:00:00', 1, 1),
('2016-12-05 00:00:00', 1, 2),
('2016-12-05 00:00:00', 1, 3),
('2016-12-05 00:00:00', 1, 4),
('2016-12-05 00:00:00', 1, 5),
('2016-12-05 00:00:00', 1, 6),
('2016-12-05 00:00:00', 1, 7),
('2016-12-05 00:00:00', 1, 8),
('2016-12-05 00:00:00', 1, 9),
('2016-12-05 00:00:00', 1, 10);


-- --------------------------------------------------------

--
-- 表的结构 `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `customerID` int(11) NOT NULL,
  `billingID` int(11) NOT NULL,
  `ship_addressID` int(11) NOT NULL,
  `billing_addressID` int(11) NOT NULL,
  `year` int(4)  NOT NULL,
  `month` int(2)  NOT NULL,
  `date` int(2)  NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `price` float NOT NULL DEFAULT '0.1',
  `status` int(11) NOT NULL DEFAULT '0'COMMENT 'status: 0: processing , 1:done'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `orders` (`orderID`, `productID`, `customerID`, `billingID`, `ship_addressID`, `billing_addressID`, `year`,`month`,`date`,`quantity`,`price`,`status`) VALUES
(1000,1,10001,2,100,100,2016,12,21,1,670,1),
(1002,2,10001,2,100,100,2016,12,22,2,250,1),
(1004,9,10001,2,100,100,2017,2,14,2,350,1),
(1006,10,10001,2,102,102,2017,3,28,1,540,1),
(1008,6,10000,4,102,102,2017,3,29,10,860,1),
(1010,7,10000,4,102,102,2016,3,29,5,600,1),
(1012,3,10000,4,102,102,2016,3,30,8,330,1),
(1014,8,10000,4,102,102,2016,3,30,5,500,1),
(1016,4,10000,4,102,102,2016,3,30,1,780,1);




-- --------------------------------------------------------

--
-- 表的结构 `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `productID` int(11) NOT NULL,
  `inventory_amount` int(11) NOT NULL,
  `product_name` varchar(45) NOT NULL,
  `price` float NOT NULL,
  `home_discount` float DEFAULT '100',
  `business_discount` float DEFAULT '100',
  `status` int(11) DEFAULT '1' COMMENT 'status: 0: off , 1:on',
  `sales_volume` int(11) NOT NULL DEFAULT '0',
  `brand` varchar(45) NOT NULL,
  `weight` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `products`
--

INSERT INTO `products` (`productID`, `inventory_amount`, `product_name`, `price`, `home_discount`, `business_discount`, `status`,`brand`,`weight`,`sales_volume`) VALUES
(1, 80, 'Inspiron 13 5358 Premium Flagship', 670, 100, 100, 1,'Dell',3.68,1 ),
(2, 80, 'Intel Pentium N3700', 250, 100, 100, 1,'Dell',4.85 ,2),
(3, 90, 'Inspiron 3000', 330, 100, 100, 1,'Dell',4.8,8),
(4, 80, 'Latitude E7450', 780, 100, 100, 1,'Dell',4 ,1),
(5, 80, 'Inspiron 5000', 570, 100, 100, 1,'Dell',6.5,0 ),
(6, 90, 'MacBook Air', 860, 100, 100, 1,'Apple',2.96,10),
(7, 80, 'MacBook Pro', 600, 100, 100, 1,'Apple',5.6 ,5),
(8, 80, 'R5-571T', 500, 100, 100, 1,'Acer',4.96 ,5),
(9, 90, 'Aspire E 15', 350, 100, 100, 1,'Acer',5.27,2),
(10, 80, 'F556UA-AB54 NB', 540, 100, 100, 1,'ASUS',5.1,1);

-- --------------------------------------------------------

--
-- 表的结构 `products_have_hardware`
--

DROP TABLE IF EXISTS `products_have_hardware`;
CREATE TABLE `products_have_hardware` (
  `productID` int(11) NOT NULL,
  `hardwareID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `products_have_hardware`
--

INSERT INTO `products_have_hardware` (`productID`, `hardwareID`) VALUES
(1, 1),
(1, 4),
(1, 11),
(1, 12),
(1, 18),
(1, 20),
(1, 24),
(1, 28),
(2, 3),
(3, 3),
(4, 2),
(5, 1),
(6, 2),
(7, 1),
(8, 2),
(9, 3),
(10, 2),
(2, 5),
(3, 5),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 6),
(9, 7),
(10, 6),
(2, 9),
(3, 10),
(4, 11),
(5, 11),
(6, 11),
(7, 9),
(8, 11),
(9, 9),
(10,11),
(2, 16),
(3, 16),
(4, 14),
(5, 17),
(6, 13),
(7, 15),
(8, 16),
(9, 16),
(10,16),
(2, 19),
(3, 19),
(4, 18),
(5, 19),
(6, 18),
(7, 19),
(8, 19),
(9, 19),
(10,18),
(2, 22),
(3, 23),
(4, 21),
(5, 23),
(6, 20),
(7, 22),
(8, 23),
(9, 23),
(10,20),
(2, 24),
(3, 24),
(4, 24),
(5, 24),
(6, 25),
(7, 25),
(8, 24),
(9, 24),
(10,24),
(2, 26),
(3, 26),
(4, 28),
(5, 28),
(6, 27),
(7, 27),
(8, 28),
(9, 28),
(10,28);

-- --------------------------------------------------------

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`addressID`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`adminID`);

--
-- Indexes for table `billinginfo`
--
ALTER TABLE `billinginfo`
  ADD PRIMARY KEY (`billingID`);

--
-- Indexes for table `business_category`
--
ALTER TABLE `business_category`
  ADD PRIMARY KEY (`business_categoryID`);

--
-- Indexes for table `business_customers`
--
ALTER TABLE `business_customers`
  ADD PRIMARY KEY (`customerID`),
  ADD KEY `category_ID` (`business_categoryID`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`customerID`,`productID`);

--
-- Indexes for table `customers_have_address`
--
ALTER TABLE `customers_have_address`
  ADD PRIMARY KEY (`addressID`,`customerID`);

--
-- Indexes for table `customers_have_billinginfo`
--
ALTER TABLE `customers_have_billinginfo`
  ADD PRIMARY KEY (`billingID`,`customerID`);

--
-- Indexes for table `hardwares`
--
ALTER TABLE `hardwares`
  ADD PRIMARY KEY (`hardwareID`),
  ADD KEY `fk_hardwares_hardware_category1_idx` (`hardware_categoryID`);

--
-- Indexes for table `hardware_category`
--
ALTER TABLE `hardware_category`
  ADD PRIMARY KEY (`hardware_categoryID`);

--
-- Indexes for table `home_customers`
--
ALTER TABLE `home_customers`
  ADD PRIMARY KEY (`customerID`);

--
-- Indexes for table `manage`
--
ALTER TABLE `manage`
  ADD PRIMARY KEY (`adminID`,`productID`,`since`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `fk_order_products1_idx` (`productID`),
  ADD KEY `fk_order_billinginfo1_idx` (`billingID`),
  ADD KEY `fk_order_address1_idx` (`ship_addressID`),
  ADD KEY `fk_order_address2_idx` (`billing_addressID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`productID`);

--
-- Indexes for table `products_have_hardware`
--
ALTER TABLE `products_have_hardware`
  ADD PRIMARY KEY (`productID`,`hardwareID`);

--

--

-- Indexes for table `supply`

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `address`
--
ALTER TABLE `address`
  MODIFY `addressID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- 使用表AUTO_INCREMENT `admin`
--
ALTER TABLE `admin`
  MODIFY `adminID` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- 使用表AUTO_INCREMENT `billinginfo`
--
ALTER TABLE `billinginfo`
  MODIFY `billingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- 使用表AUTO_INCREMENT `business_category`
--
ALTER TABLE `business_category`
  MODIFY `business_categoryID` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `hardwares`
--
ALTER TABLE `hardwares`
  MODIFY `hardwareID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
--
-- 使用表AUTO_INCREMENT `hardware_category`
--
ALTER TABLE `hardware_category`
  MODIFY `hardware_categoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- 使用表AUTO_INCREMENT `home_customers`
--
ALTER TABLE `home_customers`
  MODIFY `customerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10002;
--
-- 使用表AUTO_INCREMENT `orders`
--
ALTER TABLE `orders`
  MODIFY `orderID` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `products`
--
ALTER TABLE `products`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--

-- 限制导出的表
--

--
-- 限制表 `business_customers`
--
ALTER TABLE `business_customers`
  ADD CONSTRAINT `business_customers_ibfk_1` FOREIGN KEY (`business_categoryID`) REFERENCES `business_category` (`business_categoryID`) ON UPDATE CASCADE;

--
-- 限制表 `hardwares`
--
ALTER TABLE `hardwares`
  ADD CONSTRAINT `fk_hardwares_hardware_category1` FOREIGN KEY (`hardware_categoryID`) REFERENCES `hardware_category` (`hardware_categoryID`) ON UPDATE CASCADE;

--
-- 限制表 `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_address1` FOREIGN KEY (`ship_addressID`) REFERENCES `address` (`addressID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_address2` FOREIGN KEY (`billing_addressID`) REFERENCES `address` (`addressID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_billinginfo1` FOREIGN KEY (`billingID`) REFERENCES `billinginfo` (`billingID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_products1` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
