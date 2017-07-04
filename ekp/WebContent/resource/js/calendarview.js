/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了日历视图的构造和操作函数

作者：陈志勇
版本：1.0 2007-11-05
***********************************************/
Com_IncludeFile("rightmenu.js|calendar.js");
Com_RegisterFile("calendarview.js");


var CALENDARVIEW_TYPE_DAY = 1;		//显示单天的
var CALENDARVIEW_TYPE_WEEK_TWO = 2;		//显示每周两天的
var CALENDARVIEW_TYPE_WEEK_SEVENT = 7;		//显示每周7天的
var CALENDARVIEW_TYPE_MONTH = 30;		//显示一个月的

var CALENDARVIEW_DOC_TYPE_REPEAT = "DOC_REPEAT";	//重复日程
var CALENDARVIEW_DOC_TYPE_DRAFT = "10";		//草稿日程
var CALENDARVIEW_DOC_TYPE_ABANDON = "00";	//废弃日程
var CALENDARVIEW_DOC_TYPE_APPROVE = "20";	//待审日程
var CALENDARVIEW_DOC_TYPE_FINISH = "32";	//已完成日程
var CALENDARVIEW_DOC_TYPE_FINISH_DRAW = "31";	//已领取
var CALENDARVIEW_DOC_TYPE_NOFINISH = "30";	//审批通过但未完成日程

var CALENDARVIEW_IMGPATHPREFIX = Com_Parameter.StylePath+"calendar/";	//图片路径
var CALENDARVIEW_DOC_ICON_REPEAT = "repeat.gif";
var CALENDARVIEW_DOC_ICON_DRAFT = "draft.gif";
var CALENDARVIEW_DOC_ICON_ABANDON = "abandon.gif";	
var CALENDARVIEW_DOC_ICON_APPROVE = "approve.gif";
var CALENDARVIEW_DOC_ICON_FINISH = "finish.gif";
var CALENDARVIEW_DOC_ICON_FINISH_DRAW = "finish_draw.gif";
var CALENDARVIEW_DOC_ICON_NOFINISH = "nofinish.gif";
var CALENDARVIEW_DOC_FLAG_NORMAL = "1";
var CALENDARVIEW_DOC_FLAG_IMPORTANCE = "2";

var CALENDARVIEW_DOC_ICON_ACTIVE = "calviewbtn_active.gif";
var CALENDARVIEW_DOC_ICON_NOACTIVE = "calviewbtn_noactive.gif";

var CALENDARVIEW_DOC_WORDLENGTH_WEEK_TWO = 40;
var CALENDARVIEW_DOC_WORDLENGTH_WEEK_SEVENT = 40;
var CALENDARVIEW_DOC_WORDLENGTH_DAY = 80;
var CALENDARVIEW_DOC_WORDLENGTH_MONTH = 18;

var CalendarView_Info = new Array();
var CalendarMsg_Info = new Array();
/***********************************************
功能  日历视图对象的构造函数
参数：
	refName：
		必选，日历视图的标识名称	
	tableElement:
		必选，日历视图主题元素的标识名称		
	beanName:
		可选，读取数据的service的名称
	beanURL:
		可选，读取数据的service的URL		
***********************************************/
function CalendarView(refName, tableElement,beanName,beanURL) {
	//属性	
	viewRefName = refName;
	this.refName = refName;
	this.startDate = null;
	this.oldStartDate = null;
	this.startMonth = null;
	this.baseWeekDate="2002-1-1";
	this.navEnabled = true;
	this.showButtomWeek = true;
	this.showButtomDay = true;
	this.showButtomMonth = true;
	this.showWeekText = true;
	this.target = "_blank";
	this.tableElement = tableElement;
	this.beanName = beanName;
	this.beanURL = beanURL;
	this.hasCheckboxColumn = false;
	this.listType = CALENDARVIEW_TYPE_WEEK_TWO;
	this.clickURL = null;
	this.Columns = new Array();
	this.contentObject;
	this.drawBeginDate = null;
	this.switchObj = null;
	this.byDayButton = null;
	this.byMonthButton = null;
	this.byWeekButton = null;
	this.titleObj = null;
	this.hasGetDate = false;
	this.dataList = new Array();
	this.keyList = new Array();
	this.showKeyList = null;
	this.wordLength_Week_Two = 0;
	this.wordLength_Week_Sevent = 0;
	this.wordLength_Day = 0;
	this.wordLength_Month = 0;
	this.loadDataBegin = null;
	this.loadDataEnd = null;
	this.showTime = true;

	
	//外部函数
	this.show = Calendar_Show;
	this.goto = Calendar_Goto;
	this.head = Calendar_Head;
	this.next = Calendar_Next;
	this.prev = Calendar_Prev;
	this.last = Calendar_Last;
	this.refresh = Calendar_Refresh;
	this.changeWeek = Calendar_ChangeWeek;
	this.selectDate = Calendar_SelectDate;
	this.showChioceMenu = Calendar_ShowChioceMenu;
	this.onChoiceClick = Calendar_OnChoiceClick;
	
	//内部函数
	this.drawTable = Calendar_DrawTable;
	this.drawRows = Calendar_DrawRows;
	this.drawColumns = Calendar_DrawColumns;
	this.checkDate = Calendar_CheckDate;
	this.showData = Calendar_ShowData;
	this.showSingleData = Calendar_ShowSingleData;
	this.getContentObjByDate = Calendar_GetContentObjByDate;
	this.clearData = Calendar_ClearData;
	this.clearSingleData = Calendar_ClearSingleData;
	this.clearShow = Calendar_ClearShow;
	this.getDays = Calendar_GetDays;
	this.goPage = Calendar_GoPage;
	this.loadData = Calendar_LoadData;			//装载数据
	this.getDate = Calendar_GetDate;
	this.getDataListByDate = Calendar_GetDataListByDate;
	this.addKey = Calendar_AddKey;
	this.getTitle = Calendar_GetTitle;
	this.getWordsByLength = Calendar_GetWordsByLength;	//截取数据长度
	this.getWordLength = Calendar_GetWordLength;	//获取数据长度
	this.drawWeekColumns = Calendar_DrawWeekColumns; //生成星期显示行
	this.showYearChoice = Calendar_ShowYearChoice;
	this.showMonthChoice = Calendar_ShowMonthChoice;
	this.gotoYear = Calendar_GotoYear;
	this.gotoMonth = Calendar_GotoMonth;
	this.addDataList = Calendar_AddDataList;
	
	CalendarView_Info[refName] = this;
	calderViewObj = this;
	//事件函数
	this.onMouseOver = Calendar_OnMouseOver;
	this.onMouseOut = Calendar_OnMouseOut;
	this.onClick = Calendar_OnClick;
	this.onTitleClick = Calendar_OnTitleClick;
	//自定义事件
	this.onCustomQueryShow = null;
	this.onCustomPostShow = null;
	this.onCustomQueryClick = null;
	this.onCustomPostClick = null;
	this.onListTypeChange = null;
	
	//生成后的处理	
	Com_AddEventListener(window,"load",function(){calderViewObj.show();});
}
/**************************************
功能  日历文档构造函数
参数：
	text：
		必选，显示的链接	
	begindate：
		必选，开始时间
	enddate:
		可选，结束时间		
	title：
		鼠标移上显示的文字
	href：
		文档的链接
	strKey:
		分类名称		
	nodeType：
		文档节点类型
	importance:
		重要度 0 普通,1重要
	target：
		目标帧
*******************************************/
//增加申请部门applyDept，如果在service的map中有加此字段则显示修改by张文添
function CalendarDoc(text,begindate,enddate,title,href,strKey,nodeType,importance,applyDept,target) {
	this.subject = text;
	this.applyDept=applyDept;
	this.docURL = href;
	this.dateList = new Array();
	this.key = strKey;
	if(importance==null) importance = CALENDARVIEW_DOC_FLAG_NORMAL;
	this.importance = importance;
	//重复日程
	if(nodeType==CALENDARVIEW_DOC_TYPE_REPEAT){
		
		this.isRepeat = true;
	}else{
		var i = begindate.indexOf(" ");
		this.startDate = Calendar_FormatDate(i>0?begindate.substring(0,i):begindate);
	        this.startTime = i>0?begindate.substring(i+1):"00:00";
	        var i = enddate.indexOf(" ");
	        this.endDate = i>0?enddate.substring(0,i):enddate;
	        this.endTime = i>0?enddate.substring(i+1):"23:59";
	        var ST = Calendar_ParseDate(this.startDate);
		var ET = Calendar_ParseDate(this.endDate);		
		if(ST>=ET) {			
			this.dateList[this.dateList.length] = Calendar_FormatDate(ST);
		} 
		else {			
			while (ST<=ET) {
				this.dateList[this.dateList.length] = Calendar_FormatDate(ST);				
				var theDay = ST.getDate();
				theDay++;
				ST.setDate(theDay);
			}
		}
		if(title==null){
			title = CalendarMsg_Info["begindate"] + ":" + this.startDate + " " + this.startTime;
			title += "\n" + CalendarMsg_Info["enddate"] + ":" + this.endDate + " " + this.endTime;
			title += "\n" + CalendarMsg_Info["subject"] + ":" + this.subject;
			//判断applyDept是否存在 存在则显示修改by张文添
			if(typeof(this.applyDept)!="undefined")
			title += "\n" + CalendarMsg_Info["applyDept"] + ":" + this.applyDept;
		}
		this.title = title;
		this.href = href;		
	}
	this.nodeType = nodeType;//this.nodeType = nodeType==null?CALENDARVIEW_DOC_TYPE_FINISH:nodeType;
}

