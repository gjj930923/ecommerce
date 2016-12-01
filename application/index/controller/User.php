<?php
/**
 * Created by PhpStorm.
 * User: guo
 * Date: 11/28/16
 * Time: 3:43 PM
 */
namespace app\index\controller;
use think\Controller;
use think\Db;

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
                $customer = Db::table('home_customers')->where(array("customerID" => intval($_SESSION['customerID'])))->find();
                //$customer = Home_customers::get(intval($_SESSION['customerID']));
                $this->assign('customer', $customer);
            } else {
                $customer = Db::table('business_customers')->where(array("customerID" => intval($_SESSION['customerID'])))->find();
                //$customer = Business_customers::get(intval($_SESSION['customerID']));
                $this->assign('customer', $customer);
            }
        }
        return $this->fetch();
        //return "Orders here!";
    }

    public function signin()
    {
        session_start();
        if(isset($_POST['customerType']) && $_POST['customerType'] == "Home"){
            if($_POST['password'] == $_POST['confirm_password']){
                $home_customer = new Home_customer;
                $home_customer->age = intval($_POST['age']);
                $home_customer->email = $_POST['email'];
                $home_customer->first_name = $_POST['first_name'];
                $home_customer->gender = $_POST['gender'];
                $home_customer->income = intval($_POST['income']);
                $home_customer->last_name = $_POST['last_name'];
                $home_customer->marriage_status = $_POST['marriage_status'];
                $home_customer->nick_name = $_POST['nick_name'];
                $home_customer->password = $_POST['password'];
                $home_customer->username = $_POST['username'];
                $home_customer->save();
                if($home_customer->customerID){
                    $_SESSION['customerID'] = $home_customer->customerID;
                    $_SESSION['username'] = $home_customer->username;
                    $url = str_replace(".html", "", url("fillAddress"));
                    $this->redirect($url, 301);
                }
                else{
                    $this->error("Oops! Something wrong with the database!");
                }
            }
            else{
                $this->error("Oh! Your confirm password is not the same as the password!");
            }
        }
        else if(isset($_POST['customerType']) && $_POST['customerType'] == "Business"){
            if($_POST['password'] == $_POST['confirm_password']){
                $business_customer = new Business_customer;
                $business_customer->annual_income = intval($_POST['annual_income']);
                $business_customer->business_categoryID = intval($_POST['business_categoryID']);
                $business_customer->company_name = $_POST['company_name'];
                $business_customer->password = $_POST['password'];
                $business_customer->username = $_POST['username'];
                $business_customer->save();
                if($business_customer->customerID){
                    $_SESSION['customerID'] = $business_customer->customerID;
                    $_SESSION['username'] = $business_customer->username;
                    $url = str_replace(".html", "", url("fillAddress"));
                    $this->redirect($url, 301);
                }
                else{
                    $this->error("Oops! Something wrong with the database!");
                }
            }
            else{
                $this->error("Oh! Your confirm password is not the same as the password!");
            }
        }
        else{
            $business_category = Db::table('business_category')->select();
            $this->assign('business_category', $business_category);
            return $this->fetch();
        }
    }

    //Only comes after the signin step
    public function fillAddress()
    {
        session_start();
        if(isset($_SESSION['customerID'])){
            if(isset($_POST['state'])){
                $address = new Address;
                $address->city = $_POST['city'];
                $address->state = $_POST['state'];
                $address->street = $_POST['street'];
                $address->zip_code  = $_POST['zip_code'];
                $address->save();
                if($address->addressID){
                    $url = str_replace(".html", "", url("fillCardInfo"));
                    $this->redirect($url, 301);
                }
            }
            else{
                return $this->fetch();
            }
        }
        else{
            $this->error("You need to log in first!");
            //return "MAKE AMERICA GREAT AGAIN!  -- DONALD TRUMP";
        }
    }

    //Only comes after signin or fillAddress step()
    public function fillCardInfo(){
        session_start();
        if(isset($_SESSION['customerID'])){
            if(isset($_POST['creditcard_number'])){
                $billinginfo = new Billinginfo;
                $billinginfo->creditcard_number = $_POST['creditcard_number'];
                $billinginfo->expire_month = intval($_POST['expire_month']);
                $billinginfo->expire_year = $_POST['expire_year'];
                $billinginfo->save();
                if($billinginfo->addressID){
                    $url = str_replace(".html", "", url("Index/index"));
                    $url = str_replace("/index", "", $url);
                    $this->success('Successful! Let\'s go to find the new world!', $url);
                }
            }
            else{
                return $this->fetch();
            }
        }
        else{
            $this->error("You need to log in first!");
            //return "MAKE AMERICA GREAT AGAIN!  -- DONALD TRUMP";
        }
    }
}