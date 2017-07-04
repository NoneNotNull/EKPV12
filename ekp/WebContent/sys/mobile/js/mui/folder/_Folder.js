define( [ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-style", "dojo/dom-class", "dojo/touch"], 
		function(declare,WidgetBase, domStyle, domClass, touch) {

	return declare("mui.folder._Folder", null, {

		buildRendering : function() {
			this.inherited(arguments);
			domClass.add(this.domNode,"muiFolder");
		},
		
		postCreate : function() {
			this.inherited(arguments);
			this.connect(this.domNode, touch.press, "_onExpand");
		},
		
		_onExpand : function(evt) {
			this.defer( function() {
				if(this.defaultClickAction)
					this.defaultClickAction(evt);
				this.show(evt);
			}, 410);
			evt.preventDefault();
		},
		
		show:function(evt){
			
		}
	});
});
