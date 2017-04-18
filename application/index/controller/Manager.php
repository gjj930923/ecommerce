<?php
namespace app\index\controller;
use think\Controller;
use GraphAware\Neo4j\Client\ClientBuilder;
use think\Db;


class Manager extends Controller
{
    private static $client;
    public function _initialize()
    {
       self::$client = ClientBuilder::create()
       ->addConnection('default', 'http://php:php@localhost:7474')
       ->addConnection('bolt', 'bolt://php:php@localhost:7687')
       ->build();
     }
    public function index()
    {
        echo "Manager Test";
    }
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

        //$products=Db('products')->order(['sales_volume'=>'desc'])->select();
        $q = "MATCH (n:products) RETURN n ORDER BY ToInteger(n.sales_volume) DESC";
        $result = self::$client->run($q);
        $products = array();
        foreach ($result->getRecords() as $record) {
            $row = array();
            $row['inventory_amount'] = $record->value("n")->value("inventory_amount");
            $row['productID'] = $record->value("n")->value("productID");
            $row['business_discount'] = $record->value("n")->value("business_discount");
            $row['price'] = $record->value("n")->value("price");
            $row['home_discount'] = $record->value("n")->value("home_discount");
            $row['weight'] = $record->value("n")->value("weight");
            $row['product_name'] = $record->value("n")->value("product_name");
            $row['brand'] = $record->value("n")->value("brand");
            $row['sales_volume'] = $record->value("n")->value("sales_volume");
            $row['status'] = $record->value("n")->value("status");
            $products[] = $row;
        }
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

          //home customer made order
            $q = "MATCH (n:Homec_count_r) RETURN n.count as count LIMIT 1";
            $result = self::$client->run($q);
            foreach ($result->getRecords() as $record) {
                $Homec = $record->value("count");
            }
            if(!isset($Homec)) $Homec = 0;
            $this->assign('total_Homec',$Homec);
            //business customer made order
            $q = "MATCH (n:Businessc_count_r) RETURN n.count as count LIMIT 1";
            $result = self::$client->run($q);
            foreach ($result->getRecords() as $record) {
                $Businessc = $record->value("count");
            }
            if(!isset($Businessc)) $Homec = 0;
            $this->assign('total_Businessc',$Businessc);
            
           
              //  $this->assign('total_Homec',$Homec[0]);
           
              //  $this->assign('total_Businessc',$Businessc[0]);
             $q = 'match (n:Businessc_count_r) return toFloat(count(1)) as count';
            $result = self::$client->run($q);
             foreach ($result->getRecords() as $record1) {
                  $record1->value('count');
               }

          $q = 'match (n:Homec_count_r) return toFloat(count(1)) as count';
          $result = self::$client->run($q);
          foreach ($result->getRecords() as $record2) {
               $record2->value('count');
              }

         $ratio1 = ($record1->value('count'))/($record2->value('count'));

         $q = 'match (n:Businessc_count) return toFloat(count(1)) as count';
         $result = self::$client->run($q);
         foreach ($result->getRecords() as $record1) {
              $record1->value('count');
           }

    $q = 'match (n:Homec_count) return toFloat(count(1)) as count';
    $result = self::$client->run($q);
    foreach ($result->getRecords() as $record2) {
        $record2->value('count');
    }

        $ratio2 =  ($record1->value('count'))/($record2->value('count'));
            $this->assign('ratio_r',$ratio1);
            $this->assign('ratio',$ratio2);
          
           $q = 'MATCH (n:Homec_Dimension) RETURN n.income, n.gender, n.Lname, n.Nname, n.Fname as Fname, n.age, n.marriage_status, n.cid';
          $result = self::$client->run($q);
          $home_customers=array();
          foreach ($result->getRecords() as $record2) {
               //$record2->value('n.income');
               //$record2->value('n.gender');
               //$r2[]=$record2->value('n.Lname');
               //$record2->value('n.Nname');
               //$r[]=$record2->value('Fname');
               //$record2->value('n.age');
               //$record2->value('n.marriage_status');
                $row['income'] = $record2->value('n.income');
                $row['gender'] = $record2->value('n.gender');
                $row['Lname'] = $record2->value('n.Lname');
                $row['Nname'] = $record2->value('n.Nname');
                $row['Fname'] = $record2->value('Fname');
                $row['age'] = $record2->value('n.age');
                $row['marriage_status'] = $record2->value('n.marriage_status');
                $home_customers[] = $row;
           }

