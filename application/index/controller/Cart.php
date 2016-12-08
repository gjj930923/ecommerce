<?php
namespace app\index\controller;
use think\Controller;
use think\Db;
class Cart extends Controller
{
    public function _initialize()
    {
        session_start();
        if(!isset($_SESSION['customerID'])){
            //$url = str_replace(".html", "", url("Index/index"));
            //$url = str_replace("/index", "", $url);
            $this->error("You need to log in first!");
        }
        else{
            if($_SESSION['customerID'] % 2 == 1){
                $customer = Db::table("home_customers")->where("customerID=".$_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
            else{
                $customer = Db::table("business_customers")->where("customerID=".$_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
        }
    }

    public function index()
    {
        $userID = $_SESSION['customerID'];
        $condition = array("customerID" => $userID);
        $cart = Db::table("cart")->where($condition)->field('quantity,productID')->order('productID')->select();
        $productIDList = "";
        foreach($cart as $item){
            $productIDList .= $item['productID'] . ",";
        }
        $productIDList = rtrim($productIDList, ",");
        $products = Db::table("product")->where("ID IN(" . $productIDList. ")")->order('ID')->select();
        $this->assign($cart);
        $this->assign($products);
        return $this->fetch();
    }

    public function payment(){
        $userID = $_SESSION['customerID'];
        //The process of payment with card number
        if(isset($_POST['cardID'])){
            //maybe should be modified
            if(empty($_POST['shipperID'])){
                $this->error("Shipper Unavailable!");
            }
            else if(empty($_POST['addressID'])){
                $this->error("Address Unavailable!");
            }
            else{
                $productID = explode(" ", $_GET['productID']);
                foreach ($productID as $id){
                    $product = Db::table('product')->where(array('ID' => $id))->find();
                    $amount = Db::table('cart')->where(array('customerID=' => $userID, "productID" => $id))->find();
                    if(!$product){
                        $this->error("A product in the cart does not exist");
                    }
                    else if(intval($product['status']) == 0){
                        $this->error($productID['name']." is unavailable now!");
                    }
                    else if(!$amount){
                        $this->error("Oh no! Something Wrong with {$productID['name']} in the Cart!");
                    }
                    else if(intval($product['Inventory_Amount']) < intval($amount['quantity'])) {
                        $this->error($productID['name']." is out of stock now!");
                    }
                    else{
                        $list = array();
                        $list['billingID'] = $_POST['billingID'];
                        $list['CustomerID'] = $userID;
                        $list['productID'] = $id;
                        $list['shipper_addressID'] = $_POST['shipper_addressID'];
                        $list['billing_addressID'] = $_POST['billing_addressID'];
                        $list['shipper_ID'] = $_POST['shipperID'];
                        $list['since'] = time();
                        $list['quantity'] = $amount['quantity'];
                        $list['price'] = $product['price'];
                        if($userID % 2 == 1){
                            $list['price'] *= $product['home_discount'];
                        }
                        else{
                            $list['price'] *= $product['business_discount'];
                        }
                        $return = Db::table('orders')->insert($list);
                        if($return){
                            //delete the product in the cart
                            $condition = array("customerID" => $userID,  "productID" => $id);
                            Db::table("cart")->where($condition)->delete();
                            //modify the inventory amount
                            Db::table("products")->where("productID", $id)->setDec("inventory_amount", $amount['quantity']);
                            $product = Product::get($id);
                            $product->inventory_amount -= $amount['quantity'];
                            $product->save();
                        }
                    }
                }
                $url = str_replace(".html", "", url("Order/index"));
                $url = str_replace("/index", "", $url);
                $this->success("Your order has been placed!", $url);
            }
        }
        else{
            //The string of productID is a series of product ID(s)
            if(isset($_GET['productID'])){
                $productIDs = $_GET['productID'];
                $productIDs = str_replace(" ", ",", $productIDs);
                $condition = 'customerID = ' . $userID . " AND productID IN (" . $productIDs . ")";
                $cartList = Db::table('cart')->where($condition)->select();
                if(empty($cartList)){
                    $this->error("No products to be checked out! Please check your cart. ");
                }
                else{
                    $shipperList = Db::table('shipper')->select();
                    $this->assign('cart', $cartList);
                    $this->assign('shipperList', $shipperList);
                    $this->fetch();
                }
            }
            else{
                $this->error("No products to be checked out! Please check your cart. ");
            }
        }
    }

    public function addToCart(){
        $customerID = $_POST['customerID'];
        $productID = $_POST['productID'];
        if(isset($_POST['quantity']) && is_numeric($_POST['quantity'])){
            $quantity = $_POST['quantity'];
        }
        else{
            $quantity = 1;
        }
        if(is_numeric($customerID) && is_numeric($productID)){
            Db::table("cart")->where(array('customerID' => $customerID, 'productID' => $productID))->delete();
            $insertData = array('customerID' => $customerID, 'productID' => $productID, 'quantity' => $quantity);
            if(Db::table("cart")->insert($insertData)){
                return json_encode($insertData);
            }
            else{
                return -2;
            }
        }
        else{
            return -1;
        }
    }
}
