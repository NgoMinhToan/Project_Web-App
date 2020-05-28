<?php
    session_start();
    require_once 'db.php';

    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];

    if($action=='getHoaDon'){
        $maTruyCap = $_SESSION['maTruyCap'];
        $rs = Db::getMaKhachHang($maTruyCap);
        if($rs['success']==false){
            $rs2 = Db::getUser($maTruyCap);
            if($rs2['success'])
                $rs = Db::getMaKhachHang($rs2['maSo_ND']);
        }
        if($rs['success']){
            $hoadon = Db::thongTinHoaDon($rs['maSo_KH']);
            // echo $rs['maSo_KH'];
            // $hoadon['success'] = true;
            echo json_encode(['hoaDon'=>$hoadon, 'success'=>true]);
        }
        else
            echo json_encode(['success'=>false, 'msg'=>'Chưa là khách hàng']);

    }

    if($action=='cancel'){
        $maHoaDon = $_REQUEST['maHoaDon'];
        $maTruyCap = $_SESSION['maTruyCap'];
        $rs = Db::getMaKhachHang($maTruyCap);
        if($rs['success']==false){
            $rs2 = Db::getUser($maTruyCap);
            if($rs2['success'])
                $rs = Db::getMaKhachHang($rs2['maSo_ND']);
        }
        if($rs['success']){
            echo json_encode(Db::ND_huyPhong($rs['maSo_KH'], $maHoaDon));
        }
        else
            echo json_encode(['success'=>false, 'msg'=>'Chưa là khách hàng']);

    }
    if($action=='changeInfo'){
        echo $_POST['address'];
        $rs = Db::getUser($_SESSION['maTruyCap']);
        if($rs['success']){
            $name = $_POST['name'];
            $email = $_POST['email'];
            $phone = $_POST['phone'];
            $address = $_POST['address'];
            $city = $_POST['city'];
            $new_pwd = $_POST['new_pwd'];
            echo json_encode(Db::changeInfo($rs['maSo_ND'], $name, $email, $phone, $address, $city, $new_pwd));
            header('location: ../app/account/taikhoan.html');
        }

    }
    
?>