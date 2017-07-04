// JavaScript Document

/**
** 代码制作人: 马泽棉
** 制作时间：2013-10-29
** 文件内容描述：页面多处使用的JS脚本
** 修改日期：无
** 修改内容：无
**********************************************/



/** 向上置顶 *************************************************************************************************/
window.onscroll = function () {
    var t = document.documentElement.scrollTop || document.body.scrollTop;
    var top_div = document.getElementById("lui_common_top_divL");
    top_div.style.left = parseInt($("body").offset().left, 10) + parseInt($("body").width(), 10) - 60 + "px";
    if (t >= 100) {
        top_div.style.display = "inline";
    } else {
        top_div.style.display = "none";
    }
}

/*************************************************************************************************************/



/** 选项卡切换 ***********************************************************************************************/
function setTab(name, cursel, n) {
    for (i = 1; i <= n; i++) {
        var menu = document.getElementById(name + i);
        var con = document.getElementById("con_" + name + "_" + i);
        menu.className = i == cursel ? "current" : "";
        con.style.display = i == cursel ? "block" : "none";
    }
};

/*************************************************************************************************************/



/** 导航更多展开 ********************************************************************************************/
$(function () {
    var lui_common_more_div = $(".lui_common_more_div");
    var lui_common_headNav = $(".lui_common_headNav");
    var h = lui_common_more_div.height();
    var head_h = lui_common_headNav.height();
    lui_common_headNav.css("display", "none");
    lui_common_headNav.css({ height: 0 });
    $(".portal_sel").toggle(function () {
        lui_common_headNav.css("display", "");
        lui_common_headNav.animate({
            height: h + head_h
        }, 1000);
        $(".portal_sel a").removeClass("mesMain_portal_sel").addClass("retract");
    }, function () {
        lui_common_headNav.animate({
            height: 0
        }, 800, function () { $(this).css("display", "none"); });
        $(".portal_sel a").removeClass("retract").addClass("mesMain_portal_sel");
    });

});
function mesMainOn(obj, num) {
    $(".mesMain_li_pendinglink").removeClass("mesMain_li_pendinglink_on");
    $(".mesMain_li_link").removeClass("mesMain_li_link_on");
    if (num == 2) {
        $("#" + obj.id).addClass("mesMain_li_pendinglink_on");
    }
    else {
        $("#" + obj.id).addClass("mesMain_li_link_on");
    }
};

/*************************************************************************************************************/




/** 多维查询 *************************************************************************************************/

$(document).ready(function () {
    $(".grid_s_cl_item a").bind('click', function () {
        if ($(this).attr("class").indexOf("item1") >= 0) {
            $(this).removeClass("item1");
            $(this).addClass("item2");
        }
        else if ($(this).attr("class").indexOf("item2") >= 0) {
            $(this).removeClass("item2");
            $(this).addClass("item1");
        }
        else { }
    });

    var hideSth = $(".grid_s_c");
    var he = hideSth.height();
    $(".grid_s_c").css("height", "0px");

    $(".grid_s_b").bind('click', function () {
        if ($(".grid_s_b img").attr("alt") == "收起条件") {
            hideSth.animate({
                height: 0
            }, 1000);
            $(this).html("全部条件&nbsp;&nbsp;<img alt='全部条件' src='images/btn_down.png' width='11px' height='7px' />");
        }
        else {
            hideSth.animate({
                height: he + "px"
            }, 1000);
            $(this).html("收起条件&nbsp;&nbsp;<img alt='收起条件' src='images/btn_top.png' width='11px' height='7px' />");
        }
    });
});

