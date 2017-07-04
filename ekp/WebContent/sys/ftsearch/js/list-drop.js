// JavaScript Document
// 马泽棉 2013-05-20
//xiex 2013-5-22

// 共同部分 列表的下拉显示与上拉隐藏 效果
$(document).ready(function () {
    $("div.lui_common_list_box .lui_common_list_2_header_left").toggle(function () {
        $(this).find(".list_down_icon").attr("class", "list_up_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom","1px");
    }, function () {
        $(this).find(".list_up_icon").attr("class", "list_down_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom","0px");
    });
	
    $("div.lui_common_list_box .lui_common_list_3_header_left").toggle(function () {
        $(this).find(".list_down_icon").attr("class", "list_up_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom","1px");
    }, function () {
        $(this).find(".list_up_icon").attr("class", "list_down_icon");
        $(this).next(".lui_common_list_main_body").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
        $(this).parents(".lui_common_list_box").css("margin-bottom","0px");
    });
});

// 共同部分 列表的下拉显示与上拉隐藏 效果
/*$(document).ready(function () {
    $("div.list_menu h4").toggle(function () {
        $(this).children("span").attr("class", "list_down_icon");
        $(this).next(".list_menuBody").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    }, function () {
        $(this).children("span").attr("class", "list_up_icon");
        $(this).next(".list_menuBody").animate({ height: 'toggle', opacity: 'toggle' }, "slow");
    });
});*/



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

