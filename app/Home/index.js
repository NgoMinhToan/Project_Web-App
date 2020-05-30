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
    $("#calendar").datepicker({ dateFormat: "dd-mm-yy" }).val();
});
$(function() {
    $("#calendar-2").datepicker({ dateFormat: "dd-mm-yy" }).val();
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
let gopY = '';
const dsKV = [9,7,8,11,1,5,10,12,3,6,2,4];
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

    for(let i=0;i<$('#list_2 li.list-group-item').length;i++){
        $($('#list_2 li.list-group-item')[i]).click(e=>{
            window.location.href = `../Hotel_index/KS.html?type=index&maKhuVuc=KHUVUC${dsKV[i]}`;
        })
    }
    for(let i=0;i<$('.number').length;i++){
        $(`.number.number-${i+1}`).click((e)=>{
            window.location.href = `../Hotel_index/KS.html?type=index&maKhuVuc=KHUVUC${dsKV[i]}`;
            // localStorage.setItem('maKhuVuc', `KHUVUC${dsKV[i]}`);
        })
    }
    

    // Tìm kiếm
    // time picker
    let timestart = '1-1-2000';
    let timeend = '1-1-2000';
    let keyword = '';
    $('#search').on('change', (e)=>{
        keyword = $(e.target).val();
        console.log(keyword);
    })
    $('#calendar').on('change', ()=>{
        timestart = $('#calendar').val();
        console.log(timestart);
    })
    $('#calendar-2').on('change', ()=>{
        timeend =$('#calendar-2').val();
        console.log(timeend);
    })
    let numPhong = 1;
    let numNguoi = 2;
    $('#demo0').on('change', ()=>{
        numPhong = $('#demo0').val();
        $('#demo0').val(`  ${numPhong} phòng`);
        console.log(numPhong);
    })
    $('#demo01').on('change', ()=>{
        numNguoi =$('#demo01').val();
        $('#demo01').val(`  ${numNguoi} người`);
        console.log(numNguoi);
    })
    $('#btn_search').click((e)=>{
        // alert('chua tim dc'+keyword);
        searchEngine(keyword);
        reqAjax('../php/index.php', {action: 'search_info', timestart, timeend, numPhong, numNguoi}, res=>{});
        window.location.href = `../Hotel_index/KS.html?type=search&keyword=${keyword}`;
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

function searchEngine(keyword) {
    let filter, list;
    let rs = [];
    filter = keyword.toUpperCase();

    $.getJSON(`../php/hotel.php?action=ks_info_all`, data=>{
        list = data.map(value=>[value.maKhachSan, value.tenKhachSan]);
    }).done(()=>{
        for (i = 0; i < list.length; i++) {
            if (list[i][1].toUpperCase().indexOf(filter) > -1) {
                rs.push(list[i]);
            }
        }
    })
    console.log(rs);
}
