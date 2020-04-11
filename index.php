<?php
    require_once 'db.php';
    require_once 'decode.php';
    Db::taoTruyCap();

    // $khuVuc = decode_table('./json/khuVuc.json');
    // foreach($khuVuc as $elem)
    //     Db::khuVuc(...$elem);

    // $loaiPhong = decode_loaiPhong_table('./json/loaiPhong.json');
    // foreach($loaiPhong as $elem)
    //     Db::loaiPhong(...$elem);

    $phong = decode_table('./json/phong.json');
    foreach($phong as $elem)
        Db::khuVuc(...$elem);
?>
