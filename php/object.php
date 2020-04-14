<?php
    class LoaiPhong{
        function __construct($maLoaiPhong, $moTa, $dienTich, $controng){
            $this->maLoaiPhong = $maLoaiPhong;
            $this->moTa = $moTa;
            $this->dienTich = $dienTich;
            $this->controng = $controng;
            
        }
    }
    class MoTa{
        function __construct($ten, $scrHinh, $productContent, $toiDaSoNguoi, $tuyChon, $uuDai, $giaGoc, $soPhong){
            $this->ten = $ten;
            $this->srcHinh = $scrHinh;
            $this->productContent = $productContent;
            $this->toiDaSoNguoi = $toiDaSoNguoi;
            $this->tuyChon = $tuyChon;
            $this->uuDai = $uuDai;
            $this->giaGoc = $giaGoc;
            $this->giaGiam = floor($giaGoc*(100-$uuDai)/1000)*10;
            $this->soPhong = $soPhong;
            $this->choPhep = $soPhong>0?true:false;
        }
    }
?>