define( [ "dojo/_base/declare", "mui/query/_CategoryQueryDialogMixin",
		"mui/syscategory/SysCategoryMixin" ], function(declare,
		CategoryQueryDialogMixin, SysCategoryMixin) {
	var sysCategory = declare("mui.syscategory.SysCategoryDialogMixin", [
			CategoryQueryDialogMixin, SysCategoryMixin ], {
		
		type : SYS_CATEGORY_TYPE_CATEGORY,
		
		//是否取模板, 值:0 否  , 1 是
		getTemplate : 0,
		
		key : '_sys_cate_dialog'
	});
	return sysCategory;
});
