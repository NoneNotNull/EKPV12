define( [ "dojo/_base/declare", "dojox/mobile/_ItemBase", "dojo/dom-construct", "dojo/dom-style", "mui/util", "mui/folder/_Folder"], 
		function(declare, ItemBase, domConstruct, domStyle, util, Folder) {
		return declare("mui.query.QueryList", [ ItemBase , Folder],{
			
				baseClass : 'muiQueryListItem',
				
				icon : null ,
				
				label : '',
					
				buildRendering:function(){
					this.inherited(arguments);
					this.itemR = domConstruct.create("div",{className:'muiQueryListItemR'},this.containerNode);
					this.iconDiv = domConstruct.create("div",{
							className: "muiQueryListItemIcon"}, this.itemR);
					if(this.icon){
						domConstruct.create("i",{
								className : this.icon
							}, this.iconDiv);
					}
					domConstruct.create("div",{
							className: "muiQueryListItemLabel",
							innerHTML: this.label}, this.itemR);
					domConstruct.create("div",{className:'muiQueryListItemL'},this.containerNode);
				},
				
		
				startup:function(){
					this.inherited(arguments);
					this.referOffesetTop = this.getParent().get('topHeight');
				},
				
				show:function(evt){
					this.inherited(arguments);
				},
				
				setStyle:function(style){
					domStyle.set(this.domNode,style);
				},
				
				_setLabelAttr:function(label){
					this._set("label",label);
				}
		});
});