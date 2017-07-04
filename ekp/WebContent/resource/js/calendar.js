/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了基于JQueryUI的日历。

作者：傅游翔
版本：3.0 2013-12
***********************************************/

Com_RegisterFile("calendar.js");
Com_IncludeFile("jquery.js|data.js");
Com_IncludeFile("jquery.ui.js", "js/jquery-ui/");

(function() {
	
	var local = (function (){
		var lang = Com_Parameter.Lang;
		if (lang == null)
			return "";
		if (lang.indexOf('|') > -1) {
			lang = lang.substring(lang.indexOf('|') + 1, lang.length);
		}
		var langArray = lang.split('-');
		if (langArray.length > 1) {
			langArray[langArray.length - 1] = langArray[langArray.length - 1].toUpperCase();
		}
		lang = langArray.join('-');
		return lang;
	})();
	
	if (local.indexOf('en') < 0) {
		Com_IncludeFile("jquery.ui-" + local + ".js", "js/jquery-ui/");
	}
	
	Com_AddEventListener(window, 'load', function() {
		window.Calendar_Lang = {
			format : {
				data : window.seajs ? seajs.data.env.pattern.date : Data_GetResourceString("date.format.date"),
				time : window.seajs ? seajs.data.env.pattern.time : Data_GetResourceString("date.format.time"),
				dataTime : window.seajs ? seajs.data.env.pattern.datetime : Data_GetResourceString("date.format.datetime")
			}
		};
	});
	
	/**
	* 日历选择
	* 兼容以前的模式，在跨浏览器时，需要显示传递 event.
	* @param event
	* @param fieldname
	* @param format
	* @param callback
	* @return
	*/
	function selectDate(event, fieldname, format, callback) {
		selectCalendar(event, fieldname, format, callback, 'dateState');
	}

	/**
	* 时间选择
	* 兼容以前的模式，在跨浏览器时，需要显示传递 event.
	* @param event
	* @param fieldname
	* @param format
	* @param callback
	* @return
	*/
	function selectTime(event, fieldname, format, callback) {
		selectCalendar(event, fieldname, format, callback, 'timeState');
	}

	/**
	* 日历时间
	* 兼容以前的模式，在跨浏览器时，需要显示传递 event.
	* @param event
	* @param fieldname
	* @param format
	* @param callback
	* @return
	*/
	function selectDateTime(event, fieldname, format, callback) {
		selectCalendar(event, fieldname, format, callback, 'dateAndTimeState');
	}
	
	/**
	* 通用日期时间选择对话框，通常外部不直接调用此函数
	* @param event - 事件
	* @param fieldname - 字段名
	* @param format - 格式化方式，仅对日期有效
	* @param callback - 回调函数
	* @param type - dateState | timeState | dateAndTimeState
	* @return
	*/
	function selectCalendar(event, fieldname, format, callback, type) {
		var eventObj = null;
		if (typeof(event) == 'string' || typeof(event.tagName) == 'string') { // only ie
			callback = format;
			format = fieldname;
			fieldname = event;
			event = Com_GetEventObject();
			eventObj = event.target || event.srcElement;
		} else if (fieldname) { // 正确调用方式
			event = Com_GetEventObject();
			eventObj = event.target || event.srcElement;
		}
		if (event.preventDefault) {
			event.preventDefault();
		}else {
			event.returnValue = false;
		}
		var objField = (typeof(fieldname) == 'string') ? 
				(window.DocList_GetRowField ? DocList_GetRowField(eventObj, fieldname) : document.getElementsByName(fieldname)[0]) 
				: fieldname;

		function cb (dateText) {
			if (callback) callback({FieldObject:objField});
			if (divIframe)
				divIframe.hide();
			jQuery(objField).datepicker('destroy');
			objField.focus();
		}
		function showIframe() {
			if (!divIframe) {
				divIframe = $('<iframe style="position:absolute;display:none;border:none;background:transparent;"></iframe>').appendTo('body');
			}
			var offset = $.datepicker.dpDiv.offset();
			divIframe.css({top:offset.top, left:offset.left});
			divIframe.width($.datepicker.dpDiv.width() + 7);
			divIframe.height($.datepicker.dpDiv.height() + 5);
			divIframe.show();
		}
		if (type == "dateState") {
			jQuery( objField ).datepicker({"onSelect": cb, "onClose": function() {divIframe.hide();}}).datepicker('show');
			showIframe();
		}
		else if (type == "timeState") {
			jQuery( objField ).timepicker({"onClose": cb}).timepicker('show');
			showIframe();
		}
		else if (type == "dateAndTimeState") {
			jQuery( objField ).datetimepicker({"onClose": cb}).datetimepicker('show');
			showIframe();
		}
		
	}
	var divIframe = false;
	
	window.selectDate = selectDate;
	window.selectTime = selectTime;
	window.selectDateTime = selectDateTime;
})();


