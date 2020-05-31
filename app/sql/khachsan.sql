-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 30, 2020 lúc 08:35 AM
-- Phiên bản máy phục vụ: 10.4.11-MariaDB
-- Phiên bản PHP: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `khachsan`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dangnhap`
--

CREATE TABLE `dangnhap` (
  `maTruyCap` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maSo_ND` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `thoiGianDangNhap` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhgiawebsite`
--

CREATE TABLE `danhgiawebsite` (
  `doHaiLong` varchar(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `gopY` varchar(50) COLLATE utf8_vietnamese_ci NOT NULL,
  `cauHoi` varchar(1000) COLLATE utf8_vietnamese_ci NOT NULL,
  `email_sdt_lienhe` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hoadon`
--

CREATE TABLE `hoadon` (
  `maHoaDon` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maSo_KH` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maKhachSan` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maLoaiPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `soLuong` int(11) NOT NULL DEFAULT 1,
  `giaPhong` double NOT NULL DEFAULT 1,
  `tongGia` double NOT NULL DEFAULT 1,
  `thanhTien` double NOT NULL DEFAULT 1,
  `ngayGiaoDich` datetime NOT NULL DEFAULT current_timestamp(),
  `TG_layPhong` datetime NOT NULL DEFAULT current_timestamp(),
  `TG_traPhong` datetime NOT NULL DEFAULT current_timestamp(),
  `tuyChon` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL,
  `hinhThucThanhToan` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `trangThai` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT 'Đang chờ duyệt',
  `tenCongTy` varchar(200) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `maSoThue` varchar(200) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `diaChiCongTy` varchar(200) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `diaChiNhanHoaDon` varchar(200) COLLATE utf8_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachdatphong`
--

CREATE TABLE `khachdatphong` (
  `maTruyCap` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `ngayDat` datetime DEFAULT current_timestamp(),
  `thoiGianBatDau` datetime DEFAULT NULL,
  `thoiGianKetThuc` datetime DEFAULT NULL,
  `tongChiPhi` int(11) DEFAULT NULL,
  `tuyChon` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL DEFAULT '',
  `hinhThuc` varchar(20) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `hoTen_KTC` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `email_KTC` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `SDT_KTC` char(10) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `tinhThanhPho_KTC` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Bẫy `khachdatphong`
--
DELIMITER $$
CREATE TRIGGER `K_DatPhong` BEFORE INSERT ON `khachdatphong` FOR EACH ROW BEGIN
	DECLARE makhachhang INT;
    DECLARE repeatKH CHAR(4);
    DECLARE repeatHD CHAR(4);
    DECLARE makhachsan char(20);
    DECLARE maloaiphong char(20);
    DECLARE maHD char(20);
    DECLARE masoKH char(20);
    
    UPDATE phong SET phong.conTrong = phong.conTrong- 1 
    WHERE phong.maPhong = NEW.maPhong;
    
    UPDATE loaiphong SET loaiphong.phongConLai= loaiphong.phongConLai-1
    WHERE loaiphong.maLoaiPhong = (SELECT phong.maLoaiPhong FROM phong WHERE phong.maPhong=NEW.maPhong);
   
    IF ((SELECT COUNT(maSo_KH) FROM khachhang) = 0)
    THEN
    SET makhachhang = 1;
    ELSE
    SET makhachhang = (SELECT MAX(CONVERT(RIGHT(khachhang.maSo_KH, 4), INT)) FROM khachhang)+1;
    END IF;
    SET repeatKH = (SELECT REPEAT('0', 4- CHAR_LENGTH(CONVERT(makhachhang, CHARACTER))));
    

    IF NOT EXISTS(SELECT maTruyCap FROM khachhang WHERE khachhang.maTruyCap=NEW.maTruyCap)
    THEN
    INSERT INTO khachhang(maSo_KH, maTruyCap, hoTen_KH, email_KH, SDT_KH, tinhThanhPho_KH) VALUES(CONCAT('KH', repeatKH, makhachhang), NEW.maTruyCap, NEW.hoTen_KTC, NEW.email_KTC, NEW.SDT_KTC, NEW.tinhThanhPho_KTC);
    END IF;
    
    
    
    
	IF ((SELECT COUNT(maHoaDon) FROM hoadon) = 0)
    THEN
    SET maHD = 1;
    ELSE
    SET maHD = (SELECT MAX(CONVERT(RIGHT(hoadon.maHoaDon, 4), INT)) FROM hoadon)+1;
    END IF;
    SET repeatHD = (SELECT REPEAT('0', 4-CHAR_LENGTH(CONVERT(maHD, CHARACTER))));
    
    SET makhachsan = (SELECT phong.maKhachSan FROM phong WHERE phong.maPhong = NEW.maPhong);
    
    SET maloaiphong = (SELECT phong.maLoaiPhong FROM phong WHERE phong.maPhong = NEW.maPhong);
    
    SET masoKH = (SELECT khachhang.maSo_KH FROM khachhang WHERE khachhang.maTruyCap=NEW.maTruyCap);
    
    IF EXISTS(SELECT maHoaDon FROM hoadon WHERE hoadon.ngayGiaoDich=NEW.ngayDat AND hoadon.maSo_KH=masoKH AND hoadon.maLoaiPhong=maloaiphong AND hoadon.maKhachSan= makhachsan)
    THEN
    
    
    
    UPDATE hoadon SET soLuong = soLuong+1, tongGia=FLOOR((1+soLuong)*giaPhong/1000)*1000, hoadon.thanhTien = FLOOR(((1+soLuong)*giaPhong)*1.1/1000)*1000   WHERE maHoaDon=(SELECT maHoaDon FROM hoadon WHERE hoadon.ngayGiaoDich=NEW.ngayDat AND hoadon.maSo_KH=masoKH AND hoadon.maLoaiPhong=maloaiphong AND hoadon.maKhachSan= makhachsan);
    
    ELSE
    
    
    INSERT INTO hoadon (hoadon.maHoaDon, hoadon.maSo_KH, hoadon.maKhachSan, hoadon.maLoaiPhong, hoadon.soLuong, hoadon.giaPhong, hoadon.tongGia, hoadon.ngayGiaoDich, hoadon.TG_layPhong, hoadon.TG_traPhong, hoadon.tuyChon, hoadon.hinhThucThanhToan, hoadon.thanhTien) VALUES(CONCAT('HOADON', repeatHD, maHD), masoKH, makhachsan, maloaiphong, 1, NEW.tongChiPhi, NEW.tongChiPhi, NEW.ngayDat, NEW.thoiGianBatDau, NEW.thoiGianKetThuc, NEW.tuyChon, NEW.hinhThuc, FLOOR(NEW.tongChiPhi*1.1/1000)*1000);
    END IF;
    
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `K_HuyPhong` BEFORE DELETE ON `khachdatphong` FOR EACH ROW BEGIN
	UPDATE phong SET phong.conTrong = phong.conTrong+1
    WHERE phong.maPhong = OLD.maPhong;
    
    
    UPDATE loaiphong SET loaiphong.phongConLai=loaiphong.phongConLai+1
    WHERE loaiphong.maLoaiPhong = (SELECT phong.maLoaiPhong
    FROM phong WHERE phong.maPhong=OLD.maPhong);
    
    UPDATE hoadon SET thanhTien=0, trangThai='Đã hủy' WHERE hoadon.maSo_KH=(SELECT maSo_KH FROM khachhang WHERE khachhang.maTruyCap=OLD.maTruyCap) AND hoadon.ngayGiaoDich=OLD.ngayDat;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachhang`
--

CREATE TABLE `khachhang` (
  `maSo_KH` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maTruyCap` char(20) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `maSo_ND` char(20) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `hoTen_KH` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `email_KH` varchar(50) COLLATE utf8_vietnamese_ci NOT NULL,
  `SDT_KH` char(10) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `tinhThanhPho_KH` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachsan`
--

CREATE TABLE `khachsan` (
  `maKhachSan` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maKhuVuc` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `tenKhachSan` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL,
  `diaChi_KS` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL,
  `Review` varchar(1000) COLLATE utf8_vietnamese_ci NOT NULL,
  `diemDen` longtext COLLATE utf8_vietnamese_ci NOT NULL,
  `tienNghi` longtext COLLATE utf8_vietnamese_ci NOT NULL,
  `anhReview` longtext COLLATE utf8_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `khachsan`
--

INSERT INTO `khachsan` (`maKhachSan`, `maKhuVuc`, `tenKhachSan`, `diaChi_KS`, `Review`, `diemDen`, `tienNghi`, `anhReview`) VALUES
('MAKHACHSAN1_1', 'KHUVUC1', 'Khách sạn Dana Marina', '47-49 Đường Võ Văn Kiệt, Phường Phước Mỹ, Sơn Trà, Đà Nẵng', 'Khách sạn Dana Marina là khách sạn đạt chuẩn chất lượng 4 sao có hồ bơi,tập gym tọa lạc trên đường Võ Văn Kiệt - vị trí thuận tiện và đẹp nhất thành phố Đà Nẵng, Chỉ mất 2 phút đi bộ đến bãi tắm biển Mỹ Khê thơ mộng - nơi đã được tạp chí Forbes của Mỹ bình chọn là một trong những bãi biển đẹp nhất hành tinh, thuận lợi di chuyển đến các điểm tham quan du lịch một cách nhanh chóng.', '[[\"B\\u00e3i Bi\\u1ec3n M\\u1ef9 Kh\\u00ea\",\"0.51km\"],[\"C\\u00f4ng vi\\u00ean Bi\\u00ea\\u0309n \\u0110\\u00f4ng\",\"0.88km\"],[\"Bi\\u1ec3n M\\u1ef9 Kh\\u00ea\",\"0.90km\"],[\"B\\u00e3i t\\u1eafm T20\",\"1.18km\"],[\"C\\u1ea7u R\\u1ed3ng\",\"1.75km\"],[\"C\\u1ea7u Tr\\u1ea7n Th\\u1ecb L\\u00fd\",\"1.75km\"],[\"Ng\\u0169 H\\u00e0nh S\\u01a1n\",\"1.79km\"],[\"L\\u1ec5 h\\u1ed9i Quan Th\\u1ebf \\u00c2m\",\"1.99km\"],[\"C\\u1ea7u S\\u00f4ng H\\u00e0n\",\"2.01km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe\",\"Ph\\u00f2ng h\\u1ecdp\",\"Qu\\u00e1n bar\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"Ph\\u00f2ng gym\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"\\u0110\\u1eb7t v\\u00e9 xe\\/m\\u00e1y bay\"]', '[\".\\/images\\/Hotel\\/khach-san-dana-marina\\/1.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/2.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/3.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/4.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/5.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/6.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/7.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/8.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/9.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/10.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/11.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/12.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/13.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/14.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/15.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/16.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/17.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/18.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/19.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/20.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/21.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/22.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/23.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/24.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/25.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/26.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/27.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/28.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/29.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/30.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/31.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/32.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/33.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/34.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/35.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/36.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/37.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/38.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/39.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/40.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/41.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/42.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/43.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/44.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/45.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/46.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/47.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/48.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/49.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/50.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/51.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/52.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/53.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/54.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/55.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/56.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/57.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/58.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/59.png\",\".\\/images\\/Hotel\\/khach-san-dana-marina\\/60.png\"]'),
('MAKHACHSAN10_1', 'KHUVUC10', 'Venus Hotel &amp; Spa Hội An', '116 Hùng Vương, Hội An, Quảng Nam', 'Venus Hotel &amp; Spa nằm cách Cầu Nhật Bản ở Hội An chỉ 400 m. Khách sạn có sân hiên tắm nắng, nơi khách có thể thư giãn và quán bar nơi khách có thể chọn thưởng thức đồ uống.  Mỗi phòng tại khách sạn đều có máy lạnh và được trang bị TV. Ấm đun nước pha trà / cà phê. Một số căn hộ có khu vực tiếp khách. Phòng có phòng tắm riêng có bồn tắm hoặc vòi hoa sen. Để tạo sự thoải mái, bạn sẽ tìm thấy áo choàng tắm và dép. Venus Hotel &amp; Spa cung cấp Wi-Fi miễn phí trong toàn bộ khách sạn.  Lễ tân 24 giờ,Dịch vụ cho thuê xe đạp có tại khách sạn này và khu vực này rất phổ biến để đi xe đạp. Khách sạn cũng cung cấp dịch vụ cho thuê xe hơi.  Sân bay Quốc tế Đà Nẵng cách nơi ở này 45 phút lái xe taxi. Cách ga xe lửa Đà Nẵng 40 phút đi bằng taxi để đến khách sạn.  Đây là phần khách hàng yêu thích của chúng tôi tại Hội An, theo đánh giá độc lập. Khách sạn cũng được xếp hạng với giá trị tốt ở Hội An!', '[[\"Ch\\u00f9a Vi\\u00ean Gi\\u00e1c H\\u1ed9i An\",\"0.60km\"],[\"Ch\\u00f9a C\\u1ea7u Nh\\u1eadt B\\u1ea3n\",\"1.06km\"],[\"Ch\\u00f9a c\\u1ea7u Nh\\u1eadt B\\u1ea3n\",\"1.07km\"],[\"Ch\\u00f9a c\\u1ea7u H\\u1ed9i An\",\"1.07km\"],[\"B\\u1ea3o t\\u00e0ng v\\u0103n h\\u00f3a Sa Hu\\u1ef3nh\",\"1.14km\"],[\"Khu ph\\u1ed1 c\\u1ed5 H\\u1ed9i An\",\"1.27km\"],[\"B\\u1ea3o t\\u00e0ng H\\u1ed9i An\",\"1.39km\"],[\"Ch\\u00f9a Ch\\u00fac Th\\u00e1nh\",\"1.43km\"],[\"S\\u00f4ng Ho\\u00e0i\",\"1.47km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe mi\\u1ec5n ph\\u00ed\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\",\"Gi\\u1eef h\\u00e0nh l\\u00fd mi\\u1ec5n ph\\u00ed\"]', '[\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/1.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/2.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/3.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/4.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/5.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/6.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/7.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/8.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/9.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/10.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/11.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/12.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/13.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/14.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/15.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/16.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/17.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/18.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/19.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/20.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/21.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/22.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/23.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/24.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/25.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/26.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/27.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/28.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/29.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/30.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/31.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/32.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/33.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/34.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/35.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/36.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/37.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/38.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/39.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/40.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/41.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/42.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/43.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/44.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/45.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/46.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/47.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/48.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/49.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/50.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/51.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/52.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/53.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/54.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/55.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/56.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/57.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/58.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/59.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/60.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/61.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/62.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/63.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/64.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/65.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/66.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/67.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/68.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/69.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/70.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/71.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/72.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/73.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/74.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/75.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/76.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/77.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/78.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/79.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/80.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/81.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/82.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/83.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/84.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/85.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/86.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/87.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/88.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/89.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/90.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/91.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/92.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/93.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/94.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/95.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/96.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/97.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/98.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/99.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/100.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/101.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/102.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/103.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/104.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/105.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/106.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/107.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/108.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/109.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/110.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/111.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/112.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/113.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/114.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/115.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/116.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/117.png\",\".\\/images\\/Hotel\\/venus-hotel-spa-hoi-an\\/118.png\"]'),
('MAKHACHSAN11_1', 'KHUVUC11', 'Khách Sạn Hạ Long Plaza', '8 Hạ Long, Bãi Cháy, Hạ Long, Quảng Ninh', 'Khách sạn sang trọng này tự hào có được quang cảnh của vịnh Hạ Long và Cầu Bãi Cháy, Vịnh Hạ Long, một di sản thiên nhiên thế giới nổi tiếng. Nó chính là một sự lựa chọn lý tưởng cho cả khách doanh nhân cũng như khách du lịch ở lại, có 200 phòng nghỉ sang trọng các loại, sẽ đảm bảo làm vừa lòng quý khách. Quý khách cũng có thể thưởng thức các món ăn châu Âu, Nhật Bản, Thái hay các món ăn Việt Nam tại nhà hàng của khách sạn.&nbsp;Khách Sạn Hạ Long Plaza - quản lý bởi H&amp;K Hospitality&nbsp;có rất nhiều dịch vụ đa dạng và một vị trí tuyệt đẹp của Vịnh Hạ Long.', '[[\"B\\u00e3i t\\u1eafm B\\u00e3i Ch\\u00e1y\",\"0.14km\"],[\"C\\u1ea7u B\\u00e3i Ch\\u00e1y\",\"0.63km\"],[\"Ch\\u1ee3 B\\u00e3i Ch\\u00e1y\",\"0.83km\"],[\"Ch\\u1ee3 \\u0111\\u00eam H\\u1ea1 Long\",\"1.41km\"],[\"L\\u00e0ng ch\\u00e0i C\\u1eeda V\\u1ea1n\",\"1.57km\"],[\"C\\u00f4ng vi\\u00ean Qu\\u1ed1c t\\u1ebf Ho\\u00e0ng Gia\",\"1.88km\"],[\"\\u0110\\u1ea3o Ti T\\u1ed1p\",\"1.88km\"],[\"\\u0110\\u1ea3o R\\u1ec1u\",\"1.88km\"],[\"Ch\\u1ee3 H\\u1ea1 Long\",\"1.94km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe mi\\u1ec5n ph\\u00ed\",\"Ph\\u00f2ng h\\u1ed9i th\\u1ea3o\",\"Ph\\u00f2ng h\\u1ecdp\",\"Qu\\u00e1n bar\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Internet c\\u00f3 d\\u00e2y mi\\u1ec5n ph\\u00ed\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay t\\u00ednh ph\\u00ed\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"Ph\\u00f2ng x\\u00f4ng h\\u01a1i \\u01b0\\u1edbt\",\"Ph\\u1ee5c v\\u1ee5 \\u0111\\u1ed3 \\u0103n t\\u1ea1i ph\\u00f2ng\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\",\"Gi\\u1eb7t kh\\u00f4\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"K\\u00e9t an to\\u00e0n\",\"Gi\\u1eef h\\u00e0nh l\\u00fd mi\\u1ec5n ph\\u00ed\",\"Ph\\u00f2ng t\\u1eadp th\\u1ec3\",\"T\\u1ed5 ch\\u1ee9c s\\u1ef1 ki\\u1ec7n\",\"H\\u1ed3 b\\u01a1i d\\u00e0nh cho tr\\u1ebb em\"]', '[\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/1.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/2.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/3.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/4.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/5.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/6.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/7.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/8.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/9.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/10.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/11.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/12.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/13.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/14.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/15.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/16.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/17.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/18.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/19.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/20.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/21.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/22.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/23.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/24.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/25.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/26.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/27.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/28.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/29.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/30.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/31.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/32.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/33.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/34.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/35.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/36.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/37.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/38.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/39.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/40.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/41.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/42.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/43.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/44.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/45.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/46.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/47.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/48.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/49.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/50.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/51.png\",\".\\/images\\/Hotel\\/khach-san-ha-long-plaza\\/52.png\"]'),
('MAKHACHSAN12_1', 'KHUVUC12', 'Khách Sạn Sài Gòn Morin', '30 Lê Lợi, Huế, Thừa Thiên Huế', 'Khách Sạn Sài Gòn Morin Huế rất thoáng mát, phòng ốc sạch sẽ, trang thiết bị đầy đủ và tiện nghi. Nhân viên lại vô cùng thân thiện, nhiệt tình. Khách sạn nằm ở trung tâm nên thuận tiện đi lại và tham quan.', '[[\"C\\u1ea7u Tr\\u00e0ng Ti\\u1ec1n\",\"0.58km\"],[\"S\\u00f4ng H\\u01b0\\u01a1ng\",\"0.69km\"],[\"Nh\\u00e0 th\\u1edd Ch\\u00ednh t\\u00f2a Ph\\u00fa Cam\",\"0.69km\"],[\"Th\\u00e0nh ph\\u1ed1 Hu\\u1ebf\",\"0.69km\"],[\"S\\u00f4ng H\\u01b0\\u01a1ng Hu\\u1ebf\",\"0.85km\"],[\"K\\u1ef3 \\u00d0\\u00e0i\",\"1.06km\"],[\"Ng\\u1ecd M\\u00f4n Hu\\u1ebf\",\"1.19km\"],[\"\\u0110i\\u1ec7n Th\\u00e1i H\\u00f2a\",\"1.29km\"],[\"\\u0110\\u1ea1i N\\u1ed9i\",\"1.39km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe\",\"C\\u1eeda h\\u00e0ng l\\u01b0u ni\\u1ec7m\",\"Ph\\u00f2ng h\\u1ed9i th\\u1ea3o\",\"Ph\\u00f2ng h\\u1ecdp\",\"Salon\",\"Thang m\\u00e1y\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"S\\u00f2ng b\\u00e0i\",\"Spa\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Ph\\u00f2ng x\\u00f4ng h\\u01a1i \\u01b0\\u1edbt\",\"Ph\\u00f2ng gym\"]', '[\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/1.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/2.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/3.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/4.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/5.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/6.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/7.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/8.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/9.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/10.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/11.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/12.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/13.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/14.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/15.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/16.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/17.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/18.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/19.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/20.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/21.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/22.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/23.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/24.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/25.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/26.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/27.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/28.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/29.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/30.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/31.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/32.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/33.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/34.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/35.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/36.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/37.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/38.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/39.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/40.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/41.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/42.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/43.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/44.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/45.png\",\".\\/images\\/Hotel\\/khach-san-sai-gon-morin\\/46.png\"]'),
('MAKHACHSAN2_1', 'KHUVUC2', 'Khách Sạn Cao Vũng Tàu', '179 Thùy Vân, Phường 8, Vũng Tàu, Bà Rịa - Vũng Tàu', 'Khách Sạn Cao Vũng Tàu mang lại sự thăng hoa trong từng trải nghiệm của Quý khách. Vị trí độc đáo, đối diện bên bờ cát mịn, trải dài của bãi biển Thùy Vân, khách Sạn Cao là nơi đáng để bạn lựa chọn nhất khi đến với Vũng Tàu.&nbsp;', '[[\"Khu du l\\u1ecbch Paradise\",\"0.43km\"],[\"B\\u00e3i Th\\u00f9y V\\u00e2n (B\\u00e3i Sau)\",\"0.80km\"],[\"B\\u00e3i sau\",\"0.89km\"],[\"Khu du l\\u1ecbch Bi\\u1ec3n \\u0110\\u00f4ng\",\"0.93km\"],[\"H\\u00f2a m\\u00ecnh v\\u00e0o thi\\u00ean nhi\\u1ec7n th\\u01a1 m\\u1ed9ng c\\u1ee7a V\\u0169ng T\\u00e0u Paradise\",\"1.08km\"],[\"\\u0110\\u00e0i li\\u1ec7t s\\u0129 V\\u0169ng T\\u00e0u\",\"1.15km\"],[\"S\\u00e2n Golf V\\u0169ng T\\u00e0u\",\"1.43km\"],[\"L\\u0103ng C\\u00e1 \\u00d4ng\",\"2.07km\"],[\"\\u0110\\u00ecnh th\\u1ea7n Th\\u1eafng Tam\",\"2.44km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe mi\\u1ec5n ph\\u00ed\",\"Ph\\u00f2ng h\\u1ecdp\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"Nh\\u00e0 h\\u00e0ng\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\"]', '[\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/1.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/2.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/3.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/4.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/5.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/6.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/7.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/8.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/9.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/10.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/11.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/12.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/13.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/14.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/15.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/16.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/17.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/18.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/19.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/20.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/21.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/22.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/23.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/24.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/25.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/26.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/27.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/28.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/29.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/30.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/31.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/32.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/33.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/34.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/35.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/36.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/37.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/38.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/39.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/40.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/41.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/42.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/43.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/44.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/45.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/46.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/47.png\",\".\\/images\\/Hotel\\/khach-san-cao-vung-tau\\/48.png\"]'),
('MAKHACHSAN3_1', 'KHUVUC3', 'Khách Sạn TTC Hotel - Ngọc Lan', '42 Nguyễn Chí Thanh, Đà Lạt, Lâm Đồng', 'Khách Sạn&nbsp;TTC premium Ngọc Lan&nbsp; Đà Lạt có không gian phòng nghỉ ấm cúng, nội thất hiện đại và sang trọng. Đội ngũ nhân viên thân thiện và nhiệt tình. Khách sạnTTC premium Ngọc Lan nằm ở trung tâm nên thuận tiện đi lại và tham quan.', '[[\"Ch\\u1ee3 \\u00c2m Ph\\u1ee7 \\u0110\\u00e0 L\\u1ea1t\",\"0.18km\"],[\"Ch\\u1ee3 \\u0110\\u00e0 L\\u1ea1t\",\"0.24km\"],[\"Nh\\u00e0 th\\u1edd Con G\\u00e0\",\"0.55km\"],[\"B\\u1ea3o t\\u00e0ng L\\u00e2m \\u0110\\u1ed3ng\",\"0.79km\"],[\"C\\u00e2u l\\u1ea1c b\\u1ed9 golf \\u00d0\\u00e0 L\\u1ea1t\",\"0.79km\"],[\"Nh\\u1eefng ng\\u00f4i nh\\u00e0 ma \\u1edf \\u0110\\u00e0 L\\u1ea1t\",\"0.79km\"],[\"Th\\u00e0nh ph\\u1ed1 \\u0110\\u00e0 L\\u1ea1t\",\"0.79km\"],[\"L\\u00e0ng Bi\\u1ec7t Th\\u1ef1 C\\u1ed5\",\"0.94km\"],[\"Nh\\u00e0 Th\\u1edd G\\u1ed7 Cam Ly\",\"1.07km\"]]', '[\"B\\u00e3i \\u0111\\u1ed7 xe\",\"C\\u1eeda h\\u00e0ng l\\u01b0u ni\\u1ec7m\",\"Ph\\u00f2ng h\\u1ed9i th\\u1ea3o\",\"Ph\\u00f2ng h\\u1ecdp\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"Spa\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Ph\\u00f2ng gia \\u0111\\u00ecnh\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Ph\\u00f2ng x\\u00f4ng h\\u01a1i \\u01b0\\u1edbt\",\"Ph\\u00f2ng gym\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"\\u0110\\u1eb7t v\\u00e9 xe\\/m\\u00e1y bay\",\"Khu v\\u1ef1c h\\u00fat thu\\u1ed1c\",\"D\\u1ecbch v\\u1ee5 tr\\u00f4ng tr\\u1ebb\"]', '[\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/1.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/2.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/3.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/4.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/5.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/6.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/7.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/8.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/9.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/10.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/11.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/12.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/13.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/14.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/15.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/16.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/17.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/18.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/19.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/20.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/21.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/22.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/23.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/24.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/25.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/26.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/27.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/28.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/29.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/30.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/31.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/32.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/33.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/34.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/35.png\",\".\\/images\\/Hotel\\/khach-san-ttc-hotel-ngoc-lan\\/36.png\"]'),
('MAKHACHSAN4_1', 'KHUVUC4', 'Khách Sạn Nikko Sài Gòn', '235 Nguyễn Văn Cừ, Quận 1, Hồ Chí Minh', 'Khách Sạn Nikko Sài Gòn có vị trí thuận lợi cùng lối thiết kế trang nhã, ấm cúng, hứa hẹn mang đến cho du khách một chuyến nghỉ dưỡng thoải mái và khó quên. Đây chắc chắn là một điểm đến không thể bỏ qua.', '[[\"Ch\\u00f9a Gi\\u00e1c H\\u1ea3i - H\\u1ed3 Ch\\u00ed Minh\",\"0.61km\"],[\"Ch\\u00f9a B\\u00e0 Thi\\u00ean H\\u1eadu\",\"0.79km\"],[\"Nh\\u00e0 th\\u1edd Ch\\u1ee3 Qu\\u00e1n\",\"0.81km\"],[\"Nh\\u00e0 th\\u1edd Huy\\u1ec7n S\\u0129\",\"0.85km\"],[\"Nh\\u00e0 th\\u1edd Huy\\u1ec7n S\\u0129\",\"0.85km\"],[\"Ch\\u00f9a Nguy\\u00ean H\\u01b0\\u01a1ng\",\"0.96km\"],[\"Ch\\u00f9a An L\\u1ea1c - Qu\\u1eadn 1\",\"1.04km\"],[\"Ch\\u00f9a An L\\u1ea1c\",\"1.04km\"],[\"Nh\\u00e0 th\\u1edd C\\u1ea7u Kho\",\"1.08km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\"]', '[\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/1.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/2.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/3.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/4.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/5.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/6.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/7.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/8.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/9.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/10.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/11.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/12.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/13.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/14.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/15.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/16.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/17.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/18.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/19.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/20.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/21.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/22.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/23.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/24.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/25.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/26.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/27.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/28.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/29.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/30.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/31.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/32.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/33.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/34.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/35.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/36.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/37.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/38.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/39.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/40.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/41.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/42.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/43.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/44.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/45.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/46.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/47.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/48.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/49.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/50.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/51.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/52.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/53.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/54.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/55.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/56.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/57.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/58.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/59.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/60.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/61.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/62.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/63.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/64.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/65.png\",\".\\/images\\/Hotel\\/khach-san-nikko-sai-gon\\/66.png\"]'),
('MAKHACHSAN5_1', 'KHUVUC5', 'Khách Sạn Novotel Nha Trang', '50 Trần Phú, Phường Lộc Thọ, Nha Trang, Khánh Hòa', 'Khách Sạn Novotel Nha Trang có thiết kế thanh lịch, hiện đại ở hướng ra vịnh Nha Trang và biển. Đầy đủ tiện nghi, không gian ấm cúng và yên tĩnh. Đội ngũ nhân viên khách sạn phục vụ thân thiện và nhiệt tình.', '[[\"D\\u1ed1c L\\u1ebft\",\"0.08km\"],[\"H\\u00f2n H\\u00e8o\",\"0.08km\"],[\"Su\\u1ed1i Hoa Lan\",\"0.84km\"],[\"Khu Du L\\u1ecbch Nha Trang x\\u01b0a\",\"0.84km\"],[\"S\\u00e2n bay Nha Trang\",\"1.24km\"],[\"Nh\\u00e0 th\\u1edd \\u0110\\u00e1\",\"1.35km\"],[\"Ch\\u00f9a Ngh\\u0129a Ph\\u01b0\\u01a1ng\",\"1.43km\"],[\"Vi\\u1ec7n Pasteur Nha Trang\",\"1.57km\"],[\"Ch\\u00f9a H\\u1ed9i Ph\\u01b0\\u1edbc Kh\\u00e1nh H\\u00f2a\",\"1.67km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe\",\"C\\u1eeda h\\u00e0ng l\\u01b0u ni\\u1ec7m\",\"Ph\\u00f2ng h\\u1ed9i th\\u1ea3o\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"Nh\\u00e0 h\\u00e0ng\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"Spa\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"Ph\\u00f2ng x\\u00f4ng h\\u01a1i \\u01b0\\u1edbt\",\"Ph\\u00f2ng gym\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"Ti\\u1ec7n nghi cho ng\\u01b0\\u1eddi khuy\\u1ebft t\\u1eadt\",\"Khu v\\u1ef1c h\\u00fat thu\\u1ed1c\",\"D\\u1ecbch v\\u1ee5 tr\\u00f4ng tr\\u1ebb\"]', '[\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/1.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/2.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/3.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/4.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/5.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/6.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/7.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/8.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/9.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/10.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/11.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/12.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/13.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/14.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/15.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/16.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/17.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/18.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/19.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/20.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/21.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/22.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/23.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/24.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/25.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/26.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/27.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/28.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/29.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/30.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/31.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/32.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/33.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/34.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/35.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/36.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/37.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/38.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/39.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/40.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/41.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/42.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/43.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/44.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/45.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/46.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/47.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/48.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/49.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/50.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/51.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/52.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/53.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/54.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/55.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/56.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/57.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/58.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/59.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/60.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/61.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/62.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/63.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/64.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/65.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/66.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/67.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/68.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/69.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/70.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/71.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/72.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/73.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/74.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/75.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/76.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/77.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/78.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/79.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/80.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/81.png\",\".\\/images\\/Hotel\\/khach-san-novotel-nha-trang\\/82.png\"]');
INSERT INTO `khachsan` (`maKhachSan`, `maKhuVuc`, `tenKhachSan`, `diaChi_KS`, `Review`, `diemDen`, `tienNghi`, `anhReview`) VALUES
('MAKHACHSAN6_1', 'KHUVUC6', 'Novela Resort &amp; Spa Mũi Né', '96A Nguyễn Đình Chiểu, Hàm Tiến, Phan Thiết, Bình Thuận', 'Novela Resort &amp; Spa Mũi Né có đội ngũ nhân viên được đào tạo chuyên nghiệp và phục vụ tận tình. Đầy đủ tiện nghi, phòng thoáng mát, sạch sẽ. Trang thiết bị hiện đại và được bài trí sang trọng, ấm cúng.', '[[\"S\\u00e0i G\\u00f2n - M\\u0169i N\\u00e9 Resort\",\"1.13km\"],[\"Blue Ocean Resort\",\"1.38km\"],[\"H\\u00e0m Ti\\u1ebfn\",\"1.76km\"],[\"Seahorse Resort &amp; Spa\",\"2.49km\"],[\"L\\u00e0ng Th\\u1ee5y S\\u0129\",\"2.68km\"],[\"Anantara Resort &amp; Spa\",\"2.69km\"],[\"R\\u1eb7ng d\\u1eeba H\\u00e0m Ti\\u1ebfn\",\"3.17km\"],[\"B\\u00e3i \\u0111\\u00e1 \\u00d4ng \\u0110\\u1ecba\",\"3.59km\"],[\"Khu du l\\u1ecbch g\\u00f4n Sea Links\",\"3.61km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"B\\u00e3i \\u0111\\u1ed7 xe\",\"C\\u1eeda h\\u00e0ng l\\u01b0u ni\\u1ec7m\",\"Ph\\u00f2ng h\\u1ed9i th\\u1ea3o\",\"Ph\\u00f2ng h\\u1ecdp\",\"Salon\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Karaoke\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"Spa\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Ph\\u00f2ng gia \\u0111\\u00ecnh\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"Ph\\u00f2ng x\\u00f4ng h\\u01a1i \\u01b0\\u1edbt\",\"Ph\\u00f2ng gym\",\"B\\u00e3i t\\u1eafm ri\\u00eang\",\"Ph\\u1ee5c v\\u1ee5 \\u0111\\u1ed3 \\u0103n t\\u1ea1i ph\\u00f2ng\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"K\\u00e9t an to\\u00e0n\",\"\\u0110\\u1eb7t v\\u00e9 xe\\/m\\u00e1y bay\",\"Gi\\u1eef h\\u00e0nh l\\u00fd\",\"Ti\\u1ec7n nghi cho ng\\u01b0\\u1eddi khuy\\u1ebft t\\u1eadt\",\"Khu v\\u1ef1c h\\u00fat thu\\u1ed1c\"]', '[\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/1.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/2.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/3.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/4.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/5.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/6.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/7.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/8.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/9.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/10.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/11.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/12.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/13.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/14.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/15.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/16.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/17.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/18.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/19.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/20.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/21.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/22.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/23.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/24.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/25.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/26.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/27.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/28.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/29.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/30.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/31.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/32.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/33.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/34.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/35.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/36.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/37.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/38.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/39.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/40.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/41.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/42.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/43.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/44.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/45.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/46.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/47.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/48.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/49.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/50.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/51.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/52.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/53.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/54.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/55.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/56.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/57.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/58.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/59.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/60.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/61.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/62.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/63.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/64.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/65.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/66.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/67.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/68.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/69.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/70.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/71.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/72.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/73.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/74.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/75.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/76.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/77.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/78.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/79.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/80.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/81.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/82.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/83.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/84.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/85.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/86.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/87.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/88.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/89.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/90.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/91.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/92.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/93.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/94.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/95.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/96.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/97.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/98.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/99.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/100.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/101.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/102.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/103.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/104.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/105.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/106.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/107.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/108.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/109.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/110.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/111.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/112.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/113.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/114.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/115.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/116.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/117.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/118.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/119.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/120.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/121.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/122.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/123.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/124.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/125.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/126.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/127.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/128.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/129.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/130.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/131.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/132.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/133.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/134.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/135.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/136.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/137.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/138.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/139.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/140.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/141.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/142.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/143.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/144.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/145.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/146.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/147.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/148.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/149.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/150.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/151.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/152.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/153.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/154.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/155.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/156.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/157.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/158.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/159.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/160.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/161.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/162.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/163.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/164.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/165.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/166.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/167.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/168.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/169.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/170.png\",\".\\/images\\/Hotel\\/novela-resort-spa-mui-ne\\/171.png\"]'),
('MAKHACHSAN7_1', 'KHUVUC7', 'Khách sạn Golden Lotus Luxury', '53-55 Hàng Trống, Hoàn Kiếm, Hà Nội', 'Golden Lotus Luxury Hotel tọa lạc ở một vị trí thuận tiện cách Hồ Hoàn Kiếm nổi tiếng trong vòng 5 phút đi bộ. Khách sạn có lễ tân 24 giờ và các phòng nghỉ rộng rãi với lối trang trí hiện đại. Tại đây còn có Wi-Fi miễn phí, spa và hồ bơi trong nhà trên tầng mái.', '[[\"Ph\\u1ed1 H\\u00e0ng Tr\\u1ed1ng\",\"0.13km\"],[\"Nh\\u00e0 th\\u1edd l\\u1edbn H\\u00e0 N\\u1ed9i\",\"0.16km\"],[\"Ch\\u00f9a Linh Quang - H\\u00e0 N\\u1ed9i\",\"0.17km\"],[\"Ph\\u1ed1 H\\u00e0ng Gai\",\"0.17km\"],[\"Ph\\u1ed1 L\\u01b0\\u01a1ng V\\u0103n Can\",\"0.24km\"],[\"\\u0110\\u1ec1n Ng\\u1ecdc S\\u01a1n\",\"0.26km\"],[\"Ph\\u1ed1 H\\u00e0ng H\\u00f2m\",\"0.27km\"],[\"H\\u1ed3 G\\u01b0\\u01a1m\",\"0.29km\"],[\"Ph\\u1ed1 H\\u00e0ng M\\u00e0nh\",\"0.30km\"]]', '[\"B\\u00e3i \\u0111\\u1ed7 xe\",\"Ph\\u00f2ng h\\u1ecdp\",\"Thang m\\u00e1y\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Ph\\u00f2ng gia \\u0111\\u00ecnh\",\"Internet c\\u00f3 d\\u00e2y\",\"\\u0110\\u01b0a \\u0111\\u00f3n s\\u00e2n bay\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"H\\u1ed3 b\\u01a1i trong nh\\u00e0\",\"Khu v\\u1ef1c h\\u00fat thu\\u1ed1c\",\"D\\u1ecbch v\\u1ee5 tr\\u00f4ng tr\\u1ebb\"]', '[\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/1.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/2.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/3.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/4.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/5.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/6.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/7.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/8.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/9.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/10.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/11.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/12.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/13.png\",\".\\/images\\/Hotel\\/khach-san-golden-lotus-luxury\\/14.png\"]'),
('MAKHACHSAN8_1', 'KHUVUC8', 'La Mer Resort Phú Quốc', '118/2/6 Trần Hưng Đạo, Dương Đông, Phú Quốc, Kiên Giang', 'La Mer Resort Phú Quốc tọa lạc giữa khung cảnh nhiệt đới và cung cấp các bungalow được bài trí đơn giản. Tất cả bungalow đều có sàn lát gạch và đồ nội thất gỗ, các tiện nghi nơi đây sẽ làm hài lòng du khách.', '[[\"Ch\\u00f9a H\\u00f9ng Long\\/ S\\u00f9ng H\\u01b0ng c\\u1ed5 t\\u1ef1\",\"2.21km\"],[\"Ch\\u1ee3 \\u0111\\u00eam Dinh C\\u1eadu\",\"2.38km\"],[\"Dinh C\\u1eadu\",\"2.49km\"],[\"C\\u01a1 s\\u1edf s\\u1ea3n xu\\u1ea5t n\\u01b0\\u1edbc m\\u1eafm Ph\\u00fa Qu\\u1ed1c\",\"2.61km\"],[\"Dinh C\\u1eadu\",\"2.64km\"],[\"Nh\\u00e0 Th\\u00f9ng\",\"2.77km\"],[\"Ch\\u1ee3 D\\u01b0\\u01a1ng \\u0110\\u00f4ng\",\"2.81km\"],[\"Th\\u1ecb tr\\u1ea5n D\\u01b0\\u01a1ng \\u0110\\u00f4ng\",\"3.34km\"],[\"C\\u1ea3ng h\\u00e0ng kh\\u00f4ng qu\\u1ed1c t\\u1ebf Ph\\u00fa Qu\\u1ed1c\",\"4.44km\"]]', '[\"H\\u1ed3 b\\u01a1i ngo\\u00e0i tr\\u1eddi\",\"Truy\\u1ec1n h\\u00ecnh c\\u00e1p\\/v\\u1ec7 tinh\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"H\\u1ed7 tr\\u1ee3 \\u0111\\u1eb7t tour\",\"Nh\\u00e0 h\\u00e0ng\",\"T\\u1eafm n\\u01b0\\u1edbc n\\u00f3ng\",\"Ph\\u00f2ng gia \\u0111\\u00ecnh\",\"Internet c\\u00f3 d\\u00e2y\",\"Taxi\\/Cho thu\\u00ea xe h\\u01a1i\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\",\"Thu \\u0111\\u1ed5i ngo\\u1ea1i t\\u1ec7\",\"\\u0110\\u1eb7t v\\u00e9 xe\\/m\\u00e1y bay\",\"Khu v\\u1ef1c h\\u00fat thu\\u1ed1c\"]', '[\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/1.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/2.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/3.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/4.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/5.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/6.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/7.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/8.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/9.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/10.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/11.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/12.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/13.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/14.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/15.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/16.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/17.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/18.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/19.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/20.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/21.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/22.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/23.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/24.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/25.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/26.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/27.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/28.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/29.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/30.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/31.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/32.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/33.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/34.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/35.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/36.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/37.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/38.png\",\".\\/images\\/Hotel\\/la-mer-resort-phu-quoc\\/39.png\"]'),
('MAKHACHSAN9_1', 'KHUVUC9', 'Sapa Jade Hill Resort &amp; Spa', 'Nhà biệt thự presidential, khu du lịch nghỉ dưỡng cao cấp Cầu Mây, Thôn Lý, SaPa, Lào Cai', 'Nằm cáchtrung tâm thị trấn Sapa chưa đầy 2km và nằm trên trục giao thông du lịch chính chính của Sapa, Sapa Jade Hill Resort đủ gần để du khách có thể dễ dàng di chuyển tới trung tâm thị trấn cũng như tất cả các điểm du lịch sapa nổi tiếng như bản Cát Cát, bản Tả Van, cáp treo Phanxipang,.. Sapa Jade Hill Resort cũng đủ xa để giữ sự yên tĩnh, trong lành của một khu biệt thự nghỉ dưỡng cao cấp. Các căn biệt thự và Bungalow của Sapa Jade Hill có ban công hướng ôm trọn thung lũng Mường Hoa, một trong những góc view đẹp và lý tưởng nhất ở Sapa.', '[[\"Khu du l\\u1ecbch H\\u00e0m R\\u1ed3ng\",\"1.55km\"],[\"\\u0110\\u1ec9nh S\\u00e2n M\\u00e2y\",\"1.95km\"],[\"Th\\u1ecb tr\\u1ea5n Sapa\",\"1.95km\"],[\"Tr\\u1ea1i nu\\u00f4i c\\u00e1 h\\u1ed3i\",\"1.95km\"],[\"Nh\\u00e0 th\\u1edd \\u0110\\u00e1 Sapa\",\"1.95km\"],[\"B\\u1ea3n C\\u00e1t C\\u00e1t\",\"2.22km\"],[\"Th\\u00e1c Th\\u1ee7y \\u0110i\\u1ec7n\",\"2.53km\"],[\"N\\u00fai H\\u00e0m R\\u1ed3ng\",\"3.24km\"],[\"Hang \\u0111\\u1ed9ng T\\u1ea3 Ph\\u00ecn\",\"3.24km\"]]', '[\"B\\u00e3i \\u0111\\u1ed7 xe mi\\u1ec5n ph\\u00ed\",\"C\\u1eeda h\\u00e0ng l\\u01b0u ni\\u1ec7m\",\"Wifi mi\\u1ec5n ph\\u00ed\",\"Gi\\u1eb7t l\\u00e0\",\"Nh\\u00e0 h\\u00e0ng\",\"Qu\\u00e1n cafe\",\"L\\u1ec5 t\\u00e2n 24\\/24\",\"Massage\",\"Ph\\u1ee5c v\\u1ee5 \\u0111\\u1ed3 \\u0103n t\\u1ea1i ph\\u00f2ng\",\"D\\u1ecdn ph\\u00f2ng h\\u00e0ng ng\\u00e0y\",\"K\\u00e9t an to\\u00e0n\"]', '[\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/1.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/2.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/3.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/4.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/5.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/6.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/7.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/8.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/9.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/10.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/11.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/12.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/13.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/14.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/15.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/16.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/17.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/18.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/19.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/20.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/21.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/22.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/23.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/24.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/25.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/26.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/27.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/28.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/29.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/30.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/31.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/32.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/33.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/34.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/35.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/36.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/37.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/38.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/39.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/40.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/41.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/42.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/43.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/44.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/45.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/46.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/47.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/48.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/49.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/50.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/51.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/52.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/53.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/54.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/55.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/56.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/57.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/58.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/59.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/60.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/61.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/62.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/63.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/64.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/65.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/66.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/67.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/68.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/69.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/70.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/71.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/72.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/73.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/74.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/75.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/76.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/77.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/78.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/79.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/80.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/81.png\",\".\\/images\\/Hotel\\/sapa-jade-hill-resort-spa\\/82.png\"]');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachtruycap`
--

CREATE TABLE `khachtruycap` (
  `diaChi_IP` varchar(15) COLLATE utf8_vietnamese_ci NOT NULL,
  `maTruyCap` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `STT` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Bẫy `khachtruycap`
--
DELIMITER $$
CREATE TRIGGER `check_KTC` BEFORE DELETE ON `khachtruycap` FOR EACH ROW BEGIN
DELETE FROM dangnhap WHERE dangnhap.maTruyCap = OLD.maTruyCap;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khuvuc`
--

CREATE TABLE `khuvuc` (
  `maKhuVuc` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `tenKhuVuc` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `khuvuc`
--

INSERT INTO `khuvuc` (`maKhuVuc`, `tenKhuVuc`) VALUES
('KHUVUC1', 'Đà Nẵng'),
('KHUVUC10', 'Hội An'),
('KHUVUC11', 'Hạ Long'),
('KHUVUC12', 'Huế'),
('KHUVUC2', 'Bà Rịa - Vũng Tàu'),
('KHUVUC3', 'Đà Lạt'),
('KHUVUC4', 'Hồ Chí Minh'),
('KHUVUC5', 'Nha Trang'),
('KHUVUC6', 'Phan Thiết'),
('KHUVUC7', 'Hà Nội'),
('KHUVUC8', 'Phú Quốc'),
('KHUVUC9', 'SaPa');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `loaiphong`
--

CREATE TABLE `loaiphong` (
  `maLoaiPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `moTa` longtext COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `dienTich` int(11) DEFAULT NULL,
  `phongConLai` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `loaiphong`
--

INSERT INTO `loaiphong` (`maLoaiPhong`, `moTa`, `dienTich`, `phongConLai`) VALUES
('LOAIPHONG1_1_1', '{\"ten\":\"Superior King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-king\\/3.png\"],\"productContent\":[\"Kh\\u00f4ng c\\u1eeda s\\u1ed5\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"56\",\"giaGoc\":\"1515000\",\"giaGiam\":666600,\"soPhong\":22,\"choPhep\":true}', 26, 22),
('LOAIPHONG1_1_2', '{\"ten\":\"Superior  Twin\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-twin\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-twin\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-twin\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-twin\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-twin\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"56\",\"giaGoc\":\"1515000\",\"giaGiam\":666600,\"soPhong\":11,\"choPhep\":true}', 26, 11),
('LOAIPHONG1_1_3', '{\"ten\":\"Deluxe King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-king\\/7.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"57\",\"giaGoc\":\"1934000\",\"giaGiam\":831620,\"soPhong\":12,\"choPhep\":true}', 32, 12),
('LOAIPHONG1_1_4', '{\"ten\":\"Superior Triple\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-triple\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-triple\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-triple\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-triple\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/superior-triple\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 3 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"57\",\"giaGoc\":\"1934000\",\"giaGiam\":831620,\"soPhong\":6,\"choPhep\":true}', 28, 6),
('LOAIPHONG1_1_5', '{\"ten\":\"Deluxe Queen\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-queen\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"57\",\"giaGoc\":\"1934000\",\"giaGiam\":831620,\"soPhong\":11,\"choPhep\":true}', 30, 11),
('LOAIPHONG1_1_6', '{\"ten\":\"Deluxe Triple\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-dana-marina\\/deluxe-triple\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 3 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"56\",\"giaGoc\":\"2456000\",\"giaGiam\":1080640,\"soPhong\":11,\"choPhep\":true}', 28, 11),
('LOAIPHONG10_1_1', '{\"ten\":\"Standard double room\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/3.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/4.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/5.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/6.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/7.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-double-room\\/8.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"878000\",\"giaGiam\":878000,\"soPhong\":12,\"choPhep\":true}', 23, 12),
('LOAIPHONG10_1_2', '{\"ten\":\"Standard twin room\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-twin-room\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-twin-room\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/standard-twin-room\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"878000\",\"giaGiam\":878000,\"soPhong\":3,\"choPhep\":true}', 22, 3),
('LOAIPHONG10_1_3', '{\"ten\":\"Deluxe double balcony\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-double-balcony\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-double-balcony\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-double-balcony\\/3.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-double-balcony\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng h\\u1ed3 b\\u01a1i\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1463000\",\"giaGiam\":1463000,\"soPhong\":9,\"choPhep\":true}', 40, 9),
('LOAIPHONG10_1_4', '{\"ten\":\"Deluxe twin balcony\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/3.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/4.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/5.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-twin-balcony\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng h\\u1ed3 b\\u01a1i\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1463000\",\"giaGiam\":1463000,\"soPhong\":6,\"choPhep\":true}', 40, 6),
('LOAIPHONG10_1_5', '{\"ten\":\"Deluxe triple balcony\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/3.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/4.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/5.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/deluxe-triple-balcony\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng h\\u1ed3 b\\u01a1i\",\"3 Gi\\u01b0\\u1eddng \\u0111\\u01a1n                                                                                                                                                                              \\/ 1 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 3 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1568000\",\"giaGiam\":1568000,\"soPhong\":6,\"choPhep\":true}', 35, 6),
('LOAIPHONG10_1_6', '{\"ten\":\"Ph\\u00f2ng suite\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/1.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/2.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/3.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/4.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/5.png\",\".\\/images\\/reviewPhong\\/venus-hotel-spa-hoi-an\\/phong-suite\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng h\\u1ed3 b\\u01a1i\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1672000\",\"giaGiam\":1672000,\"soPhong\":3,\"choPhep\":true}', 40, 3),
('LOAIPHONG11_1_1', '{\"ten\":\"Ph\\u00f2ng Superior 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n (Mi\\u1ec5n Ph\\u00ed N\\u00e2ng H\\u1ea1ng Ph\\u00f2ng \\u0110\\u1ebfn 31\\/3)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-superior-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-superior-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-superior-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"50\",\"giaGoc\":\"1829000\",\"giaGiam\":914500,\"soPhong\":5,\"choPhep\":true}', 38, 5),
('LOAIPHONG11_1_2', '{\"ten\":\"Combo 2 \\u0111\\u00eam Ph\\u00f2ng Superior 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i Ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n + 1 B\\u1eefa T\\u1ed1i v\\u00e0 2 B\\u1eefa S\\u00e1ng (Half Board 2\\u0110)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-2-dem-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-2-bua-sang-half-board-2d\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-2-dem-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-2-bua-sang-half-board-2d\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-2-dem-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-2-bua-sang-half-board-2d\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-2-dem-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-2-bua-sang-half-board-2d\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-2-dem-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-2-bua-sang-half-board-2d\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n                                                                                                                                                                              \\/ 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1302000\",\"giaGiam\":1302000,\"soPhong\":5,\"choPhep\":true}', 38, 5),
('LOAIPHONG11_1_3', '{\"ten\":\"Ph\\u00f2ng Deluxe 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i Ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n (Mi\\u1ec5n Ph\\u00ed N\\u00e2ng H\\u1ea1ng Ph\\u00f2ng \\u0110\\u1ebfn 31\\/3)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/7.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-deluxe-1-giuong-doi-hoac-2-giuong-don-mien-phi-nang-hang-phong-den-31-3\\/8.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"50\",\"giaGoc\":\"2195000\",\"giaGiam\":1097500,\"soPhong\":12,\"choPhep\":true}', 42, 12),
('LOAIPHONG11_1_4', '{\"ten\":\"Combo Ph\\u00f2ng Superior 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i Ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n + 1 B\\u1eefa T\\u1ed1i  v\\u00e0 1 B\\u1eefa S\\u00e1ng (Half Board 1 \\u0110\\u00eam)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-1-bua-sang-half-board-1-dem\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-1-bua-sang-half-board-1-dem\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/combo-phong-superior-1-giuong-doi-hoac-2-giuong-don-1-bua-toi-va-1-bua-sang-half-board-1-dem\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n                                                                                                                                                                              \\/ 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1576000\",\"giaGiam\":1576000,\"soPhong\":5,\"choPhep\":true}', 38, 5),
('LOAIPHONG11_1_5', '{\"ten\":\"Ph\\u00f2ng Junior Suite 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-junior-suite-1-giuong-doi-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-junior-suite-1-giuong-doi-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-junior-suite-1-giuong-doi-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-junior-suite-1-giuong-doi-huong-bien\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"50\",\"giaGoc\":\"4704000\",\"giaGiam\":2352000,\"soPhong\":5,\"choPhep\":true}', 78, 5),
('LOAIPHONG11_1_6', '{\"ten\":\"Ph\\u00f2ng Executive Suite 1 Gi\\u01b0\\u1eddng \\u0110\\u00f4i H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-executive-suite-1-giuong-doi-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-executive-suite-1-giuong-doi-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-executive-suite-1-giuong-doi-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-executive-suite-1-giuong-doi-huong-bien\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-ha-long-plaza\\/phong-executive-suite-1-giuong-doi-huong-bien\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"50\",\"giaGoc\":\"5227000\",\"giaGiam\":2613500,\"soPhong\":7,\"choPhep\":true}', 102, 7),
('LOAIPHONG12_1_1', '{\"ten\":\"Colonial Deluxe\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-deluxe\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-deluxe\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-deluxe\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng h\\u1ed3 b\\u01a1i\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"1987000\",\"giaGiam\":1987000,\"soPhong\":6,\"choPhep\":true}', 40, 6),
('LOAIPHONG12_1_2', '{\"ten\":\"Premium City Deluxe\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-city-deluxe\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-city-deluxe\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-city-deluxe\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-city-deluxe\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2193000\",\"giaGiam\":2193000,\"soPhong\":5,\"choPhep\":true}', 50, 5),
('LOAIPHONG12_1_3', '{\"ten\":\"Premium River Deluxe\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-river-deluxe\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-river-deluxe\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-river-deluxe\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/premium-river-deluxe\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2399000\",\"giaGiam\":2399000,\"soPhong\":5,\"choPhep\":true}', 50, 5),
('LOAIPHONG12_1_4', '{\"ten\":\"Colonial Suite\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-suite\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-suite\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-suite\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/colonial-suite\\/4.png\"],\"productContent\":[\"Kh\\u00f4ng c\\u1eeda s\\u1ed5\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"3015000\",\"giaGiam\":3015000,\"soPhong\":3,\"choPhep\":true}', 60, 3),
('LOAIPHONG12_1_5', '{\"ten\":\"Morin Suite\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/morin-suite\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/morin-suite\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/morin-suite\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/morin-suite\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"4524000\",\"giaGiam\":4524000,\"soPhong\":3,\"choPhep\":true}', 100, 3),
('LOAIPHONG12_1_6', '{\"ten\":\"Executive Suite\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/executive-suite\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/executive-suite\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/executive-suite\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-sai-gon-morin\\/executive-suite\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 04\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"6169000\",\"giaGiam\":6169000,\"soPhong\":2,\"choPhep\":true}', 120, 2),
('LOAIPHONG2_1_1', '{\"ten\":\"Ph\\u00f2ng Superior 1 Gi\\u01b0\\u1eddng L\\u1edbn H\\u01b0\\u1edbng Ph\\u1ed1\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-superior-1-giuong-lon-huong-pho\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-superior-1-giuong-lon-huong-pho\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-superior-1-giuong-lon-huong-pho\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-superior-1-giuong-lon-huong-pho\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2138000\",\"giaGiam\":2138000,\"soPhong\":5,\"choPhep\":true}', 25, 5),
('LOAIPHONG2_1_2', '{\"ten\":\"Ph\\u00f2ng Deluxe 1 Gi\\u01b0\\u1eddng L\\u1edbn Ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n  H\\u01b0\\u1edbng Ph\\u1ed1\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/7.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-deluxe-1-giuong-lon-hoac-2-giuong-don-huong-pho\\/8.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2385000\",\"giaGiam\":2385000,\"soPhong\":5,\"choPhep\":true}', 32, 5),
('LOAIPHONG2_1_3', '{\"ten\":\"Ph\\u00f2ng Premium 1 Gi\\u01b0\\u1eddng L\\u1edbn Ho\\u1eb7c 2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n Ban C\\u00f4ng H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premium-1-giuong-lon-hoac-2-giuong-don-ban-cong-huong-bien\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2632000\",\"giaGiam\":2632000,\"soPhong\":5,\"choPhep\":true}', 32, 5),
('LOAIPHONG2_1_4', '{\"ten\":\"Ph\\u00f2ng Premier Executive 1 Gi\\u01b0\\u1eddng L\\u1edbn Ban C\\u00f4ng H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premier-executive-1-giuong-lon-ban-cong-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premier-executive-1-giuong-lon-ban-cong-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-premier-executive-1-giuong-lon-ban-cong-huong-bien\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2878000\",\"giaGiam\":2878000,\"soPhong\":5,\"choPhep\":true}', 37, 5),
('LOAIPHONG2_1_5', '{\"ten\":\"Ph\\u00f2ng Executive Suite 1 Gi\\u01b0\\u1eddng L\\u1edbn Ban C\\u00f4ng H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-executive-suite-1-giuong-lon-ban-cong-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-executive-suite-1-giuong-lon-ban-cong-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-executive-suite-1-giuong-lon-ban-cong-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-executive-suite-1-giuong-lon-ban-cong-huong-bien\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-executive-suite-1-giuong-lon-ban-cong-huong-bien\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"3290000\",\"giaGiam\":3290000,\"soPhong\":3,\"choPhep\":true}', 65, 3),
('LOAIPHONG2_1_6', '{\"ten\":\"Ph\\u00f2ng Royal Family H\\u01b0\\u1edbng Ph\\u1ed1\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-royal-family-huong-pho\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-royal-family-huong-pho\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-royal-family-huong-pho\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-cao-vung-tau\\/phong-royal-family-huong-pho\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 4 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 02\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"4112000\",\"giaGiam\":4112000,\"soPhong\":3,\"choPhep\":true}', 64, 3),
('LOAIPHONG3_1_1', '{\"ten\":\"Ph\\u00f2ng Deluxe double\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-ttc-hotel-ngoc-lan\\/phong-deluxe-double\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-ttc-hotel-ngoc-lan\\/phong-deluxe-double\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-ttc-hotel-ngoc-lan\\/phong-deluxe-double\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-ttc-hotel-ngoc-lan\\/phong-deluxe-double\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1724000\",\"giaGiam\":1724000,\"soPhong\":10,\"choPhep\":true}', 36, 10),
('LOAIPHONG4_1_1', '{\"ten\":\"Deluxe King\\/Twin\\/Premium\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 1 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"3948000\",\"giaGiam\":3948000,\"soPhong\":60,\"choPhep\":true}', 40, 60),
('LOAIPHONG4_1_2', '{\"ten\":\"Deluxe King\\/Twin\\/Premium\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/deluxe-king-twin-premium\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"4277000\",\"giaGiam\":4277000,\"soPhong\":60,\"choPhep\":true}', 40, 60),
('LOAIPHONG4_1_3', '{\"ten\":\"Nikko Deluxe King\\/Twin\\/Premium King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 1 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"4935000\",\"giaGiam\":4935000,\"soPhong\":47,\"choPhep\":true}', 40, 47),
('LOAIPHONG4_1_4', '{\"ten\":\"Nikko Deluxe King\\/Twin\\/Premium King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-deluxe-king-twin-premium-king\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"5264000\",\"giaGiam\":5264000,\"soPhong\":47,\"choPhep\":true}', 40, 47),
('LOAIPHONG4_1_5', '{\"ten\":\"Nikko Junior Suite  Queen\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i l\\u1edbn\"],\"toiDaSoNguoi\":\"x 1 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"6251000\",\"giaGiam\":6251000,\"soPhong\":24,\"choPhep\":true}', 60, 24),
('LOAIPHONG4_1_6', '{\"ten\":\"Nikko Junior Suite  Queen\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-junior-suite-queen\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"6580000\",\"giaGiam\":6580000,\"soPhong\":24,\"choPhep\":true}', 60, 24),
('LOAIPHONG4_1_7', '{\"ten\":\"Nikko Executive Suite King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 1 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"7238000\",\"giaGiam\":7238000,\"soPhong\":24,\"choPhep\":true}', 69, 24),
('LOAIPHONG4_1_8', '{\"ten\":\"Nikko Executive Suite King\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-nikko-sai-gon\\/nikko-executive-suite-king\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"7567000\",\"giaGiam\":7567000,\"soPhong\":24,\"choPhep\":true}', 69, 24),
('LOAIPHONG5_1_1', '{\"ten\":\"Standard Double \\/ Twin (except Russia &amp; Greater China)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/7.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/8.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/9.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/standard-double-twin-except-russia-greater-china\\/10.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"37\",\"giaGoc\":\"3054000\",\"giaGiam\":1924020,\"soPhong\":37,\"choPhep\":true}', 32, 37),
('LOAIPHONG5_1_2', '{\"ten\":\"Superior Single\\/ Double (except Russia &amp; Greater China)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-single-double-except-russia-greater-china\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 1 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"37\",\"giaGoc\":\"3467000\",\"giaGiam\":2184210,\"soPhong\":28,\"choPhep\":true}', 32, 28),
('LOAIPHONG5_1_3', '{\"ten\":\"Superior Ocean View (except Russia &amp; Greater China)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/superior-ocean-view-except-russia-greater-china\\/7.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"37\",\"giaGoc\":\"3742000\",\"giaGiam\":2357460,\"soPhong\":5,\"choPhep\":true}', 42, 5),
('LOAIPHONG5_1_4', '{\"ten\":\"Deluxe Single\\/Double (except Russia &amp; Greater China)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/7.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/8.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/9.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/10.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/deluxe-single-double-except-russia-greater-china\\/11.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"37\",\"giaGoc\":\"4293000\",\"giaGiam\":2704590,\"soPhong\":20,\"choPhep\":true}', 48, 20),
('LOAIPHONG5_1_5', '{\"ten\":\"Executive (except Russia &amp; Greater China)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/6.png\",\".\\/images\\/reviewPhong\\/khach-san-novotel-nha-trang\\/executive-except-russia-greater-china\\/7.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":\"37\",\"giaGoc\":\"4844000\",\"giaGiam\":3051720,\"soPhong\":13,\"choPhep\":true}', 32, 13),
('LOAIPHONG6_1_1', '{\"ten\":\"Deluxe h\\u01b0\\u1edbng Ph\\u1ed1 ho\\u1eb7c h\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/deluxe-huong-pho-hoac-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/deluxe-huong-pho-hoac-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/deluxe-huong-pho-hoac-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/deluxe-huong-pho-hoac-huong-bien\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"1466000\",\"giaGiam\":1466000,\"soPhong\":34,\"choPhep\":true}', 40, 34),
('LOAIPHONG6_1_2', '{\"ten\":\"Senior Deluxe H\\u01b0\\u1edbng Ph\\u1ed1 Ho\\u1eb7c H\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/senior-deluxe-huong-pho-hoac-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/senior-deluxe-huong-pho-hoac-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/senior-deluxe-huong-pho-hoac-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/senior-deluxe-huong-pho-hoac-huong-bien\\/4.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/senior-deluxe-huong-pho-hoac-huong-bien\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng bi\\u1ec3n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"1763000\",\"giaGiam\":1763000,\"soPhong\":45,\"choPhep\":true}', 40, 45),
('LOAIPHONG6_1_3', '{\"ten\":\"Novela Suite h\\u01b0\\u1edbng Ph\\u1ed1 ho\\u1eb7c h\\u01b0\\u1edbng Bi\\u1ec3n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/1.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/2.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/3.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/4.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/5.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/6.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/7.png\",\".\\/images\\/reviewPhong\\/novela-resort-spa-mui-ne\\/novela-suite-huong-pho-hoac-huong-bien\\/8.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 18\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"2061000\",\"giaGiam\":2061000,\"soPhong\":8,\"choPhep\":true}', 70, 8);
INSERT INTO `loaiphong` (`maLoaiPhong`, `moTa`, `dienTich`, `phongConLai`) VALUES
('LOAIPHONG7_1_1', '{\"ten\":\"Lotus Deluxe Gi\\u01b0\\u1eddng \\u0110\\u00f4i\\/2 Gi\\u01b0\\u1eddng \\u0110\\u01a1n\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-deluxe-giuong-doi-2-giuong-don\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-deluxe-giuong-doi-2-giuong-don\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-deluxe-giuong-doi-2-giuong-don\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-deluxe-giuong-doi-2-giuong-don\\/4.png\"],\"productContent\":[\"Kh\\u00f4ng c\\u1eeda s\\u1ed5\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"1624000\",\"giaGiam\":1624000,\"soPhong\":10,\"choPhep\":true}', 22, 10),
('LOAIPHONG7_1_2', '{\"ten\":\"Lotus Executive gi\\u01b0\\u1eddng \\u0111\\u00f4i\\/2 gi\\u01b0\\u1eddng \\u0111\\u01a1n h\\u01b0\\u1edbng ph\\u1ed1\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-executive-giuong-doi-2-giuong-don-huong-pho\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-executive-giuong-doi-2-giuong-don-huong-pho\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/lotus-executive-giuong-doi-2-giuong-don-huong-pho\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"1782000\",\"giaGiam\":1782000,\"soPhong\":5,\"choPhep\":true}', 22, 5),
('LOAIPHONG7_1_3', '{\"ten\":\"Junior Suite c\\u00f3 ban c\\u00f4ng h\\u01b0\\u1edbng ph\\u1ed1\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/5.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/junior-suite-co-ban-cong-huong-pho\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"3898000\",\"giaGiam\":3898000,\"soPhong\":1,\"choPhep\":true}', 45, 1),
('LOAIPHONG7_1_4', '{\"ten\":\"Luxury Suite c\\u00f3 Ph\\u00f2ng Sinh ho\\u1ea1t v\\u00e0 Gh\\u1ebf sofa, ban c\\u00f4ng\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/luxury-suite-co-phong-sinh-hoat-va-ghe-sofa-ban-cong\\/1.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/luxury-suite-co-phong-sinh-hoat-va-ghe-sofa-ban-cong\\/2.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/luxury-suite-co-phong-sinh-hoat-va-ghe-sofa-ban-cong\\/3.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/luxury-suite-co-phong-sinh-hoat-va-ghe-sofa-ban-cong\\/4.png\",\".\\/images\\/reviewPhong\\/khach-san-golden-lotus-luxury\\/luxury-suite-co-phong-sinh-hoat-va-ghe-sofa-ban-cong\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng ph\\u1ed1\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\",\"Xem chi ti\\u1ebft\",\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 06\\/06\\/2020\"],\"uuDai\":0,\"giaGoc\":\"4548000\",\"giaGiam\":4548000,\"soPhong\":1,\"choPhep\":true}', 45, 1),
('LOAIPHONG8_1_1', '{\"ten\":\"Standard Garden\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/standard-garden\\/1.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/standard-garden\\/2.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/standard-garden\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng v\\u01b0\\u1eddn\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"959000\",\"giaGiam\":959000,\"soPhong\":7,\"choPhep\":true}', 32, 7),
('LOAIPHONG8_1_2', '{\"ten\":\"Superior Bungalow\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/superior-bungalow\\/1.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/superior-bungalow\\/2.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/superior-bungalow\\/3.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/superior-bungalow\\/4.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/superior-bungalow\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng v\\u01b0\\u1eddn\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1028000\",\"giaGiam\":1028000,\"soPhong\":15,\"choPhep\":true}', 35, 15),
('LOAIPHONG8_1_3', '{\"ten\":\"Family Bungalow\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-bungalow\\/1.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-bungalow\\/2.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-bungalow\\/3.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-bungalow\\/4.png\"],\"productContent\":[\"H\\u01b0\\u1edbng v\\u01b0\\u1eddn\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 4 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1645000\",\"giaGiam\":1645000,\"soPhong\":10,\"choPhep\":true}', 45, 10),
('LOAIPHONG8_1_4', '{\"ten\":\"Family Two Bedroom Bungalow\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/1.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/2.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/3.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/4.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/5.png\",\".\\/images\\/reviewPhong\\/la-mer-resort-phu-quoc\\/family-two-bedroom-bungalow\\/6.png\"],\"productContent\":[\"H\\u01b0\\u1edbng v\\u01b0\\u1eddn\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n, 1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i r\\u1ea5t l\\u1edbn\"],\"toiDaSoNguoi\":\"x 4 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"Kh\\u00f4ng ho\\u00e0n h\\u1ee7y\"],\"uuDai\":0,\"giaGoc\":\"1960000\",\"giaGiam\":1960000,\"soPhong\":1,\"choPhep\":true}', 50, 1),
('LOAIPHONG9_1_1', '{\"ten\":\"Ph\\u00f2ng Deluxe Nh\\u00ecn ra Thung l\\u0169ng (Deluxe Valley View)\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/phong-deluxe-nhin-ra-thung-lung-deluxe-valley-view\\/1.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/phong-deluxe-nhin-ra-thung-lung-deluxe-valley-view\\/2.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/phong-deluxe-nhin-ra-thung-lung-deluxe-valley-view\\/3.png\"],\"productContent\":[\"H\\u01b0\\u1edbng 1 ph\\u1ea7n\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 26\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"3015000\",\"giaGiam\":3015000,\"soPhong\":14,\"choPhep\":true}', 28, 14),
('LOAIPHONG9_1_2', '{\"ten\":\"Bungalow Mountain View\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/1.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/2.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/3.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/4.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/5.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/6.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-mountain-view\\/7.png\"],\"productContent\":[\"H\\u01b0\\u1edbng n\\u00fai\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 26\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"3975000\",\"giaGiam\":3975000,\"soPhong\":20,\"choPhep\":true}', 40, 20),
('LOAIPHONG9_1_3', '{\"ten\":\"Bungalow Panorama View\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-panorama-view\\/1.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-panorama-view\\/2.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-panorama-view\\/3.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-panorama-view\\/4.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/bungalow-panorama-view\\/5.png\"],\"productContent\":[\"H\\u01b0\\u1edbng n\\u00fai\",\"1 Gi\\u01b0\\u1eddng \\u0111\\u00f4i                                                                                                                                                                              \\/ 2 Gi\\u01b0\\u1eddng \\u0111\\u01a1n\"],\"toiDaSoNguoi\":\"x 2 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 26\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"4798000\",\"giaGiam\":4798000,\"soPhong\":38,\"choPhep\":true}', 40, 38),
('LOAIPHONG9_1_4', '{\"ten\":\"Duplex Villa Garden View\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/1.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/2.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/3.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/4.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/5.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/6.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/7.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-garden-view\\/8.png\"],\"productContent\":[\"H\\u01b0\\u1edbng n\\u00fai\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 4 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 26\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"6306000\",\"giaGiam\":6306000,\"soPhong\":6,\"choPhep\":true}', 90, 6),
('LOAIPHONG9_1_5', '{\"ten\":\"Duplex Villa Valley View\",\"srcHinh\":[\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/1.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/2.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/3.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/4.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/5.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/6.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/7.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/8.png\",\".\\/images\\/reviewPhong\\/sapa-jade-hill-resort-spa\\/duplex-villa-valley-view\\/9.png\"],\"productContent\":[\"H\\u01b0\\u1edbng n\\u00fai\",\"2 Gi\\u01b0\\u1eddng \\u0111\\u00f4i\"],\"toiDaSoNguoi\":\"x 4 ng\\u01b0\\u1eddi\",\"tuyChon\":[\"Bao g\\u1ed3m B\\u1eefa s\\u00e1ng\",\"H\\u1ee7y mi\\u1ec5n ph\\u00ed \\u0111\\u1ebfn 26\\/05\\/2020\"],\"uuDai\":0,\"giaGoc\":\"7128000\",\"giaGiam\":7128000,\"soPhong\":13,\"choPhep\":true}', 90, 13);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nddatphong`
--

CREATE TABLE `nddatphong` (
  `maSo_ND` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `ngayDat` datetime NOT NULL DEFAULT current_timestamp(),
  `thoiGianBatDau` datetime DEFAULT NULL,
  `thoiGianKetThuc` datetime DEFAULT NULL,
  `tongChiPhi` int(11) DEFAULT NULL,
  `tuyChon` varchar(100) COLLATE utf8_vietnamese_ci NOT NULL DEFAULT '',
  `hinhThuc` varchar(20) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `email_2` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `SDT_2` char(10) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `hoTen_2` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `tinhThanhPho_2` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Bẫy `nddatphong`
--
DELIMITER $$
CREATE TRIGGER `ND_datPhong` AFTER INSERT ON `nddatphong` FOR EACH ROW BEGIN
	DECLARE makhachhang INT;
    #DECLARE hoTen CHARACTER(100);
    #DECLARE email CHARACTER(100);
    #DECLARE SDT NUMERIC;
    #DECLARE tinhThanhPho CHARACTER(100);
    DECLARE repeatKH CHAR(4);
    DECLARE repeatHD CHAR(4);
    DECLARE makhachsan char(20);
    DECLARE maloaiphong char(20);
    DECLARE maHD char(20);
    DECLARE masoKH char(20);
    
    UPDATE phong SET phong.conTrong = phong.conTrong- 1 
    WHERE phong.maPhong = NEW.maPhong;
    
    UPDATE loaiphong SET loaiphong.phongConLai= loaiphong.phongConLai-1
    WHERE loaiphong.maLoaiPhong = (SELECT phong.maLoaiPhong FROM phong WHERE phong.maPhong=NEW.maPhong);
   
    IF ((SELECT COUNT(maSo_KH) FROM khachhang) = 0)
    THEN
    SET makhachhang = 1;
    ELSE
    SET makhachhang = (SELECT MAX(CONVERT(RIGHT(khachhang.maSo_KH, 4), INT)) FROM khachhang)+1;
    END IF;
    SET repeatKH = (SELECT REPEAT('0', 4- CHAR_LENGTH(CONVERT(makhachhang, CHARACTER))));
    
    #SET hoTen = (SELECT hoTen_ND FROM nguoidung WHERE nguoidung.maSo_ND=NEW.maSo_ND);
    #SET email = (SELECT email_ND FROM nguoidung WHERE nguoidung.maSo_ND=NEW.maSo_ND);
    #SET SDT = (SELECT SDT_ND FROM nguoidung WHERE nguoidung.maSo_ND=NEW.maSo_ND);
    #SET tinhThanhPho = (SELECT tinhThanhPho_ND FROM nguoidung WHERE nguoidung.maSo_ND=NEW.maSo_ND);
    IF NOT EXISTS(SELECT maSo_ND FROM khachhang WHERE khachhang.maSo_ND=NEW.maSo_ND)
    THEN
    INSERT INTO khachhang(maSo_KH, maSo_ND, hoTen_KH, email_KH, SDT_KH, tinhThanhPho_KH) VALUES(CONCAT('KH', repeatKH, makhachhang), NEW.maSo_ND, NEW.hoTen_2, NEW.email_2, NEW.SDT_2, NEW.tinhThanhPho_2);
    END IF;
    
    
    
    
	IF ((SELECT COUNT(maHoaDon) FROM hoadon) = 0)
    THEN
    SET maHD = 1;
    ELSE
    SET maHD = (SELECT MAX(CONVERT(RIGHT(hoadon.maHoaDon, 4), INT)) FROM hoadon)+1;
    END IF;
    SET repeatHD = (SELECT REPEAT('0', 4-CHAR_LENGTH(CONVERT(maHD, CHARACTER))));
    
    SET makhachsan = (SELECT phong.maKhachSan FROM phong WHERE phong.maPhong = NEW.maPhong);
    
    SET maloaiphong = (SELECT phong.maLoaiPhong FROM phong WHERE phong.maPhong = NEW.maPhong);
    
    SET masoKH = (SELECT khachhang.maSo_KH FROM khachhang WHERE khachhang.maSo_ND=NEW.maSo_ND);
    
    IF EXISTS(SELECT maHoaDon FROM hoadon WHERE hoadon.ngayGiaoDich=NEW.ngayDat AND hoadon.maSo_KH=masoKH AND hoadon.maLoaiPhong=maloaiphong AND hoadon.maKhachSan= makhachsan)
    THEN
    
    
    
    UPDATE hoadon SET soLuong = soLuong+1, tongGia=((1+soLuong)*giaPhong), hoadon.thanhTien = FLOOR(((1+soLuong)*giaPhong)*1.1/1000)*1000   WHERE maHoaDon=(SELECT maHoaDon FROM hoadon WHERE hoadon.ngayGiaoDich=NEW.ngayDat AND hoadon.maSo_KH=masoKH AND hoadon.maLoaiPhong=maloaiphong AND hoadon.maKhachSan= makhachsan);
    
    ELSE
    
    
    INSERT INTO hoadon (hoadon.maHoaDon, hoadon.maSo_KH, hoadon.maKhachSan, hoadon.maLoaiPhong, hoadon.soLuong, hoadon.giaPhong, hoadon.tongGia, hoadon.ngayGiaoDich, hoadon.TG_layPhong, hoadon.TG_traPhong, hoadon.tuyChon, hoadon.hinhThucThanhToan, hoadon.thanhTien) VALUES(CONCAT('HOADON', repeatHD, maHD), masoKH, makhachsan, maloaiphong, 1, NEW.tongChiPhi, NEW.tongChiPhi, NEW.ngayDat, NEW.thoiGianBatDau, NEW.thoiGianKetThuc, NEW.tuyChon, NEW.hinhThuc, FLOOR(NEW.tongChiPhi*1.1/1000)*1000);
    END IF;
    
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ND_huyPhong` AFTER DELETE ON `nddatphong` FOR EACH ROW BEGIN
    
    UPDATE phong SET phong.conTrong = phong.conTrong + 1
    WHERE phong.maPhong = OLD.maPhong;
    
    UPDATE loaiphong SET loaiphong.phongConLai= loaiphong.phongConLai+1
    WHERE loaiphong.maLoaiPhong = (SELECT phong.maLoaiPhong
    FROM phong WHERE phong.maPhong=OLD.maPhong);
    
    UPDATE hoadon SET thanhTien=0, trangThai='Đã hủy' WHERE hoadon.maSo_KH=(SELECT maSo_KH FROM khachhang WHERE khachhang.maSo_ND=OLD.maSo_ND) AND hoadon.ngayGiaoDich=OLD.ngayDat;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung`
--

CREATE TABLE `nguoidung` (
  `maSo_ND` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `hoTen_ND` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `tenDangNhap` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `matKhau_ND` varchar(50) COLLATE utf8_vietnamese_ci NOT NULL,
  `email_ND` varchar(50) COLLATE utf8_vietnamese_ci NOT NULL,
  `SDT_ND` char(10) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `quyenQuanTri` bit(1) DEFAULT b'0',
  `diaChi_ND` varchar(100) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `tinhThanhPho_ND` varchar(50) COLLATE utf8_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung`
--

INSERT INTO `nguoidung` (`maSo_ND`, `hoTen_ND`, `tenDangNhap`, `matKhau_ND`, `email_ND`, `SDT_ND`, `quyenQuanTri`, `diaChi_ND`, `tinhThanhPho_ND`) VALUES
('ND0001', NULL, NULL, 'admin123', 'admin@gmail.com', NULL, b'1', NULL, NULL);

--
-- Bẫy `nguoidung`
--
DELIMITER $$
CREATE TRIGGER `check_ND` BEFORE DELETE ON `nguoidung` FOR EACH ROW BEGIN
	DELETE FROM dangnhap WHERE dangnhap.maSo_ND = OLD.maSo_ND;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phong`
--

CREATE TABLE `phong` (
  `maPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maLoaiPhong` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `maKhachSan` char(20) COLLATE utf8_vietnamese_ci NOT NULL,
  `conTrong` int(1) NOT NULL DEFAULT 1,
  `thoiGianDau` datetime NOT NULL DEFAULT current_timestamp(),
  `thoiGianCuoi` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `phong`
--

INSERT INTO `phong` (`maPhong`, `maLoaiPhong`, `maKhachSan`, `conTrong`, `thoiGianDau`, `thoiGianCuoi`) VALUES
('MAPHONG1_1_1_1', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_10', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_11', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_12', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_13', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_14', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_15', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_16', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_17', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_18', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_19', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_2', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_20', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_21', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_22', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_3', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_4', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_5', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_6', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_7', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_8', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_1_9', 'LOAIPHONG1_1_1', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_1', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_10', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_11', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_2', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_3', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_4', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_5', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_6', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_7', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_8', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_2_9', 'LOAIPHONG1_1_2', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_1', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_10', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_11', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_12', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_2', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_3', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_4', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_5', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_6', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_7', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_8', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_3_9', 'LOAIPHONG1_1_3', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_1', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_2', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_3', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_4', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_5', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_4_6', 'LOAIPHONG1_1_4', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_1', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_10', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_11', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_2', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_3', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_4', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_5', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_6', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_7', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_8', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_5_9', 'LOAIPHONG1_1_5', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_1', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_10', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_11', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_2', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_3', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_4', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_5', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_6', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_7', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_8', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG1_1_6_9', 'LOAIPHONG1_1_6', 'MAKHACHSAN1_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG10_1_1_1', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_10', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_11', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_12', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_2', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_3', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_4', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_5', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_6', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_7', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_8', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_1_9', 'LOAIPHONG10_1_1', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_2_1', 'LOAIPHONG10_1_2', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_2_2', 'LOAIPHONG10_1_2', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_2_3', 'LOAIPHONG10_1_2', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_1', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_2', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_3', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_4', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_5', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_6', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_7', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_8', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_3_9', 'LOAIPHONG10_1_3', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_1', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_2', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_3', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_4', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_5', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_4_6', 'LOAIPHONG10_1_4', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_1', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_2', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_3', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_4', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_5', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_5_6', 'LOAIPHONG10_1_5', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_6_1', 'LOAIPHONG10_1_6', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_6_2', 'LOAIPHONG10_1_6', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG10_1_6_3', 'LOAIPHONG10_1_6', 'MAKHACHSAN10_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_1_1', 'LOAIPHONG11_1_1', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_1_2', 'LOAIPHONG11_1_1', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_1_3', 'LOAIPHONG11_1_1', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_1_4', 'LOAIPHONG11_1_1', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_1_5', 'LOAIPHONG11_1_1', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_2_1', 'LOAIPHONG11_1_2', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG11_1_2_2', 'LOAIPHONG11_1_2', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_2_3', 'LOAIPHONG11_1_2', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_2_4', 'LOAIPHONG11_1_2', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_2_5', 'LOAIPHONG11_1_2', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_1', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_10', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_11', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_12', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_2', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_3', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_4', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_5', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_6', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_7', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_8', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_3_9', 'LOAIPHONG11_1_3', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_4_1', 'LOAIPHONG11_1_4', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_4_2', 'LOAIPHONG11_1_4', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_4_3', 'LOAIPHONG11_1_4', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_4_4', 'LOAIPHONG11_1_4', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_4_5', 'LOAIPHONG11_1_4', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_5_1', 'LOAIPHONG11_1_5', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_5_2', 'LOAIPHONG11_1_5', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_5_3', 'LOAIPHONG11_1_5', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_5_4', 'LOAIPHONG11_1_5', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_5_5', 'LOAIPHONG11_1_5', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_1', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_2', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_3', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_4', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_5', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_6', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG11_1_6_7', 'LOAIPHONG11_1_6', 'MAKHACHSAN11_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_1', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_2', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_3', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_4', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_5', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_1_6', 'LOAIPHONG12_1_1', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_2_1', 'LOAIPHONG12_1_2', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_2_2', 'LOAIPHONG12_1_2', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_2_3', 'LOAIPHONG12_1_2', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_2_4', 'LOAIPHONG12_1_2', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_2_5', 'LOAIPHONG12_1_2', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_3_1', 'LOAIPHONG12_1_3', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_3_2', 'LOAIPHONG12_1_3', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_3_3', 'LOAIPHONG12_1_3', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_3_4', 'LOAIPHONG12_1_3', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_3_5', 'LOAIPHONG12_1_3', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_4_1', 'LOAIPHONG12_1_4', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_4_2', 'LOAIPHONG12_1_4', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_4_3', 'LOAIPHONG12_1_4', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_5_1', 'LOAIPHONG12_1_5', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_5_2', 'LOAIPHONG12_1_5', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_5_3', 'LOAIPHONG12_1_5', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_6_1', 'LOAIPHONG12_1_6', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG12_1_6_2', 'LOAIPHONG12_1_6', 'MAKHACHSAN12_1', 1, '2020-05-17 09:51:46', '2020-05-17 09:51:46'),
('MAPHONG2_1_1_1', 'LOAIPHONG2_1_1', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_1_2', 'LOAIPHONG2_1_1', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_1_3', 'LOAIPHONG2_1_1', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_1_4', 'LOAIPHONG2_1_1', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_1_5', 'LOAIPHONG2_1_1', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_2_1', 'LOAIPHONG2_1_2', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_2_2', 'LOAIPHONG2_1_2', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_2_3', 'LOAIPHONG2_1_2', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_2_4', 'LOAIPHONG2_1_2', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_2_5', 'LOAIPHONG2_1_2', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_3_1', 'LOAIPHONG2_1_3', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_3_2', 'LOAIPHONG2_1_3', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_3_3', 'LOAIPHONG2_1_3', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_3_4', 'LOAIPHONG2_1_3', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_3_5', 'LOAIPHONG2_1_3', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_4_1', 'LOAIPHONG2_1_4', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_4_2', 'LOAIPHONG2_1_4', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_4_3', 'LOAIPHONG2_1_4', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_4_4', 'LOAIPHONG2_1_4', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_4_5', 'LOAIPHONG2_1_4', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_5_1', 'LOAIPHONG2_1_5', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_5_2', 'LOAIPHONG2_1_5', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_5_3', 'LOAIPHONG2_1_5', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_6_1', 'LOAIPHONG2_1_6', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_6_2', 'LOAIPHONG2_1_6', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG2_1_6_3', 'LOAIPHONG2_1_6', 'MAKHACHSAN2_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_1', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_10', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_2', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_3', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_4', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_5', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_6', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_7', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_8', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG3_1_1_9', 'LOAIPHONG3_1_1', 'MAKHACHSAN3_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_1', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_10', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_11', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_12', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_13', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_14', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_15', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_16', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_17', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_18', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_19', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_2', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_20', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_21', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_22', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_23', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_24', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_25', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_26', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_27', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_28', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_29', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_3', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_30', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_31', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_32', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_33', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_34', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_35', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_36', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_37', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_38', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_39', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_4', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_40', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_41', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_42', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_43', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_44', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_45', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_46', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_47', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_48', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_49', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_5', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_50', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_51', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_52', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_53', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_54', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_55', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_56', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_57', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_58', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_59', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_6', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_60', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_7', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_8', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_1_9', 'LOAIPHONG4_1_1', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_1', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_10', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_11', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_12', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_13', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_14', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_15', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_16', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_17', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_18', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_19', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_2', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_20', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_21', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_22', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_23', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_24', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_25', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_26', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_27', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_28', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_29', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_3', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_30', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_31', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_32', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_33', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_34', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_35', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_36', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_37', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_38', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_39', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_4', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_40', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_41', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_42', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_43', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_44', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_45', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_46', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_47', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_48', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_49', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_5', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_50', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_51', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_52', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_53', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_54', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_55', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_56', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_57', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_58', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_59', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_6', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_60', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_7', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_8', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_2_9', 'LOAIPHONG4_1_2', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_1', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_10', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_11', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_12', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_13', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_14', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_15', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_16', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_17', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_18', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_19', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_2', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_20', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_21', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_22', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_23', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_24', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_25', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_26', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_27', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_28', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_29', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_3', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_30', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_31', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_32', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_33', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_34', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_35', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_36', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_37', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_38', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_39', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_4', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_40', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_41', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_42', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_43', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_44', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_45', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_46', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_47', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_3_5', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_6', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_7', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_8', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_3_9', 'LOAIPHONG4_1_3', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:43', '2020-05-17 09:51:43'),
('MAPHONG4_1_4_1', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_10', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_11', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_12', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_13', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_14', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_15', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_16', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_17', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_18', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_19', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_2', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_20', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_21', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_22', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_23', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_24', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_25', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_26', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_27', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_28', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_29', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_3', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_30', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_31', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_32', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_33', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_34', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_35', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_36', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_37', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_38', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_39', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_4', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_40', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_41', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_42', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_43', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_44', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_45', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_46', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_47', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_5', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_6', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_7', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_8', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_4_9', 'LOAIPHONG4_1_4', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_1', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_10', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_11', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_12', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_13', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_14', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_15', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_16', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_17', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_18', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_19', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_2', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_20', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_21', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_22', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_23', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_24', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_3', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_4', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_5', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_6', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_7', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_8', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_5_9', 'LOAIPHONG4_1_5', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_1', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_10', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_11', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_12', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_13', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_14', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_15', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_16', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_17', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_18', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_19', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_2', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_20', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_21', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_22', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_23', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_24', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_3', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_4', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_5', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_6', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_7', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_8', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_6_9', 'LOAIPHONG4_1_6', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_1', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_10', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_11', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_12', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_13', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_14', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_15', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_16', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_17', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_18', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44');
INSERT INTO `phong` (`maPhong`, `maLoaiPhong`, `maKhachSan`, `conTrong`, `thoiGianDau`, `thoiGianCuoi`) VALUES
('MAPHONG4_1_7_19', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_2', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_20', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_21', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_22', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_23', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_24', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_3', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_4', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_5', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_6', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_7', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_8', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_7_9', 'LOAIPHONG4_1_7', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_1', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_10', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_11', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_12', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_13', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_14', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_15', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_16', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_17', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_18', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_19', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_2', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_20', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_21', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_22', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_23', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_24', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_3', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_4', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_5', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_6', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_7', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_8', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG4_1_8_9', 'LOAIPHONG4_1_8', 'MAKHACHSAN4_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_1', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_10', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_11', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_12', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_13', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_14', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_15', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_16', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_17', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_18', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_19', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_2', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_20', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_21', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_22', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_23', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_24', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_25', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_26', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_27', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_28', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_29', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_3', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_30', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_31', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_32', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_33', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_34', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_35', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_36', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_37', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_4', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_5', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_6', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_7', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_8', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_1_9', 'LOAIPHONG5_1_1', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_1', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_10', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_11', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_12', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_13', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_14', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_15', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_16', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_17', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_18', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_19', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_2', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_20', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_21', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_22', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_23', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_24', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_25', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_26', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_27', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_28', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_3', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_4', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_5', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_6', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_7', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_8', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_2_9', 'LOAIPHONG5_1_2', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_3_1', 'LOAIPHONG5_1_3', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_3_2', 'LOAIPHONG5_1_3', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_3_3', 'LOAIPHONG5_1_3', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_3_4', 'LOAIPHONG5_1_3', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_3_5', 'LOAIPHONG5_1_3', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_1', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_10', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_11', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_12', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_13', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_14', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_15', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_16', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_17', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_18', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_19', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_2', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_20', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_3', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_4', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_5', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_6', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_7', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_8', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_4_9', 'LOAIPHONG5_1_4', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_1', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_10', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_11', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_12', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_13', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_2', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_3', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_4', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_5', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_6', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_7', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_8', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG5_1_5_9', 'LOAIPHONG5_1_5', 'MAKHACHSAN5_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_1', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_10', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_11', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_12', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_13', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_14', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_15', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_16', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_17', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_18', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_19', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_2', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_20', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_21', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_22', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_23', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_24', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_25', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_26', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_27', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_28', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_29', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_3', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_30', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_31', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_32', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_33', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_34', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_4', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_5', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_6', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:44', '2020-05-17 09:51:44'),
('MAPHONG6_1_1_7', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_8', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_1_9', 'LOAIPHONG6_1_1', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_1', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_10', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_11', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_12', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_13', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_14', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_15', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_16', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_17', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_18', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_19', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_2', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_20', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_21', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_22', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_23', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_24', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_25', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_26', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_27', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_28', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_29', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_3', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_30', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_31', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_32', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_33', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_34', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_35', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_36', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_37', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_38', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_39', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_4', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_40', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_41', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_42', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_43', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_44', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_45', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_5', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_6', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_7', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_8', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_2_9', 'LOAIPHONG6_1_2', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_1', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_2', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_3', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_4', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_5', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_6', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_7', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG6_1_3_8', 'LOAIPHONG6_1_3', 'MAKHACHSAN6_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_1', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_10', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_2', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_3', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_4', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_5', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_6', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_7', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_8', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_1_9', 'LOAIPHONG7_1_1', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_2_1', 'LOAIPHONG7_1_2', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_2_2', 'LOAIPHONG7_1_2', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_2_3', 'LOAIPHONG7_1_2', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_2_4', 'LOAIPHONG7_1_2', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_2_5', 'LOAIPHONG7_1_2', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_3_1', 'LOAIPHONG7_1_3', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG7_1_4_1', 'LOAIPHONG7_1_4', 'MAKHACHSAN7_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_1', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_2', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_3', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_4', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_5', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_6', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_1_7', 'LOAIPHONG8_1_1', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_1', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_10', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_11', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_12', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_13', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_14', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_15', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_2', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_3', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_4', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_5', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_6', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_7', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_8', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_2_9', 'LOAIPHONG8_1_2', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_1', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_10', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_2', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_3', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_4', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_5', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_6', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_7', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_8', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_3_9', 'LOAIPHONG8_1_3', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG8_1_4_1', 'LOAIPHONG8_1_4', 'MAKHACHSAN8_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_1', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_10', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_11', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_12', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_13', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_14', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_2', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_3', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_4', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_5', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_6', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_7', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_8', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_1_9', 'LOAIPHONG9_1_1', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_1', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_10', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_11', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_12', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_13', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_14', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_15', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_16', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_17', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_18', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_19', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_2', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_20', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_3', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_4', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_5', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_6', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_7', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_8', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_2_9', 'LOAIPHONG9_1_2', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_1', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_10', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_11', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_12', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_13', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_14', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_15', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_16', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_17', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_18', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_19', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_2', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_20', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_21', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_22', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_23', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_24', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_25', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_26', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_27', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_28', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_29', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_3', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_30', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_31', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_32', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_33', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_34', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_35', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_36', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_37', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_38', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_4', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_5', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_6', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_7', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_8', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_3_9', 'LOAIPHONG9_1_3', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_1', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_2', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_3', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_4', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_5', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_4_6', 'LOAIPHONG9_1_4', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_1', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_10', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_11', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_12', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_13', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_2', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_3', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_4', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_5', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_6', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_7', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_8', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45'),
('MAPHONG9_1_5_9', 'LOAIPHONG9_1_5', 'MAKHACHSAN9_1', 1, '2020-05-17 09:51:45', '2020-05-17 09:51:45');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `dangnhap`
--
ALTER TABLE `dangnhap`
  ADD UNIQUE KEY `maTruyCap` (`maTruyCap`);

--
-- Chỉ mục cho bảng `hoadon`
--
ALTER TABLE `hoadon`
  ADD PRIMARY KEY (`maHoaDon`);

--
-- Chỉ mục cho bảng `khachdatphong`
--
ALTER TABLE `khachdatphong`
  ADD PRIMARY KEY (`maTruyCap`,`maPhong`),
  ADD KEY `FK_khachDatPhong_phong` (`maPhong`);

--
-- Chỉ mục cho bảng `khachhang`
--
ALTER TABLE `khachhang`
  ADD UNIQUE KEY `maSo_KH` (`maSo_KH`);

--
-- Chỉ mục cho bảng `khachsan`
--
ALTER TABLE `khachsan`
  ADD PRIMARY KEY (`maKhachSan`),
  ADD KEY `FK_KHACHSAN_FK_KHACHS_KHUVUC` (`maKhuVuc`);

--
-- Chỉ mục cho bảng `khachtruycap`
--
ALTER TABLE `khachtruycap`
  ADD PRIMARY KEY (`maTruyCap`);

--
-- Chỉ mục cho bảng `khuvuc`
--
ALTER TABLE `khuvuc`
  ADD PRIMARY KEY (`maKhuVuc`);

--
-- Chỉ mục cho bảng `loaiphong`
--
ALTER TABLE `loaiphong`
  ADD PRIMARY KEY (`maLoaiPhong`);

--
-- Chỉ mục cho bảng `nddatphong`
--
ALTER TABLE `nddatphong`
  ADD PRIMARY KEY (`maSo_ND`,`maPhong`,`ngayDat`) USING BTREE,
  ADD KEY `FK_NDDATPHO_NDDATPHON_PHONG` (`maPhong`);

--
-- Chỉ mục cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`maSo_ND`),
  ADD UNIQUE KEY `email_ND` (`email_ND`);

--
-- Chỉ mục cho bảng `phong`
--
ALTER TABLE `phong`
  ADD PRIMARY KEY (`maPhong`),
  ADD KEY `FK_PHONG_FK_PHONG__KHACHSAN` (`maKhachSan`),
  ADD KEY `FK_PHONG_FK_PHONG__LOAIPHON` (`maLoaiPhong`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `khachdatphong`
--
ALTER TABLE `khachdatphong`
  ADD CONSTRAINT `FK_khachDatPhong_khachTruyCap` FOREIGN KEY (`maTruyCap`) REFERENCES `khachtruycap` (`maTruyCap`),
  ADD CONSTRAINT `FK_khachDatPhong_phong` FOREIGN KEY (`maPhong`) REFERENCES `phong` (`maPhong`);

--
-- Các ràng buộc cho bảng `khachsan`
--
ALTER TABLE `khachsan`
  ADD CONSTRAINT `FK_KHACHSAN_FK_KHACHS_KHUVUC` FOREIGN KEY (`maKhuVuc`) REFERENCES `khuvuc` (`maKhuVuc`);

--
-- Các ràng buộc cho bảng `nddatphong`
--
ALTER TABLE `nddatphong`
  ADD CONSTRAINT `FK_NDDATPHO_NDDATPHON_NGUOIDUN` FOREIGN KEY (`maSo_ND`) REFERENCES `nguoidung` (`maSo_ND`),
  ADD CONSTRAINT `FK_NDDATPHO_NDDATPHON_PHONG` FOREIGN KEY (`maPhong`) REFERENCES `phong` (`maPhong`);

--
-- Các ràng buộc cho bảng `phong`
--
ALTER TABLE `phong`
  ADD CONSTRAINT `FK_PHONG_FK_PHONG__KHACHSAN` FOREIGN KEY (`maKhachSan`) REFERENCES `khachsan` (`maKhachSan`),
  ADD CONSTRAINT `FK_PHONG_FK_PHONG__LOAIPHON` FOREIGN KEY (`maLoaiPhong`) REFERENCES `loaiphong` (`maLoaiPhong`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