          $q = 'MATCH (n:Businessc_Dimension) RETURN n.business_category, n.Cname, n.annual_income';
          $result = self::$client->run($q);
          $business_customers = array();
           foreach ($result->getRecords() as $record3) {
                $row['business_category'] = $record3->value('n.business_category');
                $row['Cname'] = $record3->value('n.Cname');
                $row['annual_income'] = $record3->value('n.annual_income');
                $business_customers[] = $row;
           }
          
            $this->assign('Bdimension',$record3);

        
         //   $r=$_record[$record2];
           // $this->assign('Hdimension',$record2);
                $this->assign('Hdimension',$home_customers);
                $this->assign('Bdimension',$business_customers);
                //$this->assign('r2',$r2);

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
            //
            //
            /*
           $q = 'MATCH (n:Homec_Dimension) RETURN n.income, n.gender, n.Lname, n.Nname, n.Fname as Fname, n.age, n.marriage_status, n.cid';
          $result = self::$client->run($q);
          $r=array();
          foreach ($result->getRecords() as $record2) {
               //$record2->value('n.income');
               //$record2->value('n.gender');
               //$record2->value('n.Lname');
               //$record2->value('n.Nname');
               $r[]=$record2->value('Fname');
               //$record2->value('n.age');
               //$record2->value('n.marriage_status');

           }*/
           $date = array();
           $date[] = date("Y-m-d", strtotime("-7 day"));
           $date[] = date("Y-m-d", strtotime("-6 day"));
           $date[] = date("Y-m-d", strtotime("-5 day"));
           $date[] = date("Y-m-d", strtotime("-4 day"));
           $date[] = date("Y-m-d", strtotime("-3 day"));
           $date[] = date("Y-m-d", strtotime("-2 day"));
           $date[] = date("Y-m-d", strtotime("-1 day"));
           $this->assign('date', $date);

            $q = 'MATCH (n:Total_sales) RETURN n.sales AS sales';
            $result = self::$client->run($q);
            foreach ($result->getRecords() as $record1){
                    $total_sales=intval($record1->value('sales'));
              }

                    //$total_sales=$record1->value('sales');

                $this->assign('total_sales',$total_sales);
           
           // else
            //{
             //   $this->error("Something wrong happen");
           // }

            // Dell
               $q ="MATCH (n:Brand_sales) where n.brand='Dell' RETURN n.sales";
               $result = self::$client->run($q);
               foreach ($result->getRecords() as $record1){
                    $dell_sales = $record1->value('n.sales');
               }
                $this->assign('dell_sales',$dell_sales);
            

            //Apple
                $q ="MATCH (n:Brand_sales) where n.brand='Apple' RETURN n.sales";
               $result = self::$client->run($q);
               foreach ($result->getRecords() as $record1){
                    $apple_sales = $record1->value('n.sales');
               }
           
                $this->assign('apple_sales',$apple_sales);
           

            //Acer
                $q ="MATCH (n:Brand_sales) where n.brand='Acer' RETURN n.sales";
               $result = self::$client->run($q);
               foreach ($result->getRecords() as $record1){
                    $acer_sales = $record1->value('n.sales');
               }
                $this->assign('acer_sales',$acer_sales);
            
            //ASUS
                $q ="MATCH (n:Brand_sales) where n.brand='ASUS' RETURN n.sales";
               $result = self::$client->run($q);
               foreach ($result->getRecords() as $record1){
                    $asus_sales = $record1->value('n.sales');
               }
                $this->assign('asus_sales',$asus_sales);
            
            //
           // $result = db("Brand_sales")->select();
             $q = "MATCH (n:Brand_sales) RETURN n.brand, n.sales";
       $result = self::$client->run($q);
       foreach ($result->getRecords() as $record1){
            $record1->value('n.brand');
            $record1->value('n.sales');
       }
          $result = $record1;
              $this->assign('brands',$result);

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


