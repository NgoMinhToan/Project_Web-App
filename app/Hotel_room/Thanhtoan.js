// check info
function CheckForm() {

    var emailcheck = document.getElementById("email");
    var phonecheck = document.getElementById("phone");
    var namecheck = document.getElementById("name");

    var email = emailcheck.value;
    var phone = phonecheck.value;
    var name = namecheck.value;

    var error_email = document.getElementById("error-email");
    var error_phone = document.getElementById("error-phone");
    var error_name = document.getElementById("error-name");

    if (email === "") {
        error_email.innerHTML = "Vui lòng nhập Email !";
        emailcheck.focus();
        return false;
    } else if (!(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email))) {
        error_email.innerHTML = "Email không hợp lệ!";
        emailcheck.focus();
        return false;
    } else if (phone === "") {
        error_phone.innerHTML = "Vui lòng nhập số điện thoại !";
        phonecheck.focus();
        return false;
    } else if (name === "") {
        error_name.innerHTML = "Vui lòng nhập Họ và Tên !";
        namecheck.focus();
        return false;
    }
    return true;
}

function CheckBill() {
    var bill = document.getElementById("billbill");

    var company = document.getElementById("company");
    var code = document.getElementById("code");
    var address_company = document.getElementById("address-company");
    var address_bill = document.getElementById("address-bill");

    var error_company = document.getElementById("error-company");
    var error_code = document.getElementById("error-code");
    var error_address_company = document.getElementById("error-address-company");
    var error_address_bill = document.getElementById("error-address-bill");

    var checkcompany = company.value;
    var checkcode = code.value;
    var checkaddress_company = address_company.value;
    var checkaddress_bill = address_bill.value;

    if (bill.checked) {
        if (checkcompany === "" && checkcode === "" && checkaddress_company === "" && checkaddress_bill === "") {
            error_company.innerHTML = "Vui lòng nhập tên công ty !";
            error_code.innerHTML = "Vui lòng nhập mã số thuế !";
            error_address_company.innerHTML = "Vui lòng nhập địa chỉ công ty !";
            error_address_bill.innerHTML = "Vui lòng nhập địa chỉ nhận hóa đơn !";
        } else if (checkcode === "" && checkaddress_company === "" && checkaddress_bill === "") {
            error_code.innerHTML = "Vui lòng nhập mã số thuế !";
            error_address_company.innerHTML = "Vui lòng nhập địa chỉ công ty !";
            error_address_bill.innerHTML = "Vui lòng nhập địa chỉ nhận hóa đơn !";
        } else if (checkaddress_company === "" && checkaddress_bill === "") {
            error_address_company.innerHTML = "Vui lòng nhập địa chỉ công ty !";
            error_address_bill.innerHTML = "Vui lòng nhập địa chỉ nhận hóa đơn !";
        } else if (checkaddress_bill === "") {
            error_address_bill.innerHTML = "Vui lòng nhập địa chỉ nhận hóa đơn !";
        }
    } else {
        error_disappeared();
    }
}

function selectValid(obj) {
    var options = obj.children;
    var error_address = document.getElementById("error-address");
    for (var i = 0; i < options.length; i++) {
        if (options[i].selected) {
            error_address.innerHTML = "Bạn đã chọn thành công !";
        } else if (options[0].selected) {
            error_address.innerHTML = "Bạn chưa chọn Tỉnh/Thành Phố !";
        }
    }
}

function error_disappeared() {
    error_email = document.getElementById("error-email").innerHTML = "";
    error_phone = document.getElementById("error-phone").innerHTML = "";
    error_name = document.getElementById("error-name").innerHTML = "";
    error_company = document.getElementById("error-company").innerHTML = "";
    error_code = document.getElementById("error-code").innerHTML = "";
    error_address_company = document.getElementById("error-address-company").innerHTML = "";
    error_address_bill = document.getElementById("error-address-bill").innerHTML = "";
}

// Ẩn hiện khung xuất hóa đơn
var questions = document.getElementsByClassName('bill');
for (var j = 0; j < questions.length; j++) {
    var question = questions[j];

    question.onclick = function() {

        var answer = this.nextElementSibling; // Dùng 'this' => OK (y)(y)(y)
        var display = answer.style.display;
        answer.style.display = display == 'block' ? 'none' : 'block';
    }

}

