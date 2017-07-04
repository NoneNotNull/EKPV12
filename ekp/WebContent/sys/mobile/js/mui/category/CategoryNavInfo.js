define( [ "dojo/_base/declare", "dijit/_WidgetBase" , "dojo/_base/array", "dojo/dom", "dojo/dom-construct" ,
          "dojo/dom-style" , "dojo/topic" , "mui/dialog/Tip" ], function(declare,
		WidgetBase, array, dom, domConstruct, domStyle, topic , Tip) {
			var navInfo = declare("mui.category.CategoryNavInfo", [ WidgetBase], {
				
				baseClass : 'muiCateNavInfo',
				
				key : null, 
				
				top : null,
					
				buildRendering : function() {
					this.inherited(arguments);
					this.cateContainer = domConstruct.create("div",{className:"muiCateContainer"},this.domNode);
					this.titleNode = domConstruct.create('div', {
							'className' : 'muiCateName muiCateTitle'
							}, this.cateContainer);
					domStyle.set(this.domNode,{display:'none'});
				},

				postCreate : function() {
					this.inherited(arguments);
					this.subscribe("/mui/category/navChange","_changeNavInfo");
					this.subscribe("/mui/search/submit",function(){
						domStyle.set(this.domNode,{top:'0px'});
					});
					this.subscribe("/mui/search/cancel",function(){
						domStyle.set(this.domNode,{top:this.top});
					});
				},
				
				startup : function() {
					if (this._started) {
						return;
					}
					this.inherited(arguments);
					if(!this.top){
						var prvNode = this.getPrevNode(this.domNode);
						if(prvNode){
							this.top = prvNode.offsetHeight + "px";
						}else{
							this.top = "0px";
						}
					}
					domStyle.set(this.domNode,{top:this.top});
				},
				
			    getPrevNode: function(node) {
		            var tempFirst = node.parentNode.firstChild;
		            if (node == tempFirst) return null;
		            var tempObj = node.previousSibling;
		            while (tempObj.nodeType != 1 && tempObj.previousSibling != null) {
		                tempObj = tempObj.previousSibling;
		            }
		            return (tempObj.nodeType==1)? tempObj:null;
		        },    
				
				_changeNavInfo:function(srcObj,evt){
					if(srcObj.key == this.key){
						if(evt){
							this.titleNode.innerHTML = evt.label;
							domStyle.set(this.domNode,{display:'block'});
						}else{
							this.titleNode.innerHTML = '';
							domStyle.set(this.domNode,{display:'none'});
						}
					}
				}
			});
			return navInfo;
});