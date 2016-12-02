SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`address` (
  `addressID` INT NOT NULL AUTO_INCREMENT,
  `state` VARCHAR(20) NULL DEFAULT NULL,
  `city` VARCHAR(45) NULL DEFAULT NULL,
  `street` VARCHAR(45) NULL DEFAULT NULL,
  `zip_code` INT NULL,
  PRIMARY KEY (`addressID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.address auto_increment=100;

-- -----------------------------------------------------
-- Table `ecommerce`.`customers_have_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`customers_have_address` (
  `addressID` INT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`addressID`, `customerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`admin` (
  `adminID` INT(15) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `username` VARCHAR(45) NULL DEFAULT NULL,
  `password` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`adminID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.admin auto_increment=1000;

-- -----------------------------------------------------
-- Table `ecommerce`.`billinginfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`billinginfo` (
  `billingID` INT NOT NULL AUTO_INCREMENT,
  `creditcard_number` VARCHAR(20) NULL,
  `expire_month` INT NULL DEFAULT NULL,
  `expire_year` INT NULL,
  PRIMARY KEY (`billingID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.billinginfo auto_increment=2;

-- -----------------------------------------------------
-- Table `ecommerce`.`business_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`business_category` (
  `business_categoryID` INT NOT NULL AUTO_INCREMENT,
  `business_category_name` VARCHAR(45) NULL,
  PRIMARY KEY (`business_categoryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`business_customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`business_customers` (
  `customerID` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `company_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `annual_income` INT NOT NULL DEFAULT 0,
  `business_categoryID` INT NOT NULL,
  PRIMARY KEY (`customerID`),
  INDEX `category_ID` (`business_categoryID` ASC),
  CONSTRAINT `business_customers_ibfk_1`
    FOREIGN KEY (`business_categoryID`)
    REFERENCES `ecommerce`.`business_category` (`business_categoryID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`cart` (
  `customerID` INT NOT NULL,
  `productID` INT NOT NULL,
  `quantity` INT NULL,
  PRIMARY KEY (`customerID`, `productID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`hardware_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`hardware_category` (
  `hardware_categoryID` INT NOT NULL AUTO_INCREMENT,
  `hardware_category_name` VARCHAR(45) NULL,
  PRIMARY KEY (`hardware_categoryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.hardware_category auto_increment=2;

-- -----------------------------------------------------
-- Table `ecommerce`.`hardwares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`hardwares` (
  `hardwareID` INT NOT NULL AUTO_INCREMENT,
  `hardware_name` VARCHAR(45) NULL,
  `hardware_company` VARCHAR(45) NULL,
  `hardware_categoryID` INT NOT NULL,
  PRIMARY KEY (`hardwareID`),
  INDEX `fk_hardwares_hardware_category1_idx` (`hardware_categoryID` ASC),
  CONSTRAINT `fk_hardwares_hardware_category1`
    FOREIGN KEY (`hardware_categoryID`)
    REFERENCES `ecommerce`.`hardware_category` (`hardware_categoryID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.hardwares auto_increment=1000;

-- -----------------------------------------------------
-- Table `ecommerce`.`home_customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`home_customers` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `nick_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `gender` VARCHAR(20) NULL,
  `age` INT NOT NULL DEFAULT 0,
  `income` INT NULL DEFAULT 0,
  `marriage_status` VARCHAR(20) NULL DEFAULT "unknown",
  PRIMARY KEY (`customerID`),
  CHECK (income>=0),
  CHECK (age>=0))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.home_customers auto_increment=10001;

-- -----------------------------------------------------
-- Table `ecommerce`.`manage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`manage` (
  `since` DATETIME NOT NULL,
  `adminID` INT NOT NULL,
  `productID` INT NOT NULL,
  PRIMARY KEY (`adminID`, `productID`, `since`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`shippers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`shippers` (
  `shipperID` INT NOT NULL AUTO_INCREMENT,
  `shipper_name` VARCHAR(45) NULL,
  `shipper_phone` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`shipperID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.shippers auto_increment=1000;

-- -----------------------------------------------------
-- Table `ecommerce`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`products` (
  `productID` INT NOT NULL AUTO_INCREMENT,
  `inventory_amount` INT NULL,
  `product_name` VARCHAR(45) NULL,
  `price` FLOAT NULL,
  `home_discount` FLOAT NULL DEFAULT 1,
  `business_discount` FLOAT NULL DEFAULT 1,
  `status` INT NULL DEFAULT 1 COMMENT 'status: 0: off , 1:on',
  `branch` VARCHAR(45) NULL,
  `url` VARCHAR(200) NULL,
  PRIMARY KEY (`productID`),
	CHECK (inventory_amount>=0) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.products auto_increment=100;

-- -----------------------------------------------------
-- Table `ecommerce`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`orders` (
  `orderID` INT NOT NULL AUTO_INCREMENT,
  `productID` INT NOT NULL,
  `customerID` INT NOT NULL,
  `shipperID` INT NOT NULL,
  `billingID` INT NOT NULL,
  `ship_addressID` INT NOT NULL,
  `billing_addressID` INT NOT NULL,
  `since` DATETIME NULL,
  `quantity` INT NULL,
  `price` FLOAT NULL,
  PRIMARY KEY (`orderID`),
  INDEX `fk_order_shippers1_idx` (`shipperID` ASC),
  INDEX `fk_order_products1_idx` (`productID` ASC),
  INDEX `fk_order_billinginfo1_idx` (`billingID` ASC),
  INDEX `fk_order_address1_idx` (`ship_addressID` ASC),
  INDEX `fk_order_address2_idx` (`billing_addressID` ASC),
  CONSTRAINT `fk_order_shippers1`
    FOREIGN KEY (`shipperID`)
    REFERENCES `ecommerce`.`shippers` (`shipperID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_products1`
    FOREIGN KEY (`productID`)
    REFERENCES `ecommerce`.`products` (`productID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_billinginfo1`
    FOREIGN KEY (`billingID`)
    REFERENCES `ecommerce`.`billinginfo` (`billingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_address1`
    FOREIGN KEY (`ship_addressID`)
    REFERENCES `ecommerce`.`address` (`addressID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_address2`
    FOREIGN KEY (`billing_addressID`)
    REFERENCES `ecommerce`.`address` (`addressID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.orders auto_increment=100;

-- -----------------------------------------------------
-- Table `ecommerce`.`rate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`rate` (
  `customerID` INT NOT NULL,
  `productID` INT NOT NULL,
  `since` DATETIME NOT NULL,
  `rate` INT NULL,
  PRIMARY KEY (`customerID`, `productID`, `since`),
	CHECK (rate>=0 and rate<=10))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`suppliers` (
  `supplierID` INT NOT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(45) NULL,
  `supplier_phone` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`supplierID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
alter table ecommerce.suppliers auto_increment=1000;

-- -----------------------------------------------------
-- Table `ecommerce`.`supply`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`supply` (
  `since` DATETIME NOT NULL,
  `supplierID` INT NOT NULL,
  `productID` INT NOT NULL,
  PRIMARY KEY (`since`, `supplierID`, `productID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ecommerce`.`customers_have_billinginfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`customers_have_billinginfo` (
  `billingID` INT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`billingID`, `customerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`products_have_hardware`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`products_have_hardware` (
  `productID` INT NOT NULL,
  `hardwareID` INT NOT NULL,
  PRIMARY KEY (`productID`, `hardwareID`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
