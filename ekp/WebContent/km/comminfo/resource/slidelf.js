(function ($) {
    $.fn.extend({
        "slidelf": function (value) {
            value = $.extend({
                "prev": "",
                "next": "",
                "speed": "",
                "id": ""
            }, value)
            var dom_this = $(this).get(0); //将jquery对象转换成DOM对象;以便其它函数中调用；
            var marginl = parseInt($("ul li:first", this).css("margin-left")); //每个图片margin的数值
            var movew = $("ul li:first", this).outerWidth() + marginl; //需要滑动的数值

            //左边的动画
            function leftani() {
                //debugger;
                $("ul li:first", dom_this).animate({ "margin-left": -movew }, value.speed, function () {
                    $(this).css("margin-left", marginl).appendTo($("ul", dom_this));
                });
            }
            //右边的动画
            function rightani() {
                $("ul li:last", dom_this).prependTo($("ul", dom_this));
                $("ul li:first", dom_this).css("margin-left", -movew).animate({ "margin-left": marginl }, value.speed);
            }

            //点击左边
            $(value.id + " ." + value.prev).click(function () {
                if (!$("ul li:first", dom_this).is(":animated")) {
                    leftani();
                }
            });

            //点击左边
            $(value.id + " ." + value.next).click(function () {
                if (!$("ul li:first", dom_this).is(":animated")) {
                    rightani();
                }
            })
        }
    });
})(jQuery)