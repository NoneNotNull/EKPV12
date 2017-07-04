define( [ "dojo/_base/declare", "dijit/_Contained", "dijit/_Container",
		"dijit/_WidgetBase", "dojo/_base/lang", "dojo/dom-class",
		"dojo/dom-construct", "dojo/dom-style",  "dojo/_base/array"], function(declare, Contained,
		Container, WidgetBase, lang, domClass, domConstruct, domStyle, array) {
	return declare("mui.top.Top", [ WidgetBase, Container, Contained ], {

		bottom : '60px',

		right : '5px',

		// 当前是否显示
		_show : false,

		buildRendering : function() {
			this.inherited(arguments);
			if (!this.containerNode)
				this.containerNode = this.domNode;
			domClass.replace(this.containerNode, "muiTop");
			domStyle.set(this.domNode, {
				bottom : !this.bottom ? "60px" : this.bottom,
				right : !this.right ? "60px" : this.right
			});
			this.topNode = domConstruct.create('i', {
				className : 'mui mui-up-n'
			}, this.domNode);
		},

		startup : function() {
			if (this._started)
				return;
			this.inherited(arguments);
		},

		postCreate : function() {
			this.connect(this.domNode, "onclick", '_onClick');
			this.connectToggle();
			this.subscribe("/dojox/mobile/viewChanged,/dojox/mobile/afterTransitionIn", function(view) {
				this.hide();
				if (view._v && view.toTop) {
					if (view.getPos().y < -5) {
						this.show();
					}
				} else {
					array.forEach(view.getChildren(), function(child) {
						if (child._v && child.toTop) {
							if (child.getPos().y < -5) {
								this.show();
							}
							return false;
						}
					}, this);
				}
			});
		},

		_onClick : function(evt) {
			this.toTop(evt);
		},

		show : function() {
			domStyle.set(this.domNode, {
				display : 'block'
			});
			this.set('_show', true);
		},

		hide : function() {
			domStyle.set(this.domNode, {
				display : 'none'
			});
			this.set('_show', false);
		},

		// 以下mixin实现

		// 置顶实现
		toTop : function(evt) {
		},
		// 显示隐藏切换
		connectToggle : function() {
		}

	});
});
