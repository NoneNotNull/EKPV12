define( [ "dojo/_base/declare", "mui/form/Category", "mui/syscategory/SysCategoryMixin"],
		function(declare, Category, SysCategoryMixin) {
			var sysCategory = declare("mui.form.SysCategory", [Category , SysCategoryMixin], {
			});
			return sysCategory;
	});
