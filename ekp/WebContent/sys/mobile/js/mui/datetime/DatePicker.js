define([ "dojo/_base/declare", "dojox/mobile/SpinWheelDatePicker" ], function(
		declare, SpinWheelDatePicker) {
	var claz = declare("mui.datetime.DatePicker", [ SpinWheelDatePicker ], {
		yearPattern: "yyyy年",

		monthPattern: "MM月",

		dayPattern: "dd日"
	});
	return claz;
});