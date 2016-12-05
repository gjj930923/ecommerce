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
            $branch=$_POST['branch'];
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
}
