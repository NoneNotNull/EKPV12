define( [ "dojo/_base/declare", "dojox/mobile/_ItemBase","dojo/dom-style"], 
		function(declare,_ItemBase, domStyle) {

	return declare("mui.header.HeaderItem", [ _ItemBase ], {

		icon : null,

		baseClass : 'muiHeaderItem',
		
		label: null,
		
		referListId:null,
		
		buildRendering : function() {
			if(this.icon){
				this.baseClass = this.baseClass + " " + this.icon;
			}
			this.inherited(arguments);
		},
		
		postCreate : function() {
			this.inherited(arguments);
			this.subscribe("/mui/list/loaded","refreshLabel");
		},
		
		refreshLabel:function(evts){
			if(evts && evts.id==this.referListId && this.label){
				if(evts.totalSize)
					this.domNode.innerHTML = this.label + "("+ evts.totalSize +")";
			}
		},
		
		startup:function(){
			this.inherited(arguments);
			if (this.domNode.parentNode) {
				var h = this.domNode.parentNode.style.height;
				var styleVar =  {
						'height':h,
						'line-height' : h
					};
				domStyle.set(this.domNode, styleVar);
			}
		},
		
		_setLabelAttr:function(label){
			if(this.label){
				this.domNode.innerHTML = this.label;
			}
		}
		
	});
});