/************私有函数,外部请勿调用************************/
/*********************
功能：
	显示日历主体
参数：
**********************/
function Calendar_Show() {
	if(this.onCustomQueryShow!=null){
		if(!this.onCustomQueryShow()) return false;
	}
	if(this.tableElement != null){
		this.clearShow();
		if(typeof(this.tableElement)=="string"){		
			this.tableElement = document.getElementById(this.tableElement);
		}
		if(this.tableElement != null){
			this.loadData();
			this.contentObject = new Array();
			var table=this.drawTable();	
			this.tableElement.appendChild(table);
			this.showData();
		}
		if(this.switchObj==null){
			this.switchObj = document.getElementById("Top_Change_"+this.refName);
		}
		if(this.byDayButton==null){
			this.byDayButton = document.getElementById(this.refName+"_byDay");
			this.byMonthButton = document.getElementById(this.refName+"_byMonth");
			this.byWeekButton = document.getElementById(this.refName+"_byWeek");
			this.titleObj =  document.getElementById(this.refName+"_Title");
		}
		var choiceObj = document.getElementById("Top_Choice_"+this.refName);
		if(choiceObj!=null){
			if(this.keyList!=null&&this.keyList.length>1)
				choiceObj.style.display = "block";
			else
				choiceObj.style.display = "none";
		}

		if(this.switchObj && this.byDayButton){
			if(this.titleObj.firstChild) this.titleObj.removeChild(this.titleObj.firstChild);
			var tmpNoActBack = CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_NOACTIVE;
			var tmpActBack = CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_ACTIVE;
			if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO || this.listType==CALENDARVIEW_TYPE_WEEK_SEVENT){
				this.switchObj.style.display = "";
				this.byMonthButton.setAttribute("background",tmpNoActBack);
				this.byDayButton.setAttribute("background",tmpNoActBack);
				this.byWeekButton.setAttribute("background",tmpActBack);
			}else if(this.listType==CALENDARVIEW_TYPE_DAY){
				this.byMonthButton.setAttribute("background",tmpNoActBack);
				this.byWeekButton.setAttribute("background",tmpNoActBack);
				this.byDayButton.setAttribute("background",tmpActBack);
				this.switchObj.style.display = "none";
			}else{
				this.byWeekButton.setAttribute("background",tmpNoActBack);
				this.byDayButton.setAttribute("background",tmpNoActBack);
				this.byMonthButton.setAttribute("background",tmpActBack);
				this.switchObj.style.display = "none";						
			}
			this.titleObj.appendChild(this.getTitle());
		}
	}
	if(this.onCustomPostShow!=null){
		if(!this.onCustomPostShow()) return false;
	}	
}
/*********************
功能：
	选择日期，转到指定日期的数据
参数：
**********************/
function Calendar_SelectDate(){
	var field = document.createElement("input");
	field.setAttribute("type", "text");
	var calendarview = this;
	selectDate(field,null,function(){if(field.value!="")calendarview.goto(field.value);});
}
/*********************
功能：
	页面跳转函数，跳转到指定日期的数据
参数：
	daytime:跳转时间
	listType：跳转类型
	refreshData:是否更新数据
**********************/
function Calendar_Goto(daytime,listType,refreshData) {
	if(daytime==null && listType==this.listType){
		return true;
	}
	var listTypeChange = false;
	if(daytime==null) {
		if(this.oldStartDate==null){
			this.oldStartDate = Calendar_FormatDate(new Date());
			this.startDate = this.checkDate(this.oldStartDate!=null?this.oldStartDate:this.startMonth,listType==null?this.listType:listType);
		}else{
			this.startDate = this.checkDate(this.oldStartDate!=null?this.oldStartDate:this.startMonth,listType==null?this.listType:listType);
		}		
		daytime = this.startDate;
		listTypeChange = true;
	}else {
		this.startDate = this.checkDate(daytime,listType==null?this.listType:listType);
		this.oldStartDate = daytime;
		this.startMonth = this.startDate.substring(0,this.startDate.lastIndexOf("-"))+"-1";
	}	
	if(listType!=null && refreshData==null){
		if(listType==this.listType) refreshData = false;
		else if(Math.abs(this.listType-listType)==(CALENDARVIEW_TYPE_WEEK_SEVENT-CALENDARVIEW_TYPE_WEEK_TWO)){
			refreshData = false;
		}
	}
	if(listType!=null) this.listType = listType;
	if(refreshData) this.hasGetData = false;
	this.show();
	if(listTypeChange&&this.onListTypeChange!=null){
		this.onListTypeChange(this.listType);
	}
}
/*********************
功能：
	在周的两种显示模式间切换
参数：
**********************/
function Calendar_ChangeWeek(){
	if(this.listType!=CALENDARVIEW_TYPE_WEEK_TWO && this.listType!=CALENDARVIEW_TYPE_WEEK_SEVENT) return false;
	if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO)
		this.listType = CALENDARVIEW_TYPE_WEEK_SEVENT;
	else
		this.listType = CALENDARVIEW_TYPE_WEEK_TWO;
	this.show();
}
/*********************
功能：
	显示数据信息
参数：
**********************/
function Calendar_ShowData(){
	if(!this.hasGetData) this.loadData();
	for(var i=0;i<this.contentObject.length;i++){
		this.showSingleData(this.contentObject[i][0],this.contentObject[i][1],this.contentObject[i][2]);
	}
}
/*********************
功能：
	显示指定的信息
参数：
	strKey 关键字
	date 日期
	dataObj 位置显示对象
**********************/
function Calendar_ShowSingleData(strKey,date,dataObj) {
	if(date==null) return false;
	if(dataObj==null) {
		dataObj = this.getContentObjByDate(strKey,date);
	}
	if(dataObj!=null){		
		Calendar_ClearSingleData(dataObj);
		var table = document.createElement("TABLE");
		table.width="100%"
		var tbody = document.createElement("TBODY");
		var dataList = this.getDataListByDate(strKey,date);
		for(var i=0;i<dataList.length;i++){
			var nodeType = dataList[i].nodeType;
			if(nodeType==null)
				continue;
			var tr = document.createElement("TR");
			var td = document.createElement("TD");
			var imgVar = document.createElement("img");
			imgVar.setAttribute("src",Calendar_GetNodeIcon(nodeType));
			imgVar.setAttribute("border","0");
			td.appendChild(imgVar);
			var spanDiv = document.createElement("SPAN");					
			if(dataList[i].importance==CALENDARVIEW_DOC_FLAG_NORMAL) {
				if(dataList[i].dateList.length>1)
					spanDiv.className = "calviewDoc_moreDay";
				else	
					spanDiv.className = "calviewDoc_normal";
				
			}else spanDiv.className = "calviewDoc_Importance";			
			Com_SetInnerText(spanDiv,(this.showTime == "true"?"["+dataList[i].startTime+"-"+dataList[i].endTime+"]":" ") + this.getWordsByLength(dataList[i].subject));
			spanDiv.onclick = this.onClick;		
			td.appendChild(spanDiv);
			td.onmouseover = this.onMouseOver;
			td.onmouseout = this.onMouseOut;
			td.onclick = this.onClick;
			td.dataObj = dataList[i];
			td.title = dataList[i].title;
			tr.appendChild(td);
			tbody.appendChild(tr);			
		}
		table.appendChild(tbody);
		dataObj.appendChild(table);
	}	
}
/*********************
功能：
	获取文档类型对应的图片
参数：nodeType 文档类型
**********************/
function Calendar_GetNodeIcon(nodeType) {
	if(nodeType==CALENDARVIEW_DOC_TYPE_REPEAT) {
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_REPEAT;
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_DRAFT){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_DRAFT;
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_NOFINISH){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_NOFINISH;
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_ABANDON){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_ABANDON;		
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_APPROVE){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_APPROVE;		
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_FINISH_DRAW){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_FINISH_DRAW;		
	}else if(nodeType==CALENDARVIEW_DOC_TYPE_FINISH){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_DOC_ICON_FINISH;
	}
}
/*********************
功能：
	获取日期显示数据的对象
参数：	strKey 关键字信息
	date 时间信息
**********************/
function Calendar_GetContentObjByDate(strKey,date){
	if(date==null) return null;
	if(strKey==null) strKey="";
	var obj = null;
	for(var i=0;i<this.contentObject.length;i++){
		if(this.contentObject[i][0]==strKey && this.contentObject[i][1]==date){
			obj = this.contentObject[i][2];
			break;
		}			
	}
	return obj;
}

