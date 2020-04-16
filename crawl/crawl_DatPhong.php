<?php
    require_once 'simple_html_dom.php';
    require_once 'getImage.php';
    chdir('../');
    // include 'object.php';
    $page = './crawl/html/0.html';
    $html = file_get_html($page);

    function vn_str_filter ($str){
        $unicode = array(
            'a'=>'á|à|ả|ã|ạ|ă|ắ|ặ|ằ|ẳ|ẵ|â|ấ|ầ|ẩ|ẫ|ậ',
            'd'=>'đ',
            'e'=>'é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ',
            'i'=>'í|ì|ỉ|ĩ|ị',
            'o'=>'ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ',
            'u'=>'ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự',
            'y'=>'ý|ỳ|ỷ|ỹ|ỵ',
			'A'=>'Á|À|Ả|Ã|Ạ|Ă|Ắ|Ặ|Ằ|Ẳ|Ẵ|Â|Ấ|Ầ|Ẩ|Ẫ|Ậ',
            'D'=>'Đ',
            'E'=>'É|È|Ẻ|Ẽ|Ẹ|Ê|Ế|Ề|Ể|Ễ|Ệ',
            'I'=>'Í|Ì|Ỉ|Ĩ|Ị',
            'O'=>'Ó|Ò|Ỏ|Õ|Ọ|Ô|Ố|Ồ|Ổ|Ỗ|Ộ|Ơ|Ớ|Ờ|Ở|Ỡ|Ợ',
            'U'=>'Ú|Ù|Ủ|Ũ|Ụ|Ư|Ứ|Ừ|Ử|Ữ|Ự',
            'Y'=>'Ý|Ỳ|Ỷ|Ỹ|Ỵ',
        );
        
       foreach($unicode as $nonUnicode=>$uni){
            $str = preg_replace("/($uni)/i", $nonUnicode, $str);
       }
		return seo_friendly_url($str);
    }
    function seo_friendly_url($string){
        $string = str_replace(array('[\', \']'), '', $string);
        $string = preg_replace('/\[.*\]/U', '', $string);
        $string = preg_replace('/&(amp;)?#?[a-z0-9]+;/i', '-', $string);
        $string = htmlentities($string, ENT_COMPAT, 'utf-8');
        $string = preg_replace('/&([a-z])(acute|uml|circ|grave|ring|cedil|slash|tilde|caron|lig|quot|rsquo);/i', '\\1', $string );
        $string = preg_replace(array('/[^a-z0-9]/i', '/[-]+/') , '-', $string);
        return strtolower(trim($string, '-'));
    }

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
        if(!file_exists('./crawl/html/'.$kv.'.html'))
            break; 
        
        $html = file_get_html('./crawl/html/'.$kv.'.html');
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
            if(!file_exists('./crawl/html/'.$kv.'_'.$ks.'.html'))
                break;
            $html = file_get_html('./crawl/html/'.$kv.'_'.$ks.'.html');
            // -------------------------------------------------------------- KHACH SAN
            // ĐIỂM GẦN ĐÓ
            $diemDen = $html->find('h4.ins-title ~ ul>li');
            $diemDen = array_map(fn($a)=>[$a->find('span.location',0)->plaintext, $a->find('span.distance',0)->plaintext], $diemDen);
            $khachSan[$kv-1][] = $diemDen;

            // TIỆN ÍCH CỦA KS
            $tienNghi = $html->find('div.attribute-hotel .attribute-value');
            $tienNghi = array_map(fn($a)=>trim($a->plaintext), $tienNghi);
            $khachSan[$kv-1][] = $tienNghi;

            // LẤY ẢNH REVIEW TỪ CÁC FILE ( .a )
            $getImg = file_get_html('./crawl/html/'.$kv.'_'.$ks.'_a.html');
            $anhReview = $getImg->find('div.thumb-wrapper > img');
            for($e=0;$e<count($anhReview);$e++){
                getImage(str_replace("480x360", "1000x600", $anhReview[$e]->src), './images/Hotel/'.vn_str_filter($khachSan[$kv-1][2]), ($e+1).'.png');
                $anhReview[$e] = './images/Hotel/'.vn_str_filter($khachSan[$kv-1][2]).'/'.($e+1).'.png';

                // str_replace(' ', '', vn_str_filter($khachSan[$kv-1][2]))
            }
            $khachSan[$kv-1][] = $anhReview;
            // ------------------------------------------------------------ PHONG - LOAIPHONG
            $html = $html->find('.table-detail.table > tbody', 0);
            $index = 0;
            for($i=0; $i< count($html->find('.book-choose')); $i++){

                // LẤY CÁC THÔNG TIN CỦA CÁC LOẠI PHÒNG
                $title = trim($html->find('.title-room',$i)->plaintext);
                $html_New = $html->find('.book-choose', $i);


            
                $getImg = file_get_html('./crawl/html/'.$kv.'_'.$ks.'_b.html');
                $srcHinh = $getImg->find('.detailslider-thumbnails-list', $i);
                $srcHinh = $srcHinh->find('div.thumb-wrapper > img');
                for($e=0;$e<count($srcHinh);$e++){
                    getImage(str_replace("480x360", "1000x600", $srcHinh[$e]->src), './images/reviewPhong/'.vn_str_filter($khachSan[$kv-1][2]).'/'.vn_str_filter($title), ($e+1).'.png');
                    $srcHinh[$e] = './images/reviewPhong/'.vn_str_filter($khachSan[$kv-1][2]).'/'.vn_str_filter($title).'/'.($e+1).'.png';

                    echo vn_str_filter($khachSan[$kv-1][2]).'/'.vn_str_filter($title).'/'.($e+1).'.png';
                }
                // tai anh ve
                // getImage($html_New->find('.product-image > img', 0)->src, './image/reviewP', $kv.'-'.$ks.'-'.($i+1).'.png');
                // $srcHinh = './images/reviewP/'. $kv.'-'.$ks.'-'.($i+1).'.png';




                $productContent = $html_New->find('.product-content > p');
                array_shift($productContent);
                $dienTich = 0;
                $conTrong = '0';
                if($productContent[0]->title == 'Diện tích phòng')
                    preg_match_all('!\d+!', trim(array_shift($productContent)->plaintext), $matches);
                $dienTich = intval($matches[0][0]);
                if($productContent[count($productContent)-1]->plaintext != '')
                    $conTrong = trim(array_pop($productContent)->plaintext);
                
                $productContent = array_map(fn($a)=>trim($a->plaintext), $productContent);

                foreach($html_New->find('td.room', 0)->find('tr') as $elem){
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
                    
                    $conTrong = $soPhong; // BỎ TRỐNG CÁC PHÒNG
                    $loaiPhong[] = ['LOAIPHONG'.$kv.'_'.$ks.'_'.++$index, [$title, $srcHinh, $productContent, $toiDaSoNguoi, $tuyChon, $uuDai, $giaGoc, $soPhong], $dienTich, $conTrong];

                    for($p=1;$p<=$soPhong;$p++)
                        $phong[] = ['MAPHONG'.$kv.'_'.$ks.'_'.$index.'_'.$p, 'LOAIPHONG'.$kv.'_'.$ks.'_'.$index, 'MAKHACHSAN'.$kv.'_'.$ks];
                }
                echo 'done i = '.$i.'<br>';
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