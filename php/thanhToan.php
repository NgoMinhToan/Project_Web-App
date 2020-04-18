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
    }
    if($action=='getLoaiPhong'){
        if(isset($maLoaiPhong)){
            $result = Db::get_Phong_info($maLoaiPhong);
            $result['moTa'] = json_decode($result['moTa']);
            $result['select_room'] = $select_room;
            $result['maKhachSan'] = $maKhachSan;
            echo json_encode($result);
        }
        else
            echo json_encode(['success'=>false, 'maLoaiPhong'=>$maLoaiPhong]);
        // echo $maLoaiPhong;
    }
    if($action=='datPhong'){
        // echo ['success'=>true]
        if(isset($_SESSION['timestart'])){
            $timestart = strtotime($_SESSION['timestart']);
            $timeend = strtotime($_SESSION['timeend']);
            if ($timestart>$timeend or $timestart<time()){
                $timestart = time();
                $timeend = strtotime('+1 day');
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
        echo json_encode(['success'=>true, 'timestart'=>date('Y-m-d h:i:s', $timestart), 'timeend'=>date('Y-m-d h:i:s', $timeend), 'night'=>$night]);
    }
?>      