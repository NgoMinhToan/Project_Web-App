<?php
    // các thuộc tính dc trả về khi stmt gọi 1 câu truy vấn từ db (thành công) | lỗi
        // [affected_rows] 1 | -1
        // [insert_id] 0
        // [num_rows] 0
        // [param_count] 4
        // [field_count] 0
        // [errno] 0
        // [error] 
        // [error_list] | Array()
        // [sqlstate] 00000
        // [id] 1
    // cấu trúc db:
        //items: 
            //item_index int: đánh dấu thứ tự item, mỗi item là 1 trang web trong phần Cẩm Nang (trang web con), 
            //title varchar(1000): tựa đề để hiển thị bên ngoài hay bên trong trang web con - (chưa được thu gon...),
            //view int: lượt truy cập của trang web con (cái này cao siêu quá, chưa tìm hiểu! :)),
            //`date` date: thời gian post của trang web con.
        //contents: 
            //id int: đánh dấu phân biệt content,
            //content_index int: đánh dấu thứ tự của 1 content trong trang web con (mỗi trang web con có thể có đến 50 cái content), bắt đầu mỗi trang web thứ tự trở về 1,
            //item_index int: item mà content này thuộc về
            //src varchar(100): thư mục chứa ảnh, nếu thẻ là <img>,
            //content varchar(20000): chứa nội dung nếu thẻ này là <p> or <h4>,
            //tag varchar(10): chứa tên thẻ (p | h4 | img).
    require_once 'contents.php';
    require_once 'items.php';
    require_once 'service.php';
    require_once 'object.php';
    date_default_timezone_set("Asia/Ho_Chi_Minh");
    Db::$mysql = new mysqli('localhost', 'root', '', 'khachsan');
    if(mysqli_connect_errno()){
        die('Lỗi Kết Nối CSDL: '.mysqli_connect_error());
    }
    Db::$mysql -> set_charset("utf8");

    class Db{
        static $mysql;
        // static function get_items($start = 1, $limit = null){
        //     $rs = [];
        //     $result=self::$mysql->query("SELECT MIN(ITEM_INDEX) AS 'start', MAX(ITEM_INDEX) AS 'range' FROM items");
        //     $range=0;
        //     if($row=$result->fetch_assoc()){
        //         $range = $row["range"];
        //         $start = $row["start"];
        //     }
        //     if(is_numeric($limit)){
        //         $range = $limit - 1 + $start;
        //         // echo $range;
        //     }
        //     $stmt = self::$mysql->prepare("SELECT ITEM_INDEX, TITLE, VIEW, DATE FROM items WHERE ITEM_INDEX BETWEEN ? AND ?");
        //     $stmt->bind_param('ii', $start, $range);
            
        //     $stmt->execute();
        //     $stmt->bind_result($item_index, $title, $view, $date);
        //     while($stmt->fetch()){
        //         $rs[] = new Item($item_index, $title, $view, $date);
        //     }
        //     $stmt->close();
        //     return $rs;
        // }
        // static function add_item($row){
        //     $stmt = self::$mysql->prepare('INSERT INTO ITEMS (ITEM_INDEX, TITLE, `VIEW`, `DATE`) VALUES(?,?,?,?)');
        //     $stmt->bind_param('isis', $row->item_index, $row->title, $row->view, $row->date);
        //     $stmt->execute();
        //     $log = $stmt->affected_rows;
        //     $stmt->close();
        //     return $log;
        // }
        // static function get_contents($start = 1, $limit = null){
        //     $rs = [];
        //     $result=self::$mysql->query("SELECT MIN(ID) AS 'start', MAX(ID) AS 'range' FROM contents");
        //     $range=0;
        //     if($row=$result->fetch_assoc()){
        //         $range = $row["range"];
        //         $start = $row["start"];
        //     }
        //     if(is_numeric($limit)){
        //         $range = $limit - 1 + $start;
        //         // echo $range;
        //     }
        //     $stmt = self::$mysql->prepare('SELECT ITEM_INDEX, ID, CONTENT_INDEX, SRC, CONTENT, tag FROM contents WHERE ID BETWEEN ? AND ?');
        //     $stmt->bind_param('ii', $start, $range);
    
        //     $stmt->execute();
        //     $stmt->bind_result($item_index, $id, $content_index, $src, $content, $tag);
        //     while($stmt->fetch()){
        //         $rs[] = new Content($id, $content_index, $item_index, $src, $content, $tag);
        //     }
        //     $stmt->close();
        //     return $rs;
        // }
        // static function get_content_from_item($item_index){
        //     $rs = [];
        //     $stmt = self::$mysql->prepare('SELECT ITEM_INDEX, ID, CONTENT_INDEX, SRC, CONTENT, tag FROM contents WHERE ITEM_INDEX = ?');
        //     $stmt->bind_param('i', $item_index);
        //     $stmt->execute();
        //     $stmt->bind_result($item_index, $id, $content_index, $src, $content, $tag);
        //     while($stmt->fetch()){
        //         $rs[] = new Content($id, $content_index, $item_index, $src, $content, $tag);
        //     }
        //     $stmt->close();
        //     return $rs;
        // }
        // static function add_content($row){
        //     $stmt = self::$mysql->prepare('CALL INSERT_CONTENT(?, ?, ?, ?, ?, ?)');
        //     $stmt->bind_param('iiisss', $row->id, $row->content_index, $row->item_index, $row->src, $row->content, $row->tag);
        //     $stmt->execute();
        //     $log = $stmt->affected_rows;
        //     $stmt->close();
        //     return $log;
        // }
        // static function delete_item($item_index){
        //     self::$mysql->query("DELETE FROM contents WHERE ITEM_INDEX=$item_index");
        //     if(self::$mysql->affected_rows==-1)
        //         return self::$mysql->affected_rows;
        //     $stmt = self::$mysql->query("DELETE FROM items WHERE ITEM_INDEX=$item_index");
        //     return self::$mysql->affected_rows;
        // }
    // Db::delete_item(1);
    // Db::delete_item(2);
    // Db::delete_item(3);
    // Db::delete_item(4);
    // Db::delete_item(5);
    // Db::delete_item(6);
    // Db::delete_item(7);
    // Db::delete_item(8);
    // Db::delete_item(9);
    // Db::delete_item(10);
    // Db::delete_item(11);
    // Db::delete_item(12);
    
    // print_r(get_contents(1, 3));
    // print_r(get_items(2));
    // print_r(get_content_from_item(1));
    
    
//==========================================================================================//
//===================== PHẦN QUẢN LÝ KHÁCH SẠN ============================================//
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
            $diaChi_IP = $truyCap['diaChi_IP'];
            // print_r($truyCap);
            // echo '<br>';
            // echo $tenDangNhap_email_ND.'<br>';
            // echo $matKhau_SDT_ND.'<br>';
            $result = self::$mysql->query("SELECT dangNhap.maSo_ND, dangNhap.maTruyCap
                FROM dangNhap JOIN nguoiDung ON dangNhap.maSo_ND=nguoiDung.maSo_ND
                                JOIN khachTruyCap ON dangNhap.maTruyCap = khachTruyCap.maTruyCap
                WHERE (email_ND='$tenDangNhap_email_ND' AND matKhau_ND='$matKhau_SDT_ND' 
                    OR tenDangNhap='$tenDangNhap_email_ND' AND SDT_ND='$matKhau_SDT_ND') AND khachTruyCap.diaChi_IP='$diaChi_IP'");
            // print_r($diaChi_IP);
            // print_r($result);
            // echo $result->num_rows;
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
                // echo $maTruyCap.'<br>';
                // echo $maSo_ND.'<br>';
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
                while ($stmt->fetch()){
                    $rs = ['maKhachSan'=>$maKhachSan, 'maKhuVuc'=>$maKhuVuc, 'tenKhachSan'=>$tenKhachSan, 'diaChi_KS'=>$diaChi_KS, 'Review'=>$Review, 'diemDen'=>$diemDen, 'tienNghi'=>$tienNghi, 'anhReview'=>$anhReview];
                }
                $stmt->close();
            }
            return $rs;
        }




        static function khachDatPhong($maTruyCap, $maLoaiPhong, $soluong,$thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC, $address_bill, $address_company, $code, $company){
            $ngayDat = date("Y-m-d h:i:s",time());
            $result = self::$mysql->query("SELECT phongConLai FROM loaiPhong WHERE maLoaiPhong='$maLoaiPhong'");
            if($phongConLai = $result->fetch_assoc()){
                if($phongConLai['phongConLai'] < $soluong)
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Hết phòng trống!'];
            }else
                return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Không tồn tại mã phòng!'];
            $stmt = self::$mysql->prepare("INSERT INTO khachDatPhong(maTruyCap, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, hinhThuc, hoTen_KTC, email_KTC, SDT_KTC, tinhThanhPho_KTC)
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            for($i=1;$i<=$soluong;$i++){
                
                $result = self::$mysql->query("SELECT maPhong FROM phong WHERE conTrong=1 AND maLoaiPhong='$maLoaiPhong' LIMIT 1");
                $maPhong = $result->fetch_assoc()['maPhong'];
                
                $stmt->bind_param('sssssisssss', $maTruyCap, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC);
                $stmt->execute();
                if($stmt->affected_rows<1){
                    echo $stmt->error.'<br>';
                    echo json_encode([$maTruyCap, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $hinhThuc, $hoTen_KTC, $email_KTC, $SDT_KTC, $tinhThanhPho_KTC]);
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





        static function ndDatPhong($maSo_ND, $maLoaiPhong, $soluong, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $hinhThuc, $email_2, $SDT_2, $hoTen_2, $tinhThanhPho_2, $address_bill, $address_company, $code, $company){
            $ngayDat = date("Y-m-d h:i:s",time());
            $result = self::$mysql->query("SELECT phongConLai FROM loaiPhong WHERE maLoaiPhong='$maLoaiPhong'");
            if($phongConLai = $result->fetch_assoc()){
                if($phongConLai['phongConLai'] < $soluong)
                    return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Hết phòng trống!'];
            }else
                return ['success'=>false, 'msg'=>'Đặt phòng thất bại | Không tồn tại mã phòng!'];
            $stmt = self::$mysql->prepare("INSERT INTO ndDatPhong(maSo_ND, maPhong, ngayDat, thoiGianBatDau, thoiGianKetThuc, tongChiPhi, hinhThuc, email_2, SDT_2, hoTen_2, tinhThanhPho_2)
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            for($i=1;$i<=$soluong;$i++){
                $result = self::$mysql->query("SELECT maPhong FROM phong WHERE conTrong=1 AND maLoaiPhong='$maLoaiPhong' LIMIT 1");
                $maPhong = $result->fetch_assoc()['maPhong'];

                $stmt->bind_param('sssssisssss', $maSo_ND, $maPhong, $ngayDat, $thoiGianBatDau, $thoiGianKetThuc, $tongChiPhi, $hinhThuc, $email_2, $SDT_2, $hoTen_2, $tinhThanhPho_2);
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





        static function ND_huyPhong($maSo_ND, $maPhong){
            $result = self::$mysql->query("DELETE FROM ndDatPhong WHERE maSo_ND='$maSo_ND' AND maPhong='$maPhong'");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Đã hủy đặt phòng'];
        }






        //hủy đặt phong nd | db +1
        //hủy đặt phong khach | db +1
        //lưu lại thông tin của khách không đăng nhập
        //lưu thông tin sang bảng khách hàng
        //thống kê số phòng đã đặt như loại phòng

        // static function yKien_KH($maKhachSan, $doHaiLong, $gopY, $cauHoi, $email_SDT_lienHe){
        //     $result = self::$mysql->query("INSERT INTO danhGia VALUES('$maKhachSan', $doHaiLong, '$gopY', '$cauHoi', '$email_SDT_lienHe')");
        //     if(self::$mysql->affected_rows!=0)
        //         return ['success'=>true, 'msg'=>'Gửi Đánh Giá Thành Công!'];
        // }
        
        
        static function danhGiaWebSite($doHaiLong, $gopY, $cauHoi, $email_SDT_lienHe){
            $result = self::$mysql->query("INSERT INTO danhGiaWebSite VALUES('$doHaiLong', '$gopY', '$cauHoi', '$email_SDT_lienHe')");
            if(self::$mysql->affected_rows!=0)
                return ['success'=>true, 'msg'=>'Gửi Đánh Giá Thành Công!'];
        }
    }
    












?>