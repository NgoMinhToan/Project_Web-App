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