// ******** 以下为 1.0代码 *************
 
//将字符串转化为日期对象，第一个参数为日期字符串，默认格式为“yyyy-MM-dd”，如果要自定义格式
//把格式做为第二个参数，格式中必须含有"yyyy"、"MM"、"dd"等字串
function formatDate(strdate){
	var arr = new Array;
	var arr1 = new Array;
	var arrsort=new Array(0,1,2);
	var arrtemp=new Array;
	var arrdate =new Array;
	var tt=new Date;
	arrdate[0]=tt.getFullYear();
	arrdate[1]=tt.getMonth()+1;
	arrdate[2]=tt.getDate();
	var strformat;
	var strtemp;
	var numtemp;
	var theDate;

	if(arguments[1]!=null)
		strformat=arguments[1];
	else
		strformat="yyyy-MM-dd";
	strtemp=strformat.replace("yyyy","-");
	strtemp=strtemp.replace("MM","-");
	strtemp=strtemp.replace("dd","-");
	arr=strtemp.split("-");
	strtemp=strdate;
	for(var i=0;i<arr.length;i++)
		strtemp=strtemp.replace(arr[i],"-")
	arr=strtemp.split("-");
	for(i=0;i<arr.length;i++)
		if(arr[i]!="")
			arr1[arr1.length]=arr[i];
	arrtemp[0]=strformat.indexOf("yyyy");
	arrtemp[1]=strformat.indexOf("MM");
	arrtemp[2]=strformat.indexOf("dd");
	if(arrtemp[arrsort[0]]>arrtemp[arrsort[1]]){
		numtemp=arrsort[0];
		arrsort[0]=arrsort[1];
		arrsort[1]=numtemp;
	}
	if(arrtemp[arrsort[0]]>arrtemp[arrsort[2]]){
		numtemp=arrsort[0];
		arrsort[0]=arrsort[2];
		arrsort[2]=numtemp;
	}
	if(arrtemp[arrsort[1]]>arrtemp[arrsort[2]]){
		numtemp=arrsort[1];
		arrsort[1]=arrsort[2];
		arrsort[2]=numtemp;
	}
	var j;
	for(i=arrsort.length-1,j=arr1.length-1;j>-1;i--,j--){
		if(arrtemp[arrsort[i]] != -1)
			arrdate[arrsort[i]]=arr1[j];
	}
	if(strdate=="")
		theDate=new Date();
	else
		theDate=new Date(arrdate[0],arrdate[1]-1,arrdate[2]);
	return theDate;
}

