/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了文档界面中常用的函数

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/
/***********************************************
标签表格使用说明：
	若要使用标签表格的功能，请在页面中定义一个ID为"Label_Tabel"的多行一列表格，
	表格中每个TR元素通过设置LKS_LabelName的属性，声明标签的文本，如：<tr LKS_LabelName="我的工作">。
	若不希望用默认表格ID的名称，或在一个页面中需要定义多个标签表格，请改写全局变量Doc_LabelInfo的值（表格ID名数组）。
***********************************************/

Com_RegisterFile("docutil.js");
Com_IncludeFile("jquery.js");
Doc_LabelInfo = new Array("Label_Tabel");
if(window.Doc_LabelClass==null){
	Doc_LabelClass = {};
};

/***********************************************
功能：显示点击的标签
Doc_LoadFrame使用说明：
       要使用此方法必须在doc的Tab页下任意dom元素中使用KMSS_OnShow事件来调用此方法
        举例：<tr  LKS_LabelName=""  style="display:none" >
              <td id="punish" KMSS_OnShow="Doc_LoadFrame('punish',url)>
参数：
	tdId：
		必选，字符串，表格ID
	loadUrl：
		必选，字符串，要载入的Url
***********************************************/
function Doc_LoadFrame(tdId, loadUrl){
	var tdObj = null; 
	if(typeof(tdId)=="string"){
		tdObj = document.getElementById(tdId);
	}else{
		tdObj = tdId;
	}
	if(tdObj!=null){
		var iframeObj = tdObj.getElementsByTagName("IFRAME")[0];
		if(iframeObj!=null && (iframeObj.getAttribute("src")==""||iframeObj.getAttribute("src")==null)){
			iframeObj.setAttribute("src", loadUrl);
		}
	}
}

function Doc_GetStyleInfo(table){
	var style = table.getAttribute("LKS_LabelClass");
	if(style==null || Doc_LabelClass[style]==null){
		return {
			imagePath:Com_Parameter.StylePath+"doc/",
			classPrefix:""
		};
	}else{
		return {
			imagePath : Doc_LabelClass[style].imagePath,
			classPrefix : Doc_LabelClass[style].classPrefix
		};
	}
}
/***********************************************
功能：显示标签表格的第几个标签
参数：
	tableName：
		必选，字符串，表格ID
	index：
		必选，整数，标签索引号
***********************************************/
function Doc_SetCurrentLabel(tableName, index, noEvent){
	var tbObj = document.getElementById(tableName);
	var curLabel = tbObj.getAttribute("LKS_CurrentLabel");
	if(curLabel==index)
		return;
	var styleInfo = Doc_GetStyleInfo(tbObj);
	var imgId = tableName + "_Label_Img_";
	var btnId = tableName + "_Label_Btn_";
	
	var switchFunc = tbObj.getAttribute("LKS_OnLabelSwitch");
	if(!noEvent && switchFunc!=null){
		var switchFuncArr = switchFunc.split(";");
		for(var i=0; i<switchFuncArr.length; i++){
			if(window[switchFuncArr[i]]!=null && window[switchFuncArr[i]](tableName, index)==false)
				return;
		}
	}
	var btnObj;
	if(curLabel!=null){
		document.getElementById(imgId+curLabel+"_1").src = styleInfo.imagePath + "graylabbg1.gif";
		btnObj = document.getElementById(btnId+curLabel);
		btnObj.style.backgroundImage = "url(" + styleInfo.imagePath + "graylabbg2.gif)";
		btnObj.className = styleInfo.classPrefix+"btnlabel2";
		document.getElementById(imgId+curLabel+"_2").src = styleInfo.imagePath + "graylabbg3.gif";
	}
	document.getElementById(imgId+index+"_1").src = styleInfo.imagePath + "curlabbg1.gif";
	btnObj = document.getElementById(btnId+index);
	btnObj.style.backgroundImage = "url(" + styleInfo.imagePath + "curlabbg2.gif)";
	btnObj.className = styleInfo.classPrefix+"btnlabel1";
	document.getElementById(imgId+index+"_2").src = styleInfo.imagePath + "curlabbg3.gif";
	//先显示，后隐藏，避免页面滚动
	var trObj = $(tbObj.rows[index]);
	trObj.show();
	var resizeArr = trObj.find("*[KMSS_OnShow]:visible");
	var resizeAttr = "";
	if(resizeArr.length>0){
		resizeAttr = "KMSS_OnShow";
	}else{
		if(!Com_Parameter.IE ){
			resizeArr = trObj.find("*[onresize]:visible");
			resizeAttr = "onresize";
		}
	}
	if(resizeArr.length>0){
		resizeArr.each(function(){
			var funStr = this.getAttribute(resizeAttr);
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call(this, Com_GetEventObject());
			}
		});
	}
	for(var i=1; i<tbObj.rows.length; i++){
		if(i!=index){
			$(tbObj.rows[i]).hide();
		}
	}
	tbObj.setAttribute("LKS_CurrentLabel", index);
}

