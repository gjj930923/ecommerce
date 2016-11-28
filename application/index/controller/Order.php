<?php
namespace app\index\controller;
use think\Controller;

class Order extends Controller
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
                $customer = Home_customers::get($_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
            else{
                $customer = Business_customers::get($_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
        }
    }

    public function index(){
        $customerID = $_SESSION['customerID'];
        $orders = Db::table('orders')->where('customerID=' . $customerID)->order('since desc')->select();
        $this->assign('orders', $orders);
        return $this->fetch();
        //return "Orders here!";
    }
}