/*********************
功能：
	页面跳转函数，跳转到首页,如果是显示月份则跳转到当年的第一个月，否则都是跳转到当月的第一天或者第一个星期
参数：
**********************/
function Calendar_Head() {
	var startDate = this.startDate;
	var dt = Calendar_ParseDate(startDate);  
	var days=this.getDays(dt);
	if(this.listType!=CALENDARVIEW_TYPE_MONTH)
		dt.setDate(days[dt.getMonth()]);
	else{
		dt.setDate(1);
		dt.setMonth(0);
	}    
	startDate = Calendar_FormatDate(dt);
	this.oldStartDate = null;
	this.goto(startDate);
}
/*********************
功能：
	页面跳转函数，跳转到下一页
参数：
**********************/
function Calendar_Next() {
	this.goPage(1); 
}
/*********************
功能：
	页面跳转函数，跳转到上一页
参数：
**********************/
function Calendar_Prev() {
	this.goPage(-1);  	
}
/*********************
功能：
	页面跳转函数，跳转到最后一页
参数：
**********************/
function Calendar_Last() {
	var startDate = this.startDate;  
	var dt = Calendar_ParseDate(startDate);  
	var days=this.getDays(dt);
	if(this.listType!=CALENDARVIEW_TYPE_MONTH)
		dt.setDate(days[dt.getMonth()]);
	else{
		dt.setDate(1);
		dt.setMonth(11);
	}    
	startDate = Calendar_FormatDate(dt);
	this.oldStartDate = null;
	this.goto(startDate);  
}
/*********************
功能：
	刷新当前页面数据
参数：
**********************/
function Calendar_Refresh() {
	this.clearData(true);
	this.showData();
}
/*********************
功能：
	生成表格
参数：
**********************/
function Calendar_DrawTable() {
	var startDay,dt,oldDt;
	var daytime;
	if(this.startDate==null){
		this.oldStartDate = Calendar_FormatDate(new Date());
		this.startDate = this.checkDate(this.oldStartDate,this.listType);
		this.startMonth = this.startDate.substring(0,this.startDate.lastIndexOf("-"))+"-1";
	}
	var table = document.createElement("TABLE");
	table.className = "calviewtb";
	table.id="VW_"+this.refName;
	var tbody = document.createElement("TBODY");
	this.drawBeginDate = this.startDate;
	if(this.listType==CALENDARVIEW_TYPE_MONTH) tbody.appendChild(this.drawWeekColumns());	
	tbody.appendChild(this.drawColumns());
	this.drawRows(null,tbody);
	if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO){
		for(var i=1;i<4;i++)
		{
			startDay = this.drawBeginDate;
			dt = Calendar_ParseDate(startDay);
			oldDt = Calendar_ParseDate(startDay);  
			dt.setDate(dt.getDate()+2);
			if(dt.getDay()==0 || dt==oldDt)
				break;
			this.drawBeginDate = Calendar_FormatDate(dt);
			tbody.appendChild(this.drawColumns(i));
			this.drawRows(i,tbody);  
		}
	}else if(this.listType==CALENDARVIEW_TYPE_MONTH)
	{
		for(var i=1;i<7;i++){
			startDay = this.drawBeginDate;  
			dt = Calendar_ParseDate(startDay);
			oldDt = Calendar_ParseDate(startDay); 
			dt.setDate(dt.getDate()+7-dt.getDay());
			if(dt==oldDt || dt.getMonth()!=oldDt.getMonth()) break;
			this.drawBeginDate = Calendar_FormatDate(dt);        
			tbody.appendChild(this.drawColumns(i));
			this.drawRows(i,tbody);
		}
	}
	this.drawBeginDate = this.startDate;	
	setTimeout("window.scrollTo(0,0);if(document.body.fireEvent){document.body.fireEvent('onscroll');}", 100);
	table.appendChild(tbody);
	return table;	
}
/*********************
功能：
	按月份时生成周的显示行
参数：
**********************/
function Calendar_DrawWeekColumns(){
	var tr = document.createElement("TR");
	tr.id = "VWCol_Title";
	var classIndex = "_WeekTitle";
	var weeks = CalendarMsg_Info["weeks"];
	if(this.keyList.length>0){
		var td = document.createElement("TD");
		td.className = "calviewth"+classIndex;
		Com_SetInnerText(td,"");
		tr.appendChild(td);
	}
	for(var i=0;i<7;i++)
	{
		var td = document.createElement("TD");
		if(i==0||i==6)
			td.className = "calviewth"+classIndex+"_Holiday";
		else
			td.className = "calviewth"+classIndex;
		Com_SetInnerText(td, weeks[i]);
		tr.appendChild(td);
	}
	this.showWeekText = false;
	return tr;
}
/*********************
功能：
	生成实际数据的单元格行
参数：id :行号
	parent:父对象
**********************/
function Calendar_DrawRows(id,parent) {
	var classIndex = (id%2==0?"_double":"_single");
	var keyList=null;
	if(this.keyList.length>0){
		if(this.showKeyList==null) this.showKeyList = this.keyList;
		keyList = this.showKeyList;
	}else{
		keyList = new Array("");
	}
	for(var i=0;i<keyList.length;i++){
		var tr =  document.createElement("TR");	
		if(id==null) id = 0;
		tr.id = "VWROW_" + id+"_"+i;
		if(this.keyList.length>0){
			var td = document.createElement("TD");
			td.className = "calviewkey"+classIndex;
			td.appendChild(document.createTextNode(keyList[i]));
			tr.appendChild(td);
		}
		for(var j=0;j<this.Columns.length;j++){
			var td = document.createElement("TD");
			td.className = "calviewtd"+classIndex;
			td.columnKey = this.Columns[j];
			if(this.Columns[j]!=" ") {
				this.contentObject[this.contentObject.length] = new Array(keyList[i],this.Columns[j],td);
			}
			var calendarView = this;
			Com_AddEventListener(td,"dblclick",function(){
				var obj = Com_GetEventObject();
				obj = obj.srcElement || obj.target;
				while(obj!=null && obj.columnKey==null) 
					obj = obj.parentElement;
				if(obj.columnKey==" ") return false;
				calendarView.onTitleClick(obj.columnKey,CALENDARVIEW_TYPE_DAY,false);
			});
			tr.appendChild(td);
		}
		parent.appendChild(tr);
	}
}
/*********************
功能：
	生成表格的日期数据的单元格
参数：
**********************/
function Calendar_DrawColumns(id) {
	var tr = document.createElement("TR");
	if(id==null) id = 0;
	tr.id = "VWCol_"+id;
	
	var week,day,daytime,Cwidth;
	var colnumber,i;
	var Columns = new Array();
	var weeks = CalendarMsg_Info["weeks"];
	var Result = ""; 
	var startDay = this.drawBeginDate;      
	var dt = Calendar_ParseDate(startDay);
	var days=this.getDays(dt);
	if(id==null) id = 0;
	if(this.listType == CALENDARVIEW_TYPE_DAY) colnumber = 1;
	else if(this.listType == CALENDARVIEW_TYPE_WEEK_SEVENT)  colnumber = 7 - dt.getDay();
	else if(this.listType == CALENDARVIEW_TYPE_WEEK_TWO)  colnumber = 2;
	else if(this.listType == CALENDARVIEW_TYPE_MONTH) colnumber = 7;
	Cwidth = parseInt(95/colnumber)+"%";
	var classIndex = (id%2==0?"_double":"_single");

	if(this.keyList.length>0){
		var td = document.createElement("TD");
		td.width="100px";
		td.className = "calviewth"+classIndex;
		td.appendChild(document.createTextNode(" "));
		tr.appendChild(td);
	}
	for(i=0;i<colnumber;i++){
		var td = document.createElement("TD");
		td.width = Cwidth;
		td.className = "calviewth"+classIndex;
		if(this.listType ==CALENDARVIEW_TYPE_WEEK_TWO && i==1 && dt.getDay()==0)
		{
			Columns[Columns.length] = " ";
			td.appendChild(document.createTextNode(" "));
			tr.appendChild(td);
			break;
		}
		if(this.listType == CALENDARVIEW_TYPE_MONTH && dt.getDay()!=i)
		{
			Columns[Columns.length] = " ";
			td.appendChild(document.createTextNode(" "));
			tr.appendChild(td);
			continue;
		}
	
		daytime = Calendar_FormatDate(dt);
		var strScript = "javascript:"+this.refName+".onTitleClick('"+daytime+"',"+CALENDARVIEW_TYPE_DAY+",false)";
		week = weeks[dt.getDay()];                    
		Columns[Columns.length] = daytime;
		if(this.listType==CALENDARVIEW_TYPE_DAY || this.listType==CALENDARVIEW_TYPE_WEEK_TWO){
			
			var link = document.createElement("A");
			Com_SetInnerText(link,daytime);
			link.className = "calviewlink";
			link.href = strScript;
			td.appendChild(link);
			td.appendChild(document.createTextNode(" "));
			link = document.createElement("A");
			Com_SetInnerText(link, week);
			link.className = "calviewlink";
			link.href = strScript;	
			td.appendChild(link);		
		}else
		{			
			var link = document.createElement("A");
			if(this.showWeekText)
				Com_SetInnerText(link, week+"("+(dt.getMonth()+1)+"."+dt.getDate()+")");
			else
				Com_SetInnerText(link,Calendar_FormatDate(dt));
			if(dt.getDay()==0||dt.getDay()==6)
				link.className = "calviewlink_holiday";
			else
				link.className = "calviewlink";
			link.href = strScript;
			td.appendChild(link);
		}
		tr.appendChild(td);
		day = days[dt.getMonth()];
		if(dt.getDate()==day)
		{
			if(this.listType ==CALENDARVIEW_TYPE_MONTH)
				break;
			else
			{
				if(dt.getMonth()==11)
				{
					dt.setYear(dt.getFullYear()+1);
					dt.setMonth(0);
					dt.setDate(1);
				}else{
					dt.setDate(1);		
					dt.setMonth(dt.getMonth()+1);
				}
			} 
		}else dt.setDate(dt.getDate()+1);
	}
	if(i<(colnumber-1) && i<this.Columns.length) 
		for(i++;i<this.Columns.length;i++)  {
			Columns[Columns.length] = " ";
			var td = document.createElement("TD");
			td.width = Cwidth;
			td.className = "calviewth" + classIndex;
			td.appendChild(document.createTextNode(" "));
			tr.appendChild(td);			            
		}        
	this.Columns = Columns; 
	return tr;
}
/*********************
功能：
	清除数据的显示
参数：emptyData 是否清除已读取的数据
**********************/
function Calendar_ClearData(emptyData){
	if(this.contentObject==null) return true;
	for(var i=0;i<this.contentObject.length;i++){
		Calendar_ClearSingleData(this.contentObject[i][2]);
	}
	if(emptyData) {
		this.dataList = new Array();
		this.hasGetData = false;
	}
		
}
/*********************
功能：
	清除单个日期的数据显示
参数：
**********************/
function Calendar_ClearSingleData(dataObj,strKey) {
	if(dataObj==null) return false;
	if(typeof(dataObj)=="string") {
		if(strKey==null) strKey = "";
		dataObj = this.getContentObjByDate(strKey,dataObj);
	}
	if(dataObj){
		var child = dataObj.firstChild;
		if(child!=null)
			dataObj.removeChild(child);
	}
	
}
/*********************
功能：
	清除内容的显示
参数：refreshData 是否清空掉显示的内容
**********************/
function Calendar_ClearShow(refreshData){
	this.clearData(refreshData);
	var childArr = this.tableElement.childNodes;
	if(childArr!=null){
		var oldLen = childArr.length,i=0;
		while(childArr.length > 0){
			var tmpDomObj = childArr[i];
			this.tableElement.removeChild(tmpDomObj);
			if(tmpDomObj!=null){//防止vpn情况问题
				if(childArr.length == oldLen)
					i++;
			}else break;
		}
	}
	if(this.contentObject!=null) this.contentObject = null;
}
/*********************
功能：
	装载数据
参数：refreshData 是否清空原来的数据
**********************/
function Calendar_LoadData(refreshData) {
	var addNum = 0;	
	var endDate = "";
	if(this.startDate==null) {
		if(this.oldStartDate==null){
			this.oldStartDate = Calendar_FormatDate(new Date());
		}
		this.startDate = this.checkDate();
	}
   	var dt = Calendar_ParseDate(this.startDate);    
 	if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO || this.listType==CALENDARVIEW_TYPE_WEEK_SEVENT){
		addNum = 7;
	}else if(this.listType==CALENDARVIEW_TYPE_DAY){
		addNum = 1;
	}else{
		var days=this.getDays(dt);
		dt.setDate(days[dt.getMonth()]);
	}
	if(addNum>0){
		endDate = this.getDate(dt,addNum);
	}else{
		endDate = Calendar_FormatDate(dt);
	}
	if(refreshData==null && this.hasGetData) {
		if(this.loadDataBegin<=this.startDate && this.loadDataEnd>=endDate) return true;
		else this.dataList = new Array();
	}else{
		this.dataList = new Array();
	}	
	
	if(this.beanURL==null) {
		this.beanURL = XMLDATABEANURL + this.beanName;
	}

	var beanURL = Com_SetUrlParameter(this.beanURL,"begindate",this.startDate);
	beanURL = Com_SetUrlParameter(beanURL,"enddate",endDate);
	beanURL = Com_SetUrlParameter(beanURL,"listType",this.listType);
	beanURL = Com_SetUrlParameter(beanURL,"seq",Math.random());
	beanURL = Com_CopyParameter(beanURL);
	var nodes = new KMSSData().AddXMLData(beanURL).GetHashMapArray();
	for(var i=0;i< nodes.length;i++){
		this.addKey(nodes[i]["strKey"]);
		this.addDataList(new CalendarDoc(nodes[i]["text"],nodes[i]["begindate"],nodes[i]["enddate"],nodes[i]["title"],nodes[i]["href"],nodes[i]["strKey"],nodes[i]["nodeType"],nodes[i]["importance"],nodes[i]["applyDept"]))
		//this.dataList[this.dataList.length] = new CalendarDoc(nodes[i]["text"],nodes[i]["begindate"],nodes[i]["enddate"],nodes[i]["title"],nodes[i]["href"],nodes[i]["strKey"],nodes[i]["nodeType"],nodes[i]["importance"]);
	}
	this.loadDataBegin = this.startDate;
	this.loadDataEnd = endDate;
	this.hasGetData = true;
}
/*********************
功能：
	添加一个关键字列表
参数：strKey 关键字值
**********************/
function Calendar_AddKey(strKey){
	if(strKey==null || strKey=="") return false;
	for(var i=0;i<this.keyList.length;i++){
		if(this.keyList[i]==strKey) break;
	}

	if(i>=this.keyList.length){
		this.keyList[this.keyList.length] = strKey;
	}
}
/*********************
功能：
	获取某天的文档列表
参数：	strKey 关键字
	date 时间值
**********************/
function Calendar_GetDataListByDate(strKey,date){
	var result = new Array();
	if(strKey==null) strKey = "";
	if(date!=null) {
		for(var i=0;i<this.dataList.length;i++){
			if(this.dataList[i].key==null||this.dataList[i].key==strKey){
				for(var j=0;j<this.dataList[i].dateList.length;j++){
					if(this.dataList[i].dateList[j]==date){
						result[result.length] = this.dataList[i];
						break;  
					}
				}
			}
		}
	}
	return result; 
}
/*********************
功能：
	获取当前时间增加一天数或者月数之后的时间值
参数：	
	dt 基准日期
	addNum,增加的天数
	addMonth,增加月数
**********************/
function Calendar_GetDate(dt,addNum,addMonth) {
	if(dt==null) return null;
	if(addNum==null) addNum=0;
	if(addMonth==null) addMonth=0;
	var days=this.getDays(dt);
   	if(addNum!=0){
   		day = dt.getDate()+addNum;
   		var i = dt.getMonth();   				
  		while(day<0 || day>days[i]){
   			day = day<0?day+days[(i==0?11:i-1)]:day-days[i];
   			i = addNum<0?i-1:i+1;
   			addMonth = addNum<0?addMonth-1:addMonth+1;
   			if(i>11) i = 0;
   			else if(i<0) i = 11;
   		}   			
   		dt.setDate(day);   		
       }
       if(addMonth!=0){
   		var month = dt.getMonth();   		
   		month = month + addMonth;
   		var addYear = 0;
   		while(month<0 || month>11) {
   			month = month>11?month-12:12+month;
   			addYear = addMonth>0?addYear+1:addYear-1;
   		}
   		dt.setMonth(month);
   		dt.setYear(dt.getFullYear()+addYear);       
       }
	return Calendar_FormatDate(dt);	
	
}
/*********************
功能：
	规范和获取当前时间
参数：
**********************/
function Calendar_CheckDate(startDate,ListType) {
	if(ListType==null) ListType = this.listType;
	if(startDate==null || startDate=="") {
		var nowDt = new Date();
		startDate = Calendar_FormatDate(nowDt);
	}
	var DT = Calendar_ParseDate(startDate);
	if(ListType==CALENDARVIEW_TYPE_DAY){
		return startDate;
	}else if(ListType==CALENDARVIEW_TYPE_WEEK_TWO || ListType==CALENDARVIEW_TYPE_WEEK_SEVENT) {
  		var daynum = DT.getDay();   
  		if(daynum == 0) {
  			return startDate;
  		}
  		if(DT.getDate()>=daynum){
  			DT.setDate(DT.getDate()-daynum);
  		}else if(DT.getMonth()==0) {
      		DT.setDate(31-daynum+DT.getDate());
       		DT.setYear(DT.getFullYear()-1);
       		DT.setMonth(11);           
  		}else{
    		var days=this.getDays(DT);
    		DT.setMonth(DT.getMonth()-1);
    		DT.setDate(days[DT.getMonth()]-daynum+DT.getDate());
    	}     	
	}else if(ListType==CALENDARVIEW_TYPE_MONTH){
		DT.setDate(1);
	}
	return Calendar_FormatDate(DT);
  }
