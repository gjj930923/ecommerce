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
  `state` varchar(20) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `street` varchar(45) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `address`
--

INSERT INTO `address` (`addressID`, `state`, `city`, `street`, `zip_code`) VALUES
(100, 'PA', 'Pittsburgh', '4720 Centre Ave, Apt 4E', 15213);

-- --------------------------------------------------------

--
-- 表的结构 `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `adminID` int(15) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `admin`
--

INSERT INTO `admin` (`adminID`, `first_name`, `last_name`, `username`, `password`, `email`) VALUES
(1, 'DONALD', 'TRUMP', 'President', 'donaldtrump', 'dt@whitehouse.gov');

-- --------------------------------------------------------

--
-- 表的结构 `billinginfo`
--

DROP TABLE IF EXISTS `billinginfo`;
CREATE TABLE `billinginfo` (
  `billingID` int(11) NOT NULL,
  `creditcard_number` varchar(20) DEFAULT NULL,
  `expire_month` int(11) DEFAULT NULL,
  `expire_year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `billinginfo`
--

INSERT INTO `billinginfo` (`billingID`, `creditcard_number`, `expire_month`, `expire_year`) VALUES
(2, '88888888888888888', 12, 2019);

-- --------------------------------------------------------

--
-- 表的结构 `business_category`
--

