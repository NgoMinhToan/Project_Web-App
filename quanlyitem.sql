-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 03, 2020 lúc 02:48 AM
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
-- Cơ sở dữ liệu: `quanlyitem`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_CONTENT` (`p_ID` INT, `p_CONTENT_INDEX` INT, `p_ITEM_INDEX` INT, `p_SRC` VARCHAR(100), `p_CONTENT` VARCHAR(20000), `p_TAG` VARCHAR(10))  BEGIN
    	IF EXISTS(SELECT ITEM_INDEX FROM ITEMS WHERE ITEMS.ITEM_INDEX = p_ITEM_INDEX)
        THEN
        	INSERT INTO CONTENTS(ID, CONTENT_INDEX, ITEM_INDEX, SRC, CONTENT, TAG) VALUES(p_ID, p_CONTENT_INDEX, p_ITEM_INDEX, p_SRC, p_CONTENT, p_TAG);
        END IF;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `contents`
--

CREATE TABLE `contents` (
  `ID` int(11) NOT NULL,
  `CONTENT_INDEX` int(11) NOT NULL,
  `ITEM_INDEX` int(11) NOT NULL,
  `SRC` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `CONTENT` varchar(20000) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `TAG` varchar(10) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `items`
--

CREATE TABLE `items` (
  `ITEM_INDEX` int(11) NOT NULL,
  `TITLE` varchar(1000) COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `VIEW` int(11) DEFAULT NULL,
  `DATE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `contents`
--
ALTER TABLE `contents`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `FK_CONTENTS_ITEMS` (`ITEM_INDEX`);

--
-- Chỉ mục cho bảng `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ITEM_INDEX`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `contents`
--
ALTER TABLE `contents`
  ADD CONSTRAINT `FK_CONTENTS_ITEMS` FOREIGN KEY (`ITEM_INDEX`) REFERENCES `items` (`ITEM_INDEX`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
