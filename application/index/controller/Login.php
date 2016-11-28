<?php
namespace app\index\controller;
use think\Controller;
use think\view;
use think\Url;

class Login extends Controller
{
    public function index()
    {
        return $this->fetch();
    }
    /*public function login($username="",$password="")
    {
        if(isset($_POST['username'])){
            return "Hello " . $_POST['username'];
        }
        else{
            return "Bye Bye.";
        }
        $condition=array("username"=>$username,"password"=>$password);
        $user=M("User")->where($condition)->select();
        if ($user)
        {
            echo "oh yeah";
        }
        else
        {
            echo "sorry";
        }
    }*/

    public function login(){
        if(isset($_POST["username"])&&isset($_POST["password"]))
        {
            if(!empty($_POST["username"])&&!empty($_POST["password"]))
            {
                $username = $_POST["username"];
                $password = $_POST["password"];
                $condition = "username = " . $username;
                $home_customer=db("home_customers")->where($condition)->find();
                if($home_customer)
                {
                    if($home_customer['password'] == $password){
                        session_start();
                        $_SESSION['username'] = $home_customer['username'];
                        $_SESSION['customerID'] = $home_customer['customerID'];
                        $url = str_replace(".html", "", url("Index/index"));
                        $url = str_replace("/index", "", $url);
                        $this->success('Welcome, '.$home_customer['nick_name'] . '!', $url);
                    }
                    else{
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
                        $url = str_replace(".html", "", url("Index/index"));
                        $url = str_replace("/index", "", $url);
                        $this->success('Welcome, '.$business_customer['company_name'] . '!', $url);
                    }
                    else{
                        $this->error('Incorrect username or password.');
                    }
                }
            }
            else
            {
                $this->assign('notice', "Please enter your Username and Password");
                return $this->fetch();
            }
        }
        else
        {
            //Show the login page.
            return $this->fetch();
        }
    }

    function logout(){
        session_start();
        unset($_SESSION['username'], $_SESSION['customerID']);
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->success('Logout success!', $url);
    }
}



