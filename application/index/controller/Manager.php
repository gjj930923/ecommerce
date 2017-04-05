<?php
namespace app\index\controller;
use think\Controller;
use think\Db;

class Manager extends Controller
{
    public function index()
    {}
	public function ManagerIndex()
	{
	    session_start();
        if (isset($_SESSION['adminID']))
        {
            $this->assign('name',$_SESSION['name']);
        }
		return $this->fetch();
	}
	public function password()
    {
        session_start();
        if(!isset($_SESSION['adminID'])){
            $url = str_replace(".html", "", url("Index/index"));
            $url = str_replace(".php", "", $url);
            $url = str_replace("/index", "", $url);
            $this->error("You need to log in first!", $url);
        }
        if(isset($_SESSION['name']))
        {
            $this->assign('name',$_SESSION['name']);
        }
/*
        if(isset($_SESSION['adminID']))
        {
            $this->assign('adminID',$_SESSION['adminID']);
      }
*/
        return $this->fetch();
    }
    public function Detailinfo()
    {
        session_start();
        if( !isset($_SESSION['adminID']))
        {
            $url = str_replace(".html", "", url("Index/index"));
            $url = str_replace(".php", "", $url);
            $url = str_replace("/index", "", $url);
            $this->error("You need to log in first!", $url);
        }
        if(isset($_SESSION['name']))
        {
            $this->assign('name',$_SESSION['name']);
        }
        if(isset($_SESSION['username']))
        {
            $this->assign('username',$_SESSION['username']);
        }
        if(isset($_SESSION['adminID']))
        {
            $this->assign('adminID', $_SESSION['adminID']);
        }
        $this->assign('adminID',$_SESSION['adminID']);
        $adminID=$_SESSION['adminID'];
        $condition=array('adminID'=>$adminID);
        $admin=db('admin')->where($condition)->find();
        $this->assign('username',$admin['username']);
        $this->assign('fname',$admin['first_name']);
        $this->assign('lname',$admin['last_name']);
        $this->assign('email',$admin['email']);

        return $this->fetch();
    }
    public function newAdmin()
    {
        session_start();
        if(isset($_SESSION['name']))
        {
            $this->assign('name',$_SESSION['name']);
        }
        if(isset($_SESSION['username']))
        {
            $this->assign('username',$_SESSION['username']);
        }
        if(isset($_SESSION['adminID']))
        {
            $this->assign('adminID',$_SESSION['adminID']);
        }
        return $this->fetch();
    }
    public function newProduct()
    {
        session_start();
        if(isset($_SESSION['name']))
        {
            $this->assign('name',$_SESSION['name']);
        }
        if(isset($_SESSION['username']))
        {
            $this->assign('username',$_SESSION['username']);
        }
        if(isset($_SESSION['adminID']))
        {
            $this->assign('adminID',$_SESSION['adminID']);
        }

        $cpus = Db::table("hardwares")->where('hardware_categoryID',1)->select();
        $this->assign('cpu',$cpus);
        $gpus = Db::table("hardwares")->where('hardware_categoryID',2)->select();
        $this->assign('gpu',$gpus);
        $RAM_sizes = Db::table("hardwares")->where('hardware_categoryID',3)->select();
        $this->assign('RAM_size',$RAM_sizes);
        $screen_sizes = Db::table("hardwares")->where('hardware_categoryID',4)->select();
        $this->assign('screen_sizes',$screen_sizes);
        $hard_disk_desc = Db::table("hardwares")->where('hardware_categoryID',5)->select();
        $this->assign('Hard_disk_Description',$hard_disk_desc);
        $hard_drive_sizes = Db::table("hardwares")->where('hardware_categoryID',6)->select();
        $this->assign('Hard_Drive_Size',$hard_drive_sizes);
        $os = Db::table("hardwares")->where('hardware_categoryID',7)->select();
        $this->assign('os',$os);
        $screen_resolutions = Db::table("hardwares")->where('hardware_categoryID',8)->select();
        $this->assign('screen_resolutions',$screen_resolutions);

        return $this->fetch();
    }
    public function  CheckOrder()
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
        return $this->fetch();
    }
    public function CheckProduct()
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