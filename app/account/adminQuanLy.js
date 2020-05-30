 //Phản hồi
 document.addEventListener("DOMContentLoaded", function () {
     emoj = document.getElementsByClassName("fa");
     for (var i = 0; i < emoj.length; i++) {
         emoj[i].onclick = function () {
             for (var j = 0; j < emoj.length; j++) {
                 emoj[j].classList.remove("ra");
             }
             this.classList.add("ra");
         }
     }
     input = document.getElementsByClassName("int");
     nhap = document.getElementById("placetext-1");
     for (var k = 0; k < input.length; k++) {
         input[k].onclick = function () {
             nhap.classList.add("hienbang");
         }
     }
 }, false)
 //Đăng nhập và đăng kí
 document.addEventListener("DOMContentLoaded", function () {
     login = document.getElementById("login");
     list = document.getElementById("list");
     arrow = document.getElementById("arrow");

     login.onclick = function () {
         list.classList.toggle("xuat");
     }
     arrow.onclick = function () {
         list.classList.toggle("xuat");
     }

 }, false)
 //Kiểm tra đăng nhập 
 function Check() {
     var emailcheck = document.getElementById("email");
     var passwordcheck = document.getElementById("pwd");
     var error1 = document.getElementById("error");
     var error2 = document.getElementById("error-message");
     var email = emailcheck.value;
     var password = passwordcheck.value;
     if (email === "") {
         error1.innerHTML = "Email không được để trống";
         error1.style.color = "red";
         error1.style.fontWeight = "500";
         emailcheck.focus();
         return false;
     } else if (!(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email))) {
         error1.innerHTML = "Email không đúng định dạng.";
         emailcheck.focus();
         return false;
     } else if (password === "") {
         error2.innerHTML = "Mật khẩu không được để trống";
         error2.style.color = "red";
         error2.style.fontWeight = "500";
         passwordcheck.focus();
         return false;
     } else if (password.length < 6) {
         error2.innerHTML = "Mật khẩu phải lớn hơn 6 kí tự";
         error2.style.color = "red";
         error2.style.fontWeight = "500";
         passwordcheck.focus();
         return false;
     }
     return true;
 }
 // Auto Login
 function autoLogin() {
     reqAjax('../php/login.php', {action: 'Auto-Login'}, res=>{
        if (res.success) {
            userInfo = res;
        }
        console.log(res);
     })
     return userInfo;
 }

 // MAIN 
 let userInfo = {};

 $(() => {
    let sPath = window.location.pathname;
    let sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
    console.log(sPage);

    userInfo = autoLogin();
    
    if (!userInfo.success || userInfo.quyenQuanTri == '0') {
        window.location.replace("./Quanly.html");
    }

     $('#login ul.list-group').append('<li class="list-group-item"><a href="./adminQuanLy.html">Quản lý đơn phòng</a></li>');
    if (userInfo.success) {
        let list_group = $('#login ul.list-group');
        list_group.children('li').first().remove();
        list_group.append('<li class="list-group-item"><a href="./taiKhoanAdmin.html">Quản lý tài khoản</a></li>')
        list_group.append('<li class="list-group-item"><a href="../Login/login.html" onclick="return logOut()">Đăng xuất</a></li>')
        let account = $('<li class="list-group-item bg-primary"><a href="./taiKhoanAdmin.html" class="text-light"><strong>Thông tin tài khoản</strong></a></li>');
        account.children('a').append('<br><span>' + userInfo['email_ND'] + '</span>');
        list_group.append(account);
    }

    let ks_info;
    reqAjax('../php/hotel.php', {action: 'ks_info_all'}, res=> ks_info = res);
    console.log(ks_info);

    let phong_info = [];
    let hoaDon = [];
    reqAjax('../php/admin.php', {action: 'getHoaDon'}, res => {if (res.success) hoaDon = res.hoaDon});
    hoaDon.forEach(value=>{
        reqAjax('../php/hotel.php', { action: 'getLoaiPhong1', 'maLoaiPhong': value.maLoaiPhong}, res => phong_info.push(res));
    })

    // Quan Ly Dat Phong
     if (sPage == "adminQuanLy.html") {
         let paging = 'all';
         loadQuanLyPage(hoaDon, ks_info, phong_info, paging);
         $('#typePage').on('change', e=>{
            paging = $(e.target).val();
            loadQuanLyPage(hoaDon, ks_info, phong_info, paging);
         })
        $('#search_hoaDon').keyup((e)=>{
            loadQuanLyPage(searchEngine($(e.target).val(), hoaDon, ks_info, phong_info), ks_info, phong_info, paging);
        })
     }
     // thống kê doanh thu
     else if (sPage == 'thongKe.html') {
        let thongKeTable = $('#_table');
        thongKeTable.empty().append('<table></table>');
        thongKeTable.find('table').append('<thead> <th>Mã Khách Sạn</th> <th>Tên Khách Sạn</th> <th>Từ ngày</th> <th>Đến ngày</th> <th>Tổng doanh thu</th> </thead>');
        thongKeTable.find('table').append('<tbody> </tbody>');
        let list = {};
        hoaDon.forEach((e, i) => {
            if (list.hasOwnProperty(e.maKhachSan)) {
                list[e.maKhachSan].tongDoanhThu += e.thanhTien;
                list[e.maKhachSan].batDau = list[e.maKhachSan].batDau > e.TG_layPhong ? e.TG_layPhong : list[e.maKhachSan].batDau;
                list[e.maKhachSan].ketThuc = list[e.maKhachSan].ketThuc < e.TG_traPhong ? e.TG_traPhong : list[e.maKhachSan].ketThuc;
            } else {
                list[e.maKhachSan] = {};
                list[e.maKhachSan].batDau = e.TG_layPhong;
                list[e.maKhachSan].ketThuc = e.TG_traPhong;
                list[e.maKhachSan].tongDoanhThu = e.thanhTien;
            }
        });
        for (let i = 0; i < Object.keys(list).length; i++) {
            let maKhachSan = Object.keys(list)[i];
            $.post('../php/hotel.php', {
                'action': 'ks_info',
                'maKhachSan': maKhachSan
            }, (data) => {
                list[maKhachSan].tenKhachSan = data.tenKhachSan;
            }, 'json').done(() => {

                item = list[maKhachSan];
                thongKeTable.find('table > tbody').append(`<tr><td>${maKhachSan}</td> <td>${item.tenKhachSan}</td> <td>${item.batDau}</td> <td>${item.ketThuc}</td> <td>${inttomoney(item.tongDoanhThu)} đ</td></tr>`);

            })
        }
     }
     // quản lý đánh giá
     else if (sPage == 'danhgia.html') {
         $('#_table').empty().append('<table></table>');
         let danhGiaTable = $('#_table > table');
         danhGiaTable.append('<thead> <tr> <th>Độ hài lòng</th> <th>Góp ý</th> <th>Câu hỏi</th> <th>Liên hệ</th></tr> </thead>');
         danhGiaTable.append('<tbody></tbody>');
         let danhGiaTbody = danhGiaTable.find('tbody');
         $.getJSON(`../php/admin.php?action=getDanhGia`, data => {
             data.forEach((item, index) => {
                 danhGiaTbody.append(`<tr><td>${item.doHaiLong}</td><td>${item.gopY}</td><td>${item.cauHoi}</td><td>${item.email_sdt_lienhe}</td></tr>`);
             })
             console.log(data);
         });
     }
     // About account
     else if (sPage == 'taiKhoanAdmin.html'){
         if (userInfo.success) {
             $('#name').val(userInfo.hoTen_ND);
             $('#email').val(userInfo.email_ND);
             $('#phone').val(userInfo.SDT_ND);
             $('#address').val(userInfo.diaChi_ND);
             $('#city').val(userInfo.tinhThanhPho_ND);
             $('#account > input').attr('disabled', 'on');
         } else {
             $('#account').empty().append('<a href="../Login/login.html" role="button" class="btn btn-primary">Đăng Nhập</a>');
         }
     }

 })

 //LogOut
 function logOut() {
    let cont = false;
    reqAjax('../php/index.php', {
        action: 'LogOut'
    }, res => {
        if (res.success)
            cont = true;
    })
    return cont;
}
 // Xac nhan doi thong tin
 function confirmEdit(e) {
     if ($('#pwd').val() == userInfo.matKhau_ND) {
         if ($('#new_pwd').val() == $('#confirm_pwd').val())
             return true;
         else {
             alert('Mật khẩu mới không giống!');
             return false;
         }
     } else {
         alert('Sai mật khẩu!');
         return false;
     }
 }
 // Doi thong tin
 function edit(e) {
     $(e).attr('onclick', 'return confirmEdit(this)');
     $('#account > input').removeAttr('disabled');
     $('#account > button').last().before(`<label for="pwd">Mật khẩu:</label><input type="password" name="pwd" id="pwd"><br>`);
     $('#account > button').last().before(`<label for="new_pwd">Mật khẩu mới:</label><input type="password" name="new_pwd" id="new_pwd" value='${userInfo.matKhau_ND}'><br>`);
     $('#account > button').last().before(`<label for="confirm_pwd">Xác thực mật khẩu mới:</label><input type="password" name="confirm_pwd" id="confirm_pwd" value='${userInfo.matKhau_ND}'><br>`);
     return false;
 }

 function reqAjax(url, data, callBack = undefined, method = 'POST', async = false, dataType = 'json') {
     $.ajax({
         type: method,
         url: url,
         async: async,
         data: data,
         dataType: dataType,
         success: callBack
     });
 }

 function searchEngine(keyword, list, ks_info, phong_info) {
    let filter;
    let rs = [];
    filter = keyword.toUpperCase();
    for (i = 0; i < Object.keys(list).length; i++) {
        let tenKhachSan = ks_info.filter(value=>value.maKhachSan==list[i].maKhachSan)[0].tenKhachSan;
        let tenLoaiPhong = phong_info.filter(value=>value.maLoaiPhong==list[i].maLoaiPhong)[0].moTa.ten;
        if (list[i].maHoaDon.toUpperCase().indexOf(filter) > -1 || list[i].maSo_KH.toUpperCase().indexOf(filter) > -1 
        || list[i].maKhachSan.toUpperCase().indexOf(filter) > -1 || list[i].maLoaiPhong.toUpperCase().indexOf(filter) > -1 
        || list[i].hinhThucThanhToan.toUpperCase().indexOf(filter) > -1 || list[i].trangThai.toUpperCase().indexOf(filter) > -1 
        || list[i].soLuong == filter || tenKhachSan.toUpperCase().indexOf(filter) > -1 || tenLoaiPhong.toUpperCase().indexOf(filter) > -1) {
            rs.push(list[i]);
        }
    }
    // console.log(rs);
    return rs;
}

 function loadQuanLyPage(hoaDon, ks_info, phong_info, page='all'){
     console.log(hoaDon)
    let hoaDonTable = $('#_table');
    hoaDonTable.empty().append('<table></table>');
    hoaDonTable.find('table').append('<thead> <th>Mã Hóa Đơn</th> <th>Mã Khách Hàng</th> <th>Tổng giá</th> <th>Thành tiền</th> <th>Ngày giao dịch</th> </thead>');
    hoaDonTable.find('table').append('<tbody> </tbody>');
    hoaDon.forEach((e, i) => {
        let tenKhachSan = ks_info.filter(value=>value.maKhachSan==e.maKhachSan)[0].tenKhachSan;
        let tenLoaiPhong = phong_info.filter(value=>value.maLoaiPhong==e.maLoaiPhong)[0].moTa.ten;


        let addClass = '';
        if (e.trangThai == 'Đã thanh toán')
            addClass = 'successed';
        else if (e.trangThai == 'Đã hủy')
            addClass = 'cancelled';
        else if (e.trangThai == 'Đang chờ duyệt')
            addClass = 'waitting';
        if(page != 'all'){
            if(page != addClass){
                addClass += ' hide';
            }
        }
        hoaDonTable.find('table > tbody').append(`<tr class='hoaDon ${addClass}'> <td>${e.maHoaDon}</td> <td>${e.maSo_KH}</td> <td>${inttomoney(e.tongGia)} đ</td> <td>${inttomoney(e.thanhTien)} đ</td> <td>${e.ngayGiaoDich}</td> </tr>`);
        hoaDonTable.find('table > tbody').append(`<tr class='${addClass} hide'><td colspan=5><div class='hide'>
       <strong>Tên khách sạn:</strong> ${tenKhachSan}<br>
       <strong>Loại phòng:</strong> ${tenLoaiPhong}<br>
       <strong>Số lượng:</strong> ${e.soLuong}<br>
       <strong>Giá phòng:</strong> ${inttomoney(e.giaPhong)} đ<br>
       <strong>Tùy chọn:</strong> ${e.tuyChon}<br>
       <strong>Thời gian lấy phòng:</strong> ${e.TG_layPhong}<br>
       <strong>Thời gian trả phòng:</strong> ${e.TG_traPhong}<br>
       <strong>Hình thức thanh toán:</strong> ${e.hinhThucThanhToan}<hr>
       <strong>Tên công ty:</strong> ${e.tenCongTy}<br>
       <strong>Mã số thuế:</strong> ${e.maSoThue}<br>
       <strong>Địa chỉ công ty:</strong> ${e.diaChiCongTy}<br>
       <strong>Địa chỉ nhận hóa đơn:</strong> ${e.diaChiNhanHoaDon}<hr>
       <strong>Trạng thái: </strong>${e.trangThai}<br>
       <a role='button' class='btn btn-success text-light accept-btn ${addClass}' onclick='return accept("${e.maHoaDon}", "${e.maSo_KH}");' href=''>Duyệt</a> <a role='button' class='btn btn-danger text-light cancel-btn ${addClass}' onclick='return cancel("${e.maHoaDon}", "${e.maSo_KH}");' href=''>Hủy</a>
   </div></td></tr>`);

        let hoaDonTbody = $(`table > tbody > tr.hoaDon`)
        $(hoaDonTbody[i]).click(e => {
            $(hoaDonTbody[i]).next().slideToggle('fast');
            $(hoaDonTbody[i]).next().find('div').slideToggle('fast');
        })
    })
 }
 // huy dat phong
 function cancel(maHoaDon, maSo_KH) {
     if (userInfo.success) {
         if (confirm('Bạn có chắc muốn hủy đơn này không?')) {
            reqAjax('../php/admin.php', {action: 'duyet', accept: 0, maHoaDon, maSo_KH});
            //  $.getJSON(`../php/admin.php?action=duyet&&accept=0&maHoaDon=${maHoaDon}`);
             return true;
         } else
             return false;
     } else {
         alert('Bạn không thể hủy đơn này!');
         return false;
     }
 }
 function accept(maHoaDon, maSo_KH) {
     if (userInfo.success) {
         reqAjax('../php/admin.php', {action: 'duyet', accept: 1, maHoaDon, maSo_KH});
        //  $.getJSON(`../php/admin.php?action=duyet&accept=1&maHoaDon=${maHoaDon}`);
         return true;
     } else {
         alert('Bạn không được quyền hủy đơn này!');
         return false;
     }
 }
 // tien te
 function inttomoney(int) {
     return int.toString().split('').reverse().join('').replace(/(...?)/g, '$1,').split('').reverse().join('').replace(/^,/, '');
 }
 //Kiểm tra đăng kí
 function Check_2() {
     var emailcheck_2 = document.getElementById("email-2");
     var passwordcheck_2 = document.getElementById("pwd-2");
     var passwordcheck_3 = document.getElementById("pwd-3");
     var error_1 = document.getElementById("error2");
     var error_2 = document.getElementById("error-message-2");
     // var passwordcheck_3 = document.getElementById("pwd-3");
     var error_3 = document.getElementById("error-message-3");
     var email_2 = emailcheck_2.value;
     var password_2 = passwordcheck_2.value;
     var password_3 = passwordcheck_3.value;
     if (email_2 === "") {
         error_1.innerHTML = "Email không được để trống";
         error_1.style.color = "red";
         error_1.style.fontWeight = "500";
         emailcheck_2.focus();
         return false;
     } else if (!(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email_2))) {
         error_1.innerHTML = "Email không đúng định dạng.";
         emailcheck_2.focus();
         return false;
     } else if (password_2 === "") {
         error_2.innerHTML = "Mật khẩu không được để trống";
         error_2.style.color = "red";
         error_2.style.fontWeight = "500";
         passwordcheck_2.focus();
         return false;
     } else if (password_2.length < 6) {
         error_2.innerHTML = "Mật khẩu phải lớn hơn 6 kí tự";
         error_2.style.color = "red";
         error_2.style.fontWeight = "500";
         passwordcheck_2.focus();
         return false;
     } else if (password_3 === "") {
         error_3.innerHTML = "Xác nhận mật khẩu không được để trống";
         error_3.style.color = "red";
         error_3.style.fontWeight = "500";
         passwordcheck_3.focus();
         return false;
     } else if (password_2 !== password_3) {
         error_3.innerHTML = "Xác nhận mật khẩu không đúng. Vui lòng kiểm tra lại!";
         error_3.style.color = "red";
         error_3.style.fontWeight = "500";
         passwordcheck_3.focus();
         return false;
     } else if (password_2 === password_3) {
         error_3.innerHTML = "";
         passwordcheck_3.focus();
         return false;
     }
     return true;
 }
 //Đổi đăng nhập thành đăng ký
 $(function () {
     $(".quadangky").click(function (e) {
         e.preventDefault();
         $(".row .dangki").animate({
             opacity: 1,
             marginTop: -500,
             zIndex: 4
         });
         $(".row .left").animate({
             opacity: 0,
             paddingLeft: -100
         });
     });
     $(".quadangnhap").click(function (e) {
         e.preventDefault();
         $(".row .dangki").animate({
             opacity: 0,
             marginTop: 500
         });
         $(".row .left").animate({
             opacity: 1,
             paddingLeft: 0
         });
     });
 });