//Phản hồi
document.addEventListener("DOMContentLoaded", function() {
    emoj = document.getElementsByClassName("fa");
    for (var i = 0; i < emoj.length; i++) {
        emoj[i].onclick = function() {
            for (var j = 0; j < emoj.length; j++) {
                emoj[j].classList.remove("ra");
            }
            this.classList.add("ra");
        }
    }
    input = document.getElementsByClassName("int");
    nhap = document.getElementById("placetext-1");
    for (var k = 0; k < input.length; k++) {
        input[k].onclick = function() {
            nhap.classList.add("hienbang");
        }
    }
}, false)

//Đăng nhập và đăng kí
document.addEventListener("DOMContentLoaded", function() {
    login = document.getElementById("login");
    list = document.getElementById("list");
    arrow = document.getElementById("arrow");
    ngoai = document.getElementById("body");
    login.onclick = function() {
        list.classList.toggle("xuat");
    }
    arrow.onclick = function() {
        list.classList.toggle("xuat");
    }
    ngoai.onclick = function() {
        list.classList.remove("xuat")
    }
}, false)

//Tìm phòng và tìm khách sạn
document.addEventListener("DOMContentLoaded", function() {
    search = document.getElementById("search");
    search.onclick = function() {
        list_2.classList.toggle("hien");

    }
}, false)
$(function() {
    $("#calendar").datepicker();
});
$(function() {
    $("#calendar-2").datepicker();
});
//Chọn ngày
$("input[name='demo0']").TouchSpin({
    min: 1,
    max: 10,
    initval: '',
    eplacementval: '',
    decimals: 0,
    forcestepdivisibility: 'round',
    verticalbuttons: false,
    verticalupclass: 'glyphicon glyphicon-chevron-up',
    verticaldownclass: 'glyphicon glyphicon-chevron-down',
    boostat: 5,
    booster: true,
    maxboostedstep: 10,
    prefix_extraclass: '',
    postfix_extraclass: '',
    step: 1,
    stepinterval: 100,
    stepintervaldelay: 500,
    mousewheel: true,
    buttondown_class: 'btn btn-dark',
    buttonup_class: 'btn btn-dark',
    buttondown_txt: '-',
    buttonup_txt: '+'
});
document.addEventListener("DOMContentLoaded", function() {
    var clickguest = document.getElementsByClassName("guest-all");
    var add = document.getElementById("add");
    for (var i = 0; i < clickguest.length; i++) {
        clickguest[i].onclick = function() {
            add.classList.toggle("hienadd");
        }
    }
}, false);
$(document).ready(function() {
    $("#demo0").change(function(e) {
        e.preventDefault();
        var value = $(this).val();
        if (value == "#demo0") {
            $("#room").html("please");
        } else {
            $("#room").html($(this).val());
        }
    });
});
$(document).ready(function() {
    $("#demo01").change(function(e) {
        e.preventDefault();
        var value = $(this).val();
        if (value == "#demo0") {
            $("#room-1").html("please");
        } else {
            $("#room-1").html($(this).val());
        }
    });
});

//Phóng to ảnh fanctbox
$(document).ready(function() {
    $('.images-hotel a').fancybox();
    $('.images-room a').fancybox();
});

//animate
$(document).ready(function() {
    $("#animate").click(function(move) {
        move.preventDefault();
        $('html,body').animate({ scrollTop: 700 }, 300);
    });
});

// Ẩn hiện khung xuất hóa đơn
var questions = document.getElementsByClassName('title-comfort');
for (var j = 0; j < questions.length; j++) {
    var question = questions[j];

    question.onclick = function() {

        var answer = this.nextElementSibling; // Dùng 'this' => OK (y)(y)(y)
        var display = answer.style.display;
        answer.style.display = display == 'none' ? 'block' : 'none';
    }

}

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
autoLogin();
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

// Lấy Dữ Liệu các phòng của Khách Sạn



var maKhachSan = 'MAKHACHSAN11_1';//------------------------------

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

