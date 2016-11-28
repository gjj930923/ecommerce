<?php
/**
 * Created by PhpStorm.
 * User: guo
 * Date: 11/28/16
 * Time: 3:43 PM
 */
namespace app\index\controller;
use think\Controller;

class User extends Controller
{
    public function _initialize()
    {

    }

    public function index()
    {
        //Initialize to clarity whether logined
        session_start();
        if (!isset($_SESSION['customerID'])) {
            //$url = str_replace(".html", "", url("Index/index"));
            //$url = str_replace("/index", "", $url);
            $this->error("You need to log in first!");
        } else {
            if ($_SESSION['customerID'] % 2 == 1) {
                $customer = Home_customers::get($_SESSION['customerID']);
                $this->assign('customer', $customer);
            } else {
                $customer = Business_customers::get($_SESSION['customerID']);
                $this->assign('customer', $customer);
            }
        }
        return $this->fetch();
        //return "Orders here!";
    }

    public function signin()
    {
        session_start();
        if($_SESSION['customerType'] == "Customer"){
            
        }
        else if($_SESSION['customerType'] == "Business"){

        }
        else{
            return $this->fetch();
        }
    }

    //Only comes after the signin step
    public function fillAddress()
    {

    }

    //Only comes after fillAddress step()
    public function fillCardInfo(){

    }
}