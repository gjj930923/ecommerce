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
    	public function Customer()
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

            //home customer register
            $result = db("homec_count_r")->select();
            $Homec_r=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $Homec_r[] = $a['count'];
                }
            }
            //business customer register
            $result = db("businessc_count_r")->select();
            $Businessc_r=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $Businessc_r[] = $a['count'];
                }
            }

            //home customer made order
            $result = db("homec_count")->select();
            $Homec=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $Homec[] = $a['count'];
                }
                $this->assign('total_Homec',$Homec[0]);
            }
            //business customer made order
            $result = db("businessc_count")->select();
            $Businessc=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $Businessc[] = $a['count'];
                }
                $this->assign('total_Businessc',$Businessc[0]);
            }
            $ratio_r=$Homec_r[0]/$Businessc_r[0];
            $ratio=$Homec[0]/$Businessc[0];
            $this->assign('ratio_r',$ratio_r);
            $this->assign('ratio',$ratio);

            $result=db("business_dimension")->select();
            $this->assign('Bdimension',$result);

            $result=db('homec_dimension')->select();
            $this->assign('Hdimension',$result);

    		return $this->fetch();
    	}
        public function Brands()
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
            //Total sales
            $array=DB('total_sales')->select();
            $total_sales=array();
            foreach ($array as $a)
            {
                $total_sales[]=$a['sales'];
            }
            if($total_sales)
            {
                $this->assign('total_sales',$total_sales[0]);
            }
            else
            {
                $this->error("Something wrong happen");
            }
            // Dell
            $result = db("brand_sales")->where('brand',"Dell")->select();
            $dell_sales=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $dell_sales[]=$a['sales'];
                }
                $this->assign('dell_sales',$dell_sales[0]);
            }

            //Apple
            $result = db("brand_sales")->where('brand',"Apple")->select();
            $apple_sales=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $apple_sales[]=$a['sales'];
                }
                $this->assign('apple_sales',$apple_sales[0]);
            }

            //Acer
            $result = db("brand_sales")->where('brand',"Acer")->select();
            $acer_sales=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $acer_sales[]=$a['sales'];
                }
                $this->assign('acer_sales',$acer_sales[0]);
            }
            //ASUS
            $result = db("brand_sales")->where('brand',"ASUS")->select();
            $asus_sales=array();
            if($result)
            {
                foreach ($result as $a)
                {
                    $asus_sales[]=$a['sales'];
                }
                $this->assign('asus_sales',$asus_sales[0]);
            }
            //
            $result = db("brand_sales")->select();
            $this->assign('brands',$result);

           //strtotime
            $date=array();
            $date[]=date("Y-m-d", strtotime("-7 day"));
            $date[]=date("Y-m-d", strtotime("-6 day"));
            $date[]=date("Y-m-d", strtotime("-5 day"));
            $date[]=date("Y-m-d", strtotime("-4 day"));
            $date[]=date("Y-m-d", strtotime("-3 day"));
            $date[]=date("Y-m-d", strtotime("-2 day"));
            $date[]=date("Y-m-d", strtotime("-1 day"));
            $this->assign('date',$date);

            $ymax=0;

            $dell=[];

            for($i=0;$i<7;$i++)
            {
                $condition=(['year'=>date("Y",strtotime($date[$i])),'month'=>(int)date("m",strtotime($date[$i])),'day'=>(int)date("d",strtotime($date[$i])),'brand'=>"Dell"]);
                $result=db('brand_date_sales')->where($condition)->select();
                if($result)
                {
                    foreach ($result as $a)
                    {
                        $dell[]=$a['sales'];
                        if($a['sales']>$ymax)
                        {
                            $ymax=$a['sales'];
                        }
                    }
                }
                else
                {
                        $dell[]=0;
                }
            }
            $this->assign('dell',$dell);

            $apple=[];
            for($i=0;$i<7;$i++)
            {
                $condition=(['year'=>date("Y",strtotime($date[$i])),'month'=>(int)date("m",strtotime($date[$i])),'day'=>(int)date("d",strtotime($date[$i])),'brand'=>"Apple"]);
                $result=db('brand_date_sales')->where($condition)->select();
                if($result)
                {
                    foreach ($result as $a)
                    {
                        $apple[]=$a['sales'];
                        if($a['sales']>$ymax)
                        {
                            $ymax=$a['sales'];
                        }
                    }
                }
                else
                {
                    $apple[]=0;
                }
            }
            $this->assign('apple',$apple);

            $acer=[];
            for($i=0;$i<7;$i++)
            {
                $condition=(['year'=>date("Y",strtotime($date[$i])),'month'=>(int)date("m",strtotime($date[$i])),'day'=>(int)date("d",strtotime($date[$i])),'brand'=>"Acer"]);
                $result=db('brand_date_sales')->where($condition)->select();
                if($result)
                {
                    foreach ($result as $a)
                    {
                        $acer[]=$a['sales'];
                        if($a['sales']>$ymax)
                        {
                            $ymax=$a['sales'];
                        }
                    }
                }
                else
                {
                    $acer[]=0;
                }
            }
            $this->assign('acer',$acer);

            $asus=[];
            for($i=0;$i<7;$i++)
            {
                $condition=(['year'=>date("Y",strtotime($date[$i])),'month'=>(int)date("m",strtotime($date[$i])),'day'=>(int)date("d",strtotime($date[$i])),'brand'=>"ASUS"]);
                $result=db('brand_date_sales')->where($condition)->select();
                if($result)
                {
                    foreach ($result as $a)
                    {
                        $asus[]=$a['sales'];
                        if($a['sales']>$ymax)
                        {
                            $ymax=$a['sales'];
                        }
                    }
                }
                else
                {
                    $asus[]=0;
                }
            }
            $this->assign('asus',$asus);
            $this->assign('ymax',$ymax);
            return $this->fetch();
        }
        public function Sales()
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

            if(isset($_POST['date']))
            {
                $date=$_POST['date'];
                $this->assign('date',$date);
                $year=date("Y",strtotime($date));
                $month=(int)date("m",strtotime($date));
                $day=(int)date("d",strtotime($date));
            }
            else
            {
                $year=1970;
                $month=1;
                $day=1;
            }
            
            $top5=db('top5')->where('year',(string)$year)->where('month',(string)$month)->where('day',(string)$day)->order('sales','desc')->limit(5)->select();
            $bottom5=db('bottom5')->where('year',(string)$year)->where('month',(string)$month)->where('day',(string)$day)->order('sales','asc')->limit(5)->select();         
            $brand=db('brand_date_sales')->where('year',(string)$year)->where('month',(string)$month)->where('day',(string)$day)->order('sales','desc')->limit(1)->select();
            $bcategory=db('bcategory_date_sales')->where('year',(string)$year)->where('month',(string)$month)->where('day',(string)$day)->limit(2)->select();
            $this->assign('top5',$top5);
            $this->assign('bottom5',$bottom5);
            $this->assign('brand',$brand);
            $this->assign('bcategory',$bcategory);

            return $this->fetch();
        }
        public function BvsP()
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
            $result=db('product_dimension')->select();
            $this->assign('Pdimension',$result);

            if(isset($_POST['Pname']))
            {
                $Pname=$_POST['Pname'];
            }
            else
            {
                $Pname="";
            }
            $this->assign('pname', $Pname);
            $result=db('pname_bcategory_sales')->where('Pname',$Pname)->order('sales','desc')->select();
            $this->assign('Pname_Bcategory_sales',$result);
            return $this->fetch();
        }
        public function demand()
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
            $product=db('product_dimension')->select();
            $this->assign('product',$product);

            if(isset($_POST['Pname']))
            {
                $pname=$_POST['Pname'];
               //$this->assign('pname',$pname);

            }
            else
            {
                $pname="";
            }
            $this->assign('pname',$pname);
            $result=db("pname_price_sales")->where('Pname',$pname)->order('price','asc')->select();
            $d=array();
            foreach ($result as $r)
            {
                $a=['x'=>$r['price'],'y'=>$r['sales']];
                $d[]=$a;
            }
            $demand=json_encode($d);
            $this->assign('demand',$demand);


            return $this->fetch();
        }
    public function marketing()
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

        $product=db('product_dimension')->select();
        // if($product)
        // {
        //     $this->error("no");
        // }

        $this->assign('product',$product);

        if(isset($_POST['Pname']))
        {
            $pname=$_POST['Pname'];
        }
        else
        {
            $pname="";
        }
        $this->assign('pname',$pname);
        if(isset($_POST['month']))
        {
            $month=$_POST['month'];
        }
    else
        {
            $month="";
        }

        $month_convert=(["1"=>"January","2"=>"February","3"=>"March","4"=>"April","5"=>"May","6" =>"June", "7"=>"July", "8"=>"August", "9"=>"September", "10"=>"October", "11"=>"November", "12"=>"December"]);
        if($month=="")
        {
            $month_name="";
        }
        else
        {
            $month_name=$month_convert[$month];
        }
        $this->assign('month',$month_name);
        if(isset($_POST['year']))
        {
            $year=$_POST['year'];
        }
    else
        {
            $year="";
        }
        $this->assign('year',$year);
        $condition=(['Pname'=>$pname,'year'=>$year,'month'=>$month]);
        $result=db('pname_nname_sales')->where($condition)->select();
        $this->assign('home',$result);


        $result=db('pname_cname_sales')->where($condition)->select();
        $this->assign('business',$result);

        return $this->fetch();
    }
}