            return $this->fetch("Brands");
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
            $data=(['year'=>$year,'month'=>$month,'day'=>$day]);
            $q = "MATCH (n:top5) WHERE n.year='".$year."' AND n.month='".$month."' AND n.day='".$day."' RETURN n ORDER BY ToInteger(n.sales) DESC LIMIT 5";
            $result = self::$client->run($q);
            $top5 = array();
            foreach ($result->getRecords() as $record) {
                $row['Pname'] = $record->value("n")->value("Pname");
                $row['sales'] = $record->value("n")->value("sales");
                $top5[] = $row;
            }
            $q = "MATCH (n:bottom5) WHERE n.year='".$year."' AND n.month='".$month."' AND n.day='".$day."' RETURN n ORDER BY ToInteger(n.sales) LIMIT 5";
            $result = self::$client->run($q);
            $bottom5 = array();
            foreach ($result->getRecords() as $record) {
                $row['Pname'] = $record->value("n")->value("Pname");
                $row['sales'] = $record->value("n")->value("sales");
                $bottom5[] = $row;
            }
            $q = "MATCH (n:Brand_date_sales) WHERE n.Year='".$year."' AND n.Month='".$month."' AND n.Date='".$day."' RETURN n ORDER BY ToInteger(n.Sales) DESC LIMIT 1";
            $result = self::$client->run($q);
            $brand = array();
            foreach ($result->getRecords() as $record) {
                $row['brand'] = $record->value("n")->value("Brand");
                $row['sales'] = $record->value("n")->value("Sales");
                $brand[] = $row;
            }
            $q = "MATCH (n:Bcategory_date_sales) WHERE n.year='".$year."' AND n.month='".$month."' AND n.day='".$day."' RETURN n ORDER BY ToInteger(n.sales) DESC LIMIT 2";
            $result = self::$client->run($q);
            $bcategory = array();
            foreach ($result->getRecords() as $record) {
                $row['Bcategory'] = $record->value("n")->value("Bcategory");
                $row['sales'] = $record->value("n")->value("sales");
                $bcategory[] = $row;
            }
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
            //$result=db('Product_dimension')->select();
            $q = "MATCH (n:Product_Dimension) RETURN n.Pname as Pname";
            $result = self::$client->run($q);
            $Pdimension = array();
            foreach ($result->getRecords() as $record) {
                $row['Pname'] = $record->value("Pname");
                $Pdimension[] = $row;
            }
            $this->assign('Pdimension',$Pdimension);

            if(isset($_POST['Pname']))
            {
                $Pname=$_POST['Pname'];
            }
            else
            {
                $Pname="";
            }
            //$result=db('Pname_bcategory_sales')->where('Pname',$Pname)->order(['sales'=>'desc'])->select();
            $q = "MATCH (n:Pname_Bcategory_sales) WHERE n.Pname = '".$Pname."' RETURN n ORDER BY ToInteger(n.sales) DESC";
            $result = self::$client->run($q);
            $PBS = array();
            foreach ($result->getRecords() as $record) {
                $row['Pname'] = $record->value("n")->value("Pname");
                $row['Bcategory'] = $record->value("n")->value("Bcategory");
                $row['sales'] = $record->value("n")->value("sales");
                $PBS[] = $row;
            }
            $this->assign('Pname_Bcategory_sales',$PBS);
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
            //$product=db('Product_dimension')->select();
            $q = "MATCH (n:Product_Dimension) RETURN n.Pname as Pname";
            $result = self::$client->run($q);
            $Pdimension = array();
            foreach ($result->getRecords() as $record) {
                $row['Pname'] = $record->value("Pname");
                $Pdimension[] = $row;
            }
            $this->assign('product',$Pdimension);

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
            //$result=db("Pname_price_sales")->where('Pname',$pname)->order(['price'=>'asc'])->select();
            $q = "MATCH (n:Pname_price_sales) WHERE n.Pname = '".$pname."' RETURN n ORDER BY n.price";
            $result = self::$client->run($q);
            $PPS = array();
            foreach ($result->getRecords() as $record) {
                $row['price'] = intval($record->value("n")->value("price"));
                $row['sales'] = intval($record->value("n")->value("sales"));
                $PPS[] = $row;
            }
            $d=array();
            foreach ($PPS as $r)
            {
                $a=['x'=>$r['price'],'y'=>$r['sales']];
                $d[]=$a;
            }
            $demand=json_encode($d);
            //echo $demand;
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

        $q = "MATCH (n:Product_Dimension) RETURN n.Pname as Pname";
        $result = self::$client->run($q);
        $Pdimension = array();
        foreach ($result->getRecords() as $record) {
           $row['Pname'] = $record->value("Pname");
           $Pdimension[] = $row;
        }
        $this->assign('product',$Pdimension);

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
        $conditions = "n.Pname = '".$pname."' AND n.year = '".$year."' AND n.month = '".$month."'";
        $result=db('Pname_nname_sales')->where($condition)->select();
        $this->assign('home',$result);


        //$result=db('Pname_cname_sales')->where($condition)->select();
        $q = "MATCH (n:Pname_Cname_sales) WHERE ".$conditions." RETURN n";
        $result = self::$client->run($q);
        $PCS = array();
        foreach ($result->getRecords() as $record) {
           $row['Cname'] = $record->value("n")->value("Cname");
           $row['annual_income'] = $record->value("n")->value("annual_income");
           $row['business_category'] = $record->value("n")->value("business_category");
           $PCS[] = $row;
        }
        $this->assign('business',$PCS);

        return $this->fetch();
    }
}