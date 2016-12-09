<?php
namespace app\index\controller;
use think\Controller;
use think\Db;

class Admin extends Controller
{
    public function index()
    {
        $hardware_list = Db::table("hardwares")->order("hardware_categoryID")->select();
        $this->assign("hardware_list", $hardware_list);
        return $this->fetch();
    }
    public function newAdmin()
    {
        return $this->fetch();
    }
    public function addProduct()
    {
        session_start();
       if(isset($_SESSION['adminID']))
       {
            $adminID=$_SESSION['adminID'];
            $product_name=$_POST['product_name'];
            $price=$_POST['price'];
            $home_discount=$_POST['home_discount'];
            $business_discount=$_POST['business_discount'];
            $status=$_POST['status'];
            $amount=$_POST['amount'];
            $hardware_list = $_POST['hardware'];

            $data=(['product_name'=>$product_name,'price'=>$price,'home_discount'=>$home_discount,'business_discount'=>$business_discount,'status'=>$status,'branch'=>$branch,'inventory_amount'=>$amount]);
            $productID=Db::table('products')->insertGetId($data);
            if ($productID)
            {
                $date=date("Y/m/d");
                $data=(['adminID'=>$adminID,'productID'=>$productID,'since'=>$date]);
                $result=Db::table('manage')->insert($data);
                if($result)
                {
                    if($hardware_list){
                        $hardware_data = [];
                        foreach ($hardware_list as $hardwareID){
                            $hardware_data[] = array('productID' => $productID, 'hardwareID' => $hardwareID);
                        }
                        Db::name('products_have_hardware')->insertAll($hardware_data);
                    }
                    $url = str_replace(".html", "", url("Admin/index"));
                    $this->success("ok",$url);
                }
                else
                {
                    $this->error("something wrong happen");
                }
            }
            else
            {
                $this->error("something wrong happen");
            }

        }
        else
        {
            $this->error("fatal error");
        }
    }
    public function goback()
    {
        $url = str_replace(".html", "", url("Index/index"));
        $url = str_replace("/index", "", $url);
        $this->redirect($url,301);
    }
    public function addAdmin()
    {
        if(isset($_POST["username"])&&isset($_POST["password"])&&isset($_POST["check_password"])&&isset($_POST["fname"])&&isset($_POST["lname"])&&isset($_POST["email"]))
        {
            $username=$_POST["username"];
            $password = $_POST["password"];
            $checkpassword = $_POST["check_password"];
            $fname=$_POST["fname"];
            $lname=$_POST["lname"];
            $email=$_POST["email"];
            $result=$this->doubleName($username);
            if($result)
            {
                $this->error("The username has already existed. Please make a new one");
            }
            else
            {
                if ($password != $checkpassword)
                {
                    $this->error("The password are not same");
                }
                else
                {
                    $data = (['username' => $username, 'password' => $password,  'first_name' => $fname, 'last_name' => $lname, 'email' => $email]);
                    $result=Db::table('admin')->insert($data);
                }
                if ($result)
                {
                    $url = str_replace(".html", "", url("Index/index"));
                    $url = str_replace("/index", "", $url);
                    $this->success('Add successfully', $url);
                }
                else
                {
                    $this->error("something weird happen");
                }
            }
        }
        else
        {
            $this->error("fatal error!");
        }

    }
    public function doubleName($username)
    {
            $condition = array('username' => $username);
            $result = db("admin")->where($condition)->find();
            if ($result) {
                return 1;
            } else {
                return 0;
            }
    }
    public function orders()
    {
        return $this->fetch();
    }
}