function conditionList(currentPage, obj) {
    var objid = $(obj).attr("name") || '';
    var objValue = $(obj).attr("name") || '';


    if ($(obj).attr("name") != undefined) {
        objValue = $(obj).attr("name");
    }

    if (obj != undefined) {
        var parentDivId = obj.parentNode.id; //当前对象的父id
        if (parentDivId == "div_type") {
            var obj1 = $("#div_type span");
            for (var i = 0; i < obj1.length; i++) {
                $(obj1[i]).removeClass('orange');
            }
            folderid = objValue;
            showCondition($(obj).attr("title"), $(obj).html());
        }
        else if (parentDivId == "div_S") {
            var obj1 = $("#div_S span");
            for (var i = 0; i < obj1.length; i++) {
                $(obj1[i]).removeClass('orange');
            }
            folderid = objValue;
            showCondition($(obj).attr("title"), $(obj).html());
        }
        else if (parentDivId == "其他选项") {
        }
        $(obj).addClass('orange');
    }
};

function showCondition(Ctitle, Cname) {
    $(".grid_s_tl span").each(function (i, val) {
        if (val.title == Ctitle) {
            $(this).remove();
        }
    });
    $(".grid_s_tl").html($(".grid_s_tl").html() + "<span class='item' id=" + Cname + "</span>");
    abridgeTag();
}

function abridgeTag() {
    $(".grid_s_tl span").each(function (i, val) {
        $(this).click(function () {
            $("[title='" + val.title + "']").each(function () {
                $(this).removeClass('orange');
            });
            $(this).remove();
        });
    });
};

//多维查询 鼠标进入文本框移除文字 效果
$(document).ready(function () {
    $(".grid_s_r_inputBox input").focus(function () {
        var txt_value = $(this).val();
        if (txt_value == this.defaultValue) {
            $(this).val("");
            $(this).next("div.grid_s_r_input_img").addClass("grid_s_r_input_img_on");
        }
    });
    $(".grid_s_r_inputBox input").blur(function () {
        var txt_value = $(this).val();
        if (txt_value == "") {
            $(this).val(this.defaultValue);
            $(this).next("div.grid_s_r_input_img").removeClass("grid_s_r_input_img_on");
        }
    });

});

/*************************************************************************************************************/



/** 分类索引菜单 *************************************************************************************************/

// 分类索引菜单 效果
$(function () {
    $(".lui_common_category_box li").each(function (index) {
        $(this).mouseover(function () {
            $(this).children(".itemBox").css({ "background-color": "#fff", "z-index": "99999", "border-top": "1px solid #35a9dc", "border-bottom": "1px solid #35a9dc" }).children("a").attr("item_on");
            $(".lui_common_category_box div.catagory_tips:eq(" + index + ")").show()
        }).mouseout(function () {
            $(".lui_common_category_box .catagory_tips").hide();
            $(this).children(".itemBox").css({ "background": "none", "border": "none", "z-index": "0" }).children("a").attr("item")
        });
    });
});


// 分类索引菜单 伸拉 效果
$(document).ready(function () {

    $("#firstpane li").click(function () {
        $("#firstpane").parents(".category_navBox").css({ "padding-top": "0" });
        $("#firstpane li.head").removeClass().addClass("categy_m_header");
        $(this).next("li.categy_m_body").slideToggle(500).siblings(".categy_m_body").slideUp("slow");
    });

    $("#pre_l a").click(function () {
        $("#firstpane li.categy_m_header").removeClass().addClass("head");
        $("#firstpane li.categy_m_body").hide();
        $("#firstpane").parents(".category_navBox").css({ "padding-top": "10px" });
    });

});

$(document).ready(function () {
    $("#overview a[title=分类概览]").click(function () {
        $("#guide").slideDown(300);
        $("#return").show(300);
    });

    $("#return").click(function () {
        $("#guide").slideUp(300);
        $("#return").hide(300);
    });
});

/*************************************************************************************************************/


