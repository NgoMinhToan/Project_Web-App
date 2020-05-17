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
            list_group.append('<li class="list-group-item"><a href="../account/quanly.html">Quản lý đơn phòng</a></li>')
            list_group.append('<li class="list-group-item"><a href="../account/taikhoan.html">Quản lý tài khoản</a></li>')
            list_group.append('<li class="list-group-item"><a href="../Login/login.html" onclick="return logOut()">Đăng xuất</a></li>')
            let account = $('<li class="list-group-item bg-primary"><a href="../account/quanly.html" class="text-light"><strong>Thông tin tài khoản</strong></a></li>');
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