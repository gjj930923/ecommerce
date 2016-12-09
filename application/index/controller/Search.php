<?php
namespace app\index\controller;
use think\Controller;
use think\Db;
class Search extends Controller
{
    public function _initialize()
    {
        session_start();
        if(!isset($_SESSION['customerID'])){
            $url = str_replace(".html", "", url("Index/index"));
            $url = str_replace(".php", "", $url);
            $url = str_replace("/index", "", $url);
            $this->error("You need to log in first!", $url);
        }
        else{
            if($_SESSION['customerID'] % 2 == 1){
                $customer = Db::table("home_customers")->where("customerID=".$_SESSION['customerID'])->find();
                $this->assign('customer', $customer);
            }
            else{
                $customer = Db::table("business_customers")->where("customerID=".$_SESSION['customerID'])->find();
                $this->assign('customer', $customer);
            }
        }
    }

    public function index()
    {
        if(isset($_GET['keyword'])){
            $keyword = $_GET['keyword'];
        }
        else{
            $keyword = "";
        }
        $condition = "product_name LIKE '%".$keyword."%'";
        if(!empty($_GET['type'])) {
            $type = $_GET['type'];
            $type = str_replace(" ", ",", $type);
            $subSQL = "SELECT DISTINCT productID FROM products_have_hardware WHERE 	hardwareID IN (" . $type . ")";
            $condition .= " AND productID IN (" . $subSQL . ")";
        }
        //return "SELECT * FROM products WHERE " . $condition;
        $result = Db::query("SELECT * FROM products WHERE status=1 AND " . $condition);
        $resultWithHardware = array();
        //$result = Db::table("products")->where($condition)->select();
        //$result = $result.toArray();
        //Add hardware list on hardware descriptions
        $i = 0;
        foreach ($result as $r) {
            $productHardware = Db::table("products_have_hardware")->where("productID", $r['productID'])->select();
            $hwName = array();
            foreach ($productHardware as $hw){
                $hwTuple = Db::table("hardwares")->where("hardwareID", $hw['hardwareID'])->find();
                $hwName[] = $hwTuple['hardware_name'];
            }
            foreach ($r as $k => $v){
                $resultWithHardware[$i][$k] = $v;
            }
            $resultWithHardware[$i]['hardware'] = implode(", ", $hwName);
            if($_SESSION['customerID'] % 2 == 1){
                $resultWithHardware[$i]['discount_price'] = round($r['price'] * $r['home_discount'] / 100.00, 2);
            }
            else{
                $resultWithHardware[$i]['discount_price'] = round($r['price'] * $r['business_discount'] / 100.00, 2);
            }

            $i++;
        }
        unset($result);
        $result = $resultWithHardware;
        $this->assign("result", $result);
        //Related hardware
        if($result){
            $productIDs = array();
            foreach ($result as $r){
                $productIDs[] = $r['productID'];
            }
            //return "SELECT DISTINCT * FROM hardwares WHERE hardwareID IN (SELECT hardwareID FROM products_have_hardware WHERE productID IN(".implode(",", $productIDs)."))";
            $hardware = Db::query("SELECT DISTINCT * FROM hardwares WHERE hardwareID IN (SELECT hardwareID FROM products_have_hardware WHERE productID IN(".implode(",", $productIDs)."))");
            $this->assign("hardware", $hardware);
        }
        //Get products in cart
        //$cartList = Db::table("cart")->where(array("customerID" => $_SESSION['customerID']))->select();
        //$pid = array();
        //foreach ($cartList as $cl) {
        //    $pid[] = $cl['productID'];
        //}
        //$cartProductList = Db::table('products')->where('productID', 'in', $pid);
        $cartProductList = Db::query("SELECT * FROM products,cart WHERE cart.customerID = ".$_SESSION['customerID']." AND cart.productID = products.productID ");
        $cartProductIDs = array();
        foreach($cartProductList as $list){
            $cartProductIDs[] = $list['productID'];
        }
        if(!empty($cartProductIDs)){
            $cartProductIDString = implode(",", $cartProductIDs);
            $this->assign("cartProductIDString", $cartProductIDString);
        }
        $this->assign("customerID", $_SESSION['customerID']);
        $this->assign("cartProductList", $cartProductList);
        return $this->fetch();
    }
}
