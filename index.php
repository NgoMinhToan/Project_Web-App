<?php
    require_once 'db.php';
    require_once 'decode.php';
    $truyCap = Db::taoTruyCap();

    // Db::resetID();
    // Db::dangKy('ngo minh toan', 'mtoan', 'mtoan', 'mtoan@@gmail', 1234567899, 0, 'sddscdcsdc','thcmd');
    // Db::dangKy('ngo toan', 'mtoan23', 'mtoan23', 'mtoan@@gm332ail', 12345699, 0, 'sdd3233scdcsdc','t33hcmd');
    print_r(Db::dangNhap('mtoan23', 'mtoan23', $truyCap));

?>
