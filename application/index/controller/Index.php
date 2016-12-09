<?php
namespace app\index\controller;
use think\Controller;
use think\Db;
class Index extends Controller
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

        session_start();
        if(isset($_SESSION["username"]))
        {
            $this->assign('username',$_SESSION["username"]);
            if (isset($_SESSION['adminID']))
            {
                $this->assign('adminID',$_SESSION['adminID']);
                $this->assign('name',$_SESSION['name']);
            }
            else
            {
                if($_SESSION['customerID'] % 2 == 1)
                {
                    $this->assign('name',$_SESSION['name']);
                }
                else
                {
                    $this->assign('name',$_SESSION['name']);
                }
            }

        }
        $quantitySum = Db::table("orders")->sum('quantity');
        $this->assign("quantitySum", $quantitySum);
        return $this->fetch();
        //return '<style type="text/css">*{ padding: 0; margin: 0; } .think_default_text{ padding: 4px 48px;} a{color:#2E5CD5;cursor: pointer;text-decoration: none} a:hover{text-decoration:underline; } body{ background: #fff; font-family: "Century Gothic","Microsoft yahei"; color: #333;font-size:18px} h1{ font-size: 100px; font-weight: normal; margin-bottom: 12px; } p{ line-height: 1.6em; font-size: 42px }</style><div style="padding: 24px 48px;"> <h1>:)</h1><p> ThinkPHP V5<br/><span style="font-size:30px">十年磨一剑 - 为API开发设计的高性能框架</span></p><span style="font-size:22px;">[ V5.0 版本由 <a href="http://www.qiniu.com" target="qiniu">七牛云</a> 独家赞助发布 ]</span></div><script type="text/javascript" src="http://tajs.qq.com/stats?sId=9347272" charset="UTF-8"></script><script type="text/javascript" src="http://ad.topthink.com/Public/static/client.js"></script><thinkad id="ad_bd568ce7058a1091"></thinkad>';
    }

    public function hello(){
        return $this->fetch();
    }

    public function login(){
        return $this->fetch();
    }
}
