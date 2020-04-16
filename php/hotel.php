<?php
    require_once 'db.php';
    require_once 'object.php';
    require_once 'decode.php';
    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];
    
    if($action == 'getLoaiPhong'){
        $result = Db::getLoaiPhong($_POST['maKhachSan']);
        for($i=0;$i<count($result);$i++)
            $result[$i]['moTa'] = json_decode($result[$i]['moTa']);
        echo json_encode($result);
    }

    if($action == 'ks_info'){
        $result = Db::getKs_Info($_POST['maKhachSan']);
        for($i=0;$i<count($result);$i++){
            $result[$i]['anhReview'] = json_decode($result[$i]['anhReview']);
            $result[$i]['diemDen'] = json_decode($result[$i]['diemDen']);
            $result[$i]['tienNghi'] = json_decode($result[$i]['tienNghi']);
        }
        echo json_encode($result);
    }
?>