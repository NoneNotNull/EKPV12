define([ "dojo/_base/declare", "dijit/_WidgetBase", "dijit/_Contained",
		"dijit/_Container", "dojo/window", "dojo/_base/array",
		"dojo/dom-style", "dojo/dom-class" ], function(declare, WidgetBase,
		Contained, Container, win, array, domStyle, domClass) {
	return declare("mui.query.QueryList", [ WidgetBase, Contained, Container ],
			{

				baseClass : 'muiQueryList',

				// 距离手机顶部高度
				topHeight : 0,

				HIDE_EVENT : '/mui/folder/hide',

				SHOW_EVENT : '/mui/folder/show',
				
				startup : function() {
					this.subscribe(this.HIDE_EVENT, 'hide');
					this.subscribe(this.SHOW_EVENT, 'show');
					this.inherited(arguments);
					var childs = this.getChildren();
					var avgLen = this.domNode.offsetWidth / (childs.length)
							- childs.length + 1;
					array.forEach(childs, function(child) {
						if (child && child.setStyle) {
							child.setStyle({
								width : avgLen + 'px'
							});
						}
					}, this);
				},
				
				show : function() {
					var childs = this.getChildren();
					var time = 80, times = 400, tim = 400;
					array.forEach(childs, function(child) {
						if (child && child.itemR) {
							this.defer(function() {
								domClass.add(child.itemR, 'muiQueryScale');
								this.defer(function() {
									domClass.remove(child.itemR,
											'muiQueryScale');
									domClass.add(child.itemR,
											'muiQueryListItemROn');
								}, tim);
							}, times);
							times += time;
						}
					}, this);
				},

				hide : function() {
					var childs = this.getChildren(), len = childs.length;
					var time = 80, times = time * len, tim = 400;
					array.forEach(childs, function(child) {
						if (child && child.itemR) {
							this.defer(function() {
								domClass.add(child.itemR, 'muiQueryScaled');
								this.defer(function() {
									domClass.remove(child.itemR,
											'muiQueryScaled');
									domClass.remove(child.itemR,
											'muiQueryListItemROn');
								}, tim);
							}, times);
							times -= time;
						}
					}, this);
				}
			});
});