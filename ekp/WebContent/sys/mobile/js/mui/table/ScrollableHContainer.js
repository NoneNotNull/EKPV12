define( [ "dojo/_base/declare", "dijit/_WidgetBase", "dijit/_Contained", "dijit/_Container", "dojo/dom-style"],
		function(declare, WidgetBase, Contained, Container, domStyle) {
	
	return declare("mui.table.ScrollableHContainer", [WidgetBase, Contained, Container], {

		buildRendering : function() {
			this.inherited(arguments);
		
		},
		startup : function() {
			this.inherited(arguments);
		},
		
		resizeH:function(h){
			if(h>0){
				domStyle.set(this.domNode,{'height': h + 'px'});
			}
		}
	});
});