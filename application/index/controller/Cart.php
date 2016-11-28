<?php
namespace app\index\controller;
use think\Controller;
class Cart extends Controller
{
    public function _initialize()
    {
        session_start();
        if(!isset($_SESSION['userID'])){
            //$url = str_replace(".html", "", url("Index/index"));
            //$url = str_replace("/index", "", $url);
            $this->error("You need to log in first!");
        }
        else{
            if($_SESSION['customerID'] % 2 == 1){
                $customer = Home_customers::get($_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
            else{
                $customer = Business_customers::get($_SESSION['customerID']);
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
                $order = new Order;
                $productID = explode("+", $_GET['productID']);
                foreach ($productID as $id){
                    $product = Db::table('product')->where('ID=' . $id)->find();
                    $amount = Db::table('cart')->where('customerID=' . $userID . "AND productID=" . $id)->find();
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
                        $list[0]['billinginfo_ID'] = $_POST['cardID'];
                        $list[0]['Customer_ID'] = $userID;
                        $list[0]['product_ID'] = $id;
                        $list[0]['shipper_ID'] = $_POST['shipperID'];
                        $return = $order->saveAll($list);
                        if($return){
                            //delete the product in the cart
                            $condition = array("customerID" => $userID,  "productID" => $id);
                            Cart::destroy($condition);
                            //modify the inventory amount
                            $product = Product::get($id);
                            $product->inventory_amount -= $amount['quantity'];
                            $product->save();
                        }
                    }
                }
                $url = str_replace(".html", "", url("Order/index"));
                $url = str_replace("/index", "", $url);
                $this->success("Your order has benn placed!", $url);
            }
        }
        else{
            //The string of productID is a series of product ID(s)
            if(isset($_GET['productID'])){
                $productIDs = $_GET['productID'];
                $productIDs = str_replace("+", ",", $productIDs);
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
}
