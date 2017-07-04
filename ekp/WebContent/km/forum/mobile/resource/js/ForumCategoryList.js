define( [ "dojo/_base/declare","mui/category/CategoryList" ], function(declare,
		CategoryList) {
	return declare("km.forum.mobile.resource.js.ForumCategoryList", [ CategoryList ], {
		
		modelName:null,
		
		//数据请求URL
		dataUrl : '/km/forum/mobile/kmForumMobileCategory.do?method=cateList&categoryId=!{parentId}&modelName=!{modelName}&authType=!{authType}'
			
	});
});