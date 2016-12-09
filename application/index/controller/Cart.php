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
                $customer = Db::table("home_customers")->where("customerID=".$_SESSION['customerID'])->find();
                $this->assign('customer', $customer);
                $this->assign('name', $customer['nick_name']);
            }
            else{
                $customer = Db::table("business_customers")->where("customerID=".$_SESSION['customerID'])->find();
                $this->assign('customer', $customer);
                $this->assign('name', $customer['company_name']);
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
        if(isset($_POST['billingID']) && isset($_POST['addressID']) && isset($_POST['billingAddressID'])){
            //maybe should be modified
            //$productID = explode(" ", $_GET['productID']);
            $cartProduct = Db::table("cart")->where("customerID", $userID)->select();
            $productID = array();
            foreach ($cartProduct as $p) {
                $productID[] = $p['productID'];
            }
            foreach ($productID as $id){
                $product = Db::table('products')->where(array('productID' => $id))->find();
                $amount = Db::table('cart')->where(array('customerID' => $userID, "productID" => $id))->find();
                if(!$product){
                    $this->error("A product in the cart does not exist");
                }
                else if(intval($product['status']) == 0){
                    $this->error($productID['name']." is unavailable now!");
                }
                else if(!$amount){
                    $this->error("Oh no! Something Wrong with {$productID['name']} in the Cart!");
                }
                else if(intval($product['inventory_amount']) < intval($amount['quantity'])) {
                    $this->error($productID['name']." is out of stock now!");
                }
                else{
                    $list = array();
                    $list['status'] = 0;
                    $list['billingID'] = $_POST['billingID'];
                    $list['customerID'] = $userID;
                    $list['productID'] = $id;
                    $list['ship_addressID'] = $_POST['addressID'];
                    $list['billing_addressID'] = $_POST['billingAddressID'];
                    //$list['shipper_ID'] = $_POST['shipperID'];
                    $list['since'] = date("Y-m-d H:i:s",time());
                    $list['quantity'] = $amount['quantity'];
                    $list['price'] = $product['price'];
                    if($userID % 2 == 1){
                        $list['price'] *= $product['home_discount'] / 100.00;
                    }
                    else{
                        $list['price'] *= $product['business_discount'] / 100.00;
                    }
                    $return = Db::table('orders')->insert($list);
                    if($return){
                        //delete the product in the cart
                        $condition = array("customerID" => $userID,  "productID" => $id);
                        Db::table("cart")->where($condition)->delete();
                        //modify the inventory amount
                        Db::table("products")->where("productID", $id)->setDec("inventory_amount", $amount['quantity']);

                    }
                }
            }
            $url = str_replace(".html", "", url("Index/index"));
            $url = str_replace("/index", "", $url);
            $this->success("Your order has been placed!", $url);
        }
        else{
            //The string of productID is a series of product ID(s)
            if(isset($_POST['productID']) && isset($_POST['quantity'])){
                $productIDs = $_POST['productID'];
                $quantities = $_POST['quantity'];
                if(count($productIDs) != count($quantities)){
                    $this->error("Wrong in the Cart!");
                }
                else{
                    if(!is_array($productIDs)){
                        $this->addCart($userID, $productIDs, $quantities);
                    }
                    else{
                        $i = 0;
                        foreach ($productIDs as $pid){
                            $this->addCart($userID, $pid, $quantities[$i]);
                            $i++;
                        }
                    }
                }

            }

            //Get the contents of the cart.
            //$productIDs = $_GET['productID'];
            //$productIDs = str_replace(" ", ",", $productIDs);
            //$condition = 'customerID = ' . $userID . " AND productID IN (" . $productIDs . ")";
            $condition = array('customerID' => $userID);
            $cartList = Db::table('cart')->where($condition)->select();
            if(empty($cartList)){
                $this->error("No products to be checked out! Please check your cart. ");
            }
            else{
                //$shipperList = Db::table('shipper')->select();
                $this->assign('cart', $cartList);
                //Get address list
                $addressList = db("customers_have_address")->where('customerID', $userID)->select();
                $addressIDs = array();
                foreach ($addressList as $addr) {
                    $addressIDs[] = $addr['addressID'];
                }
                if(!empty($addressIDs)) {
                    $addresses = db("address")->where("addressID", "in", $addressIDs)->select();
                    $this->assign("addresses", $addresses);
                }
                //Get billing info
                $billingList = db("customers_have_billinginfo")->where('customerID', $userID)->select();
                $billingIDs = array();
                foreach ($billingList as $billing) {
                    $billingIDs[] = $billing['billingID'];
                }
                if(!empty($billingIDs)){
                    $billinginfos = db("billinginfo")->where("billingID", "in", $billingIDs)->select();
                    $this->assign("billinginfos", $billinginfos);
                }
                return $this->fetch();
            }
        }
    }

    public function addCart($customerID, $productID, $quantity){
        if(Db::table("cart")->where(array("productID" => $productID, "customerID" => $customerID))->find()){
            Db::table("cart")->where(array("productID" => $productID, "customerID" => $customerID))->update(array("quantity" => $quantity));
        }
        else{
            Db::table("cart")->insert(array("productID" => $productID, "customerID" => $customerID, "quantity" => $quantity));
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