function Doc_AddLabelSwitchEvent(table, funcName){
	if(typeof(table)=="string"){
		table = document.getElementById(table);
	}
	var att = table.getAttribute("LKS_OnLabelSwitch");
	att = att==null?funcName:att+";"+funcName;
	table.setAttribute("LKS_OnLabelSwitch", att);
}

function Doc_GetLabelStyle(tableName, index){
	var tbObj = document.getElementById(tableName);
	var btnId = tableName + "_Label_Btn_"+index;
	return document.getElementById(btnId).style;
}

function Doc_DisableLabel(tableName, index, disabled){
	var tbObj = document.getElementById(tableName);
	var btnId = tableName + "_Label_Btn_"+index;
	var btn = document.getElementById(tableName + "_Label_Btn_"+index);
	if(btn==null){
		setTimeout("Doc_DisableLabel(\""+tableName+"\","+index+","+disabled+")", 100);
	}else{
		btn.disabled = disabled;
	}
}

/***********************************************
功能：禁用标签表格的相应id的标签
备注：使用此方法需在标签行增加LKS_LabelId属性
参数：
	labelId：
		必选，字符串，标签行LKS_LabelId值
	disabled：
	    必选，布尔值
	add by limh 2010年12月15日
***********************************************/
function Doc_DisableLabelById(labelId, disabled){
    var	labelObj = document.getElementById(labelId);
	if(!labelObj){
		setTimeout("Doc_DisableLabelById('"+labelId+"',"+disabled+")",100);			
	}
	else{
		labelObj.disabled = disabled;
		for(var i=0;i<labelObj.childNodes.length;i++){
			if(labelObj.childNodes[i].tagName=="INPUT"){
				labelObj.childNodes[i].disabled = disabled;
			}
		}
	}
}


/***********************************************
功能：隐藏标签表格的相应id的标签
备注：使用此方法需在标签行增加LKS_LabelId属性
参数：
	tableName：
		必选，字符串，表格ID
	labelId：
		必选，字符串，标签行LKS_LabelId值
	add by limh 2010年12月15日
***********************************************/
function Doc_HideLabelById(tableName,labelId){			
    var	labelObj =document.getElementById(labelId);
		if(!labelObj){
			setTimeout("Doc_HideLabelById('"+tableName+"','"+labelId+"')",100);			
		}
		else{
			var tbObj = document.getElementById(tableName);
			labelObj.style.display = "none";
			var index = 0;
			var hideIndex;
			for(var i=0;i<tbObj.rows.length;i++){
				var LabelId_Temp = tbObj.rows[i].getAttribute("LKS_LabelId");
				var LKS_LabelName = tbObj.rows[i].getAttribute("LKS_LabelName");
				if(LKS_LabelName){
					index++;
					if(LabelId_Temp&&LabelId_Temp==labelId){
						tbObj.rows[i].style.display="none";
						hideIndex = index;
					}
				}
				
			}
			var curLabel = tbObj.getAttribute("LKS_CurrentLabel");
			if(curLabel&&curLabel!=new String(hideIndex)){
				Doc_SetCurrentLabel(tableName, curLabel, true);
			}
			else{
				for(var i=1;i<index+1;i++){
					if(i!=hideIndex){
						Doc_SetCurrentLabel(tableName, new String(i), true);						
						break;
					}
				}
			}
		}
}

function Doc_RefreshWithLabel(paramName, index){
	var url = Com_SetUrlParameter(location.href, paramName, index);
	window.open(url, "_self");
}

function Doc_RefreshWithLabelName(paramName, labelName){
	var index = 0;
	outloop:
	for(var i=0; i<Doc_LabelInfo.length; i++){
		var tbObj = document.getElementById(Doc_LabelInfo[i]);
		for(var j=1; j<tbObj.rows.length; j++){
			if(tbObj.rows[j].getAttribute("LKS_LabelName")==labelName){
				index = j;
				break outloop;
			}
		}
	}
	var url = location.href;
	if(index>0){
		url = Com_SetUrlParameter(url, paramName, index);
	}
	window.open(url, "_self");
}