function loaiPhong(){
    var val;
    $.ajax({
        type: 'POST',
        url: '../../php/hotel.php',
        async: false,
        data: {action: 'getLoaiPhong', maKhachSan: maKhachSan},
        dataType: 'json',
        success: (response)=>{
            // console.log(response);
            val = response;
        }
    });
    return val;
}
$(()=>{
    let ks_info = getKS_Info();
    let loaiphong_info = loaiPhong();
    console.log(ks_info);
    let body = $('#id-body');

    //section header

    //section under header

    //section under header 1
    $('.under-header-1').empty();
    $('.under-header-1').append('<div class="container"> <div class="row"> <div class="col-lg-12 url"> <ul> <li> <a href="">Khách sạn</a> </li> <li class="sign">&gt;</li> <li> <a href="">'+ks_info.maKhuVuc+'</a> </li> <li class="sign">&gt;</li> <li>'+ks_info.tenKhachSan+'</li> </ul> <hr> </div> </div> </div>');
    //section body
    body.find('.title-info h4').text(ks_info['tenKhachSan']);
    body.find('.address-info > p').text(ks_info.diaChi_KS);

    let imgReview = $($(body).find('div.images-hotel'));
    imgReview.empty();
    for(let i=0;i<ks_info.anhReview.length && i<10;i++){
        imgReview.append('<a><img></a>');
        $(imgReview.find('a')[i]).attr({'data-fancybox':"gallery", 'href':ks_info.anhReview[i]});
        $(imgReview.find('a > img')[i]).attr('src',ks_info.anhReview[i]);
    }
    $(imgReview.find('a')[9]).attr('class','img10');

    $(body).find('.list-box tbody').empty();
    for(let i=0;i<ks_info.diemDen.length;i++){
        let cell = $($(body).find('.list-box tbody'));
        cell.append('<tr></tr>');
        console.log(ks_info.diemDen[i]);
        ks_info.diemDen[i].forEach((item, index)=>{
            $(cell.find('tr')[i]).append('<td></td>');
            $($(cell.find('tr')[i]).find('td')[index]).text(item);
        })
        $($(cell.find('tr')[i]).find('td')[1]).attr('class', 'km');
    }

    // console.log(loaiphong_info);

    // section under body
    $('.under-body').empty().append('<div class="container"> <div class="row"> <div class="col-lg-12 col-md-12 col-sm-12 col-12"> <div class="table-hotel" id="table-hotel"></div></div></div></div>');
    let tabel_hotel = $('div#table-hotel, div.table-hotel');
    tabel_hotel.append('<table class="title-table"><tbody><tr class="tr_1"><td class="text">Chọn Phòng '+ks_info.tenKhachSan+'</td><td class="td_1"><i class="fa fa-check-circle"> Đảm bảo giá tốt nhất</i><br><small>Giá ưu đãi chỉ dành cho khách nội địa</small></td></tr></tbody></table><table border="1" class="title-room"> <tbody> <tr class="type"> <td>LOẠI PHÒNG</td> <td>TỐI ĐA</td> <td>TÙY CHỌN</td> <td> <strong>GIÁ 1 ĐÊM</strong><br> <small>Chưa bao gồm thuế, phí</small> </td> <td>SỐ LƯỢNG</td> <td>ĐẶT PHÒNG</td> </tr> </tbody> </table>');
    loaiphong_info.forEach((item, index)=>{
        console.log(item);
        tabel_hotel.append('<table border="1" class="name-room"> <tbody><tr class="name"> <td>'+item.moTa.ten+'</td> </tr> </tbody></table>');
        tabel_hotel.append('<table border="1" class="info-room"><tbody><tr class="info-type"><td class="info-type-1"></td><td class="info-type-2"></td><td class="info-type-3"></td><td class="info-type-4"></td><td class="info-type-5"></td><td class="info-type-6"></td></tr></tbody></table>');
        let table = $(tabel_hotel.find('table.info-room')[index]);
        let info = table.find('.info-type-1');
        info.append('<div class="images-room"></div>');
        for(let i=0;i<item.moTa.srcHinh.length && i<4;i++)
            info.find('.images-room').append('<a data-fancybox="gallery" href="'+item.moTa.srcHinh[i]+'"><img src="'+item.moTa.srcHinh[i]+'"></a>');
        info.append('<div class="m"> <i class="fa fa-expand"></i> <small>'+item.dienTich+' m</small> <sup>2</sup> </div>');
        if(item.moTa.productContent!=undefined)
            info.append('<div class="bedbed"> <i class="fa fa-eye"></i> <small>'+item.moTa.productContent[0]+'</small><br> <i class="fa fa-bed"></i> <small>'+item.moTa.productContent[1]+'</small> </div>');
        info.append('<small class="text_1">Còn '+item.phongConLai+' phòng !</small>');

        info = table.find('.info-type-2');
        info.append('<i class="fa fa-user"></i><small>  '+item.moTa.toiDaSoNguoi+'</small>');
        info = table.find('.info-type-3');
        if(item.moTa.tuyChon[0]!=undefined)
            info.append('<i class="fa fa-coffee"> '+item.moTa.tuyChon[0]+'</i>');
        if(item.moTa.tuyChon[1]!=undefined)
            info.append('<br><i class="fa fa-times"> '+item.moTa.tuyChon[1]+'</i>');

        info = table.find('.info-type-4');
        if(item.moTa.uuDai>0){
            info.append('<p class="sale_sale"> Khuyến mãi đặt biệt - '+item.moTa.uuDai+' % </p>');
            info.append('<small><strike>'+item.moTa.giaGoc+' đ</strike></small>');
        }
        else{
            info.append('<p class="sale_sale" style="background: none; border: none"></p>');
        }
        info.append('<br><small class="money">'+item.moTa.giaGiam+' đ</small>');
        
        info = table.find('.info-type-5');
        info.append('<select name="" id=""> </select>');
        
        for(let i=1;i<=item.phongConLai;i++)
            info.find('select').append('<option value="'+i+'">'+i+' phòng</option>');
        
        info = table.find('.info-type-6');
        info.append('<a href="#"><button type="button" class="btn btn-warning">ĐẶT NGAY</button></a>');
    })

    //section convenience
    let dic_class = {
        "Hồ bơi ngoài trời": '<i class="fa fa-shower"></i>',
        "Bãi đỗ xe": '<i class="fa fa-car"></i>',
        "Phòng họp": '<i class="fa fa-home"></i>',
        "Quán bar": '<i class="fa fa-glass"></i>',
        "Thang máy": '<i class="fa fa-list-alt"></i>',
        "Truyền hình cáp/vệ tinh": '<i class="fa fa-tv"></i>',
        "Wifi miễn phí": '<i class="fa fa-wifi"></i>',
        "Giặt là": '<i class="fa fa-database"></i>',
        "Hỗ trợ đặt tour": '<i class="fa fa-users"></i>',
        "Nhà hàng": '<i class="fa fa-university"></i>',
        "Quán cafe": '<i class="fa fa-coffee"></i>',
        "Lễ tân 24/24": '<i class="fa fa-male"></i>',
        "Internet có dây": '<i class="fa fa-internet-explorer"></i>',
        "Đưa đón sân bay": '<i class="fa fa-bus"></i>',
        "Taxi/Cho thuê xe hơi": '<i class="fa fa-taxi"></i>',
        "Phòng gym": '<i class="fa fa-building"></i>',
        "Thu đổi ngoại tệ": '<i class="fa fa-money"></i>',
        "Đặt vé xe/máy bay": '<i class="fa fa-ticket"></i>',
        "Bãi đỗ xe miễn phí": '<i class="fa fa-car"></i>',
        "Tắm nước nóng": '<i class="fa fa-shower"></i>',
        "Dọn phòng hàng ngày": '<i class="fa fa-paint-brush"></i>',
        "Giữ hành lý miễn phí": '<i class="fa fa-briefcase"></i>',
        "Phòng hội thảo": '<i class="fa fa-home"></i>',
        "Massage": '<i class="fa fa-bath"></i>',
        "Internet có dây miễn phí": '<i class="fa fa-internet-explorer"></i>',
        "Đưa đón sân bay tính phí": '<i class="fa fa-bus"></i>',
        "Phòng xông hơi ướt": '<i class="fa fa-bath"></i>',
        "Phục vụ đồ ăn tại phòng": '<i class="fa fa-male"></i>',
        "Giặt khô": '<i class="fa fa-tint"></i>',
        "Két an toàn": '<i class="fa fa-shield"></i>',
        "Phòng tập thể": '<i class="fa fa-home"></i>',
        "Tổ chức sự kiện": '<i class="fa fa-glass"></i>',
        "Hồ bơi dành cho trẻ em": 'i class="fa fa-shower"></i>',
        "Cửa hàng lưu niệm": '<i class="fa fa-gift"></i>',
        "Salon": '<i class="fa fa-home"></i>',
        "Sòng bài": '<i class="fa fa-hand-spock-o"></i>',
        "Spa": '<i class="fa fa-bath"></i>',
        "Phòng gia đình": '<i class="fa fa-home"></i>',
        "Khu vực hút thuốc": '<i class="fa fa-check"></i>',
        "Dịch vụ trông trẻ": '<i class="fa fa-check"></i>',
        "Tiện nghi cho người khuyết tật": '<i class="fa fa-wheelchair"></i>',
        "Hồ bơi trong nhà": 'i class="fa fa-shower"></i>',
        "Karaoke": '<i class="fas fa-music fa-sm"></i>',
        "Bãi tắm riêng": '<i class="fa fa-shower"></i>',
        "Giữ hành lý": '<i class="fa fa-briefcase"></i>'
    }
    let convenience = $('.convenience .info-comfort .row');
    convenience.empty();
    convenience.append('<div class="col-lg-4 col-md-4 col-sm-4 col-12 cot_1"> </div>');
    convenience.append('<div class="col-lg-4 col-md-4 col-sm-4 col-12 cot_2"> </div>');
    convenience.append('<div class="col-lg-4 col-md-4 col-sm-4 col-12 cot_3"> </div>');
    let column = 0;
    ks_info.tienNghi.forEach((item, index, arr)=>{
        convenience.find('.cot_'+(((column++)%3)+1)).append(dic_class[item]+' <span>'+item+'</span><br>');
    })

})

