<?php
    require_once 'simple_html_dom.php';
    require_once 'getImage.php';
    chdir('../');
    $html = file_get_html('https://mytour.vn/');
    // Crawl Khu Vực
    
    $link_khuvuc = [];
    $ma_khuvuc = [];
    $ten_khuvuc = [];
    foreach($html->find('a.events-tracking') as $elem){
        if(count($link_khuvuc)<=12){
            $link_khuvuc[] = $elem->href;
            $ma_khuvuc[] = 'KHUVUC'.$elem->find('h3', 0)->plaintext;
        }
        else
            break;
    }
    print_r($link_khuvuc);
    print_r($ma_khuvuc);
    // Crawl Khách sạn
    // Crawl Phòng
    // Crawl Loại Phòng

    
    // if(!is_dir('./json') || !file_exists('./json'))
    //     mkdir('json');
    
    // chdir('./json');

    // $fp = fopen('items.json', 'w');
    // fwrite($fp, json_encode($recode_item));
    // fclose($fp);

    // $fp = fopen('contents.json', 'w');
    // fwrite($fp, json_encode($recode_content));
    // fclose($fp);

    // chdir('../');
?>