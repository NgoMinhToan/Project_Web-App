<?php
    require_once 'simple_html_dom.php';
    require_once 'getImage.php';
    chdir('../');
    // Crawl Item
    $item_index = [];
    $title = '';
    $view = '';
    $date = '';
    $recode_item = [];
    // Crawl Content
    $id = 1;
    $content_index = 1;
    // $item_index = [];
    $src = '';
    $content = '';
    $tag = '';
    $recode_content = [];
    // Crawl
    $num = 1;
    $link_item = [];
    $html = file_get_html('https://mytour.vn/location?page=1');
    foreach($html->find('.blog-item') as $elem){
        $item_index[] = $num++;
        $link_item[] = $elem->find('a', 0)->href;
    }
    $sites = array_map(fn($site)=> file_get_html('https://mytour.vn'.$site)->find('.col-md-9', 0), $link_item);
    $i = 0;
    foreach($sites as $site){
        $title = trim($site->find('.title-lg', 0)->plaintext);
        $content_index = 1;
        foreach($site->find('p, h4, p > img') as $elem){
            $src = '';
            $content = '';
            $tag = '';
            $newHtml = str_get_html($elem);
            if($newHtml->find('p') && $newHtml->find('p', 0)->plaintext != ''){
                if($newHtml->find('span.date'))
                    $date = $newHtml->find('span.date', 0)->plaintext;
                if($newHtml->find('span.data-view'))
                    $view = $newHtml->find('span.data-view', 0)->plaintext;
                else{
                    $content = trim($newHtml->find('p', 0)->plaintext);
                    $tag = 'p';
                }
            }
            if($newHtml->find('h4')){
                $content = trim($newHtml->find('h4', 0)->plaintext);
                $tag = 'h4';
            }
            if($newHtml->find('p > img')){
                // getImage($newHtml->find('p > img', 0)->src, "/image/item$item_index[$i]", 'pic'.($content_index+1).'.png');
                $src = '/image/item'.$item_index[$i].'/pic'.($content_index+1).'.png';
                $tag = 'img';
            }
            if($src != '' || $content != '')
                $recode_content[] = [$id++, $content_index++, $item_index[$i], $src, $content, $tag];
        }
        $recode_item[] = [$item_index[$i], $title, $view, $date];
        $i++;
    }
    // print_r($recode_item);
    // print_r($recode_content);
    if(!is_dir('./json') || !file_exists('./json'))
        mkdir('json');
    
    chdir('./json');

    $fp = fopen('items.json', 'w');
    fwrite($fp, json_encode($recode_item));
    fclose($fp);

    $fp = fopen('contents.json', 'w');
    fwrite($fp, json_encode($recode_content));
    fclose($fp);

    chdir('../');
?>