/*********************
功能：
	获取每年每个月的天数
参数：
**********************/
function Calendar_GetDays(dt) {
	var calYear = dt.getFullYear();
	var days=[31,(calYear%4==0&&calYear%100!=0||calYear%400==0)?29:28,31,30,31,30,31,31,30,31,30,31];
	return days;
}
/*********************
功能：
	获取翻页
参数：page 整数 前N页,负数表示前翻
**********************/
function Calendar_GoPage(page){
	if(page==null || page==0){
		return false;
	}
	var day,addNum,addMonth=0;
	var startDate = this.startDate;
	var dt = Calendar_ParseDate(startDate);
	if(this.listType == CALENDARVIEW_TYPE_WEEK_TWO || this.listType == CALENDARVIEW_TYPE_WEEK_SEVENT) {
		addNum = page*7;		
	}
   	else if(this.listType==CALENDARVIEW_TYPE_MONTH) {
   		addMonth = page;		
   		addNum = 0;
   	}else if(this.listType==CALENDARVIEW_TYPE_DAY) {
   		addNum = 1*page;   		
   	}
	
   	startDate = this.getDate(dt,addNum,addMonth);  
   	this.oldStartDate = null;
	this.goto(startDate);
}
/*********************
功能：
	字符串转换成时间日期型值（YYYY-MM-DD）
参数：strDate 日期字符串
**********************/
function Calendar_ParseDate(strDate){
	return formatDate(strDate,Data_GetResourceString("date.format.date"));
}
/*********************
功能：
	格式化日期（YYYY-MM-DD）
参数：date 要格式化的日期对象
**********************/
function Calendar_FormatDate(date){
	if(typeof(date)=="string"){
		date = Calendar_ParseDate(date);
	}
	var pattern = Data_GetResourceString("date.format.date");
	return date.format(pattern);
}
/*********************
功能：
	鼠标移动触发事件
参数：
**********************/
function Calendar_OnMouseOver() {
	var obj = Com_GetEventObject();
	if(obj){
		obj = obj.srcElement;
		sourceObj = obj;
		while(obj!=null&&obj.tagName!="TABLE") obj = obj.parentElement;
		if(obj!=null){
			obj = obj.parentElement;
			if(sourceObj.className!=null) sourceObj.oldClassName = sourceObj.className;
			sourceObj.className = obj.className + "_mouseOver";
		}
	}
}
/*********************
功能：
	鼠标移出触发事件
参数：
**********************/
function Calendar_OnMouseOut() {
	var obj = Com_GetEventObject();
	if(obj){
		obj = obj.srcElement||obj.target;
		if(obj.oldClassName!=null) obj.className = obj.oldClassName
		else obj.className = "";
	}
}
/*********************
功能：
	鼠标点击触发事件
参数：
**********************/
function Calendar_OnClick() {
	var obj = Com_GetEventObject();	
	if(obj){
		obj.cancelBubble = true;
		obj = obj.srcElement?obj.srcElement : obj.target;
		while(obj!=null&&obj.tagName!="TD") obj = obj.parentElement;
		if(this.onCustomQueryClick!=null){
			if(!this.onCustomQueryClick(obj)) return false;
		}		
		if(obj.dataObj!=null){
			if(obj.dataObj.href!=null){
				Com_OpenWindow(obj.dataObj.href);
			}
		}
	}
	if(this.onCustomPostClick!=null){
		if(!this.onCustomPostClick(obj)) return false;
	}
	
}
/******************************
功能: 
	鼠标点击标题触发事件
参数
	dayTime:跳转时间
	listType：跳转类型
	refreshData:是否更新数据
*******************************/
function Calendar_OnTitleClick(dateTime,listType,refreshData){
	if(this.clickURL==null)
		this.goto(dateTime,listType,refreshData);
	else{
		var newURL = this.clickURL.replace('!{datetime}',dateTime);
		window.open(encodeURI(newURL));
	}
}
/*********************
功能：
	读取当前的标题
参数：
**********************/
function Calendar_GetTitle(){
	var st = Calendar_ParseDate(this.OldStartDate==null?this.startDate:this.OldStartDate);
	if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO || this.listType==CALENDARVIEW_TYPE_WEEK_SEVENT){
		var nowt = Calendar_ParseDate(Calendar_FormatDate(new Date()));
		var base = Calendar_ParseDate("2002-01-06");
		var weekBase = parseInt((nowt-base)/(24*3600000)/7);
		var weekNum = parseInt((st-base)/(24*3600000)/7);
		if(weekBase==weekNum){
			return document.createTextNode(CalendarMsg_Info["thisWeek"]);
		}else if(weekBase>weekNum){
			return document.createTextNode(CalendarMsg_Info["prevWeek"].replace("{0}",weekBase-weekNum));
		}else{
			return document.createTextNode(CalendarMsg_Info["nextWeek"].replace("{0}",weekNum-weekBase));
		}
	}else if(this.listType==CALENDARVIEW_TYPE_DAY){
		var nowt = Calendar_ParseDate(Calendar_FormatDate(new Date()));
		var dayNum = parseInt((nowt-st)/(24*3600000));
		if(dayNum==0){
			return document.createTextNode(CalendarMsg_Info["thisDay"]);
		}else if(dayNum>0){
			return document.createTextNode(CalendarMsg_Info["prevDay"].replace("{0}",dayNum));
		}else{
			return document.createTextNode(CalendarMsg_Info["nextDay"].replace("{0}",-dayNum));
		}
	}else{
		var retObj = document.createElement("DIV");
		var calendarView = this;
		var link1 = document.createElement("A");
		link1.className = "calviewTitle_link";
		link1.onclick = function(){
			calendarView.showYearChoice();
			return false;
		}
		Com_SetInnerText(link1,st.getFullYear()+ CalendarMsg_Info["year"]);
		retObj.appendChild(link1);
		var link2 = document.createElement("A");
		link2.className = "calviewTitle_link";
		link2.onclick = function(){
			calendarView.showMonthChoice();
		}
		Com_SetInnerText(link2,CalendarMsg_Info["months"][st.getMonth()]);
		retObj.appendChild(link2);
		return  retObj;				
	}	
}
/*********************
功能：
	截取当前文档的主题
参数：words 主题
**********************/
function Calendar_GetWordsByLength(words) {
	var length = this.getWordLength();
	var len = 0;
	var i, c;
	for(i=0; i<words.length; i++){
		c = words.charAt(i);
		if(encodeURIComponent(c).length>6)
			len += 2;
		else
			len ++;
		if(len>length)
			break;
	}
	if(i<words.length)
		words = words.substring(0, i-2) + "...";
	return words;

}
/*********************
功能：
	获取当前文档的主题的长度
参数：word 主题
**********************/
function Calendar_GetWordLength() {
	var wordRate = (screen.width-200)/(1024-200);
	var wordLength;
	if(this.listType==CALENDARVIEW_TYPE_DAY){
		if(this.wordLength_Day==0) 
			this.wordLength_Day = Math.floor(CALENDARVIEW_DOC_WORDLENGTH_DAY*wordRate);
		return this.wordLength_Day;		
	}else if(this.listType==CALENDARVIEW_TYPE_WEEK_TWO){
		if(this.wordLength_Week_Two==0) 
			this.wordLength_Week_Two = Math.floor(CALENDARVIEW_DOC_WORDLENGTH_WEEK_TWO*wordRate);
		return this.wordLength_Week_Two;
	}else if(this.listType==CALENDARVIEW_TYPE_WEEK_SEVENT){
		if(this.wordLength_Week_Sevent==0) 
			this.wordLength_Week_Sevent = Math.floor(CALENDARVIEW_DOC_WORDLENGTH_WEEK_SEVENT*wordRate);
		return this.wordLength_Week_Sevent;
	}else{
		if(this.wordLength_Month==0) 
			this.wordLength_Month = Math.floor(CALENDARVIEW_DOC_WORDLENGTH_MONTH*wordRate);
		return this.wordLength_Month;		
	}

}
/*********************
功能：
	显示筛选的菜单
参数：
**********************/
function Calendar_ShowChioceMenu() {
	if(this.keyList==null|| this.keyList.length==0) return false;
	if(this.showKeyList==null) this.showKeyList = this.keyList;
	popWin = new PopWinObject();
	popWin.HideWhenMouseOut = true;
	popWin.ClearWhenHide = true;
	popWin.Document.oncontextmenu = function(){return false};
	popWin.Body.style.marginTop = 0;
	popWin.Body.style.marginBottom = 4;
	popWin.Body.style.marginLeft = 0;
	popWin.Body.style.marginRight = 4;
	popWin.Body.style.backgroundColor = "#aabbdd";
	
	var i,j,k;
	var result = "";
	var isCheck=" ";
	result = "<table bgcolor=#999999 border=0 cellspacing=1 cellpadding=4 width=300><tr>";
	k = 0;
	for(i=0;i<this.keyList.length;i++) {
		for(j=0;j<this.showKeyList.length;j++) 
			if(this.keyList[i]==this.showKeyList[j]) {isCheck=" checked";break;}
		result +="<td bgcolor=#F3F3F3 nowrap width=33% style='font-family:Microsoft YaHei, Geneva,SimSun;font-size: 12px;'><input type=checkbox onClick='parent."+this.refName+".onChoiceClick(" + i + ",this.checked);' name=" + this.refName + "_Choice value="+this.keyList[i]+isCheck+" text="+this.keyList[i]+">"+this.keyList[i]+"</td>";
		if(k==2 && i<this.keyList.length-1)
		{
			result +="</tr><tr>";
			k=0;
		}else
			k++;
		isCheck=" "
	}
	for(;k<3; k++)
		result += "<td bgcolor=#F3F3F3>&nbsp;</td>";
	result += "</tr></table>";
	var obj = Com_GetEventObject();
	popWin.PopByPoint(result,obj.x,obj.y);
}
/*********************
功能：
	筛选触发按钮
参数：index keylist的标号
      checked 选中还是不选中
**********************/
function Calendar_OnChoiceClick(index,checked) {
	if(index>=this.keyList.length) return false;
	if(checked) {
		this.showKeyList[this.showKeyList.length] = this.keyList[index]
	}else{
		var result = new Array();
		for(var i=0;i<this.showKeyList.length;i++) {
			if(this.showKeyList[i]!= this.keyList[index])
				result[result.length] = this.showKeyList[i];
		}
		this.showKeyList = result;
	}
	this.clearShow(false);
	this.show();
}
/*********************
功能：
	添加数据
参数：node 节点 
      orderBy 排序属性
**********************/
function Calendar_AddDataList(node,orderBy) {
	if(orderBy==null) orderBy = "startTime";
	this.dataList[this.dataList.length] = node;
	for(var i=this.dataList.length-1;i>0;i--){
		if(this.dataList[i-1][orderBy]>this.dataList[i][orderBy]){
			var tmpNode = this.dataList[i];
			this.dataList[i] = this.dataList[i-1];
			this.dataList[i-1] = tmpNode;
		}else{
			break;
		}
	}
}
/*********************
功能：
	获取日期的显示
参数：month 月份
      day 日期
**********************/
function Calendar_GetDayName(month,day){
	//var strDayName = CalendarMsg_Info["dayname"];
	//if(strDayName==null) strDayName =  month + "." + day;
	//strDayName = strDayName.replace("{0}",month).replace("{1}",day);
	//return strDayName;
	
	var pattern = Data_GetResourceString("date.format.date");	
	var dt = new Date();
	dt.setDate(day);
	dt.setMonth(month-1);	
	return dt.format(pattern);
}

