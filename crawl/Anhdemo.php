<?php
    include 'simple_html_dom.php';
    $html = file_get_html('../html/12_1_a.html');
    // echo $html;
    $anhReview = $html->find('div.thumb-wrapper > img');
    foreach($anhReview as $e)
        echo str_replace("480x360", "1000x600", $e);
?>