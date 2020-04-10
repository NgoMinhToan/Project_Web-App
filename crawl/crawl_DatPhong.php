<?php
    require_once 'simple_html_dom.php';
    require_once 'getImage.php';
    chdir('../');
    include 'LoaiPhong.php';
    $page = './html/0.html';
    $html = file_get_html($page);


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
    if(!is_dir('./json') || !file_exists('./json'))
        mkdir('json');
    chdir('./json');

    $fp = fopen('khuVuc.json', 'w');
    fwrite($fp, json_encode($khuvuc));
    fclose($fp);
    chdir('../');
    // ===============================================
    // Crawl Khách sạn
    $khachSan = [];
    for($kv = 1; $kv <= count($khuvuc); $kv++){
        if(!file_exists('./html/'.$kv.'.html'))
            break; 
        
        $html = file_get_html('./html/'.$kv.'.html');
        $index = 0;
        foreach($html->find('div.product-item.row') as $elem){
            $tenKhachSan = trim($elem->find('div > h2.title-sm', 0)->plaintext);
            $diaChi_KS = trim($elem->find('div > p.text-df span.gray', 0)->plaintext);
            $Review = trim($elem->find('div.multiLineEllipsis-3', 0)->plaintext);
            $khachSan[] = ['MAKHACHSAN'.$kv.'_'.++$index, 'KHUVUC'.$kv, $tenKhachSan, $diaChi_KS, $Review];

        break;
        }
    }
    // print_r($khachSan);

    
    
    // ===============================================
    // Crawl LoaiPhong
    $loaiPhong = [];
    $phong = [];
    for($kv = 1; $kv <= count($khuvuc); $kv++)
        for($ks = 1; $ks <= count($khachSan); $ks++){
            if(!file_exists('./html/'.$kv.'_'.$ks.'.html'))
                break;
            $html = file_get_html('./html/'.$kv.'_'.$ks.'.html');
            $diemDen = $html->find('h4.ins-title ~ ul>li');
            $diemDen = array_map(fn($a)=>[$a->find('span.location',0)->plaintext, $a->find('span.distance',0)->plaintext], $diemDen);
            
            $khachSan[$kv-1][] = $diemDen;
            $tienNghi = $html->find('div.attribute-hotel .attribute-value');
            echo (count($html->find('div.attribute-hotel')).'<br>');
            $tienNghi = array_map(fn($a)=>trim($a->plaintext), $tienNghi);

            $html = $html->find('.table-detail.table > tbody', 0);
            $index = 0;
            for($i=0; $i< count($html->find('.book-choose')); $i++){
                $title = trim($html->find('.title-room',$i)->plaintext);
                $srcHinh = str_replace('480x360', '1000x600', $html->find('.product-image > img', $i)->src);
                // tai anh ve
                $productContent = $html->find('.product-content > p');
                array_shift($productContent);
                $dienTich = '0 m';
                $conTrong = '0';
                if($productContent[0]->title == 'Diện tích phòng')
                    $dienTich = trim(array_shift($productContent)->plaintext);
                if($productContent[count($productContent)-1]->plaintext != '')
                    $conTrong = trim(array_pop($productContent)->plaintext);
                
                $productContent = array_map(fn($a)=>trim($a->plaintext), $productContent);
                foreach($html->find('td.room', $i)->find('tr') as $elem){
                    $toiDaSoNguoi = trim($elem->find('.user-group', 0)->plaintext);
                    $tuyChon = $elem->find('.room-condition > p');
                    $tuyChon = array_map(fn($a)=>trim($a->plaintext), $tuyChon);
                    array_pop($tuyChon);
                    $matches = [[0]];
                    if(isset($elem->find('.item-price > p > strong.label.bg-red', 0)->plaintext))
                        preg_match_all('!\d+!', $elem->find('.item-price > p > strong.label.bg-red', 0)->plaintext, $matches);
                    $uuDai =$matches[0][0];
                    preg_match_all('!\d+!', str_replace(',', '', $elem->find('.item-price > p.price-old', 0)->plaintext), $matches);
                    $giaGoc = $matches[0][0];
                    $soPhong = count($elem->find('td.select-df  option')) -1;
                    
                    $conTrong = $soPhong; // cho trong het
                    $loaiPhong[] = ['LOAIPHONG'.$kv.'_'.$ks.'_'.++$index, [$title, $srcHinh, $productContent, $toiDaSoNguoi, $tuyChon, $uuDai, $giaGoc, $soPhong], $dienTich, $conTrong];

                    for($p=1;$p<=$soPhong;$p++)
                        $phong[] = ['MAPHONG'.$kv.'_'.$ks.'_'.$index.'_'.$p, 'LOAIPHONG'.$kv.'_'.$ks.'_'.$index, 'MAKHACHSAN'.$kv.'_'.$ks];
                }
            }
        }
    if(!is_dir('./json') || !file_exists('./json'))
    mkdir('json');
    chdir('./json');

    $fp = fopen('khachSan.json', 'w');
    fwrite($fp, json_encode($khachSan));
    fclose($fp);
    chdir('../');

    if(!is_dir('./json') || !file_exists('./json'))
        mkdir('json');
    chdir('./json');

    $fp = fopen('loaiPhong.json', 'w');
    fwrite($fp, json_encode($loaiPhong));
    fclose($fp);
    $fp = fopen('phong.json', 'w');
    fwrite($fp, json_encode($phong));
    fclose($fp);

    chdir('../');
?>