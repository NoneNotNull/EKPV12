define( [ "dojo/_base/declare", "mui/query/_CategoryQueryDialogMixin",
		"mui/simplecategory/SimpleCategoryMixin" ], function(declare,
		CategoryQueryDialogMixin, SysCategoryMixin) {
	var simpleCategory = declare(
			"mui.simplecategory.SimpleCategoryDialogMixin", [
					CategoryQueryDialogMixin, SysCategoryMixin ], {
				key : '_sys_simple_cate_dialog'
			});
	return simpleCategory;
});