define(	["dojo/_base/declare" , "dojo/dom-class", "mui/iconUtils" , "mui/category/CategoryItemMixin"],
		function(declare, domClass, iconUtils, CategoryItemMixin) {
			var item = declare("mui.simplecategory.SimpleCategoryItemMixin", [CategoryItemMixin], {

				buildRendering:function(){
					this.fdId = this.value;
					this.label = this.text;
					this.icon  = 'mui mui-file-text';
					this.type = window.SIMPLE_CATEGORY_TYPE_CATEGORY;
					this.inherited(arguments);
				},
				
				getTitle:function(){
					return this.label;
				},
				
				//是否显示往下一级
				showMore : function(){
					if(this.type == window.SIMPLE_CATEGORY_TYPE_CATEGORY){
						return true;
					}
					return false;
				},
				
				//是否显示选择框
				showSelect:function(){
					var pWeiget = this.getParent();
					if(pWeiget && pWeiget.selType==this.type){
						return true;
					}
					return false;
				},
				
				//是否选中
				isSelected:function(){
					var pWeiget = this.getParent();
					if(pWeiget && pWeiget.curIds && (pWeiget.curIds.indexOf(this.fdId)>-1)){
						return true;
					}
					return false;
				},
				
				buildIcon:function(iconNode){
					if(this.icon){
						iconUtils.setIcon(this.icon, null,
								this._headerIcon, null, iconNode);
					}
				}
			});
			return item;
		});