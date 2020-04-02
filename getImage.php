<?php
    function getImage($url, $dir, $fname){
        $main_dir = getcwd();
        $dirs = explode('/', $dir);
        foreach ($dirs as $d) {
            if(!is_dir(getcwd().'/'.$d) || !file_exists(getcwd().'/'.$d))
                mkdir($d);
            chdir(getcwd().'/'.$d);
        }
        file_put_contents($fname, file_get_contents($url));
        chdir($main_dir);
    }
    // getImage('https://staticproxy.mytourcdn.com/480x360,q90/resources/pictures/locations/srm1585032323.jpg', 'image/pic','idc.png');
?>