<?php
namespace app\index\controller;
use think\Controller;
use think\Db;

class Admin extends Controller
{
    public function index()
    {
        $cpus = Db::table("hardwares")->where('hardware_categoryID',1)->select();
        $this->assign('cpu',$cpus);
        $gpus = Db::table("hardwares")->where('hardware_categoryID',2)->select();
        $this->assign('gpu',$gpus);
        $screen_sizes = Db::table("hardwares")->where('hardware_categoryID',3)->select();
        $this->assign('screen_size',$screen_sizes);
        $roms = Db::table("hardwares")->where('hardware_categoryID',4)->select();
        $this->assign('rom',$roms);
        $hard_disks = Db::table("hardwares")->where('hardware_categoryID',5)->select();
        $this->assign('hard_disk',$hard_disks);
        $screen_resolutions = Db::table("hardwares")->where('hardware_categoryID',6)->select();
        $this->assign('screen_resolution',$screen_resolutions);
        $bluetooths = Db::table("hardwares")->where('hardware_categoryID',7)->select();
        $this->assign('bluetooth',$bluetooths);
        return $this->fetch();
    }
    public function newAdmin()
    {
        return $this->fetch();
    }
    public function addProduct()
    {
        session_start();
       if(isset($_SESSION['adminID'])) {
           $adminID = $_SESSION['adminID'];
           $product_name = $_POST['product_name'];
           $check = $this->doubleProductName($product_name);
           if ($check) {
               $this->error("product name has been already existed!");
           } else {
               $price = $_POST['price'];
               $home_discount = $_POST['home_discount'];
               $business_discount = $_POST['business_discount'];
               $status = $_POST['status'];
               $amount = $_POST['amount'];
               $cpu = $_POST['cpu'];
               $gpu = $_POST['gpu'];
               $screen_size = $_POST['screen_size'];
               $rom = $_POST['rom'];
               $hard_disk = $_POST['hard_disk'];
               $screen_resolution = $_POST['screen_resolution'];
               $bluetooth = $_POST['bluetooth'];
               $hardware_list = array();
               $hardware_list[] = $cpu + $gpu + $screen_size + $rom + $hard_disk + $screen_resolution + $bluetooth;


               $data = (['product_name' => $product_name, 'price' => $price, 'home_discount' => $home_discount, 'business_discount' => $business_discount, 'status' => $status, 'inventory_amount' => $amount]);
               $productID = Db::table('products')->insertGetId($data);
               if ($productID) {
                   $date = date("Y/m/d");
                   $data = (['adminID' => $adminID, 'productID' => $productID, 'since' => $date]);
                   $result = Db::table('manage')->insert($data);
                   if ($result) {
                       if ($hardware_list) {
                           $hardware_data = [];
                           foreach ($hardware_list as $hardwareID) {
                               $hardware_data[] = array('productID' => $productID, 'hardwareID' => $hardwareID);
                           }
                           Db::name('products_have_hardware')->insertAll($hardware_data);
                       }
                       $url = str_replace(".html", "", url("Admin/index"));
                       $this->success("ok", $url);
                   } else {
                       $this->error("something wrong happen");
                   }
               } else {
                   $this->error("something wrong happen");
               }
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
    public function  order_check_admin()
    {
        session_start();
        if(isset($_SESSION['username']))
        {
            $this->assign('username',$_SESSION['username']);
            $this->assign('name',$_SESSION['name']);
        }
        if (isset($_SESSION['adminID']))
        {
            $this->assign('adminID',$_SESSION['adminID']);
        }

        $orders=Db('products')->alias('p')->join('orders o','o.productID=p.productID')->select();
        $this->assign('orders',$orders);
        $productIDs=array();
        foreach ($orders as $pro)
        {
            $productIDs[]=$pro['productID'];
        }
        $products=Db("products")->where('productID','=',$productIDs);
        $this->assign('products',$products);
        /*$orderIDs=array();
        $customerIDs=array();
        $billingIDs=array();
        $ship_addressIDs=array();
        $billing_addressIDs=array();
        $sinces=array();
        $quantities=array();
        $prices=array();
        $statuses=array();
        $orderIDs[]=$orders['orderID'];
        $customerIDs[]=$orders['customerID'];
        $billingIDs[]=$orders['billingID'];
        $ship_addressIDs[]=$orders['ship_addressID'];
        $billing_addressIDs[]=$orders['billing_addressID'];
        $sinces[]=$orders['since'];
        $quantities[]=$orders['quantity'];
        $prices[]=$orders['price'];
        $statuses[]=$orders['status'];

        $this->assign('orderID',$orderIDs);
        $this->assign('productID',$productIDs);
        $this->assign('customerID',$customerIDs);
        $this->assign('billingID',$billingIDs);
        $this->assign('oship_addressID',$ship_addressIDs);
        $this->assign('billing_addressID',$billing_addressIDs);
        $this->assign('since',$sinces);
        $this->assign('quantity',$quantities);
        $this->assign('price',$prices);
        $this->assign('status',$statuses);
        */

        return $this->fetch();



        return $this->fetch();
    }
    public function doubleProductName($product_name)
    {
       $condition=array('product_name'=>$product_name);
        $result=Db('products')->where($condition)->find();
        if($result)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    public function  updateProduct()
    {

    }
    public function product_check_admin()
    {
        session_start();
        if(isset($_SESSION['username']))
        {
            $this->assign('username',$_SESSION['username']);
            $this->assign('name',$_SESSION['name']);
        }
        if (isset($_SESSION['adminID']))
        {
            $this->assign('adminID',$_SESSION['adminID']);
        }

        $products=Db('products')->order(['sales_volume'=>'desc'])->select();
        $this->assign('products',$products);
        return $this->fetch();
    }
}