DROP TABLE IF EXISTS `business_category`;
CREATE TABLE `business_category` (
  `business_categoryID` int(11) NOT NULL,
  `business_category_name` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

-- --------------------------------------------------------

--
-- 表的结构 `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `customerID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL
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
(100, 10001);

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
(2, 10001);

-- --------------------------------------------------------

--
-- 表的结构 `hardwares`
--

DROP TABLE IF EXISTS `hardwares`;
CREATE TABLE `hardwares` (
  `hardwareID` int(11) NOT NULL,
  `hardware_name` varchar(45) DEFAULT NULL,
  `hardware_company` varchar(45) DEFAULT NULL,
  `hardware_categoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `hardwares`
--

INSERT INTO `hardwares` (`hardwareID`, `hardware_name`, `hardware_company`, `hardware_categoryID`) VALUES
(1, 'i7', 'Intel', 1),
(2, 'i5', 'Intel', 1),
(3, 'i3', 'Intel', 1),
(4, 'AMD', 'AMD', 1),
(5, 'Graphics Media Accelerator', NULL, 2),
(6, 'Special Display Card', NULL, 2),
(7, 'Dual Video Card', NULL, 2),
(8, '17 inch+ screen', NULL, 3),
(9, '15 inch screen', NULL, 3),
(10, '14 inch screen', NULL, 3),
(11, '13 inch screen', NULL, 3),
(12, '12 inch screen', NULL, 3),
(13, '11 inch- screen', NULL, 3),
(14, '32GB+ ROM', NULL, 4),
(15, '16GB ROM', NULL, 4),
(16, '8GB ROM', NULL, 4),
(17, '4GB ROM ', NULL, 4),
(18, '2GB ROM', NULL, 4),
(19, '1TB Disk', NULL, 5),
(20, '500GB Disk', NULL, 5),
(21, '512GB SSD', NULL, 5),
(22, '256GB SSD', NULL, 5),
(23, '128GB SSD', NULL, 5),
(24, '4K/3K/2K Resolution', NULL, 6),
(25, '1920*1080 Full HD', NULL, 6),
(26, '1366*768 Screen', NULL, 6),
(27, 'Other Screen', NULL, 6),
(28, 'Bluetooth 4.2', NULL, 7),
(29, 'Bluetooth 4.1', NULL, 7),
(30, 'Bluetooth 4.0 or less', NULL, 7);

-- --------------------------------------------------------

--
-- 表的结构 `hardware_category`
--

DROP TABLE IF EXISTS `hardware_category`;
CREATE TABLE `hardware_category` (
  `hardware_categoryID` int(11) NOT NULL,
  `hardware_category_name` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `hardware_category`
--

INSERT INTO `hardware_category` (`hardware_categoryID`, `hardware_category_name`) VALUES
(1, 'CPU'),
(2, 'GPU'),
(3, 'screen_size'),
(4, 'ROM'),
(5, 'hard_disk'),
(6, 'screen_resolution'),
(7, 'bluetooth');

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
  `email` varchar(45) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `age` int(11) NOT NULL DEFAULT '0',
  `income` int(11) DEFAULT '0',
  `marriage_status` varchar(20) DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `home_customers`
--

INSERT INTO `home_customers` (`customerID`, `username`, `password`, `first_name`, `last_name`, `nick_name`, `email`, `gender`, `age`, `income`, `marriage_status`) VALUES
(10001, 'gjj', '1234', 'Junjia', 'Guo', 'Jeff', 'jug44@pitt.edu', 'male', 24, -11, 'no');

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
('2016-12-05 00:00:00', 1, 3);

-- --------------------------------------------------------

--
-- 表的结构 `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `customerID` int(11) NOT NULL,
  `shipperID` int(11) NOT NULL,
  `billingID` int(11) NOT NULL,
  `ship_addressID` int(11) NOT NULL,
  `billing_addressID` int(11) NOT NULL,
  `since` datetime DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `productID` int(11) NOT NULL,
  `inventory_amount` int(11) NOT NULL,
  `product_name` varchar(45) DEFAULT NULL,
  `price` float NOT NULL,
  `home_discount` float DEFAULT '100',
  `business_discount` float DEFAULT '100',
  `status` int(11) DEFAULT '1' COMMENT 'status: 0: off , 1:on',
  `branch` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `products`
--

INSERT INTO `products` (`productID`, `inventory_amount`, `product_name`, `price`, `home_discount`, `business_discount`, `status`, `branch`) VALUES
(1, 3, 'Hardware Test', 1000, 99, 96, 1, 'Apple'),
(2, 3, 'Hardware Test', 1000, 99, 96, 1, 'Apple'),
(3, 3, 'Hardware Test', 1000, 99, 96, 1, 'Apple');

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
(1, 8),
(1, 14),
(1, 19),
(1, 21),
(1, 24),
(2, 1),
(2, 25),
(3, 1),
(3, 15);

-- --------------------------------------------------------

--
-- 表的结构 `rate`
--

DROP TABLE IF EXISTS `rate`;
CREATE TABLE `rate` (
  `customerID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `since` datetime NOT NULL,
  `rate` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `shippers`
--

DROP TABLE IF EXISTS `shippers`;
CREATE TABLE `shippers` (
  `shipperID` int(11) NOT NULL,
  `shipper_name` varchar(45) DEFAULT NULL,
  `shipper_phone` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `shippers`
--

INSERT INTO `shippers` (`shipperID`, `shipper_name`, `shipper_phone`) VALUES
(1, 'USPS', '4125833363'),
(2, 'Fedex', '4128880000');

-- --------------------------------------------------------

--
-- 表的结构 `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `supplierID` int(11) NOT NULL,
  `supplier_name` varchar(45) DEFAULT NULL,
  `supplier_phone` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `supply`
--

DROP TABLE IF EXISTS `supply`;
CREATE TABLE `supply` (
  `since` datetime NOT NULL,
  `supplierID` int(11) NOT NULL,
  `productID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  ADD KEY `fk_order_shippers1_idx` (`shipperID`),
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
-- Indexes for table `rate`
--
ALTER TABLE `rate`
  ADD PRIMARY KEY (`customerID`,`productID`,`since`);

--
-- Indexes for table `shippers`
--
ALTER TABLE `shippers`
  ADD PRIMARY KEY (`shipperID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplierID`);

--
-- Indexes for table `supply`
--
ALTER TABLE `supply`
  ADD PRIMARY KEY (`since`,`supplierID`,`productID`);

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
-- 使用表AUTO_INCREMENT `shippers`
--
ALTER TABLE `shippers`
  MODIFY `shipperID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- 使用表AUTO_INCREMENT `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplierID` int(11) NOT NULL AUTO_INCREMENT;
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
  ADD CONSTRAINT `fk_order_products1` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_shippers1` FOREIGN KEY (`shipperID`) REFERENCES `shippers` (`shipperID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
