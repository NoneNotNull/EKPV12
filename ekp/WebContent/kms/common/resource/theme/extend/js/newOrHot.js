// JavaScript Document
/* 最新、最热 */
(function($) {
		$.fn.imgHover = function(option) {
        var s = $.extend({
            delay: 100,
            current: "hover"
        }, option || {});
        $.each(this, function() {
            var timer1 = null, timer2 = null, flag = false;
            //if ($(this).find('.mask_img').length > 0) {
                $(this).bind("mouseover", function() {
                    if (flag) {
                        clearTimeout(timer2);
                    } else {
                        var _this = $(this);
                        timer1 = setTimeout(function() {
                            _this.addClass(s.current);
                            flag = true;
                        }, s.delay);
                    }
                }).bind("mouseout", function() {
                    if (flag) {
                        var _this = $(this);
                        timer2 = setTimeout(function() {
                            _this.removeClass(s.current);
                            flag = false;
                        }, s.delay);
                    } else {
                        clearTimeout(timer1);
                    }
                });
				$(this).find('li').bind("mouseover", function() {
					clearTimeout(timer1);
                    clearTimeout(timer2);
										var _this = $(this);
										_this.addClass('on').siblings().removeClass('on');
										
                });	
				var liWidth = $(this).find('li').width();
				var len = $(this).find('li').length;
				$(this).find('.imgLists').width(liWidth*len);
				var l = $(this).find('.imgLists').css("left");
				var index = 0;
				$(this).find('.pre').bind("click",function(){
					if(index > 0){
						leftMove(--index,this);
					}
				});	
				$(this).find('.next').bind("click",function(){
					if(index < len-8){
						rightMove(++index,this);
					}
										
				});	
				function leftMove(i,obj){
					$(obj).prev('.imgLists').stop(true,false).animate({left : -liWidth*i},200,"swing");
				}
				function rightMove(i,obj){
					$(obj).prevAll('.imgLists').stop(true,false).animate({left : -liWidth*i},200,"swing");
				}				
        });
		
     };
})(jQuery);

/* 图片列表  */
function move(){
	 $('.slideWrap').imgHover({current:"hover"});
}
