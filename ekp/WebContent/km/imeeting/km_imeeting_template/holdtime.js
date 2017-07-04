var $$$ = function (id) {
	return ("string" == typeof(id)) ? document.getElementById(id) : id;
};

var FormatMonthOrDayNum = function (iNum) {
	if (iNum < 10) {
		return "0" + iNum;
	}
	return "" + iNum;
}
var SetQuarterMonthSelect = function(oSelect) {
	var aQuarterMonth = Data_GetResourceString("calendar.quarterMonth.names").split(",");
	//var aQuarterMonth = new Array(
		//"第一月", "第二月", "第三月"
	//);
	oSelect.options.length = aQuarterMonth.length;
	for (var i = 0; i < aQuarterMonth.length; i++) {
		oSelect.options[i].text = aQuarterMonth[i];
		oSelect.options[i].value = FormatMonthOrDayNum(1 + i);
	}
}
var SetSelect = function(oSelect, iLength) {
	oSelect.options.length = iLength;
	for (var i = 0; i < iLength; i++) {
		oSelect.options[i].text = oSelect.options[i].value = FormatMonthOrDayNum(1 + i);
	}
}

var SetDaySelect = function(oSelect, iMonth) {
	// 取得闰年月份天数
	var daysInMonth = new Date(2012, iMonth, 0).getDate();
	SetSelect(oSelect, daysInMonth);
}

var SetWeekSelect = function(oSelect) {
	var aWeek = Data_GetResourceString("calendar.week.names").split(",");
	//var aWeek = new Array(
		//"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"
	//);
	// 添加option
	oSelect.options.length = aWeek.length;
	for (var i = 0; i < aWeek.length; i++) {
		oSelect.options[i].text = aWeek[i];
		oSelect.options[i].value = FormatMonthOrDayNum(i + 1);
	}
}
// 设置下拉列表选择值
var SetSelected = function (oSelect, sValue) {
	if (sValue != null && sValue != "") {
		// 设置选中项
		for (var i = 0; i < oSelect.options.length; i++) {
			if (oSelect.options[i].value == sValue) {
				oSelect.selectedIndex = i;
				break;
			}
		}
	}
}
// 获取radio选择的值
function getRadioCheckedValue(sName) {
	var aNames = document.getElementsByName(sName);
	for (i=0; i<aNames.length; i++) {
		if (aNames[i].checked) {
			return aNames[i].value;
		}
	}
}
// 月或日选择事件
function MonthOrDaySelectChange (speriodType, sMonth, sDay, bRefreshDay) {
	if (bRefreshDay == null) {
		bRefreshDay = false;
	}
	// 选择月后，刷新日
	if (bRefreshDay) {
		SetDaySelect($$$(sDay), $$$(sMonth).value);
	}
	if (getRadioCheckedValue("fdPeriodType") == speriodType) {
		$$$("fdHoldTime").value = $$$(sMonth).value + "-" + $$$(sDay).value;
	}
}
// 日选择事件
function DaySelectChange (speriodType, sValue) {
	if (getRadioCheckedValue("fdPeriodType") == speriodType) {
		$$$("fdHoldTime").value = '00' + '-' + sValue;
	}
}
// 点击周期事件
function PeriodTypeChick(sValue) {
	switch(sValue) {
		case "1":
			$$$('fdHoldTime').value = $$$('periodTypeYear_Month').value + '-' + $$$('periodTypeYear_Day').value;
			$("#notifyDayDiv").show();
			break;
		case "2":
			$$$('fdHoldTime').value = $$$('periodTypeQuarter_Month').value + '-' + $$$('periodTypeQuarter_Day').value;
			$("#notifyDayDiv").show();
			break;
		case "3":
			$$$('fdHoldTime').value = '00' + '-' + $$$('periodTypeMonth_Day').value;
			$("#notifyDayDiv").show();
			break;
		case "4":
			$$$('fdHoldTime').value = '00' + '-' + $$$('periodTypeWeek_Day').value;
			$("#notifyDayDiv").show();
			break;
		case "5":
			$$$('fdHoldTime').value = '';
			$("#notifyDayDiv").hide();
			break;
		default:
			$$$('fdHoldTime').value = '';
			$("#notifyDayDiv").hide();
	}
}