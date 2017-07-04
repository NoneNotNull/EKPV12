/***********************************************
功能：显示标签表格的第几个标签,修改core中原方法原当前页和现当前页索引号不能相同的缺陷，并增加拖拽框同步
参数：
	tableName：
		必选，字符串，表格ID
	index：
		必选，整数，标签索引号
***********************************************/
function _Designer_Control_LabelTable__SetCurrentLabel(tableName, index, noEvent)
{
	var tbObj = document.getElementById(tableName);
	var curLabel = tbObj.getAttribute("LKS_CurrentLabel");
	var imagePath = Com_Parameter.StylePath+"doc/";
	var imgId = tableName + "_Label_Img_";
	var btnId = tableName + "_Label_Btn_";
	document.getElementById(btnId+index).blur();
	var switchFunc = tbObj.getAttribute("LKS_OnLabelSwitch");
	if(!noEvent && switchFunc!=null){
		var switchFuncArr = switchFunc.split(";");
		for(var i=0; i<switchFuncArr.length; i++){
			if(window[switchFuncArr[i]]!=null && window[switchFuncArr[i]](tableName, index)==false)
				return;
		}
	}
	var btnObj;
	if(curLabel!=null&&curLabel!=index){
		document.getElementById(imgId+curLabel+"_1").src = imagePath + "graylabbg1.gif";
		btnObj = document.getElementById(btnId+curLabel);
		btnObj.style.backgroundImage = "url(" + imagePath + "graylabbg2.gif)";
		btnObj.className = "btnlabel2";
		document.getElementById(imgId+curLabel+"_2").src = imagePath + "graylabbg3.gif";
	}
	document.getElementById(imgId+index+"_1").src = imagePath + "curlabbg1.gif";
	btnObj = document.getElementById(btnId+index);
	btnObj.style.backgroundImage = "url(" + imagePath + "curlabbg2.gif)";
	btnObj.className = "btnlabel1";
	document.getElementById(imgId+index+"_2").src = imagePath + "curlabbg3.gif";
	for(var i=1; i<tbObj.rows.length; i++)
		tbObj.rows[i].style.display = i==index?"":"none";
	tbObj.setAttribute("LKS_CurrentLabel", index);

}