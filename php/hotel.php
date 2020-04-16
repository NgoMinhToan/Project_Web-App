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
        $result['anhReview'] = json_decode($result['anhReview']);
        $result['diemDen'] = json_decode($result['diemDen']);
        $result['tienNghi'] = json_decode($result['tienNghi']);
        echo json_encode($result);
    }
?>