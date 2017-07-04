define( [ "dojo/_base/declare","dojox/mobile/ScrollableView", "dojo/dom-style", "dojo/ready"],
		function(declare, ScrollableView, domStyle, ready) {
	
	return declare("mui.table.ScrollableHView", [ScrollableView], {
		
		scrollDir:'h',
		
		height:'100%',
		
		scrollBar:false,
		
		buildRendering : function() {
			this.inherited(arguments);
			var _self = this;
			ready(function(){
				_self.resize();
			});
		},
		
		postCreate : function() {
			this.inherited(arguments);
			this.subscribe("/mui/list/resize","resize");
		},
		
		resize : function() {
			var arguH  = this.containerNode.offsetHeight;
			var parentW = this.getParent();
			if(parentW && parentW.resizeH){
				parentW.resizeH(arguH);
			}
			this.inherited(arguments);
		}
	});
});