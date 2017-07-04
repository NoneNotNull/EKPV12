(function(jQuery) {

	var Slider = EventTarget.extend({
		constructor : function(container, options) {
			this.options = {
				speed : 300
			}, this.container = jQuery('.' + container);
			this.sliderBox = jQuery(["<li class='", "sliderBox", "'> ", "</li>"]
					.join('')).appendTo(this.container);
			this.init();
		},

		// 初始话队列
		init : function() {
			this.loadStyle();
			var that = this;
			var lis = jQuery('li', this.container);
			lis.not(".sliderBox").hover(function() {
						that.slidering(this);
					}, function() {
					});
			that.container.bind('mouseleave', function() {
						that.sliderBox.stop();
						that.sliderBox.width('0px');
					});
		},

		// 滑动动作
		slidering : function(obj) {
			this.sliderBox.dequeue().animate({
						width : obj.offsetWidth,
						left : obj.offsetLeft
					}, this.options.speed);
		},

		// 无阻塞引入样式表
		loadStyle : function() {
			var thisScript;
			(function(script, me) {
				for (var i in script) {
					if (script[i].src
							&& script[i].src.indexOf('kms_slider') !== -1)
						thisScript = script[i];
				};
			}(document.getElementsByTagName('script'), thisScript));
			var link = document.createElement('link');
			link.rel = 'stylesheet';
			link.href = KMS.themePath + '/navSlider/navSlider.css';
			thisScript.parentNode.insertBefore(link, thisScript);
		}
	})
	KMS.Slider = Slider;
})(jQuery)

$(function() {
			new KMS.Slider('silderNav', {
						speed : 10
					});
		});
