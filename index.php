<?php
    require_once 'db.php';
    require_once 'decode.php';
    $truyCap = Db::taoTruyCap();

    // Db::resetID();
    // Db::dangKy('ngo minh toan', 'mtoan', 'mtoan', 'mtoan@@gmail', 1234567899, 0, 'sddscdcsdc','thcmd');
    // print_r(Db::dangKy('ngo toan', 'mtoan4', 'mtoan4', 'mtoan@@gm332ail', 12345699, 0, 'sdd3233scdcsdc','t33hcmd'));
    $result = Db::dangNhap('mtoan4', 'mtoan4', $truyCap);
    // print_r($result);
    // print_r(Db::khachDatPhong($truyCap['maTruyCap'], 'MAPHONG6_1_2_32', '2020-5-1', '2020-6-1', '1600000', 'thanh toan online', 'ngo minh toan', 'mtoan', 0346144237, 'tphcm'));
    print_r(Db::ndDatPhong($result['maSo_ND'], 'MAPHONG6_1_2_32', '2020-5-1', '2020-6-1', '1600000', 'thanh toan online'));

?>
