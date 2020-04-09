<?php
    require_once 'simple_html_dom.php';
    require_once 'getImage.php';
    chdir('../');
    include 'LoaiPhong.php';
    $page = 'https://mytour.vn/';
    $html = file_get_html($page);

    
    if(!is_dir('./json') || !file_exists('./json'))
        mkdir('json');
    chdir('./json');

    // ===============================================
    // Crawl Khu Vực
    $khuvuc = [];
    $link =[];
    $array = $html->find('a.events-tracking');
    for($i=1;$i<=12;$i++){
        $link[] = $array[$i]->href;
        $khuvuc[] = ['KHUVUC'.$i, $array[$i]->find('h3', 0)->plaintext];
    }
    // print_r($khuvuc);
    $fp = fopen('khuVuc.json', 'w');
    fwrite($fp, json_encode($khuvuc));
    fclose($fp);

    // ===============================================
    // Crawl Khách sạn
    $khachSan = [];
    for($kv = 1; $kv <= count($khuvuc); $kv++)
        for($i = 1; $i < 100; $i++){
            if(!file_exists('./html/'.$kv.'_'.$i.'.html'))
                break; 
            
            $html = file_get_html('./html/'.$kv.'_'.$i.'.html');
            foreach($html->find('div.product-item.row') as $elem){
                $tenKhachSan = trim($elem->find('div > h2.title-sm', 0)->plaintext);
                $diaChi_KS = trim($elem->find('div > p.text-df span.gray', 0)->plaintext);
                $Review = trim($elem->find('div.multiLineEllipsis-3', 0)->plaintext);
                $khachSan[] = ['MAKHACHSAN'.$kv.'_'.$i, 'KHUVUC'.$kv, $tenKhachSan, $diaChi_KS, $Review];
            }
        }
    print_r($khachSan);
    $fp = fopen('khachSan.json', 'w');
    fwrite($fp, json_encode($khachSan));
    fclose($fp);
    
    // ===============================================
    // Crawl LoaiPhong
    $loaiPhong = [];
    $phong = [];
    for($kv = 1; $kv <= count($khuvuc); $kv++)
        for($ks = 1; $ks <= count($khachSan); $ks++)
            for($i = 1; $i < 100; $i++){
                if(!file_exists('./html/'.$kv.'_'.$ks.'_'.$i.'.html'))
                    break;
                $html = file_get_html('./html/'.$kv.'_'.$ks.'_'.$i.'.html')->find('.table-detail.table > tbody', 0);
                for($i=0; $i< count($html->find('.book-choose')); $i++){
                    $title = $html->find('.title-room',$i)->plaintext;
                    $srcHinh = str_replace('480x360', '1000x600', $html->find('.product-image > img', $i)->src);
                    $dienTich = trim($html->find('.product-content > p', 1 + $i*5)->plaintext);
                    $loaiGiuong = trim($html->find('.product-content > p', 3 + $i*5)->plaintext);
                    $conTrong = trim($html->find('.product-content > p', 4 + $i*5)->plaintext);
                    foreach($html->find('td.room', $i)->find('tr') as $elem){
                        $toiDaSoNguoi = $elem->find('.user-group', 0)->plaintext;
                        $buaSang = $elem->find('.room-condition > p', 0)->plaintext;
                        $hoanHuy = $elem->find('.room-condition > p', 1)->plaintext;
                        preg_match_all('!\d+!', $elem->find('.item-price > p', 0)->plaintext, $matches);
                        $uuDai =$matches[0][0];
                        preg_match_all('!\d+!', str_replace(',', '', $elem->find('.item-price > p', 1)->plaintext), $matches);
                        $giaGoc = $matches[0][0];
                        $soPhong = count($elem->find('td.select-df  option')) -1;
            
                        $loaiPhong[] = ['LOAIPHONG'.$kv.'_'.$ks.'_'.$i, [$title, $srcHinh, $loaiGiuong, $toiDaSoNguoi, $buaSang, $hoanHuy, $uuDai, $giaGoc, $soPhong], $dienTich, $conTrong];

                        for($p=1;$p<=$soPhong;$p++)
                            $phong[] = ['MAPHONG'.$kv.'_'.$ks.'_'.$i.'_'.$p, 'LOAIPHONG'.$kv.'_'.$ks.'_'.$i, 'MAKHACHSAN'.$kv.'_'.$ks];
                    }
                }
            }
    
    $fp = fopen('loaiPhong.json', 'w');
    fwrite($fp, json_encode($loaiPhong));
    fclose($fp);
    $fp = fopen('phong.json', 'w');
    fwrite($fp, json_encode($phong));
    fclose($fp);

    chdir('../');
?>