define([
    "mui/tabbar/TabBarButton",
	"dojo/_base/declare",
	"mui/form/_CategoryBase",
	"dojo/dom-construct",
	"mui/util",
	"mui/dialog/Tip"
	], function(TabBarButton, declare, CategoryBase, domConstruct, util, Tip) {
	
	return declare("mui.tabbar.CreateButton", [TabBarButton, CategoryBase], {
		icon1 : "mui mui-create",
		
		key : '_cateSelect',
		
		createUrl:'',
		
		buildRendering:function(){
			this.inherited(arguments);
		},
		
		postCreate : function() {
			this.inherited(arguments);
			this.eventBind();
		},
		
		_onClick : function(evt) {
			this.defer(function(){
				this._selectCate();
			}, 350);
		},
		
		afterSelectCate:function(evt){
			var process = Tip.processing();
			process.show();
			this.defer(function(){
				window.open(util.formatUrl(util.urlResolver(this.createUrl, evt)),"_self");
				process.hide();
			},300);
		},
		
		returnDialog:function(srcObj , evt){
			this.inherited(arguments);
			if(srcObj.key == this.key){
				this.afterSelectCate(evt);
			}
		}
	});
});