<?php
    require_once 'db.php';
    require_once 'decode.php';
    Db::taoTruyCap();

    Db::resetID();

    // $khuVuc = decode_table('./json/khuVuc.json');
    // foreach($khuVuc as $elem)
    //     Db::khuVuc(...$elem);

    // $loaiPhong = decode_loaiPhong_table('./json/loaiPhong.json');
    // foreach($loaiPhong as $elem)
    //     Db::loaiPhong(...$elem);

    // $khachSan = decode_khachSan_table('./json/khachSan.json');
    // foreach($khachSan as $elem)
    //     Db::khachSan(...$elem);

    // $phong = decode_table('./json/phong.json');
    // foreach($phong as $elem)
    //     Db::phong(...$elem);
?>
