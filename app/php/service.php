<?php
    require_once ("db.php");
    function get_user_ip() {
        if (array_key_exists('HTTP_X_FORWARDED_FOR', $_SERVER) && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            if (strpos($_SERVER['HTTP_X_FORWARDED_FOR'], ',') > 0) {
                $addr = explode(",",$_SERVER['HTTP_X_FORWARDED_FOR']);
                return trim($addr[0]);
            } else {
                return $_SERVER['HTTP_X_FORWARDED_FOR'];
            }
        } else {
            return $_SERVER['REMOTE_ADDR'];
        }
    }
    function toDateTime($time){
        $newTime = str_replace('/', '-', $time);
        return date('Y-m-d h:i:s', strtotime($newTime));
    }
    // echo toDateTime('26/10/1999 10:12:30');
    // echo get_user_ip();
    // function 
    // if(isset($_REQUEST["action"]));
    //     $action=$_REQUEST["action"];
    // if(isset($_GET["id"]) && !$action){
    //     if($_REQUEST["id"]){
    //         $kq=DbClass::get($_REQUEST["id"]);
    //     }
    //     echo json_encode($kq->tojson());
    //     exit(0);
    // }
    // if($action=="del"){
    //     if(DbClass::delete($_REQUEST['id'])==1)
    //         $kq = array("isvalid"=>true,"msg"=>"Đã xoá");
    //     else
    //         $kq = array("isvalid"=>false,"msg"=>"Lỗi xoá sản phẩm ".$_REQUEST['id']);
    //     echo json_encode($kq);
    //     exit(0);
    // }
    // if($action=="search"){
    //     $json =array();
    //     $dssp = DbClass::search($_REQUEST['kw']);
    //     for($i=0;$i<count($dssp);$i++)
    //         $json[]=$dssp[$i]->tojson();
    //     echo json_encode($json);
    //     exit(0);
    // }
    // if($action=="add"){
    //     if(isset($_POST["sp"]))
    //         $st = $_POST["sp"];
    //     else {
    //         $json = file_get_contents('php://input');
    //         $st = json_decode($json);
    //     }
    //     $sp=new SanPham();
    //     $sp->fromJson($st);
    //     if(!$sp->image)
    //         $sp->image="";
    //     if(DbClass::add($sp)===1){
    //         $kq = array("isvalid"=>true,"msg"=>"Đã lưu", "item"=>$sp);
    //     }
    //     else
    //         $kq = array("isvalid"=>false,"msg"=>"Lỗi lưu sản phẩm ". DbClass::$db->error, "sp"=>$sp,"sent"=>$st);
    //     echo json_encode($kq);
    //     exit(0);
    // }
    // if($action=="modify"){
    //     if(isset($_POST["sp"]))
    //         $st = $_POST["sp"];
    //     else {
    //         $json = file_get_contents('php://input');
    //         $st = json_decode($json);
    //     }
    //     $sp=new SanPham();
    //     $sp->fromJson($st);
    //     // if(!$sp->image)
    //     //     $sp->image="";
    //     if(DbClass::edit($sp)<=1){
    //         $kq = array("isvalid"=>true,"msg"=>"Đã sửa", "item"=>$sp);
    //     }
    //     else
    //         $kq = array("isvalid"=>false,"msg"=>"Lỗi lưu sản phẩm ". DbClass::$db->error, "sp"=>$sp,"sent"=>$st);
    //     echo json_encode($kq);
    //     exit(0);
    // }
?>