define(
		[ "dojo/_base/declare", "mui/form/Category", "mui/address/AddressMixin" ],
		function(declare, Category, AddressMixin) {
			var Address = declare("mui.form.Address",
					[ Category, AddressMixin ], {

					});
			return Address;
		});