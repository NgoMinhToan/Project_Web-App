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