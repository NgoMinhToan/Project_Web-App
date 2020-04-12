<?php
    // insert sql xong chạy cái này để đẩy lên rồi get dữ liệu về từ database
    require_once 'db.php';
    require_once 'decode.php';
    // // lấy ra Object
    // $items = decode_item_from_json('.\json\items.json');
    // $contents = decode_content_from_json('.\json\contents.json');

    // //rồi đẩy lên db
    // foreach($items as $elem)
    //     Db::add_item($elem);
    
    // foreach($contents as $elem)
    //     Db::add_content($elem);
    
    // // get dữ liệu từ db rồi in ra content của 1 item : item_index = 1
    // echo '<h3>Item 1</h3><hr><div>';
    // foreach(Db::get_content_from_item(1) as $content){
    //     echo 'id: '.$content->id.'<br>';
    //     echo 'content_index: '.$content->content_index.'<br>';
    //     echo 'item_index: '.$content->item_index.'<br>';
    //     echo 'src: '.$content->src.'<br>';
    //     echo 'content: '.$content->content.'<br>';
    //     echo 'tag: '.$content->tag.'<br><hr>';
    // }
    // echo '<div>'





    
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