function Calendar_ShowYearChoice(theYear) {
	var st = Calendar_ParseDate(this.OldStartDate==null?this.startDate:this.OldStartDate);
	if(theYear==null) {
		year = st.getFullYear();
		if(year<100) year += 1900;
		theYear = year;
		var rm = new RightMenuObject(65);
	}else {
		rm = this.rm;
		rm.MenuItems = new Array;
		year = theYear;
	}	
	year = year-5;	
	rm.AddItem("　∧",this.refName+".showYearChoice",theYear+1);
	for(var i=0;i<10;i++){
		rm.AddItem((year+i)+ CalendarMsg_Info["year"],this.refName+".gotoYear",(year+i));
	}
	rm.AddItem("　∨",this.refName+".showYearChoice",theYear-1);
	rm.Show();
	this.rm = rm;	
}

function Calendar_ShowMonthChoice() {
	var st = Calendar_ParseDate(this.OldStartDate==null?this.startDate:this.OldStartDate);
	var month = st.getMonth();
	var rm = new RightMenuObject(65);
	for(var i=0;i<12;i++){
		rm.AddItem(CalendarMsg_Info["months"][i],this.refName+".gotoMonth",i.toString());
	}
	rm.Show();
}

function Calendar_GotoMonth(month){
	var monthVar=0;
	if(!isNaN(month))
		monthVar=parseInt(month,10);
	var st = Calendar_ParseDate(this.OldStartDate==null?this.startDate:this.OldStartDate);
	st.setMonth(monthVar);
	this.goto(Calendar_FormatDate(st));
}

function Calendar_GotoYear(year){
	var st = Calendar_ParseDate(this.OldStartDate==null?this.startDate:this.OldStartDate);
	st.setYear(year);
	this.goto(Calendar_FormatDate(st));
}