//时间比较函数
function compareDate(endDate,beginDate,endTime,beginTime){
	//参数为字符串，后两个参数可以为空
	//返回值：0、相等；正数：结束时间大于开始时间；负数：结束时间小于开始时间
	var arrDate;
	//var strBDate,strEDate;
	var datBDate,datEDate;
	var datToday = new Date();

	//初始化开始日期，为空串则设为今天
	if(beginDate==""){
		datBDate = new Date(datToday.getYear(),datToday.getMonth(),datToday.getDate());
	}else{
		datBDate = new Date(Date.parse(beginDate.replace(/-/g,"\/")));
		//arrDate=beginDate.split("-");
		//datBDate = new Date(arrDate[1] + "-" + arrDate[2] + "-" + arrDate[0]);
	}

	//初始化结束日期，为空串则设为今天
	if(endDate==""){
		datEDate = new Date(datToday.getYear(),datToday.getMonth(),datToday.getDate());
	}else{
		datEDate = new Date(Date.parse(endDate.replace(/-/g,"\/")));
		//arrDate=endDate.split("-");
		//datEDate = new Date(arrDate[1] + "-" + arrDate[2] + "-" + arrDate[0]);
	}

	//初始化开始时间，为空则忽略
	if(beginTime!=null && beginTime!=""){
		arrDate=beginTime.split(":");
		datBDate.setHours(arrDate[0]);
		if(arrDate.length>1){
			datBDate.setMinutes(arrDate[1]);
		}
		if(arrDate.length>2){
			datBDate.setSeconds(arrDate[2]);
		}
	}
	//初始化开始时间，为空串则设为现在
	if(beginTime==""){
		datBDate.setHours(datToday.getHours());
		datBDate.setMinutes(datToday.getMinutes());
	}

	//初始化结束时间，为空则忽略
	if(endTime!=null && endTime!=""){
		arrDate=endTime.split(":");
		datEDate.setHours(arrDate[0]);
		if(arrDate.length>1)
			datEDate.setMinutes(arrDate[1]);
		if(arrDate.length>2)
			datEDate.setSeconds(arrDate[2]);
	}
	//初始化开始时间，为空串则设为现在
	if(endTime==""){
		datEDate.setHours(datToday.getHours());
		datEDate.setMinutes(datToday.getMinutes());
	}
	return (datEDate - datBDate);
}

//时间比较函数
function compareTime(endTime,beginTime){
	//参数为字符串
	//返回值：0、相等；正数：结束时间大于开始时间；负数：结束时间小于开始时间
	var arrDate;
	var datBTime,datETime;
	var datToday = new Date();
	datBTime = new Date();
	datETime = new Date();
	//初始化开始时间，为空则忽略
	if(beginTime!=null && beginTime!=""){
		arrDate=beginTime.split(":");
		datBTime.setHours(arrDate[0]);
		if(arrDate.length>1){
			datBTime.setMinutes(arrDate[1]);
		}
		if(arrDate.length>2){
			datBTime.setSeconds(arrDate[2]);
		}
	}
	//初始化开始时间，为空串则设为现在
	if(beginTime==""){
		datBTime.setHours(datToday.getHours());
		datBTime.setMinutes(datToday.getMinutes());
	}

	//初始化结束时间，为空则忽略
	if(endTime!=null && endTime!=""){
		arrDate=endTime.split(":");
		datETime.setHours(arrDate[0]);
		if(arrDate.length>1)
			datETime.setMinutes(arrDate[1]);
		if(arrDate.length>2)
			datETime.setSeconds(arrDate[2]);
	}
	//初始化开始时间，为空串则设为现在
	if(endTime==""){
		datETime.setHours(datToday.getHours());
		datETime.setMinutes(datToday.getMinutes());
	}
	return (datETime - datBTime);
}
//判断时间格式是否正确
function isValidTime(strTime){
	var n;
	if(strTime=="")
		return false;
	var re=/[^\d:]/g;
	if(re.test(strTime))
		return false;
	var arrTime = strTime.split(":");
	n = parseInt(arrTime[0],10);
	if(isNaN(n))
		return false;
	if(n>23 || n<0)
		return false;
	if(arrTime.length>1){
		n=parseInt(arrTime[1],10);
		if(isNaN(n))
			return false;
		if(n>59 || n<0)
			return false;
	}
	if(arrTime.length>2){
		n=parseInt(arrTime[2],10);
		if(isNaN(n))
			return false;
		if(n>59 || n<0)
			return false;
	}
	return true;
}

