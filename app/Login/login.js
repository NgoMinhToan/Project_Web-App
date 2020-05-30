// Tự động đăng nhập
$.ajax({
    type: 'POST',
    url: '../php/login.php',
    async: false,
    data: {action: 'Auto-Login'},
    dataType: 'json',
    success: (response)=>{
        if(response['success'])
            window.location.href = '../Home/index.html';
    }
});

//Phản hồi
$(document).ready(()=>{
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

    //Đổi đăng nhập thành đăng ký
    $(function() {
        $(".quadangky").click(function(e) {
            e.preventDefault();
            $(".row .dangki").animate({ opacity: 1, marginTop: -510, zIndex: 4 });
            $(".row .left").animate({ opacity: 0, paddingLeft: -100 });
        });
        $(".quadangnhap").click(function(e) {
            e.preventDefault();
            $(".row .dangki").animate({ opacity: 0, marginTop: -1200 });
            $(".row .left").animate({ opacity: 1, paddingLeft: 0 });
        });
    });
})
    //Kiểm tra đăng nhập 
function onCheck() {
    var emailcheck = document.getElementById("email");
    var passwordcheck = document.getElementById("pwd");
    var email = emailcheck.value;
    var password = passwordcheck.value;
    var error1 = document.getElementById("error");
    var error2 = document.getElementById("error-message");
    if (email === "") {
        error1.innerHTML = "Email không được để trống";
        error1.style.color = "red";
        error1.style.fontWeight = "500";
        emailcheck.focus();
        return false;
    } else if (!(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email))) {
        error1.innerHTML = "Email không đúng định dạng.";
        error1.style.color = "red";
        error1.style.fontWeight = "500";
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
//Kiểm tra đăng nhập - Server
function onLogin(){
    var cont_login = false;
    var email=$('#email').val();
    var pwd=$('#pwd').val();
    var err_email=$('#error');
    var err_pwd=$('#error-message');
    $.ajax({
        type: 'POST',
        url: '../php/login.php',
        async: false,
        data: {action: 'onLogin', email: email, pwd: pwd},
        dataType: 'json',
        success: (response)=>{
            if(response['success'])
                cont_login = true;
            console.log(response);
        }
    });
    if(!cont_login){
        err_email.text('Email không khớp!').css({'color':'red', 'fontWeight': 500});
        err_pwd.text('Mật khẩu không khớp!').css({'color':'red', 'fontWeight': 500});

        if($('input#pwd').attr('type')=='text'){
            err_email.text('Tên người dùng không khớp!').css({'color':'red', 'fontWeight': 500});
            err_pwd.text('Số điện thoại không khớp!').css({'color':'red', 'fontWeight': 500});
        }
    }
    return cont_login;
}

//Kiểm tra đăng kí
function onCheck_2() {
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
    }
    return true;
}
//Kiểm tra đăng kí - Server
function onSignUp(){
    var cont_signUp = false;
    var email=$('#email-2').val();
    var pwd=$('#pwd-2').val();
    var err_email=$('#error2');
    $.ajax({
        type: 'POST',
        url: '../php/login.php',
        async: false,
        data: {action: 'onSignUp', email: email, pwd: pwd},
        dataType: 'json',
        success: (response)=>{
            if(response['success'])
                cont_signUp = true;
            console.log(response);
        }
    });
    if(!cont_signUp){
        err_email.text('Email đã tồn tại!').css({'color':'red', 'fontWeight': 500});
    }
    // alert(cont_signUp);
    return cont_signUp;
}

// Quên mật khẩu
function forgetPass(event){
    $(event).css('display', 'none');
    $('#title-login').text('Đăng Nhập Bằng Tên Người Dùng');
    $('#email-label').text('Tên người dùng');
    $('#pwd-label').text('Số điện thoại');
    $('#remember-pass-check').css('display', 'none');
    $('input#email').attr('type', 'text');
    $('input#pwd').attr('type', 'text');
    $('#sub').attr('onclick', '');
}