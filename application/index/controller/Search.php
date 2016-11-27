<?php
namespace app\index\controller;
use think\Controller;
class Search extends Controller
{
    public function index()
    {
        $keyword = $_GET['keyword'];
        $condition = "name LIKE %".$keyword."%";
        if(!empty($_GET['type'])) {
            $type = $_GET['type'];
            $type = replace("+", ",", $type);
            $subSQL = "SELECT DISTINCT product_ID FROM Relation WHERE Hardwares_ID IN (" . $type . ")";
            $condition .= " AND product_ID IN (" . $subSQL . ")";
        }
        $result = db("product")->where($condition)->select();
        //$result = $result.toArray();
        $this->assign("result", $result);
        return $this->fetch();
    }
}
