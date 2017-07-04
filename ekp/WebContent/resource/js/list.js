/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了视图界面中常用的函数

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
/***********************************************
视图列表中样式的重载说明：
	若要使用标签表格的功能，请在页面中定义一个ID为"List_ViewTable"的多行一列表格，
	将表格中标题行的复选框名称设为"List_Tongle"，内容行中的复选框设为"List_Selected"。
	若不希望用默认的命名规则，或希望出现多个列表，请改写List_TBInfo的配值，其值的格式为请参考上面的声明。
***********************************************/

Com_RegisterFile("list.js");
Com_IncludeFile("list_page.js", "style/"+Com_Parameter.Style+"/list/");
List_TBInfo = new Array(
	{TBID:"List_ViewTable", tongleboxName:"List_Tongle", checkName:"List_Selected"}
);

/***********************************************
功能：选择标题行复选框触发的动作，全选/全不选
***********************************************/
function tongleSelect(checkname,tongleboxname){
	var checkAll = document.getElementsByName(checkname);
	var tonglebox = document.getElementsByName(tongleboxname)[0];
	for (var i=0;i<checkAll.length;i++)
		checkAll[i].checked = tonglebox.checked;
}

/***********************************************
功能：选择内容行复选框触发的动作，重置标题行复选框状态
***********************************************/
function resetTongle(checkname,tongleboxname){
	var checkAll = document.getElementsByName(checkname);
	for (var i=0; i<checkAll.length; i++)
		if(!checkAll[i].checked)
			break;
	document.getElementsByName(tongleboxname)[0].checked = i==checkAll.length;
}

/***********************************************
功能：校验是否是整形的输入
***********************************************/
function validateInteger(field) {
	var bValid = true;
    if (field.type == 'text' ||
    	field.type == 'textarea' ||
		field.type == 'select-one' ||
		field.type == 'radio') {
		var value = '';
		if (field.type == "select-one") {
			var si = field.selectedIndex;
		    if (si >= 0) {
			    value = field.options[si].value;
		    }
		} else {
			value = field.value;
		}
		if (value.length > 0) {
			if (!isAllDigits(value)) {
				bValid = false;
				field.focus();					        
			} else {
				var iValue = parseInt(value);
				if (isNaN(iValue) || !(iValue >= -2147483648 && iValue <= 2147483647)) {
					if (i == 0) {
						focusField = field;
					}
					bValid = false;
				}
			}
		}
	}
	return bValid;
}

/***********************************************
功能：校验是否是数组的输入
***********************************************/
function isAllDigits(argvalue) {
	argvalue = argvalue.toString();
	var validChars = "0123456789";
	var startFrom = 0;
	if (argvalue.substring(0, 2) == "0x") {
	   validChars = "0123456789abcdefABCDEF";
	   startFrom = 2;
	} else if (argvalue.charAt(0) == "0") {
	   validChars = "01234567";
	   startFrom = 1;
	} else if (argvalue.charAt(0) == "-") {
	   startFrom = 1;
	}
	
	for (var n = startFrom; n < argvalue.length; n++) {
	    if (validChars.indexOf(argvalue.substring(n, n+1)) == -1) return false;
	}
	return true;
}

//=============================以下函数为内部函数，普通模块请勿调用==============================
/***********************************************
功能：整理视图列表中的样式
说明：该函数将在页面载入的时候自动运行，详细说明请间文件说明后的部分。
***********************************************/
function List_ReloadCSS(){
	var TBObj, i, j, k, href, obj;
	var wordRate = (screen.width-200)/(1024-200);
	for(i=0; i<List_TBInfo.length; i++){
		TBObj = document.getElementById(List_TBInfo[i].TBID);
		if(TBObj==null)
			continue;
		TBObj.style.width = "100%";
		TBObj.rows[0].className = "tr_listfirst";
		for(j=0; j<TBObj.rows[0].cells.length; j++)
			TBObj.rows[0].cells[j].noWrap = true;
		for(j=1; j<TBObj.rows.length; j++){
			TBObj.rows[j].className = (j % 2==0)?"tr_listrow2":"tr_listrow1";
			TBObj.rows[j].onmouseover = List_Onmouseover;
			var href = TBObj.rows[j].getAttribute("kmss_href");
			if(href!=null && href!=""){
				TBObj.rows[j].onclick = List_ClickRow;
				TBObj.rows[j].style.cursor = "pointer";
			}
			for(k=0; k<TBObj.rows[j].cells.length; k++){
				var wordLength = TBObj.rows[j].cells[k].getAttribute("kmss_wordlength");
				if(wordLength==null)
					continue;
				wordLength = parseInt(wordLength);
				if(isNaN(wordLength) || wordLength<1)
					continue;
				wordLength = Math.floor(wordLength*wordRate);
				var wordStr = TBObj.rows[j].cells[k].innerHTML;
				wordStr = wordStr.replace(/^\s*(\S+)\s*$/, "$1");
				TBObj.rows[j].cells[k].title = wordStr;
				TBObj.rows[j].cells[k].innerHTML = List_GetWordsByLength(wordStr.replace(/\s+/gi, " "), wordLength);
				TBObj.rows[j].cells[k].style.textAlign = "left";
			}
		}
		obj = TBObj.getElementsByTagName("input");
		for(j=0; j<obj.length; j++)
			Com_AddEventListener(obj[j], "click", List_CancelRowClick);
		obj = TBObj.getElementsByTagName("a");
		for(j=0; j<obj.length; j++)
			Com_AddEventListener(obj[j], "click", List_CancelRowClick);
		obj = document.getElementsByName(List_TBInfo[i].tongleboxName);
		if(obj.length>0){
			eval("List_TmpFunction = function(){tongleSelect('"+List_TBInfo[i].checkName+"', '"+List_TBInfo[i].tongleboxName+"')}");
			Com_AddEventListener(obj[0], "click", List_TmpFunction);
			eval("List_TmpFunction = function(){resetTongle('"+List_TBInfo[i].checkName+"', '"+List_TBInfo[i].tongleboxName+"')}");
			obj = document.getElementsByName(List_TBInfo[i].checkName);
			for(j=0; j<obj.length; j++)
				Com_AddEventListener(obj[j], "click", List_TmpFunction);
		}
	}
}

function List_GetWordsByLength(words, length){
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

/***********************************************
功能：取消行的事件冒泡
***********************************************/
function List_CancelRowClick(){
	Com_GetEventObject().cancelBubble = true;
}

/***********************************************
功能：行的点击事件
***********************************************/
function List_ClickRow(){
	Com_OpenWindow(this.getAttribute("kmss_href"), this.getAttribute("kmss_target"), this.getAttribute("kmss_winstyle"), this.getAttribute("kmss_keepurl"));
}

/***********************************************
功能：行的mouseover事件
***********************************************/
function List_Onmouseover(){
	if(List_CurrentRowInfo.rowObj!=null)
		List_CurrentRowInfo.rowObj.className = List_CurrentRowInfo.className;
	List_CurrentRowInfo.rowObj = this;
	List_CurrentRowInfo.className = List_CurrentRowInfo.rowObj.className;
	this.className = "tr_listrowcur";
}

List_CurrentRowInfo = new Object;		//当前行的信息
List_TmpFunction = null;				//临时变量
Com_AddEventListener(window, "load", List_ReloadCSS);
//=============================以上函数为内部函数，普通模块请勿调用==============================