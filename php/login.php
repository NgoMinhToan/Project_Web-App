<?php

    require_once 'db.php';
    $action = '';
    if(isset($_REQUEST['action']))
        $action = $_REQUEST['action'];
    
    if($action == 'onLogin'){
        $email = $_POST['email'];
        $pwd = $_POST['pwd'];
        echo json_encode(Db::tonTai_ND($email, $pwd));
    }

    if($action == 'onSignUp'){
        $email = $_REQUEST['email'];
        $pwd = $_REQUEST['pwd'];
        $result = Db::tonTai_ND_DK($email);
        if($result['success'])
            echo json_encode(Db::dangKy(NULL, NULL, $pwd, $email, NULL, 0, NULL,NULL));
        else
            echo json_encode($result);
    }

    if(isset($_REQUEST['btn_submit_login'])){
        $email = $_POST['email'];
        $pwd = $_POST['pwd'];
        if(isset($_COOKIE['maTruyCap'])){
            $maTruyCap = $_COOKIE['maTruyCap'];
            Db::capNhat_IP($maTruyCap);
        }
        else{
            $maTruyCap = Db::taoTruyCap()['maTruyCap'];
        }
        setcookie('maTruyCap', $maTruyCap, time() + (86400 * 30), "/"); // 86400 = 1 day
        Db::dangNhap($email, $pwd, Db::getTruyCap($maTruyCap));
    }
    ?>