<?php
namespace app\index\controller;
use think\Controller;
use think\Db;
class Test extends Controller
{
    public function index()
    {
        //phpinfo();
        //$mongo=new MongoDB();
        //var_dump($mongo->connected);
        $result=DB::name('movies')->find();
        echo var_dumo($result);
    }

}