/*****************************************************************
功能：验证“date.format.date”模式的日期格式是否正确
参数：
	date：要验证的日期字符串，如：“2009-08-24”、“08/24/2009”	
*****************************************************************/
function chkDateFormat(dateStr)
{
	var reg = null;
	var lang = Data_GetResourceString("locale.language");
	if ("zh-CN" == lang)
	{
		reg = /^\d{4}-\d{2}-\d{2}/;
	}
	if ("en-US" == lang){
		reg = /^\d{2}([/])\d{2}([/])\d{4}/;
	}
	else
	{
		reg = /^\d{4}-\d{2}-\d{2}/;
	}
	
	if(dateStr != null )
	{
		var valDate = dateStr.match(reg);
		if(valDate == null)
		{
			return false;
		}
		else
		{
		 	return true;
		}
    }
		return true;
}


/*****************************************************************
功能：将日期转换成相应日期模式的字符串
参数：
	format：要转换的日期模式，如"E MMM dd yyyy HH:mm:ss"
注意：参数format中，月份"M"必须大于2位，等于2位（“MM”）以数字的形式显示，
     如09；大于2位（“MMM”）以显示为英文月份，如August。
	
*****************************************************************/
Date.prototype.format = function(format)
{ 
	  //从默认资源文件获取周标签
	  var weekNamesStr = Data_GetResourceString("calendar.week.names");
	  var weekDay = new Array();
	  weekDay = weekNamesStr.split(",");
	  
	  // 从默认资源文件获取月标签
	  var monthNamesStr = Data_GetResourceString("calendar.month.names");
	  var monthName  = new Array();
	  monthName = monthNamesStr.split(",");
	  
	   // 从默认资源文件获取月简写标签
	  var shortMonthNamesStr = Data_GetResourceString("calendar.month.shortNames");
	  var shortMonthName  = new Array();
	  shortMonthName = shortMonthNamesStr.split(",");
	  
	  var o = {   
				  "M+" :  this.getMonth()+1,                  //month   
				  "d+" :  this.getDate(),                     //day   
				  "E+" :  weekDay[this.getDay()],           //week
				  "H+" :  this.getHours(),                    //hour   
			      "m+" :  this.getMinutes(),                  //minute   
			      "s+" :  this.getSeconds(),                  //second   
			      "q+" :  Math.floor((this.getMonth()+3)/3),  //quarter   
			      "S"  :  this.getMilliseconds()              // millisecond
  			  }   
   
	//用年替换"yyyy"
  if(/(y+)/.test(format)) 
  {   
  	     format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  }   
  
  for(var k in o) 
  {  
		if(new RegExp("("+ k +")").test(format)) 
		{ 
			if("E" != RegExp.$1.substr(0,1) && "M" != RegExp.$1.substr(0,1))
			{	
				format = format.replace(RegExp.$1, RegExp.$1.length==1? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
			}
	   }
  }

  for(var k in o) 
  {  
		if(new RegExp("("+ k +")").test(format)) 
		{ 
			//用星期替换“E”
			if ("E" == RegExp.$1.substr(0,1))
			{
				format = format.replace(RegExp.$1, o[k]); 
			}

			//替换月份
			if ("M" == RegExp.$1.substr(0,1))
			{
				//如果format中“M”位数为2，则用数字月份替换“M”，如08
				if (RegExp.$1.length == 2)
				{
					format = format.replace(RegExp.$1, ("00"+ o[k]).substr((""+ o[k]).length)); 
				}
				//如果format中“M”位数大于2，则用英文月份替换“M”，如Aug
				if (RegExp.$1.length == 3)
				{
					format = format.replace(RegExp.$1, shortMonthName[o[k]-1]); 
				}
				//如果format中“M”位数大于2，则用英文月份替换“M”，如Augest
				if (RegExp.$1.length == 4)
				{
					format = format.replace(RegExp.$1, monthName[o[k]-1]); 
				}
				
			}
		}   
  }
   
	return format;
}