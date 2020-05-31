<?php
    session_start();
    require_once 'db.php';
    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];
    
    if($action == 'onLogin'){
        $email = $_POST['email'];
        $pwd = $_POST['pwd'];
        echo json_encode(Db::tonTai_ND($email, $pwd));
    }

    // Log Out
    if($action == 'LogOut'){
        if($_SESSION['maTruyCap']){
            echo json_encode(Db::dangXuat($_SESSION['maTruyCap']));
            unset($_SESSION['maTruyCap']);
        }
    }

    if($action == 'danhGia'){
        echo json_encode(Db::danhGiaWebSite($_POST['doHaiLong'], $_POST['gopY'], $_POST['cauHoi'], $_POST['email_sdt_lienhe']));
    }

    if($action=='search_info'){
        $_SESSION['timestart'] = $_POST['timestart'];
        $_SESSION['timeend'] = $_POST['timeend'];
        $_SESSION['numPhong'] = $_POST['numPhong'];
        $_SESSION['numNguoi'] = $_POST['numNguoi'];
    }

    if($action == 'getResult'){
        $type = $_REQUEST['type'];
        if($type == 'index'){
            echo json_encode(['success'=>true, 'type'=>$type, 'maKhuVuc'=>$_POST['maKhuVuc']]);
        }
        else if($type == 'search'){
            echo json_encode(['success'=>true, 'type'=>$type, 'keyword'=>$_POST['keyword'], 'timestart'=>$_SESSION['timestart']??'', 'timeend'=>$_SESSION['timeend']??'', 'numPhong'=>$_SESSION['numPhong']??1, 'numNguoi'=>$_SESSION['numNguoi']??2]);
        }
        else{
            echo json_encode(['success'=>false]);
        }
    }
?>