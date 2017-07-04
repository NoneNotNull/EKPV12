define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/_base/lang",
		"dojo/dom-class", "dojo/dom-construct", "dojo/dom-style",
		"mui/dialog/_DialogBase", "dojo/html", "dojo/dom-geometry" ], function(
		declare, WidgetBase, lang, domClass, domConstruct, domStyle,
		_DialogBase, html, domGeometry) {
	var claz = declare('mui.dialog.Smoke', [ _DialogBase ], {

		icon : null,
		time : 500,
		callback : null,
		// 方向
		direction : 'up',
		// 触发对象，dom
		target : null,
		// 触发位置,{x:'',y:''}，跟target2选1
		pos : null,

		buildRendering : function() {
			this.containerNode = domConstruct.create('div', {
				className : this.icon
			}, document.body, 'last');
			this.inherited(arguments);
		},

		show : function() {
			var pos;
			if (this.pos)
				pos = this.pos;
			else if (this.target)
				pos = domGeometry.position(this.target, true);
			var x = pos.x, y = pos.y, h = pos.h;
			domStyle.set(this.containerNode, {
				position : 'absolute',
				top : y + 'px',
				left : x + 'px'
			});
			var isUp = this.direction == 'up';
			isUp ? this._show1() : this._show2();
			this.inherited(arguments);
			setTimeout(lang.hitch(this, this.hide), 800);
		},

		_show1 : function() {
			domClass.add(this.containerNode, 'muiDialogSmokeUp');
		},

		_show2 : function() {
			domClass.add(this.containerNode, 'muiDialogSmokeDown');
		},

		hide : function() {
			if (this.callback)
				this.callback.call();
			this.inherited(arguments);
			this.destroy();
		}
	});

	return {
		smoke : function(options) {
			return new claz(options).show();
		}
	};

})