//=============================以下函数为内部函数，普通模块请勿调用==============================
/***********************************************
功能：显示标签表格
说明：该函数将在页面载入的时候自动运行，详细说明请间文件说明后的部分。
***********************************************/
function Doc_ShowLabelTable(setLabelTable){
	var  showLabelTable = Doc_LabelInfo ;
	if(setLabelTable!=null)
		showLabelTable = [setLabelTable];
	for(var n=0; n<showLabelTable.length; n++){
		var tableName = showLabelTable[n];
		var tbObj = document.getElementById(tableName);
		if(tbObj==null)
			continue;
		if(setLabelTable==null){
			//非加载指定labeltable时，对于设置了LKS_LabelTableShow为不显示的不做显示处理，
			//可由其自定义调用展现
			var isShow = tbObj.getAttribute("LKS_LabelTableShow");
			isShow = isShow==null?"1":isShow;
			if(isShow!="1" && isShow!="true") continue;
		}
		//var init = tbObj.getAttribute("LKS_Initialized");
		//if(init=="1") continue;
		var styleInfo = Doc_GetStyleInfo(tbObj);
		var curLabelIndex = tbObj.getAttribute("LKS_LabelDefaultIndex");
		if(curLabelIndex==null)
			curLabelIndex = -1;
		var maxLen = tbObj.getAttribute("LKS_LabelMaxLength");
		if(maxLen==null)
			maxLen = 100;
		else
			maxLen = parseInt(maxLen);
		tbObj.className = styleInfo.classPrefix + "tb_label";
		var imgId = tableName + "_Label_Img_";
		var btnId = tableName + "_Label_Btn_";
		var tdObj = tbObj.insertRow(0);
		tdObj = tdObj.insertCell(0);
		tdObj.className = styleInfo.classPrefix + "td_label0";
		var htmlCode = "";
		for(var i=1; i<tbObj.rows.length; i++){
			tbObj.rows[i].cells[0].className = styleInfo.classPrefix + "td_label";
			var attVal = tbObj.rows[i].getAttribute("LKS_LabelName");
			//增加标签头的id属性，此属性由标签行LKS_LabelId属性取得 add by limh 2010年12月14日
			var labelId = tbObj.rows[i].getAttribute("LKS_LabelId");
			if(attVal!=null && attVal!=""){
				var style = tbObj.rows[i].getAttribute("LKS_LabelStyle");
				tbObj.rows[i].setAttribute("LKS_LabelIndex", i);
				if(curLabelIndex==-1)
					curLabelIndex = i;
				var disName = attVal;
				if(disName.length>maxLen)
					disName = disName.substring(0, maxLen-2)+"..";
				//增加标签头的id属性 add by limh 2010年12月14日
				if(labelId){
					htmlCode += "<nobr id='"+labelId+"'>";
				}else{
					htmlCode += "<nobr>";
				}
				htmlCode += "<img id ='" + imgId + i + "_1' src='" + styleInfo.imagePath + "graylabbg1.gif' align=top>";				
				htmlCode += "<input type=button id='" + btnId + i + "' class="+styleInfo.classPrefix+"btnlabel2 value=\"" + disName.replace(/\"/gi, "&quot;") + "\"" +
					" title=\"" + attVal.replace(/\"/gi, "&quot;") + "\"" +
					" style='background:url("+styleInfo.imagePath+"graylabbg2.gif);" + (style==null?"":style) +
					"' onclick='Doc_SetCurrentLabel(\""+tableName+"\", "+i+");'>";
				htmlCode += "<img id ='" + imgId + i + "_2' src='" + styleInfo.imagePath + "graylabbg3.gif' align=top>&nbsp;</nobr>";
			}
		}
		tdObj.innerHTML = htmlCode;
		tbObj.style.display = "";
		if(curLabelIndex>-1)
			Doc_SetCurrentLabel(tableName, curLabelIndex, true);
	}
}

/***********************************************
功能：window的onload事件
***********************************************/
function Doc_OnLoad(){
	Doc_ShowLabelTable();
}
Com_AddEventListener(window, "load", Doc_OnLoad);
//=============================以上函数为内部函数，普通模块请勿调用==============================