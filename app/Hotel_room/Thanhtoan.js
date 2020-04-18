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
var userInfo = {};
function autoLogin(){
    // var isSuccess = false;
    $.ajax({
        type: 'POST',
        url: '../../php/login.php',
        async: false,
        data: {action: 'Auto-Login'},
        dataType: 'json',
        success: (response)=>{
            if(response['success']){
                userInfo = response;
            }
            console.log(response);
        }
    });
    return userInfo;
}
$(()=>{
    autoLogin();

})
$(()=>{
    if(userInfo.hasOwnProperty('success'))
        if(userInfo['success']){
            console.log(userInfo['maSo_ND']);
            let list_group = $('#login ul.list-group');
            list_group.children('li').first().remove();
            list_group.append('<li class="list-group-item"><a href="">Quản lý đơn phòng</a></li>')
            list_group.append('<li class="list-group-item"><a href="">Quản lý tài khoản</a></li>')
            list_group.append('<li class="list-group-item"><a href="../Login/login.html" onclick="return logOut()">Đăng xuất</a></li>')
            let account = $('<li class="list-group-item bg-primary"><a href="" class="text-light"><strong>Thông tin tài khoản</strong></a></li>');
            account.children('a').append('<br><span>'+userInfo['email_ND']+'</span>');
            list_group.append(account);

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

        }

})

//LogOut
function logOut(){
    var cont = false;
    $.ajax({
        type: 'POST',
        url: '../../php/index.php',
        async: false,
        data: {action: 'LogOut'},
        dataType: 'json',
        success: (response)=>{
            if(response['success'])
                cont = true;
        }
    });
    return cont;

}
var gopY = '';
$(()=>{
    for(let i =0;i<$('label.check').length;i++){
        $($('.check')[i]).click(()=>{
            gopY = $($('.check > p')[i]).text();
        })
    }
})
function danhGia(){
    let doHaiLong = $('.modal-content.note div.fa.emoj.ra > p').text();
    let cauHoi = $('#placetext-1').val();
    let email_sdt_lienhe = $('#email_sdt_lienhe').val();
    
    var cont = false;
    $.ajax({
        type: 'POST',
        url: '../../php/index.php',
        async: false,
        data: {action: 'danhGia', doHaiLong: doHaiLong, gopY: gopY, cauHoi: cauHoi, email_sdt_lienhe: email_sdt_lienhe},
        dataType: 'json',
        success: (response)=>{
            if(response['success'])
                cont = true;
        }
    });
    return cont;
}
// Accept Link
function get_LoaiPhong_info(){
    let result = '';
    $.ajax({
        type: 'POST',
        url: '../../php/thanhToan.php',
        async: false,
        data: {action: 'getLoaiPhong'},
        dataType: 'json',
        success: (response)=>{
            if(response.success){
                result = response;
                console.log(response);
            }
        }
    });
    return result;
}
function getKS_Info(){
    var val;
    $.ajax({    
        type: 'POST',
        url: '../../php/hotel.php',
        async: false,
        data: {action: 'ks_info', maKhachSan: maKhachSan},
        dataType: 'json',
        success: (response)=>{
            // console.log(response);
            val = response;
        }
    });
    return val;
}
function datPhong_Info(){
    var val;
    $.ajax({    
        type: 'POST',
        url: '../../php/thanhToan.php',
        async: false,
        data: {action: 'datPhong'},
        dataType: 'json',
        success: (response)=>{
            console.log(response);
            val = response;
        }
    });
    return val;
}

