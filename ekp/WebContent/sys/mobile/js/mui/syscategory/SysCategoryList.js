define( [ "dojo/_base/declare", "dojo/_base/lang", "mui/category/CategoryList" ], function(declare,
		 lang, CategoryList) {
	return declare("mui.syscategory.SysCategoryList", [ CategoryList ], {
		
		modelName : null,
		
		//有权限查看的类别id
		authCateIds : null,
		
		//数据请求URL
		dataUrl : '/sys/category/mobile/sysCategory.do?method=cateList&categoryId=!{parentId}&getTemplate=!{selType}&modelName=!{modelName}&authType=!{authType}',
			
		buildQuery:function(){
			var params = this.inherited(arguments);  
			return lang.mixin(params , {
				authCateIds : this.authCateIds
			});
		}
	});
});