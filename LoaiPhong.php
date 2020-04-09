<?php
//  {
    //     loaiphong: {
    //         ten:
    //         srcHinh:
    //         dientich:
    //         loaigiuong:
    //         dambao:
    //     }
    //     toiDaSoNguoi: 
    //     tuyChon: {
    //         baoGomBuaSang: 1
    //         khongHuyHoan: 1
    //     }
    //     gia1Dem: {
    //         datSomGiaTot: %
    //         giaCu:
    //         giaMoi:
    //     }
    //     soLuong: {
    //         soPhong:
    //         giuongPhu: 0
    //     }
    // }
    class LoaiPhong{
        static $index = 1;
        function __construct($moTa, $dienTich, $controng){
            $this->maLoaiPhong = 'LOAIPHONG'.LoaiPhong::$index++;
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