// 共同部分 列表的下拉显示与上拉隐藏 效果
$(document).ready(function () {
    $("div.lui_common_list_box .lui_common_list_2_header_left").toggle(function () {
        $(this).find(".list_down_icon").attr("class", "list_up_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom", "1px");
    }, function () {
        $(this).find(".list_up_icon").attr("class", "list_down_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom", "0px");
    });

    $("div.lui_common_list_box .lui_common_list_3_header_left").toggle(function () {
        $(this).find(".list_down_icon").attr("class", "list_up_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom", "1px");
    }, function () {
        $(this).find(".list_up_icon").attr("class", "list_down_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom", "0px");
    });
});




//知识模块 
$(function () {
    //类文件夹 展开和收起
    $("div.lui_doc_relateKnow .fold_ul").toggle(function () {
        $(this).children("dt").attr("class", "fold");
        $(this).children("dd").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    }, function () {
        $(this).children("dt").attr("class", "unfold");
        $(this).children("dd").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    });

});


//底部选项卡
function setBottomTab(name, cursel, n) {
    for (i = 1; i <= n; i++) {
        if (i == cursel) {
            var menu = document.getElementById(name + i);
            var con = document.getElementById("con_" + name + "_" + i);
            if (menu.className == "current") {
                menu.className = "";
                con.style.display = "none";
            }
            else {
                menu.className = "current";
                con.style.display = "block";
            }
        }
    }

    var id = "con_" + name + "_" + cursel;
    return document.getElementById(id).scrollIntoView(); //类文章章节跳转
}

function closeWinow() {
    if (confirm("您确定要关闭本页吗？")) {
        window.opener = null;
        window.open('', '_self');
        window.close();
    }
    else { }
}



// 导航首页 列表的下拉显示与上拉隐藏 效果
$(document).ready(function () {
    $("div.navigation_box h1 p").toggle(function () {
        $(this).children("span").attr("class", "nav_l_up_icon");
        $(this).children("em").text("展开");
        $(this).parents("h1").next(".navi_content_wrapper").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    }, function () {
        $(this).children("span").attr("class", "nav_l_down_icon");
        $(this).children("em").text("收起");
        $(this).parents("h1").next(".navi_content_wrapper").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    });
});


//嵌套模式九宫格 导航首页列表下拉显示与上拉隐藏 效果
$(document).ready(function () {
    $("div.lui_portal_navigationBoxTopM h1 p").toggle(function () {
        $(this).children("span").attr("class", "nav_l_up_icon");
        $(this).children("em").text("展开");
        $(this).parents(".lui_portal_navigationBoxTopL").next(".lui_portal_navigationBoxMiddleL").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    }, function () {
        $(this).children("span").attr("class", "nav_l_down_icon");
        $(this).children("em").text("收起");
        $(this).parents(".lui_portal_navigationBoxTopL").next(".lui_portal_navigationBoxMiddleL").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    });
});

// 搜索页面 搜索筛选
$(document).ready(function () {
    var $category = $(".search_filter dl.search_area dd:gt(2)");
    $category.hide();
    $("div.dropBtn").toggle(function () {
        $category.slideDown("slow");
        $(this).children("span").addClass("on").text("收缩");
    }, function () {
        $category.slideUp("slow");
        $(this).children("span").removeClass("on").text("展开");
    });
});

// 论坛 右边收藏版块的下拉显示与上拉隐藏 效果
$(document).ready(function () {
    $("div.slider_box").toggle(function () {
        $(this).text("展开").css({ "background": "url(images/forum_slider_bg_2.gif) 0 0 no-repeat" })
        .next(".forum_f_word_box").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    }, function () {
        $(this).text("收起").css({ "background": "url(images/forum_slider_bg.gif) 0 0 no-repeat" })
        .next(".forum_f_word_box").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    });
});





