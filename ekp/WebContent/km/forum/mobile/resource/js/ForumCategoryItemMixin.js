define(	["dojo/_base/declare" , "dojo/dom-class", "mui/iconUtils" , "mui/simplecategory/SimpleCategoryItemMixin"],
		function(declare, domClass, iconUtils, SimpleCategoryItemMixin) {
			var item = declare("km.forum.mobile.resource.js.ForumCategoryItemMixin", [SimpleCategoryItemMixin], {

				buildRendering:function(){
					this.inherited(arguments);
					this.type = this.nodeType=="CATEGORY"?window.SIMPLE_CATEGORY_TYPE_CATEGORY:1;
				},
				
				//是否显示往下一级
				showMore : function(){
					return true;
				},
				
				//是否显示选择框
				showSelect:function(){
					if(this.type==window.SIMPLE_CATEGORY_TYPE_CATEGORY){
						return true;
					}
					return false;
				}
			});
			return item;
		});