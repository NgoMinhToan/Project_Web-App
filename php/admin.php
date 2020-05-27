<?php
    session_start();
    require_once 'db.php';

    
    $action = '';
    if(isset($_REQUEST['action']))
    $action = $_REQUEST['action'];
    

    if($action=='getHoaDon'){
        $hoadon = Db::thongTinHoaDonADMIN();
            echo json_encode(['hoaDon'=>$hoadon, 'success'=>true]);
    }


    if($action=='duyet'){
        if($_REQUEST['accept']==1)
                $accept = true;
            else
                $accept = false;
        $maHoaDon = $_REQUEST['maHoaDon'];
        echo json_encode(Db::duyetDonADMIN($maHoaDon, $accept));
           
    }

    if($action=='getDanhGia'){
        $danhgia = Db::getDanhGia();
        echo json_encode($danhgia);
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