/** 条件选择下拉效果 ********************************************************************************************/
jQuery.fn.extend({
    dropdown: function () {
        return this.each(function (i, obj) {
            var obj = $(this);
            var top = obj.offset().top;
            var left = obj.offset().left;
            var height = obj.height();
            var width = obj.width();
            var select = obj.prev("select");
            var options = select.find("option");
            var nheight = options.height();
            var className = select.attr("class");

            var uli = "", val = "", txt = "";
            var ul = $("#dropdownOptionsFor" + className);
            if (ul.length > 0) { ul.remove(); }
            else {
                $(".dropdown-options").remove();
                ul = document.createElement("ul");
                $(ul).attr("id", "dropdownOptionsFor" + className).addClass("dropdown-options").css({ position: "absolute", left: left, top: top + height, width: width });

                options.each(function (i) {
                    val = $(this).val();
                    txt = $(this).text();
                    uli += "<li><a data-value='" + val + "' href='javascript:void(0);'>" + txt + "</a></li>";
                });
                $(ul).html(uli);
                $("body").append(ul);
            }

            $("li a", $(ul)).live("click", function () {
                val = $(this).attr("data-value");
                txt = $(this).html();
                select.val(val);
                $("span.dropdown-input", obj).html(txt);
                $(ul).remove();
            });

            $(document).click(function () { $(ul).remove(); });
        });
    }
});

$(document).ready(function () {
    $("a.dropdown").live("click", function () { $(this).dropdown() });

    $("a.com_dropdown").live("click", function () { $(this).dropdown() });

    $("a.k_opt_drop").live("click", function () { $(this).dropdown() });


    //流程新建
    $("a.flow_dropdown").live("click", function () { $(this).dropdown() });

    $("a.sheet_td_dropdown").live("click", function () { $(this).dropdown() });
});

/*************************************************************************************************************/

/** 简易版下拉框 **********************************************************************************************************/
//下拉框
$(function () {
    $("a.viewlist_dropdown").click(function () {
        var obj = $(this);
        var top = obj.offset().top;
        var left = obj.offset().left;
        var height = obj.height();
        var width = obj.width();
        var ul = $(".viewlist_droplist");
        if (ul.css("display") == "block") { ul.css("display", "none"); }
        else {
            $(ul).css({ display: "block", position: "absolute", left: 0, top: height, width: width });
        }
    });

    $(".viewlist_droplist li").click(function () {
        val = $(this).attr("data-value");
        txt = $(this).html();
        $("a.viewlist_dropdown span.dropdown-input").html(txt);
        $(".viewlist_droplist").css("display", "none");
    });
});
/************************************************************************************************************/

/** 文本框焦点 ********************************************************************************************/
$(document).ready(function () {
    $(":input").focus(function () {
        if ($(this).val() == this.defaultValue) {
            $(this).val("");
        }
    }).blur(function () {
        if ($(this).val() == '') {
            $(this).val(this.defaultValue);
        }
    });
})

/*************************************************************************************************************/



/** 智能浮动 *****************************************************************************************************/
//文档列表查看
$.fn.smartFloat = function () {
    var position = function (element) {
        var top = element.position().top, pos = element.css("position");
        alert(pos);
        $(window).scroll(function () {
            var scrolls = $(this).scrollTop();
            if (scrolls > top) { //如果滚动到页面超出了当前元素element的相对页面顶部的高度
                if (window.XMLHttpRequest) { //如果不是ie6
                    element.css({
                        position: "fixed",
                        top: 0
                    });
                } else { //如果是ie6
                    element.css({
                        top: scrolls
                    });
                }
            } else {
                element.css({
                    position: pos,
                    top: top
                });
            }
        });
    };
    return $(this).each(function () {
        position($(this));
    });
};

$(function () {
    //$(".lui_common_list_4_headerL").smartFloat().css("width", "792px");
});

/************************************************************************************************************/



