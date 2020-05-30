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