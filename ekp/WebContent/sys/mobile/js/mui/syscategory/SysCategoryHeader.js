define( [ "dojo/_base/declare", "mui/category/CategoryHeader"], function(declare,CategoryHeader) {
		var header = declare("mui.syscategory.SysCategoryHeader", [ CategoryHeader], {
				
				modelName: null ,
				
				title:"分类选择",
				
				//获取详细信息地址
				detailUrl : '/sys/category/mobile/sysCategory.do?method=detailList&cateId=!{curId}&modelName=!{modelName}'
			});
			return header;
});