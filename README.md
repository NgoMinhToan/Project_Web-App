# Project_LapTrinhWeb_UngDung
 Trang web đặt phòng khách sạn

[db.php]
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
[class Db]
// at: mysql - gọi sql
// fn: get_items($start = 1, $limit = null): trả về mảng đối tượng Item_Object bắt đầu từ item (param 1), giới hạn trả về (param 2), không ghi auto trả về hết.
// fn: add_item($row): thêm item vào db, đầu vào là đối tượng Item_Object
// fn: get_contents($start = 1, $limit = null): giống get_items nhưng đối tượng trả về là mảng Content_Object
// fn: get_content_from_item($item_index) trả về mảng đối tượng Content_Object mà thuộc item_index đầu vào (nội dung của trang web nào đó)
// fn: add_content($row): giống add_item với đầu vào là Content_Object
// fn: delete_item($item_index): xóa 1 item trên db, cũng xóa luôn các content thuộc về item này.

