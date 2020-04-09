<?php

class Phong{
    static $index = 1;
    function __contruct($maLoaiPhong, $maKhachSan){
        $this->maPhong = 'MAPHONG'.Phong::$index;
        $this->maLoaiPhong = $maLoaiPhong;
        $this->maKhachSan = $maKhachSan;
    }
}
?>