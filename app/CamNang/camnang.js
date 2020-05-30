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

         login.onclick = function() {
             list.classList.toggle("xuat");
         }
         arrow.onclick = function() {
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
 //Kiểm tra đăng nhập 

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
 $(function() {
     $(".quadangky").click(function(e) {
         e.preventDefault();

         $(".row .dangki").animate({ opacity: 1, marginTop: -500, zIndex: 4 });
         $(".row .left").animate({ opacity: 0, paddingLeft: -100 });
     });
     $(".quadangnhap").click(function(e) {
         e.preventDefault();

         $(".row .dangki").animate({ opacity: 0, marginTop: 500 });
         $(".row .left").animate({ opacity: 1, paddingLeft: 0 });
     });
 });
 //thu gọn và xổ ra
 $(document).ready(function() {
     $(".border-1").click(function(e) {
         e.preventDefault();
         $(".border-2").slideToggle();
         $(".fa-chevron-up").toggleClass("xoay");
     });

 });
 //mui ten xoay

 //hiệu ứng fancybox
 $(document).ready(function() {
     $(".resort-info a").fancybox();
 });

 //truotxuongnoicanxuong
 $(document).ready(function() {
     $(".down-1").click(function(e) {
         e.preventDefault();
         $("html,body").animate({ scrollTop: 580 });
     });
     $(".down-2").click(function(e) {
         e.preventDefault();
         $("html,body").animate({ scrollTop: 180 });
     });
     $(".down-3").click(function(e) {
         e.preventDefault();
         $("html,body").animate({ scrollTop: 1000 });
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