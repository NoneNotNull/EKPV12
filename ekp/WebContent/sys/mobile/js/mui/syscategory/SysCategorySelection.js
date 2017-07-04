define([ "dojo/_base/declare", "mui/iconUtils",
				"mui/category/CategorySelection" ],
		function(declare, iconUtils, CategorySelection) {
			var selection = declare("mui.syscategory.SysCategorySelection",[ CategorySelection ],{

				modelName:null,
				
				//获取详细信息地址
				detailUrl : '/sys/category/mobile/sysCategory.do?method=detailList&cateId=!{curIds}&modelName=!{modelName}',

				buildIcon : function(iconNode, item) {
					iconUtils.setIcon("mui mui-file-text", null, null, null,
						iconNode);
				}
			});
			return selection;
		});