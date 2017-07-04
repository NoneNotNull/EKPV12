Com_RegisterFile("lightbox.js");
Com_IncludeFile("json2.js");

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
			zIndex : 2000
			// 层叠顺序
		};
	},
	// 显示
	Show : function() {

		with (this.Lay.style) {
			// 设置透明度
			opacity = this.Opacity / 100;
			backgroundColor = this.Color;
			display = "block";
			position = "fixed";
		}
		this.Lay.style.top ="0px";
		this.Lay.style.left ="0px";
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

	// 显示
	Show : function() {
		// 覆盖层

		this.Over && this.OverLay.Show();
		this.Box.style.display = "block";
		// 定位
		this.Box.style.position = "fixed";

		this.Box.style.top =  "50%";
		this.Box.style.left = "50%";
		this.onShow();  
		$(this.Box).css({'margin-top' : -$(this.Box).height()/2,'margin-left' : -$(this.Box).width()/2}) ; 
	
	},
	// 关闭
	Close : function() {
		this.Box.style.display = "none";
		this.OverLay.Close();
	}
};

