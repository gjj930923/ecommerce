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
		return $this->fetch();
	}
}