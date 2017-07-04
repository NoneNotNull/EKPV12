Com_RegisterFile("lightbox.js");

var isIE = (document.all) ? true : false;

var isIE6 = isIE && ([/MSIE (\d+)\.0/i.exec(navigator.userAgent)][0][1] == 6);

var isIE10 = isIE && ([/MSIE (\d+)\.0/i.exec(navigator.userAgent)][0][1] == 10);

var jessy = function(id) {
	return "string" == typeof id ? document.getElementById(id) : id;
};

var Class = {
	create : function() {
		return function() {
			this.initialize.apply(this, arguments);
		}
	}
};

var Bind = function(object, fun) {
	return function() {
		return fun.apply(object, arguments);
	};
};

var OverLay = Class.create();
OverLay.prototype = {
	initialize : function(options) {

		this.SetOptions(options);

		this.Lay = jessy(this.options.Lay)
				|| document.body.insertBefore(this.defaultLay(),
						document.body.childNodes[0]);

		this.Color = this.options.Color;
		this.Opacity = parseInt(this.options.Opacity);
		this.zIndex = parseInt(this.options.zIndex);

		with (this.Lay.style) {
			display = "none";
			zIndex = this.zIndex;
			left = top = 0;
			position = "absolute";
			width = height = "100%";
		}

	},

	defaultLay : function() {
		var lay = document.createElement('div');
		lay.setAttribute('id', 'boxdiv');
		return lay;
	},

	// 设置默认属性
	SetOptions : function(options) {
		this.options = {// 默认ֵ
			Lay : null,// 覆盖层对象
			Color : "#000",// 颜色
			Opacity : 30,// 透明度(0-100)
			zIndex : 1000
			// 层叠顺序
		};
	},
	// 显示
	Show : function() {

		with (this.Lay.style) {
			// 设置透明度
			isIE && !isIE10
					? filter = "alpha(opacity:" + this.Opacity + ")"
					: opacity = this.Opacity / 100;
			backgroundColor = this.Color;
			display = "block";
		}
		if (isIE6) {
			this.Lay.style.top = ($(document).scrollTop() + parseInt(($(document.body)[0].clientHeight - this.Lay.offsetHeight)
					/ 2))
					+ "px";
			this.Lay.style.left = ($(document).scrollLeft() + parseInt(($(document.body)[0].clientWidth - this.Lay.offsetWidth)
					/ 2))
					+ "px";
		} else if(isIE){
		    this.Lay.style.top = (document.documentElement.scrollTop + parseInt((document.documentElement.clientHeight - this.Lay.offsetHeight)
					/ 2))
					+ "px";
			this.Lay.style.left = (document.documentElement.scrollLeft + parseInt((document.documentElement.clientWidth - this.Lay.offsetWidth)
					/ 2))
					+ "px";
		}else {
			this.Lay.style.top = (document.body.scrollTop + parseInt((document.body.clientHeight - this.Lay.offsetHeight)
					/ 2))
					+ "px";
			this.Lay.style.left = (document.body.scrollLeft + parseInt((document.body.clientWidth - this.Lay.offsetWidth)
					/ 2))
					+ "px";
		}
	},
	// 关闭
	Close : function() {
		this.Lay.style.display = "none";
	}
};

var LightBox = Class.create();
LightBox.prototype = {
	initialize : function(box, options) {

		this.Box = jessy(box);// 显示层

		this.OverLay = new OverLay(options);// 覆盖层

		this.SetOptions(options);

		this.Over = !!this.options.Over;
		this.Center = !!this.options.Center;
		this.onShow = this.options.onShow;

		this.Box.style.zIndex = this.OverLay.zIndex + 1;
		this.Box.style.display = "none";
	},
	// 设置默认属性
	SetOptions : function(options) {
		this.options = {// 默认值
			Over : true,// 是否显示覆盖层
			Center : true,// 是否居中
			onShow : function() {
			}// 显示时执行
		};
	},

	// 兼容ie6的居中定位程序
	SetCenter : function() {

		this.Box.style.marginTop = $(document).scrollTop() - arguments[0] / 2
				+ "px";
		this.Box.style.marginLeft = $(document).scrollLeft() - arguments[1] / 2
				+ "px";
	},
	// 显示
	Show : function() {
		// 覆盖层

		this.Over && this.OverLay.Show();
		this.Box.style.display = "block";
		// 定位
		this.Box.style.position = "absolute";

		// 居中
		if(this.Center && isIE){
			var top = (document.documentElement.scrollTop + parseInt((document.documentElement.clientHeight - this.Box.offsetHeight)
					/ 2));
			var left = (document.documentElement.scrollLeft + parseInt((document.documentElement.clientWidth - this.Box.offsetWidth)
					/ 2));
			this.Box.style.top = top + "px";
			if (top < 0)
				this.Box.style.top = 0 + "px";
			this.Box.style.left = left + "px";
			if (left < 0)
				this.Box.style.left = 0 + "px";
			
		}else if (this.Center && !isIE6) {
			var top = (document.body.scrollTop + parseInt((document.body.clientHeight - this.Box.offsetHeight)
					/ 2));
			var left = (document.body.scrollLeft + parseInt((document.body.clientWidth - this.Box.offsetWidth)
					/ 2));
			this.Box.style.top = top + "px";
			if (top < 0)
				this.Box.style.top = 0 + "px";
			this.Box.style.left = left + "px";
			if (left < 0)
				this.Box.style.left = 0 + "px";
		} else {
			this.Box.style.top = "50%";
			this.Box.style.left = "50%";
		}
		if (isIE6) {
			this.SetCenter(arguments[0], arguments[1]);
		}
		this.onShow();
	},
	// 关闭
	Close : function() {
		this.Box.style.display = "none";
		this.OverLay.Close();
	}
};
