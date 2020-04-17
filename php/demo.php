<?php
    require_once 'db.php';
    require_once 'decode.php';
    $truyCap = Db::taoTruyCap();

    // Db::resetID();
    // Db::dangKy('ngo minh toan', 'minhtoan', 'toan2610', 'mtoan12610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo minh toan', 'minhtoan1', 'toan2610', 'mtoan22610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo minh toan', 'minhtoan2', 'toan2610', 'mtoan32610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo minh toan', 'minhtoan3', 'toan2610', 'mtoan42610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo minh toan', 'minhtoan4', 'toan2610', 'mtoan52610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo minh toan', 'minhtoan5', 'toan2610', 'mtoan62610@gmail.com', '0346144237', 0, 'sddscdcsdc','thcmd');
    // print_r(Db::dangKy('ngo toan', 'mtoan4', 'mtoan4', 'mtoan@gm332ail', 12345699, 0, 'sdd3233scdcsdc','t33hcmd'));
    print_r($result = Db::dangNhap('mtoan12610@gmail.com', 'toan2610', $truyCap));
    echo '<br>';
    // print_r($result);
    // print_r($result);
    // print_r(Db::khachDatPhong($truyCap['maTruyCap'], 'LOAIPHONG2_1_5', '2020-5-1', '2020-6-1', '1600000', 'thanh toan online', 'ngo minh toan', 'mtoan', 0346144237, 'tphcm'));
    // print_r(Db::khachDatPhong($truyCap['maTruyCap'], 'LOAIPHONG5_1_5', 6, '2020-5-1', '2020-6-1', '1600000', 'thanh toan online', 'ngo minh toan', 'mtoan', 0346144237, 'tphcm'));
    print_r(Db::ndDatPhong($result['maSo_ND'], 'LOAIPHONG1_1_2', 10, '2020-5-1', '2020-6-1', '1600000', 'thanh toan online'));
    // print_r(Db::ND_huyPhong($result['maSo_ND'], 'MAPHONG10_1_2_2'));
    // echo json_encode(Db::dangXuat('ND0001'));
?>
