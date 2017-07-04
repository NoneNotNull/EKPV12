define( [ "dojo/_base/declare","dijit/_WidgetBase", "dojo/dom-style", "dojo/touch"],
		function(declare, WidgetBase, domStyle, touch) {
	
	return declare("mui.table.ScrollableHViewArea", [WidgetBase], {
		
	
		buildRendering : function() {
			this.inherited(arguments);
			domStyle.set(this.domNode,{
					'overflow-x':'auto',
					'overflow-y':'hidden'
				});
		},
		
		postCreate : function() {
			this.inherited(arguments);
			var scrollStartPosX = -1;
			this.connect(this.domNode, touch.press, function(e){
				scrollStartPosX = this.domNode.scrollLeft + e.pageX;
				e.preventDefault();
			});
			this.connect(this.domNode, touch.move, function(e){
				if(scrollStartPosX != -1){
					var pos = (scrollStartPosX - e.pageX);
					this.domNode.scrollLeft = pos;
				}
				e.preventDefault();
			});
		},
		
		startup : function() {
			this.inherited(arguments);
		}
	});
});