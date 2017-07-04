/**
 * 分类查询父类
 * 具体实现类:
 * 		mui.simplecategory.SimpleCategoryDialogMixin（简单分类）
 * 		mui.syscategory.SysCategoryDialogMixin（全局分类）
 */
define( [ "dojo/_base/declare", "mui/form/_CategoryBase",  "mui/util"],
		function(declare, CategoryBase, util) {
			var category = declare("mui.query._CategoryQueryDialogMixin", [CategoryBase], {
				filterURL:null,
				
				redirectURL: null,
				
				postCreate : function() {
					this.inherited(arguments);
					this.eventBind();
				},
			
				show:function(refHeight){
					this._selectCate();
				},
				
				_formatParam:function(){
					var url = location.href;
					if(this.redirectURL){
						this.curNames = encodeURIComponent(this.curNames);
						url =  util.formatUrl(util.urlResolver(this.redirectURL,this));
					}
					return util.setUrlParameter(url,"queryStr",util.urlResolver(this.filterURL,this));
				},
				
				returnDialog:function(srcObj , evt){
					this.inherited(arguments);
					if(srcObj.key == this.key){
						window.open(this._formatParam(),'_self');
						this._set('curIds', '');
						this._set('curNames', '');
					}
				}
			});
			return category;
	});