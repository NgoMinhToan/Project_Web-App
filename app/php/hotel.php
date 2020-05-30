<?php
    session_start();
    require_once 'db.php';
    require_once 'object.php';
    require_once 'decode.php';
    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];
    

    
    if($action == 'setKhuVuc'){
        $rs = DB::ksInKv($_POST['maKhuVuc']);
        echo json_encode($rs);
    }
    
    if($action == 'getLoaiPhong'){
        $result = Db::get_Phong_info_all($_POST['maKhachSan']);
        for($i=0;$i<count($result);$i++)
            $result[$i]['moTa'] = json_decode($result[$i]['moTa']);
        echo json_encode($result);
    }

    if($action=='getLoaiPhong1'){
        $result = Db::get_Phong_info($_POST['maLoaiPhong']);
        $result['moTa'] = json_decode($result['moTa']);
        echo json_encode($result);
    }

    if($action == 'ks_info'){
        $result = Db::get_Ks_Info($_POST['maKhachSan']);
        $result['anhReview'] = json_decode($result['anhReview']);
        $result['diemDen'] = json_decode($result['diemDen']);
        $result['tienNghi'] = json_decode($result['tienNghi']);
        echo json_encode($result);
    }

    if($action == 'ks_info_all'){
        $result = Db::get_Ks_Info_all();
        for($i=0;$i<count($result);$i++){
            $result[$i]['anhReview'] = json_decode($result[$i]['anhReview']);
            $result[$i]['diemDen'] = json_decode($result[$i]['diemDen']);
            $result[$i]['tienNghi'] = json_decode($result[$i]['tienNghi']);

        }
        echo json_encode($result);
    }

    // Chuyển Hướng
    if($action == 'direction'){
        $_SESSION['maKhachSan'] = $_POST['maKhachSan'];
        $_SESSION['maLoaiPhong'] = $_POST['maLoaiPhong'];
        $_SESSION['select_room'] = $_POST['select_room'];
        $_SESSION['timestart'] = $_POST['timestart'];
        $_SESSION['timeend'] = $_POST['timeend'];
        $_SESSION['option'] = $_POST['option'];
        echo json_encode(['success'=>true]);
    }

    
?>