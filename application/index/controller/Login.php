<?php
namespace app\index\controller;
use think\Controller;
use think\view;
use think\Url;

class Login extends Controller
{
    public function index()
    {
        //$time = date("Y-m-d",time());
        //$this->assign('time', $time);
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
        $time = date("Y-m-d",time());
        if(isset($_POST["username"])&&isset($_POST["password"]))
        {
            if(!empty($_POST["username"])&&!empty($_POST["password"]))
            {
                $username = $_POST["username"];
                $password = $_POST["password"];
                $condition=array("username"=>$username,"password"=>$password);
                $user=db("login")->where($condition)->find();
                if($user)
                {
                    session_start();
                    //return $this->fetch("index");
                    //$this->success('新增成功', 'index');
                    //$this->redirect('index');
                    //redirect('http://'.$_SERVER['HTTP_HOST']);
                    //$this->redirect($_SERVER['HTTP_HOST'].str_replace(".html", "", url("Index/index")));
                    $_SESSION['username'] = $user["username"];
                    $url = str_replace(".html", "", url("Index/index"));
                    $url = str_replace("/index", "", $url);
                    $this->success('登录成功！'.$_SESSION['username'], $url);
                    //redirect(Url::build("index"));
                    //return "OH MY GOD!";
                    //$this->redirect(url("Index/index"));
                    //return "OH MY GOD!";
                }
                else
                {
                    $this->error('新增失败');
                }
                //return "Hello " . $_POST['username'];
                //$this->assign('username', $_POST["username"]);
            }
            else
            {
                $this->assign('notice', "Please enter your Username and Password");
                //$this->error('User does not exist!');
                return $this->fetch();
            }
        }
        else
        {
            //return "Please contact IT departemnt.";
            return $this->fetch();
        }
        //$this->assign('time', $time);

    }

    function logout(){
        session_start();
        unset($_SESSION['username']);
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->success('Logout success!', $url);
    }
}



