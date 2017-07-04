define( [ "dojo/_base/declare","mui/category/CategoryList","dojo/_base/lang"], function(declare,
		CategoryList, lang) {
	return declare("mui.simplecategory.SimpleCategoryList", [ CategoryList ], {
		
		modelName:null,
		
		authCateIds : null,
		
		//数据请求URL
		dataUrl : '/sys/category/mobile/sysSimpleCategory.do?method=cateList&categoryId=!{parentId}&getTemplate=!{selType}&modelName=!{modelName}&authType=!{authType}',
		
		buildQuery:function(){
			var params = this.inherited(arguments);
			return lang.mixin(params , {
				authCateIds : this.authCateIds
			});
		}
			
	});
});