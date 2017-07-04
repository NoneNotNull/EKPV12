define( [ "dojo/_base/declare", "mui/form/Category",
		"mui/simplecategory/SimpleCategory" ], function(declare, Category,
		SimpleCategory) {
	var simpleCategory = declare("mui.form.SimpleCategory", [ Category,
			SimpleCategory ], {});
	return simpleCategory;
});