var dP_info = datPhong_Info();
var phong_info = get_LoaiPhong_info();
$(()=>{
    loadPage(phong_info, dP_info);
    
})
var maLoaiPhong;
var maKhachSan;
function inttomoney(int){
    return int.toString().split('').reverse().join('').replace(/(...?)/g, '$1,').split('').reverse().join('').replace(/^,/, '');
}
function loadPage(phong_info, dP_info){
    maLoaiPhong = phong_info.maLoaiPhong;
    maKhachSan = phong_info.maKhachSan;
    let ks_info = getKS_Info(maKhachSan);
    console.log(ks_info);

    timestart = dP_info.timestart;
    timeend = dP_info.timeend;
    night = dP_info.night;
    
    let box_ks = $('#ks_box');
    box_ks.find('.box-header .title-info h4').text(ks_info.tenKhachSan);
    box_ks.find('.box-header .address-info p').text(ks_info.diaChi_KS);
    $(box_ks.find('.box-header .time-info .time-info-2 p')[0]).html('<input type="datetime-local" id="timestart" value="'+dP_info.timestart+'" name="timestart" style="width: 100%">');
    $(box_ks.find('.box-header .time-info .time-info-2 p')[1]).html('<input type="datetime-local" id="timeend" value="'+dP_info.timeend+'" name="timeend" style="width: 100%">');
    $(box_ks.find('.box-header .time-info .time-info-2 p')[2]).html('<input type="number" disabled id="numnight" value="'+dP_info.night+'" name="numnight" min="1" max="10" style="width: 20%">');

    $('.booking-bill td.text').text(phong_info.moTa.ten);

    $('.booking-bill td.text-1').empty();
    $('.booking-bill td.text-1').append(phong_info.select_room+' phòng <br> <ul> </ul>');
    phong_info.moTa.tuyChon.forEach((item)=>{
        $('.booking-bill td.text-1 ul').append('<li>'+item+'</li>')
    })
    $('.booking-bill td.text-2 p.price').text(inttomoney(phong_info.moTa.giaGiam*dP_info.night)+' đ/ '+dP_info.night+' đêm');
    $('.table-1 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*0.1/1000)*1000*dP_info.night)+ ' đ');

    $('.table-3 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*1.1/1000)*1000*dP_info.night) + ' đ');

    $($($('.table-3 tr')[1]).find('td')[0]).empty().append('<strong>Thanh Toán</strong> <br> ('+dP_info.night+' đêm) <br> Đã bao gồm VAT');



    // alert(maLoaiPhong.dienTich);
}
var timestart = '1970-1-1 00:00:00';
var timeend = '1970-1-1 00:00:00';
var night = 1;
var email = '';
var std = 0;
var hoTen = '';
var tinhthanhpho = '';
var dic_month = {1:31, 2:(28 + night%4==0), 3: 31, 4:30, 5:31, 6: 30, 7:31, 8: 31, 9: 30, 10: 31, 11:30, 12:31};
$(()=>{
    $('#timeend').change(()=>{
        console.log($('#timeend').val());
        timeend = $('#timeend').val().replace('T', ' '); 
        if(new Date(timestart)>new Date(timeend))
            $('#error-date').text('Bạn chọn ngày không hợp lệ');
        else{
            $('#error-date').text('');
            night = (new Date(timeend).getDate() - new Date(timestart).getDate());
            night = (new Date(timeend).getDate() - new Date(timestart).getDate());
            var month = (new Date(timestart).getMonth()+1);
            var year = new Date(timestart).getFullYear();
            while(night<0 || month < (new Date(timeend).getMonth()+1) || year < new Date(timeend).getFullYear()){
                dic_month = {1:31, 2:(28 + night%4==0), 3: 31, 4:30, 5:31, 6: 30, 7:31, 8: 31, 9: 30, 10: 31, 11:30, 12:31};
                night += dic_month[month];
                if(month==12){
                    month =1;
                    year++;
                }    
                month++;
            }
            $('#numnight').val(night);

            $('.booking-bill td.text-2 p.price').text(inttomoney(phong_info.moTa.giaGiam*night)+' đ/ '+night+' đêm');
            $('.table-1 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*0.1/1000)*1000*night)+ ' đ');
            $('.table-3 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*1.1/1000)*1000*night) + ' đ');
            $($($('.table-3 tr')[1]).find('td')[0]).empty().append('<strong>Thanh Toán</strong> <br> ('+night+' đêm) <br> Đã bao gồm VAT');
        }
    })
    $('#timestart').change(()=>{
        console.log($('#timestart').val());
        timestart = $('#timestart').val().replace('T', ' ');
        if(new Date(timestart)>new Date(timeend))
            $('#error-date').text('Bạn chọn ngày không hợp lệ');
        else{
            $('#error-date').text('');
            night = (new Date(timeend).getDate() - new Date(timestart).getDate());
            var month = (new Date(timestart).getMonth()+1);
            var year = new Date(timestart).getFullYear();
            while(night<0 || month < (new Date(timeend).getMonth()+1) || year < new Date(timeend).getFullYear()){
                dic_month = {1:31, 2:(28 + night%4==0), 3: 31, 4:30, 5:31, 6: 30, 7:31, 8: 31, 9: 30, 10: 31, 11:30, 12:31};
                night += dic_month[month];
                if(month==12){
                    month =1;
                    year++;
                }
                month++;
            }
            $('#numnight').val(night);

            $('.booking-bill td.text-2 p.price').text(inttomoney(phong_info.moTa.giaGiam*night)+' đ/ '+night+' đêm');
            $('.table-1 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*0.1/1000)*1000*night)+ ' đ');
            $('.table-3 td.price').text(inttomoney(Math.floor(phong_info.moTa.giaGiam*1.1/1000)*1000*night) + ' đ');
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
})