<?php
    require_once 'db.php';
    require_once 'items.php';
    require_once 'contents.php';
    // đưa từ file json sang đối tượng Item_Object
    function decode_item_from_json($path){
        if(!file_exists($path))
            return [];
        $textFile = json_decode(file_get_contents($path));
        $rs = [];
        foreach($textFile as $elem){
            $date = str_replace('/', '-', $elem[3]);
            $rs[] = new Item($elem[0], $elem[1], $elem[2], date('Y-m-d', strtotime($date)));
        }
        return $rs;
    }
    // đưa từ file json sang đối tượng Content_Object
    function decode_content_from_json($path){
        if(!file_exists($path))
            return [];
        $textFile = json_decode(file_get_contents($path));
        $rs = [];
        foreach($textFile as $elem){
            $rs[] = new Content($elem[0], $elem[1], $elem[2], $elem[3], $elem[4], $elem[5]);
        }
        return $rs;
    }

?>