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
                echo $ID;
            }
            $diaChi_IP = get_user_ip();
            return self::$mysql->query("INSERT INTO khachTruyCap (diaChi_IP, maTruyCap, STT) VALUES('$diaChi_IP', 'MTC$ID', $ID)");
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
        static function loaiPhong($maLoaiPhong, $moTa, $dienTich, $phongConLai){
            $stmt = self::$mysql->prepare("INSERT INTO loaiPhong (maLoaiPhong, moTa, dienTich, phongConLai) VALUES(?, ?, ?, ?)");
            $stmt->bind_param('sssi', $maLoaiPhong, $moTa, $dienTich, $phongConLai);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }


        static function get_items($start = 1, $limit = null){
            $rs = [];
            $result=self::$mysql->query("SELECT MIN(ITEM_INDEX) AS 'start', MAX(ITEM_INDEX) AS 'range' FROM items");
            $range=0;
            if($row=$result->fetch_assoc()){
                $range = $row["range"];
                $start = $row["start"];
            }
            if(is_numeric($limit)){
                $range = $limit - 1 + $start;
                // echo $range;
            }
            $stmt = self::$mysql->prepare("SELECT ITEM_INDEX, TITLE, VIEW, DATE FROM items WHERE ITEM_INDEX BETWEEN ? AND ?");
            $stmt->bind_param('ii', $start, $range);
            
            $stmt->execute();
            $stmt->bind_result($item_index, $title, $view, $date);
            while($stmt->fetch()){
                $rs[] = new Item($item_index, $title, $view, $date);
            }
            $stmt->close();
            return $rs;
        }
        static function add_item($row){
            $stmt = self::$mysql->prepare('INSERT INTO ITEMS (ITEM_INDEX, TITLE, `VIEW`, `DATE`) VALUES(?,?,?,?)');
            $stmt->bind_param('isis', $row->item_index, $row->title, $row->view, $row->date);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }
        static function get_contents($start = 1, $limit = null){
            $rs = [];
            $result=self::$mysql->query("SELECT MIN(ID) AS 'start', MAX(ID) AS 'range' FROM contents");
            $range=0;
            if($row=$result->fetch_assoc()){
                $range = $row["range"];
                $start = $row["start"];
            }
            if(is_numeric($limit)){
                $range = $limit - 1 + $start;
                // echo $range;
            }
            $stmt = self::$mysql->prepare('SELECT ITEM_INDEX, ID, CONTENT_INDEX, SRC, CONTENT, tag FROM contents WHERE ID BETWEEN ? AND ?');
            $stmt->bind_param('ii', $start, $range);

            $stmt->execute();
            $stmt->bind_result($item_index, $id, $content_index, $src, $content, $tag);
            while($stmt->fetch()){
                $rs[] = new Content($id, $content_index, $item_index, $src, $content, $tag);
            }
            $stmt->close();
            return $rs;
        }
        static function get_content_from_item($item_index){
            $rs = [];
            $stmt = self::$mysql->prepare('SELECT ITEM_INDEX, ID, CONTENT_INDEX, SRC, CONTENT, tag FROM contents WHERE ITEM_INDEX = ?');
            $stmt->bind_param('i', $item_index);
            $stmt->execute();
            $stmt->bind_result($item_index, $id, $content_index, $src, $content, $tag);
            while($stmt->fetch()){
                $rs[] = new Content($id, $content_index, $item_index, $src, $content, $tag);
            }
            $stmt->close();
            return $rs;
        }
        static function add_content($row){
            $stmt = self::$mysql->prepare('CALL INSERT_CONTENT(?, ?, ?, ?, ?, ?)');
            $stmt->bind_param('iiisss', $row->id, $row->content_index, $row->item_index, $row->src, $row->content, $row->tag);
            $stmt->execute();
            $log = $stmt->affected_rows;
            $stmt->close();
            return $log;
        }
        static function delete_item($item_index){
            self::$mysql->query("DELETE FROM contents WHERE ITEM_INDEX=$item_index");
            if(self::$mysql->affected_rows==-1)
                return self::$mysql->affected_rows;
            $stmt = self::$mysql->query("DELETE FROM items WHERE ITEM_INDEX=$item_index");
            return self::$mysql->affected_rows;
        }
    }












?>