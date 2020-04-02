<?php
    require_once 'db.php';
    require_once 'items.php';
    require_once 'contents.php';
    function decode_item_from_json($path){
        $textFile = json_decode(file_get_contents($path));
        $rs = [];
        foreach($textFile as $elem){
            $date = str_replace('/', '-', $elem[3]);
            $rs[] = new Item($elem[0], $elem[1], $elem[2], date('Y-m-d', strtotime($date)));
        }
        return $rs;
    }
    function decode_content_from_json($path){
        $textFile = json_decode(file_get_contents($path));
        $rs = [];
        foreach($textFile as $elem){
            $rs[] = new Content($elem[0], $elem[1], $elem[2], $elem[3], $elem[4], $elem[5]);
        }
        return $rs;
    }
    $items = decode_item_from_json('.\items.json');
    $contents = decode_content_from_json('.\contents.json');

    foreach($items as $elem)
        print_r($elem);
    
    foreach($contents as $elem)
        Db::add_content($elem);
        
?>