$(function() {
(function() {
		var scrollContent = $('#sidecatalog');
		var contentDiv = $('#contentDiv');
		var scrollDiv = $('#sideDiv');
		if (Com_Parameter.IE) {
			$(window).scroll(function() {
				var position = scrollContent.position(), divPosition = contentDiv
						.position(), scrollTop = $(window).scrollTop(), top;
				var scroll = function() {
					if (scrollContent.attr('top')) {
						top = scrollContent.attr('top');
					} else {
						top = position.top;
						scrollContent.attr('top', position.top);
					}
					scrollContent
							.css('top', (parseInt(top) + scrollTop + 'px'));
					scrollContent.attr('scroll', scrollTop);
					if (divPosition.top < scrollTop) {
						scrollDiv.css('visibility', 'visible');
					} else {
						scrollDiv.css('visibility', 'hidden');
					}
				};
				if ((position.top + scrollContent.height()) < (divPosition.top + contentDiv
						.height())) {
					scroll();
				} else if (scrollTop < scrollContent.attr('scroll')) {
					scroll();
				} else {
					scrollContent.css('top', (divPosition.top
									+ contentDiv.height() - scrollContent
									.height()));

				}
			});
		} else { // 非ie浏览器模式

			var s_l = parseInt($('#main').offset().left
					+ $('.content3').width())
					+ 20;
			$('#sidecatalog').css({
						'left' : s_l,
						'bottom' : 10
					});
			$('#side-catalog-content').css({
						'left' : parseInt($('#sidecatalog').css('left')) + 30,
						'bottom' : 48
					});

			$(window).scroll(function() {
				var position = scrollContent.position(), divPosition = contentDiv
						.position();
				// console.log(position.top);
				if ((position.top + scrollDiv.height()) > (divPosition.top - 10)) {
					scrollDiv.show();
					scrollContent.show();
				}
				// console.log(divPosition.top + "@@@@@@@@@");
				// console.log($(window).scrollTop() + "????????");
				if (divPosition.top > $(window).scrollTop()) {
					scrollDiv.hide();
				}
			});
		}
	})();
	// 引入样式--
	var thisScript;
	(function(script, me) {
		for (var i in script) {
			if (script[i].src && script[i].src.indexOf('catalogSlide') !== -1)
				thisScript = script[i];
		};
	}(document.getElementsByTagName('script'), thisScript));
	var link = document.createElement('link');
	link.rel = 'stylesheet';
	link.href = KMS.basePath + '/wiki/resource/catalogSlide/catalogSlide.css';
	thisScript.parentNode.insertBefore(link, thisScript);
})