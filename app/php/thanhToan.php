<?php
    session_start();
    require_once 'db.php';
    require_once 'object.php';
    require_once 'decode.php';
    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];
    

    // Accept Link
    // $maLoaiPhong = '';
    if(isset($_SESSION['maLoaiPhong'])){
        $maLoaiPhong = $_SESSION['maLoaiPhong'];
        $maKhachSan = $_SESSION['maKhachSan'];
        $select_room = $_SESSION['select_room'];
        $option = $_SESSION['option'];
    }
    if($action=='getLoaiPhong'){
        if(isset($maLoaiPhong)){
            $result = Db::get_Phong_info($maLoaiPhong);
            $result['moTa'] = json_decode($result['moTa']);
            $result['select_room'] = $select_room;
            $result['maKhachSan'] = $maKhachSan;
            $result['option'] = $option;
            echo json_encode($result);
        }
        else
            echo json_encode(['success'=>false]);
        // echo $maLoaiPhong;
    }
    if($action=='datPhong_info'){
        // echo ['success'=>true]
        if(isset($_SESSION['timestart'])){
            $timestart = strtotime($_SESSION['timestart']);
            $timeend = strtotime($_SESSION['timeend']);
            if ($timestart>$timeend or $timestart<time()){
                $timestart = strtotime('+1 day');
                $timeend = strtotime('+2 day');
                $night = 1;
            }
            else
                $night = date('d', $timeend) - date('d', $timestart);
        }
        else{
            $timestart = time();
            $timeend = strtotime('+1 day');
            $night = 1;
        }
        echo json_encode(['success'=>true, 'timestart'=>str_replace(' ', 'T', date('Y-m-d h:i:s', $timestart)), 'timeend'=>str_replace(' ', 'T', date('Y-m-d h:i:s', $timeend)), 'night'=>$night]);
    }
    if($action == 'datPhong_confirm'){

        $timestart = $_POST['timestart'];
        $timeend = $_POST['timeend'];
        $night = $_POST['night'];
        $email = $_POST['email'];
        $sdt = $_POST['sdt'];
        $hoTen = $_POST['hoTen'];
        $tinhthanhpho = $_POST['tinhthanhpho'];
        $PTTT = $_POST['PTTT'];
        $address_bill = $_POST['address_bill'];
        $address_company = $_POST['address_company'];
        $code = $_POST['code'];
        $company = $_POST['company'];
        $chiPhi = $_POST['chiPhi']*$night;
        $maLoaiPhong = $_POST['maLoaiPhong'];
        $soluong = $_POST['select_room'];
        if(empty($option))
            $option = '';

        if($_POST['dangnhap']=='true')
            echo json_encode(Db::ndDatPhong($_POST['maSo_ND'], $maLoaiPhong, $soluong, $timestart, $timeend, $chiPhi, $option, $PTTT, $email, $sdt, $hoTen, $tinhthanhpho, $address_bill, $address_company, $code, $company));
        else
            echo json_encode(Db::khachDatPhong($_SESSION['maTruyCap'], $maLoaiPhong, $soluong, $timestart, $timeend, $chiPhi, $option, $PTTT, $hoTen, $email, $sdt, $tinhthanhpho, $address_bill, $address_company, $code, $company));
    }
?>      