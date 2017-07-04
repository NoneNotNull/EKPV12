define(	["dojo/_base/declare" , "dojo/dom-class", "mui/iconUtils" , "mui/category/CategoryItemMixin" , "mui/util"],
		function(declare, domClass, iconUtils, CategoryItemMixin, util) {
			var item = declare("mui.address.AddressItemMixin", [CategoryItemMixin ], {

				buildRendering:function(){
					this.inherited(arguments);
				},
				
				//获取分组标题信息
				getTitle:function(){
					if( this.label=='2' ){
						return "组织";
					}
					if(this.label=='4'){
						return "岗位";
					}
					return this.label;
				},
				
				//是否显示往下一级
				showMore : function(){
					if((this.type | window.ORG_TYPE_ORGORDEPT) ==  window.ORG_TYPE_ORGORDEPT){
						return true;
					}
					return false;
				},
				
				//是否显示选择框
				showSelect:function(){
					var pWeiget = this.getParent();
					if(pWeiget && ((pWeiget.selType & this.type) ==  this.type)){
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
						iconUtils.setIcon(util.formatUrl(this.icon), null,
								this._headerIcon, null, iconNode);
					}else{
						if((this.type | window.ORG_TYPE_ORGORDEPT) ==  window.ORG_TYPE_ORGORDEPT){
							this.icon = "mui mui-group muiAddressDept"; 
						}
						if((this.type | window.ORG_TYPE_POST) ==  window.ORG_TYPE_POST){
							this.icon = "mui mui-post muiAddressPost"; 
						}
						iconUtils.setIcon(this.icon, null,
								this._headerIcon, null, iconNode);
					}
				}
			});
			return item;
		});