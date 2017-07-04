define( [ "dojo/_base/declare", "dojo/dom-style", "dojo/dom-class", "dijit/_WidgetBase",
		"dijit/_Contained", "dijit/_Container", "dojo/_base/array","dojo/_base/lang" ], 
	function(declare, domStyle, domClass, WidgetBase, Contained, Container, array, lang) {
	var header = declare("mui.header.Header", [ WidgetBase, Container,
			Contained ], {
		//默认自适应
		width : "100%",

		height : "",

		baseClass : "muiHeader",

		buildRendering : function() {
			this.inherited(arguments);
			if (this.width != '100%') {
				domStyle.set(this.domNode,{"width" : this.width});
			}
			if (this.height != '') {
				domStyle.set(this.domNode,{"height" : this.height});
			}
		},
		//加载
		startup : function() {
			this.inherited(arguments);
			this.changeChildDisplay();
		},

		//子对象处理
		changeChildDisplay : function() {
			array.forEach(this.getChildren(), lang.hitch(this,function(_weiget) {
				if(_weiget && _weiget.domNode){
					domClass.add( _weiget.domNode,"muiHeaderItem");
				}
			}));
		}
	});
	return header;
});