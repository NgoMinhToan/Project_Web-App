<?php
    require_once 'service.php';
    date_default_timezone_set("Asia/Ho_Chi_Minh");
    Db::$mysql = new mysqli('localhost', 'root', '', 'khachsan');
    if(mysqli_connect_errno()){
        die('Lỗi Kết Nối CSDL: '.mysqli_connect_error());
    }
    Db::$mysql -> set_charset("utf8");

    class Db{
        static $mysql;
        static function taoTruyCap(){
            $ID = 1;
            $lastID = self::$mysql->query("SELECT count(STT) as 'num' from khachTruyCap");
            if ($lastID->fetch_assoc()['num'] != 0){
                $lastID = self::$mysql->query("SELECT max(STT) as lastID from khachTruyCap");
                preg_match_all('!\d+!', $lastID->fetch_assoc()['lastID'], $lastID);
                $ID = $lastID[0][0]+1;
                // echo $ID;
            }
            $maTruyCap = 'MTC';
            for($i=0;$i<4-strlen($ID);$i++)
                $maTruyCap .= '0';
            $maTruyCap.=$ID;
            // echo $maTruyCap;

            $diaChi_IP = get_user_ip();
            // echo $diaChi_IP;
            self::$mysql->query("INSERT INTO khachTruyCap (diaChi_IP, maTruyCap, STT) VALUES('$diaChi_IP', '$maTruyCap', $ID)");
            if (self::$mysql->affected_rows==1)
                return ['success'=>true, 'msg'=>'Đã tạo mã truy cập', 'maTruyCap'=>$maTruyCap, 'diaChi_IP'=>$diaChi_IP];
        }





        static function getTruyCap($maTruyCap){
            $result = self::$mysql->query("SELECT * FROM khachTruyCap WHERE maTruyCap='$maTruyCap'");
            return $result->fetch_assoc();
        }





        static function capNhat_IP($maTruyCap){
            $diaChi_IP = get_user_ip();
            self::$mysql->query("UPDATE khachTruyCap SET diaChi_IP='$diaChi_IP' WHERE maTruyCap='$maTruyCap'");
            if(self::$mysql->affected_rows==1)
                return ['success'=>true, 'msg'=>'Đã cập nhật IP!'];
            return ['success'=>false, 'msg'=>'Không có IP!'];
        }





        static function resetID(){
            self::$mysql->query("DELETE FROM khachtruycap");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Đã reset lại số truy cập'];
        }





        static function khuVuc($maKhuVuc, $tenKhuVuc){
            $stmt = self::$mysql->prepare("INSERT INTO khuVuc (maKhuVuc, tenKhuVuc) VALUES(?, ?)");
            $stmt->bind_param('ss', $maKhuVuc, $tenKhuVuc);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }





        static function ksInKv($maKhuVuc){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT tenKhuVuc, maKhachSan from khuVuc JOIN khachSan ON khuVuc.maKhuVuc=khachSan.maKhuVuc WHERE khuVuc.maKhuVuc=?")){
                $stmt->bind_param('s', $maKhuVuc);
                $stmt->execute();
                $stmt->bind_result($tenKhuVuc, $maKhachSan);
                while ($stmt->fetch()){
                    $rs[] = ['tenKhuVuc'=>$tenKhuVuc, 'maKhachSan'=>$maKhachSan];
                }
                $stmt->close();
            }
            return $rs;
        }





        static function resetKhuVuc(){
            self::$mysql->query("DELETE FROM khuVuc");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Đã reset lại các khu vựa'];
        }





        static function loaiPhong($maLoaiPhong, $moTa, $dienTich, $phongConLai){
            $stmt = self::$mysql->prepare("INSERT INTO loaiPhong (maLoaiPhong, moTa, dienTich, phongConLai) VALUES(?, ?, ?, ?)");
            $stmt->bind_param('sssi', $maLoaiPhong, $moTa, $dienTich, $phongConLai);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }




        
        static function khachSan(...$elem){
            $stmt = self::$mysql->prepare("INSERT INTO khachSan (maKhachSan, maKhuVuc, tenKhachSan, diaChi_KS, Review, diemDen, tienNghi, anhReview) VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param('ssssssss', ...$elem);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }





        static function phong($maPhong, $maLoaiPhong, $maKhachSan){
            $stmt = self::$mysql->prepare("INSERT INTO phong (maPhong, maLoaiPhong, maKhachSan) VALUES(?, ?, ?)");
            $stmt->bind_param('sss', $maPhong, $maLoaiPhong, $maKhachSan);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }





        static function dangKy($hoTen_ND, $tenDangNhap, $matKhau_ND, $email_ND, $SDT_ND, $quyenQuanTri, $diaChi_ND, $tinhThanhPho_ND){
            // nếu tồn tại trong người dùng
            if($tenDangNhap!=NULL){
                $result = self::$mysql->query("SELECT maSo_ND FROM nguoiDung WHERE tenDangNhap='$tenDangNhap'");
                if ($result->num_rows==1){
                    return ['success'=>false, 'msg'=>'Tên người dùng đã tồn tại!'];
                }
            }
            // lấy ID cuối cùng ra
            $lastID = self::$mysql->query("SELECT maSo_ND from nguoiDung");
            $rs = [1];
            while ($result = $lastID->fetch_assoc()){
                preg_match_all('!\d+!', $result['maSo_ND'], $match);
                $rs[] = $match[0][0]+1;
            }
            $maSo_ND = 'ND';
            for($i=0;$i<4-strlen(max($rs));$i++)
                $maSo_ND .= '0';
            $maSo_ND.=max($rs);
            $stmt = self::$mysql->prepare("INSERT INTO nguoiDung (maSo_ND, hoTen_ND, tenDangNhap, matKhau_ND, email_ND, SDT_ND, quyenQuanTri, diaChi_ND, tinhThanhPho_ND) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param('ssssssiss', $maSo_ND, $hoTen_ND, $tenDangNhap, $matKhau_ND, $email_ND, $SDT_ND, $quyenQuanTri, $diaChi_ND, $tinhThanhPho_ND);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            if($log==1)
                return ['success'=>true, 'msg'=>'Đăng ký thành công!'];
            return ['success'=>false, 'msg'=>'Tên người dùng không hợp lệ hoặc đã tồn tại!'];
        }




        static function dangNhap($tenDangNhap_email_ND, $matKhau_SDT_ND, $truyCap){
            // nếu tồn tại trong đăng nhâp
            $result = self::$mysql->query("SELECT dangNhap.maSo_ND, dangNhap.maTruyCap
                FROM dangNhap JOIN nguoiDung ON dangNhap.maSo_ND=nguoiDung.maSo_ND
                                JOIN khachTruyCap ON dangNhap.maTruyCap = khachTruyCap.maTruyCap
                WHERE (email_ND='$tenDangNhap_email_ND' AND matKhau_ND='$matKhau_SDT_ND' 
                    OR tenDangNhap='$tenDangNhap_email_ND' AND SDT_ND='$matKhau_SDT_ND')");

            if ($result->num_rows==1){
                $result = $result->fetch_assoc();
                $maSo_ND = $result['maSo_ND'];
                $maTruyCap = $result['maTruyCap'];
                self::$mysql->query("DELETE FROM dangNhap WHERE maSo_ND='$maSo_ND' AND maTruyCap='$maTruyCap'");
            }
            $result = self::$mysql->query("SELECT * FROM nguoiDung WHERE email_ND='$tenDangNhap_email_ND' AND matKhau_ND='$matKhau_SDT_ND' OR tenDangNhap='$tenDangNhap_email_ND' AND SDT_ND='$matKhau_SDT_ND'");
            if ($result->num_rows==1){
                $result = $result->fetch_assoc();
                $maTruyCap = $truyCap['maTruyCap'];
                $maSo_ND = $result['maSo_ND'];
 
                self::$mysql->query("INSERT INTO dangNhap (maTruyCap, maSo_ND) VALUES('$maTruyCap', '$maSo_ND')");
                if(self::$mysql->affected_rows==1)
                    return array_merge(['success'=>true, 'msg'=>'Đăng nhập thành công!'], $result);
                return ['success'=>false, 'msg'=>'Đăng nhập thất bại!', self::$mysql->affected_rows];
            }
            return ['success'=>false, 'msg'=>'Sai tên đăng nhập hoặc mật khẩu!', $result];
        }




        static function dangXuat($maTruyCap){
            self::$mysql->query("DELETE FROM dangNhap WHERE maTruyCap = '$maTruyCap'");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Đã đăng xuất thành công!'];
        }





        static function getUser($maTruyCap){
            $result = self::$mysql->query("SELECT * FROM nguoiDung INNER JOIN dangNhap ON nguoiDung.maSo_ND=dangNhap.maSo_ND WHERE maTruyCap='$maTruyCap'");
            if($result->num_rows==1)
                return array_merge(['success'=>true, 'msg'=>'Tìm thấy người dùng!'], $result->fetch_assoc());
            return ['success'=>false, 'msg'=>'Không tìm thấy người dùng!'];
        }





        static function tonTai_ND($tenDangNhap_email_ND, $matKhau_SDT_ND){
            // $diaChi_IP = $truyCap['diaChi_IP'];
            $result = self::$mysql->query("SELECT maSo_ND FROM nguoiDung 
                WHERE email_ND='$tenDangNhap_email_ND' AND matKhau_ND='$matKhau_SDT_ND' 
                    OR tenDangNhap='$tenDangNhap_email_ND' AND SDT_ND='$matKhau_SDT_ND'");
            if($result = $result->fetch_assoc())
                return array_merge(['success'=>true, 'msg'=>'Tồn tại người dùng!'], $result);
            return ['success'=>false, 'msg'=>'Người dùng không tồn tại!'];
        }





        static function tonTai_ND_DK($email_ND){
            // $diaChi_IP = $truyCap['diaChi_IP'];
            $result = self::$mysql->query("SELECT maSo_ND FROM nguoiDung WHERE email_ND='$email_ND'");
            if($result = $result->fetch_assoc())
                return array_merge(['success'=>false, 'msg'=>'Email đã tồn tại!'], $result);
            return ['success'=>true, 'msg'=>'Không trùng lặp!'];
        }




        static function getPhong($maLoaiPhong){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT maPhong, maLoaiPhong, maKhachSan FROM phong WHERE conTrong>0 AND maLoaiPhong=?")){
                $stmt->bind_param('s', $maLoaiPhong);
                $stmt->execute();
                $stmt->bind_result($maPhong, $maLoaiPhong, $maKhachSan);
                while ($stmt->fetch()){
                    $rs[] = ['maPhong'=>$maPhong, 'maLoaiPhong'=>$maLoaiPhong, 'maKhachSan'=>$maKhachSan];
                }
                $stmt->close();
            }
            return $rs;
        }




        static function get_Phong_info_all($maKhachSan){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT loaiPhong.maLoaiPhong, moTa, dienTich, phongConLai FROM loaiPhong INNER JOIN (SELECT DISTINCT maLoaiPhong FROM phong WHERE maKhachSan=?) S1 ON loaiPhong.maLoaiPhong = S1.maLoaiPhong")){
                $stmt->bind_param('s', $maKhachSan);
                $stmt->execute();
                $stmt->bind_result($maLoaiPhong, $moTa, $dienTich, $phongConLai);
                while ($stmt->fetch()){
                    $rs[] = ['maLoaiPhong'=>$maLoaiPhong, 'moTa'=>$moTa, 'dienTich'=>$dienTich, 'phongConLai'=>$phongConLai];
                }
                $stmt->close();
            }
            return $rs;
        }




        static function get_Phong_info($maLoaiPhong){
            $rs = ['success'=>false,'maLoaiPhong'=>$maLoaiPhong, 'moTa'=>[], 'dienTich'=>'', 'phongConLai'=>''];
            if($stmt = self::$mysql->prepare("SELECT loaiPhong.maLoaiPhong, moTa, dienTich, phongConLai FROM loaiPhong WHERE loaiPhong.maLoaiPhong = ?")){
                $stmt->bind_param('s', $maLoaiPhong);
                $stmt->execute();
                $stmt->bind_result($maLoaiPhong, $moTa, $dienTich, $phongConLai);
                if ($stmt->fetch()){
                    $rs = ['success'=>true,'maLoaiPhong'=>$maLoaiPhong, 'moTa'=>$moTa, 'dienTich'=>$dienTich, 'phongConLai'=>$phongConLai];
                }
                $stmt->close();
            }
            return $rs;
        }




        static function get_Ks_Info($maKhachSan){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM khachSan WHERE maKhachSan= ?")){
                $stmt->bind_param('s', $maKhachSan);
                $stmt->execute();
                $stmt->bind_result($maKhachSan, $maKhuVuc, $tenKhachSan, $diaChi_KS, $Review, $diemDen, $tienNghi, $anhReview);
                if ($stmt->fetch()){
                    $rs = ['maKhachSan'=>$maKhachSan, 'maKhuVuc'=>$maKhuVuc, 'tenKhachSan'=>htmlspecialchars_decode($tenKhachSan), 'diaChi_KS'=>$diaChi_KS, 'Review'=>$Review, 'diemDen'=>$diemDen, 'tienNghi'=>$tienNghi, 'anhReview'=>$anhReview];
                }
                $stmt->close();
            }
            return $rs;
        }


        static function get_Kv_Info($maKhuVuc){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM khuVuc WHERE maKhuVuc= ?")){
                $stmt->bind_param('s', $maKhuVuc);
                $stmt->execute();
                $stmt->bind_result($maKhuVuc, $tenKhuVuc);
                if ($stmt->fetch()){
                    $rs = ['maKhuVuc'=>$maKhuVuc, 'tenKhuVuc'=>htmlspecialchars_decode($tenKhuVuc)];
                }
                $stmt->close();
            }
            return $rs;
        }





        static function get_Ks_Info_all(){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM khachSan")){
                $stmt->execute();
                $stmt->bind_result($maKhachSan, $maKhuVuc, $tenKhachSan, $diaChi_KS, $Review, $diemDen, $tienNghi, $anhReview);
                while ($stmt->fetch()){
                    $rs[] = ['maKhachSan'=>$maKhachSan, 'maKhuVuc'=>$maKhuVuc, 'tenKhachSan'=>htmlspecialchars_decode($tenKhachSan), 'diaChi_KS'=>$diaChi_KS, 'Review'=>$Review, 'diemDen'=>$diemDen, 'tienNghi'=>$tienNghi, 'anhReview'=>$anhReview];
                }
                $stmt->close();
            }
            return $rs;
        }




        static function khachDatPhong($maTruyCap, $maLoaiPhong, $soluong,$thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $tuyChon, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC, $address_bill, $address_company, $code, $company){
            $ngayDat = date("Y-m-d h:i:s",time());
            $result = self::$mysql->query("SELECT phongConLai FROM loaiPhong WHERE maLoaiPhong='$maLoaiPhong'");
            if($phongConLai = $result->fetch_assoc()){
                if($phongConLai['phongConLai'] < $soluong)
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Hết phòng trống!'];
            }else
                return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Không tồn tại mã phòng!'];
            $stmt = self::$mysql->prepare("INSERT INTO khachDatPhong(maTruyCap, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, tuyChon, hinhThuc, hoTen_KTC, email_KTC, SDT_KTC, tinhThanhPho_KTC)
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            for($i=1;$i<=$soluong;$i++){
                
                $result = self::$mysql->query("SELECT maPhong FROM phong WHERE conTrong=1 AND maLoaiPhong='$maLoaiPhong' LIMIT 1");
                $maPhong = $result->fetch_assoc()['maPhong'];
                
                $stmt->bind_param('sssssissssss', $maTruyCap, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $tuyChon, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC);
                $stmt->execute();
                if($stmt->affected_rows<1){
                    echo $stmt->error.'<br>';
                    echo json_encode([$maTruyCap, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $tuyChon, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC]);
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại!'];
                }
                // self::$mysql->query("INSERT INTO khachDatPhong(maTruyCap, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, hinhThuc, hoTen_KTC, email_KTC, SDT_KTC, tinhThanhPho_KTC)
                //                     VALUES('$maTruyCap', '$maPhong', '$ngayDat', '$thoiGianBatDau','$thoiGianKetThuc', $tongChiPhi, '$hinhThuc', '$hoTen_KTC', '$email_KTC', '$SDT_KTC', '$tinhThanhPho_KTC')");
                // if(self::$mysql->affected_rows!=1)
                //     return ['success'=>false, 'msg'=>'Đặt phòng thất bại!'];
            }
            $stmt->close();
            self::$mysql->query("UPDATE hoadon SET diaChiNhanHoaDon='$address_bill', diaChiCongTy='$address_company', maSoThue='$code', tenCongTy='$company' WHERE ngayGiaoDich='$ngayDat' AND  maSo_KH=(SELECT maSo_KH FROM khachhang WHERE maTruyCap='$maTruyCap')");
            return ['success'=>true, 'msg'=>'Đặt phòng thành công!'];
        }//db -1





        static function ndDatPhong($maSo_ND, $maLoaiPhong, $soluong, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $tuyChon, $hinhThuc, $email_2, $SDT_2, $hoTen_2, $tinhThanhPho_2, $address_bill, $address_company, $code, $company){
            $ngayDat = date("Y-m-d h:i:s",time());
            $result = self::$mysql->query("SELECT phongConLai FROM loaiPhong WHERE maLoaiPhong='$maLoaiPhong'");
            if($phongConLai = $result->fetch_assoc()){
                if($phongConLai['phongConLai'] < $soluong)
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Hết phòng trống!'];
            }else
                return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Không tồn tại mã phòng!'];
            $stmt = self::$mysql->prepare("INSERT INTO ndDatPhong(maSo_ND, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, tuyChon, hinhThuc, email_2, SDT_2, hoTen_2, tinhThanhPho_2)
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            for($i=1;$i<=$soluong;$i++){
                $result = self::$mysql->query("SELECT maPhong FROM phong WHERE conTrong=1 AND maLoaiPhong='$maLoaiPhong' LIMIT 1");
                $maPhong = $result->fetch_assoc()['maPhong'];

                $stmt->bind_param('sssssissssss', $maSo_ND, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $tuyChon, $hinhThuc, $email_2, $SDT_2, $hoTen_2, $tinhThanhPho_2);
                $stmt->execute();
                if($stmt->affected_rows<1){
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại!'];
                }
                // self::$mysql->query("INSERT INTO ndDatPhong(maSo_ND, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, hinhThuc, email_2, SDT_2, hoTen_2, tinhThanhPho_2)
                //                     VALUES('$maSo_ND', '$maPhong', '$ngayDat', '$thoiGianBatDau', '$thoiGianKetThuc', $tongChiPhi, '$hinhThuc', '$email_2', $SDT_2, '$hoTen_2', '$tinhThanhPho_2')");
                // if(self::$mysql->affected_rows!=1)
                //     return ['success'=>false, 'msg'=>'Đặt phòng thất bại!'];
            }
            $stmt->close();
            self::$mysql->query("UPDATE hoadon SET address_bill='$address_bill', address_company='$address_company', code='$code', company='$company' WHERE ngayGiaoDich='$ngayDat' AND maSo_KH=(SELECT maSo_KH FROM khachhang WHERE maSo_ND='$maSo_ND')");
            return ['success'=>true, 'msg'=>'Đặt phòng thành công!'];
            
        }//db -1



        static function ND_huyPhong($maSo_KH, $maHoaDon){
            $result = self::$mysql->query("SELECT maSo_ND FROM khachHang WHERE maSo_KH='$maSo_KH'");
            if($maSo_ND = $result->fetch_assoc()){
                $maSo_ND = $maSo_ND['maSo_ND'];
                $result = self::$mysql->query("SELECT maPhong FROM ndDatPhong S1 JOIN hoaDon S2 ON S1.ngayDat=S2.ngayGiaoDich WHERE S1.maSo_ND='$maSo_ND' AND maHoaDon='$maHoaDon'");
                $stmt = self::$mysql->prepare("DELETE FROM ndDatPhong WHERE maPhong=?");
                $stmt->bind_param('s', $phong);
                while($phong = $result->fetch_assoc()){
                    $phong = $phong['maPhong'];
                    $stmt->execute();
                }
                if(self::$mysql->affected_rows!=0)
                    return ['success'=>true, 'msg'=>'Đã hủy đặt phòng'];
                else
                    return ['success'=>false, 'msg'=>'Hủy phòng không thành công'];

            }
        }
        static function khach_huyPhong($maSo_KH, $maHoaDon){
            $result = self::$mysql->query("SELECT maTruyCap FROM khachHang WHERE maSo_KH='$maSo_KH'");
            if($maTruyCap = $result->fetch_assoc()){
                $maTruyCap = $maTruyCap['maTruyCap'];
                $result = self::$mysql->query("SELECT maPhong FROM khachDatPhong S1 JOIN hoaDon S2 ON S1.ngayDat=S2.ngayGiaoDich WHERE S1.maTruyCap='$maTruyCap' AND maHoaDon='$maHoaDon'");
                $stmt = self::$mysql->prepare("DELETE FROM khachDatPhong WHERE maPhong=?");
                $stmt->bind_param('s', $phong);
                while($phong = $result->fetch_assoc()){
                    $phong = $phong['maPhong'];
                    $stmt->execute();
                }
                if(self::$mysql->affected_rows!=0)
                    return ['success'=>true, 'msg'=>'Đã hủy đặt phòng'];
                else
                    return ['success'=>false, 'msg'=>'Hủy phòng không thành công'];
            }
        }







        static function thongTinHoaDon($maSo_KH){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM hoaDon WHERE maSo_KH= ?")){
                $stmt->bind_param('s', $maSo_KH);
                $stmt->execute();
                $rs2 = $stmt->get_result();
                while ($row = $rs2->fetch_assoc()){
                    $rs[] = $row;
                }
                $stmt->close();
            }
            return $rs;
        }







        static function thongTinHoaDonADMIN(){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM hoaDon")){
                $stmt->execute();
                $rs2 = $stmt->get_result();
                while ($row = $rs2->fetch_assoc()){
                    $rs[] = $row;
                }
                $stmt->close();
                return ['success'=>true, 'hoaDon'=>$rs];
            }
            return ['success'=>false];
        }




        static function thongTinKhachHangADMIN(){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM khachHang")){
                $stmt->execute();
                $rs2 = $stmt->get_result();
                while ($row = $rs2->fetch_assoc()){
                    $rs[] = $row;
                }
                $stmt->close();
                return ['success'=>true, 'khachHang'=>$rs];
            }
            return ['success'=>false];
        }




        static function duyetDonADMIN($maHoaDon, $maSo_KH, $accept){
            if($accept){
                self::$mysql->query("UPDATE hoaDon SET trangThai = 'Đã thanh toán' WHERE maHoaDon='$maHoaDon'");
            }else{
                self::ND_huyPhong($maSo_KH, $maHoaDon);
                self::khach_huyPhong($maSo_KH, $maHoaDon);
            }
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Duyệt thành công'];
        }




        static function getMaKhachHang($maTruyCap_maSo_ND){
            $result = self::$mysql->query("SELECT maSo_KH FROM khachhang WHERE maTruyCap='$maTruyCap_maSo_ND' OR maSo_ND='$maTruyCap_maSo_ND'");
            if($result = $result->fetch_assoc())
                return array_merge(['success'=>true, 'msg'=>'Là khách hàng'], $result);
            return ['success'=>false, 'msg'=>'Không phải khách hàng'];
        }



      
        // static function isAdmin($maSo_ND){
        //     $result = self::$mysql->query("SELECT quyenQuanTri FROM nguoidung WHERE maSo_ND = '$maSo_ND'");
        //     if($result = $result->fetch_assoc())
        //         return array_merge(['success'=>true, 'msg'=>'Là quản trị viên'], $result);
        //     return ['success'=>false, 'msg'=>'là khách hàng'];
        // }
        
        
        static function danhGiaWebSite($doHaiLong, $gopY, $cauHoi, $email_SDT_lienHe){
            $result = self::$mysql->query("INSERT INTO danhGiaWebSite VALUES('$doHaiLong', '$gopY', '$cauHoi', '$email_SDT_lienHe')");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Gửi Đánh Giá Thành Công!', 'err'=>self::$mysql->affected_rows];
        }


        static function getDanhGia(){
            $rs = [];
            if($stmt = self::$mysql->prepare("SELECT * FROM danhGiaWebSite")){
                $stmt->execute();
                $rs2 = $stmt->get_result();
                while ($row = $rs2->fetch_assoc()){
                    $rs[] = $row;
                }
                $stmt->close();
            }
            return $rs;
        }


        static function changeInfo($maSo_ND, $name, $email, $tenDangNhap, $phone, $address, $city, $new_pwd){
            $result = self::$mysql->query("UPDATE nguoiDung SET hoTen_ND = '$name', tenDangNhap = '$tenDangNhap', email_ND = '$email', SDT_ND = '$phone', diaChi_ND = '$address', tinhThanhPho_ND = '$city', matKhau_ND = '$new_pwd' WHERE maSo_ND='$maSo_ND' ");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Cập nhật thông tin thành công!'];
        }

    }
    












?>