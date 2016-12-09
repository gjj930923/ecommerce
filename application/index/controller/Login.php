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
                $business_customer = db("business_customers")->where($condition)->find();
                if($home_customer)
                {
                    if($home_customer['password'] == $password)
                    {
                        session_start();
                        $_SESSION['username'] = $home_customer['username'];
                        $_SESSION['customerID'] = $home_customer['customerID'];
                        $_SESSION['name']=$home_customer['nick_name'];
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
                else if ($business_customer)
                {
                    if($business_customer['password'] == $password){
                        session_start();
                        $_SESSION['username'] = $business_customer['username'];
                        $_SESSION['customerID'] = $business_customer['customerID'];
                        $_SESSION['name']=$business_customer['company_name'];
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
                else
                {
                    $username = $_POST["username"];
                    $password = $_POST["password"];
                    $condition = array("username" => $username);
                    $admin = db("admin")->where($condition)->find();
                    if ($admin['password'] == $password)
                    {
                        session_start();
                        $_SESSION['username'] = $admin['username'];
                        $_SESSION['adminID'] = $admin['adminID'];
                        $_SESSION['name']=$admin['first_name']." ".$admin['last_name'];
                        $url = str_replace(".html", "", url("Index/index"));
                        $url = str_replace("/index", "", $url);
                        $this->redirect($url, 301);
                    }
                    else
                    {
                        $this->error('Incorrect username or password.');
                    }
                }
            }
            else
            {
                $this->error("Please enter your username and password");
            }
        }
        else
        {
            $this->error('Fatal problem!.');
        }
    }

    function logout(){
        session_start();
        unset($_SESSION['username'], $_SESSION['customerID'],$_SESSION['nick_name'],$_SESSION['company_name'],$_SESSION['first_name'],$_SESSION['last_name'],$_SESSION['adminID']);
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->redirect($url,301);
    }
}