// Tab chọn phương thức thanh toán
function openMenu(evt, menuName) {
    var i, x, tablinks;
    x = document.getElementsByClassName("menu");
    for (i = 0; i < x.length; i++) {
        x[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < x.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" ", "");
    }
    document.getElementById(menuName).style.display = "block";
    evt.currentTarget.firstElementChild.className += " ";
}
document.getElementById("myLink").click();


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
let userInfo = {success: false};
let gopY = '';
let dP_info = datPhong_Info();
let phong_info = get_LoaiPhong_info();
console.log(phong_info);
let maLoaiPhong;
let maKhachSan;
let timestart = '1970-1-1 00:00:00';
let timeend = '1970-1-1 00:00:00';
let night = 1;
let email = '';
let sdt = 0;
let hoTen = '';
let tinhthanhpho = '';
let month;
let year;
let PTTT = 'Thẻ Tín Dụng';
let address_bill = address_company = code = company = '';
$(() => {
   let sPath = window.location.pathname;
   let sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
   console.log(sPage);

   userInfo = autoLogin();
   if(userInfo.quyenQuanTri=='1'){
        window.location.replace("../account/adminQuanLy.html");
    }

    $('#login ul.list-group').append('<li class="list-group-item"><a href="../account/quanly.html">Quản lý đơn phòng</a></li>');
   if (userInfo.success) {
       let list_group = $('#login ul.list-group');
       list_group.children('li').first().remove();
       list_group.append('<li class="list-group-item"><a href="../account/taikhoan.html">Quản lý tài khoản</a></li>')
       list_group.append('<li class="list-group-item"><a href="../Login/login.html" onclick="return logOut()">Đăng xuất</a></li>')
       let account = $('<li class="list-group-item bg-primary"><a href="../account/taikhoan.html" class="text-light"><strong>Thông tin tài khoản</strong></a></li>');
       account.children('a').append('<br><span>' + userInfo['email_ND'] + '</span>');
       list_group.append(account);
   }
   for (let i = 0; i < $('label.check').length; i++) {
        $($('.check')[i]).click(() => {
            gopY = $($('.check > p')[i]).text();
        })
    }

    // phần thanh toán
    $('.titleform a').empty();
    $('#email').val(userInfo.email_ND);
    $('#phone').val(userInfo.SDT_ND);
    $('#name').val(userInfo.hoTen_ND);

    for(let i=0; i<$('#province option').length; i++){
        if($($('#province option')[i]).text==userInfo.tinhThanhPho_ND)
            $($('#province option')[i]).attr('selected');
    }

    email = userInfo.email_ND;
    std = userInfo.SDT_ND;
    hoTen = userInfo.hoTen_ND;
    tinhthanhpho = userInfo.tinhThanhPho_ND;

    loadPage(phong_info, dP_info);

    $('#timeend').change(()=>{
        console.log($('#timeend').val());
        timeend = $('#timeend').val().replace('T', ' '); 
    })
    $('#timestart').change(()=>{
        console.log($('#timestart').val());
        timestart = $('#timestart').val().replace('T', ' ');
    })
    $('#timestart, #timeend').change(()=>{
        if(new Date(timestart)>=new Date(timeend) || new Date(timestart)<new Date())
            $('#error-date').text('Bạn chọn ngày không hợp lệ');
        else{
            $('#error-date').text('');
            night = (new Date(timeend).getDate() - new Date(timestart).getDate());
            month = (new Date(timestart).getMonth()+1);
            year = new Date(timestart).getFullYear();
            while(night<0 || month < (new Date(timeend).getMonth()+1) || year < new Date(timeend).getFullYear()){
                dic_month = {1:31, 2:(28 + year%4==0), 3: 31, 4:30, 5:31, 6: 30, 7:31, 8: 31, 9: 30, 10: 31, 11:30, 12:31};
                night += dic_month[month];
                if(month==12){
                    month =1;
                    year++;
                }
                else
                    month++;
            }
            $('#numnight').val(night);

            $('.booking-bill td.text-2 p.price').text(inttomoney(phong_info.moTa.giaGiam*night*phong_info.select_room)+' đ/ '+night+' đêm');
            $('.table-1 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*0.1/1000)*1000*night*phong_info.select_room)+ ' đ');
            $('.table-3 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*1.1/1000)*1000*night*phong_info.select_room) + ' đ');
            $($($('.table-3 tr')[1]).find('td')[0]).empty().append('<strong>Thanh Toán</strong> <br> ('+night+' đêm) <br> Đã bao gồm VAT');
        }
    })
    $('#numnight').change(()=>{
        console.log($('#numnight').val());
        night = $('#numnight').val();
    })
    $('#email').change(()=>{
        console.log($('#email').val());
        email = $('#email').val();
    })
    $('#phone').change(()=>{
        console.log($('#phone').val());
        sdt = $('#phone').val();
    })
    $('#name').change(()=>{
        console.log($('#name').val());
        hoTen = $('#name').val();
    })
    $('#province').change(()=>{
        console.log($($('#province option')[$('#province').val()-1]).text());
        tinhthanhpho = $($('#province option')[$('#province').val()-1]).text();
    })
    $('[name="PTthanhToan"]').change(()=>{
        console.log($('input[name="PTthanhToan"]:checked').val());
        PTTT = $('input[name="PTthanhToan"]:checked').val();
    })
    $('#address-bill').change(()=>{
        console.log($('#address-bill').val());
        address_bill = $('#address-bill').val();
    })
    $('#address-company').change(()=>{
        console.log($('#address-company').val());
        address_company = $('#address-company').val();
    })
    $('#code').change(()=>{
        console.log($('#code').val());
        code = $('#code').val();
    })
    $('#company').change(()=>{
        console.log($('#company').val());
        company = $('#company').val();
    })

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

function danhGia() {
    let doHaiLong = $('.modal-content.note div.fa.emoj.ra > p').text();
    let cauHoi = $('#placetext-1').val();
    let email_sdt_lienhe = $('#email_sdt_lienhe').val();

    var cont = false;
    reqAjax('../php/index.php', {
        action: 'danhGia',
        doHaiLong,
        gopY,
        cauHoi,
        email_sdt_lienhe
    }, res => {
        if (res.success)
            cont = true;
    })
    return cont;
}

function reqAjax(url, data, callBack, method = 'POST', async = false, dataType = 'json') {
    $.ajax({
        type: method,
        url: url,
        async: async,
        data: data,
        dataType: dataType,
        success: callBack
    });
}

// Accept Link
function get_LoaiPhong_info(){
    let result = '';
    reqAjax('../php/thanhToan.php', {action: 'getLoaiPhong'}, res=> {
        if(res.success)
            result = res;
        console.log(res);
    })
    return result;
}
function getKS_Info(maKhachSan){
    let val;
    reqAjax('../php/hotel.php', {action: 'ks_info', maKhachSan}, res=> val=res);
    return val;
}
function datPhong_Info(){
    let val;
    reqAjax('../php/thanhToan.php', {action: 'datPhong_info'}, res=> {
        console.log(res);
        val = res;
    })
    return val;
}
function btn_datPhong(){
    let cont = false;
    reqAjax('../php/thanhToan.php', {action: 'datPhong_confirm', dangnhap: userInfo.success, maSo_ND: userInfo.maSo_ND, select_room: phong_info.select_room, maLoaiPhong, timestart, timeend, night, chiPhi: phong_info.moTa.giaGiam, email, sdt, hoTen, tinhthanhpho, PTTT, address_bill, address_company, code, company, option:phong_info.option}, res=>{
        if(res.success)
            cont = true;
        console.log(res);
    })
    return cont;
}
function inttomoney(int){
    return int.toString().split('').reverse().join('').replace(/(...?)/g, '$1,').split('').reverse().join('').replace(/^,/, '');
}
function loadPage(phong_info, dP_info){
    maLoaiPhong = phong_info.maLoaiPhong;
    maKhachSan = phong_info.maKhachSan;
    let ks_info = getKS_Info(maKhachSan);

    timestart = dP_info.timestart;
    timeend = dP_info.timeend;
    night = dP_info.night;
    //

    //
    let box_ks = $('#ks_box');
    box_ks.find('.box-header .title-info h4').text(ks_info.tenKhachSan);
    box_ks.find('.box-header .address-info p').text(ks_info.diaChi_KS);
    $(box_ks.find('.box-header .time-info .time-info-2 p')[0]).html('<input type="datetime-local" id="timestart" value="'+dP_info.timestart+'" name="timestart" style="width: 100%">');
    $(box_ks.find('.box-header .time-info .time-info-2 p')[1]).html('<input type="datetime-local" id="timeend" value="'+dP_info.timeend+'" name="timeend" style="width: 100%">');
    $(box_ks.find('.box-header .time-info .time-info-2 p')[2]).html('<input type="number" disabled id="numnight" value="'+dP_info.night+'" name="numnight" min="1" max="10" style="width: 20%">');

    $('.booking-bill td.text').text(phong_info.moTa.ten);

    $('.booking-bill td.text-1').empty();
    $('.booking-bill td.text-1').append(phong_info.select_room+' phòng <br> <ul> </ul>');
    // phong_info.moTa.tuyChon.forEach((item)=>{
    if(phong_info.option!=undefined)
        $('.booking-bill td.text-1 ul').append('<li>'+phong_info.option+'</li>')
    // })
    $('.booking-bill td.text-2 p.price').text(inttomoney(phong_info.moTa.giaGiam*dP_info.night*phong_info.select_room)+' đ/ '+dP_info.night+' đêm');
    $('.table-1 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*0.1/1000)*1000*dP_info.night*phong_info.select_room)+ ' đ');

    $('.table-3 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*1.1/1000)*1000*dP_info.night*phong_info.select_room) + ' đ');

    $($($('.table-3 tr')[1]).find('td')[0]).empty().append('<strong>Thanh Toán</strong> <br> ('+dP_info.night+' đêm) <br> Đã bao gồm VAT');

    // alert(maLoaiPhong.dienTich);
}


