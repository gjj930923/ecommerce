<?php
namespace app\index\controller;
use think\Controller;
use think\view;
use think\Url;

class Login extends Controller
{
    public function index()
    {
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->redirect($url,301);
    }
    public function login(){
        if(isset($_POST["username"])&&isset($_POST["password"]))
        {
            if(!empty($_POST["username"])&&!empty($_POST["password"]))
            {
                $username = $_POST["username"];
                $password = $_POST["password"];
                $condition = array("username"=>$username);
                $home_customer=db("home_customers")->where($condition)->find();
                if($home_customer)
                {
                    if($home_customer['password'] == $password)
                    {
                        session_start();
                        $_SESSION['username'] = $home_customer['username'];
                        $_SESSION['customerID'] = $home_customer['customerID'];
                        $_SESSION['nick_name']=$home_customer['nick_name'];
                        $url = str_replace(".html", "", url("Index/index"));
                        $url = str_replace("/index", "", $url);
                        //$this->success('Welcome, '.$home_customer['nick_name'] . '!', $url);
                        $this->redirect($url,301);
                    }
                    else
                    {
                        $this->error('Incorrect username or password.');
                    }
                }
                else
                {
                    $business_customer = db("business_customers")->where($condition)->find();
                    if($business_customer['password'] == $password){
                        session_start();
                        $_SESSION['username'] = $business_customer['username'];
                        $_SESSION['customerID'] = $business_customer['customerID'];
                        $_SESSION['company_name']=$business_customer['company_name'];
                        $url = str_replace(".html", "", url("Index/index"));
                        $url = str_replace("/index", "", $url);
                        //$this->success('Welcome, '.$business_customer['company_name'] . '!', $url);
                        $this->redirect($url,301);
                    }
                    else
                    {
                        $this->error('Incorrect username or password.');
                    }
                }
            }
            else
            {
                //$this->error('Please enter your username and password.');
                //$notice= "Please enter your Username and Password";
                //$_SESSION['notice']=$notice;
                //$url = str_replace(".html", "", url("Index/index"));
                //$url = str_replace("/index", "", $url);
                //$this->redirect($url,301);
            }
        }
        else
        {
            $this->error('Fatal problem!.');
            //Show the login page.
            //$this->error('Please input your username and password.');
        }
    }

    function logout(){
        session_start();
        unset($_SESSION['username'], $_SESSION['customerID'],$_SESSION['nick_name'],$_SESSION['company_name']);
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->redirect($url,301);
    }
}