/** 日历新增共享 *****************************************************************************************************/
$(document).ready(function () {
    $("#calendarDetail").hide();
    $("#calendarNote").hide();

    $("#btnCalendar").click(function () {
        $("#calendar").fadeOut(300);
        $("#calendarDetail").fadeIn(400);
    });
    $("#tabNote").click(function () {
        $("#calendar").fadeOut(300);
        $("#calendarNote").fadeIn(400);
    });

    $(".s_c_warn").click(function () {
        var warnItem = "<div class='s_c_itemBox clrfix'><div class='label'>&nbsp;</div><div class='input_box clrfix'><select class='s_c_select w80'><option>电子邮件</option><option>手机短信</option><option>人工提醒</option></select><input class='s_c_input w35' type='text' value='60' /><select class='s_c_select w70'><option>分钟</option><option>小时</option></select><div class='s_c_btn_1'></div></div></div>";

        $(this).parents("div.s_c_itemBox").prepend(warnItem);
    });




    $('div.s_c_itemBox').bind('click', function (evt) {
        var $target = $(evt.target);

        if ($target.attr('class') == 's_c_btn_1') {
            $target.parent().parent().remove();

        }
    });




});

/*****************************************************************************************************************/

/** 日历 **************************************************************************************************************/
function DateLinkMapping(date, link) {
    this.Date = date;
    this.Link = link;
}
var Calendar = {
    settings:
            {
                firstDayOfWeek: 1,
                baseClass: "calendar",
                curDayClass: "curDay",
                prevMonthCellClass: "prevMonth",
                nextMonthCellClass: "nextMonth",
                curMonthNormalCellClass: "",
                prevNextMonthDaysVisible: true
            },
    containerId: "",
    weekDayNames: [],
    dateLinkMappings: [],
    Init: function (weekDayNames, dateLinkMappings, settings) {
        if (!weekDayNames || weekDayNames.length && weekDayNames.length != 7) {
            this.weekDayNames[1] = "周一";
            this.weekDayNames[2] = "周二";
            this.weekDayNames[3] = "周三";
            this.weekDayNames[4] = "周四";
            this.weekDayNames[5] = "周五";
            this.weekDayNames[6] = "周六";
            this.weekDayNames[7] = "周日";
        }
        else {
            this.weekDayNames = weekDayNames;
        }
        if (dateLinkMappings) {
            this.dateLinkMappings = dateLinkMappings;
        }
    },
    RenderCalendar: function (divId, month, year) {
        this.containerId = divId;
        var ht = [];

        ht.push("<table class='", this.settings.baseClass, "' cellspacing='0' cellpadding='0' border='0'>");
        ht.push(this._RenderTitle(month, year));
        ht.push(this._RenderBody(month, year));
        ht.push("</table>");

        document.getElementById(divId).innerHTML = ht.join("");
        this._InitEvent(divId, month, year);
    },
    _RenderTitle: function (month, year) {
        var ht = [];
        //日期
        ht.push("<tr>");
        ht.push("<th colspan='7'><div class='calendar_header'><div class='calendar_date'><span class='", this.containerId, "_prevMonth' id='", this.containerId, "_prevMonth' title='上一月'></span><span>", year, "-", month, "</span><span class='", this.containerId, "_nextMonth' id='", this.containerId, "_nextMonth' title='下一月'></span></div><div class='to_today'>回今天</div></></th>");
        ht.push("</tr>");
        //星期
        ht.push("<tr>");
        for (var i = 0; i < 7; i++) {
            var day = (i + this.settings.firstDayOfWeek) == 7 ? 7 : (i + this.settings.firstDayOfWeek) % 7;
            ht.push("<th class='calendar_headTh'>", this.weekDayNames[day], "</th>")
        }
        ht.push("</tr>");
        return ht.join("");
    },
    _RenderBody: function (month, year) {
        //debugger;
        var date = new Date(year, month - 1, 1);
        var day = date.getDay();
        var dayOfMonth = 1;
        var daysOfPrevMonth = (7 - this.settings.firstDayOfWeek + day) % 7;
        var totalDays = this._GetTotalDays(month, year);
        var totalDaysOfPrevMonth = this._GetToalDaysOfPrevMonth(month, year);
        var ht = [];
        var curDate;

        for (var i = 0; ; i++) {
            curDate = null;
            if (i % 7 == 0) {//新起一行
                ht.push("<tr>");
            }
            ht.push("<td");
            if (i >= daysOfPrevMonth && dayOfMonth <= totalDays) {//本月
                curDate = new Date(year, month - 1, dayOfMonth);
                if (Date.parse(new Date().toDateString()) - curDate == 0) {
                    ht.push(" class='", this.settings.curDayClass, "'");
                }
                else {
                    ht.push(" class='", this.settings.curMonthNormalCellClass, "'");
                }
                dayOfMonth++;

            }
            else if (i < daysOfPrevMonth) {//上月
                if (this.settings.prevNextMonthDaysVisible) {
                    var prevMonth = month;
                    var prevYear = year;
                    if (month == 1) {
                        prevMonth = 12;
                        prevYear = prevYear - 1;
                    }
                    else {
                        prevMonth = prevMonth - 1;
                    }
                    curDate = new Date(prevYear, prevMonth - 1, totalDaysOfPrevMonth - (daysOfPrevMonth - i - 1));

                    ht.push(" class='", this.settings.prevMonthCellClass, "'");
                }
            }
            else {//下月
                if (this.settings.prevNextMonthDaysVisible) {
                    var nextMonth = month;
                    var nextYear = year;
                    if (month == 12) {
                        nextMonth = 1;
                        nextYear = prevYear + 1;
                    }
                    else {
                        nextMonth = nextMonth + 1;
                    }
                    curDate = new Date(nextYear, nextMonth - 1, i - dayOfMonth - daysOfPrevMonth + 2);
                    ht.push(" class='", this.settings.nextMonthCellClass, "'");
                }
            }
            ht.push(">");
            ht.push(this._BuildCell(curDate));
            ht.push("</td>");
            if (i % 7 == 6) {//结束一行
                ht.push("</tr>");
            }
            if (i % 7 == 6 && dayOfMonth - 1 >= totalDays) {
                break;
            }
        }
        return ht.join("");
    },
    _BuildCell: function (curDate) {
        //debugger;
        var ht = [];
        if (curDate) {
            for (var j = 0; j < this.dateLinkMappings.length; j++) {
                if (Date.parse(this.dateLinkMappings[j].Date) - curDate == 0) {
                    ht.push("<a href='", this.dateLinkMappings[j].Link, "'>", curDate.getDate(), "</a>");
                    break;
                }
            }
            if (j == this.dateLinkMappings.length) {
                ht.push(curDate.getDate());
            }
        }
        else {
            ht.push("&nbsp;");
        }
        return ht.join("");
    },
    _InitEvent: function (divId, month, year) {
        //debugger;
        var t = this;

        document.getElementById(this.containerId + "_prevMonth").onclick = function () {
            if (month == 1) {
                month = 12;
                year = year - 1;
            }
            else {
                month = month - 1;
            }

            t.RenderCalendar(divId, month, year);
        };
        document.getElementById(this.containerId + "_nextMonth").onclick = function () {
            if (month == 12) {
                month = 1;
                year = year + 1;
            }
            else {
                month = month + 1;
            }

            t.RenderCalendar(divId, month, year);
        };
    },
    //计算指定月的总天数
    _GetTotalDays: function (month, year) {
        if (month == 2) {
            if (this._IsLeapYear(year)) {
                return 29;
            }
            else {
                return 28;
            }
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        }
        else {
            return 31;
        }
    },
    _GetToalDaysOfPrevMonth: function (month, year) {
        if (month == 1) {
            month = 12;
            year = year - 1;
        }
        else {
            month = month - 1;
        }
        return this._GetTotalDays(month, year);
    },
    //判断是否是闰年
    _IsLeapYear: function (year) {
        return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
    }
};

/*****************************************************************************************************************/








