<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
</head>
<script type="text/javascript">
Com_Parameter.DialogLang = parent.Com_Parameter.DialogLang;
function writeMessage(key){
	document.write(Com_Parameter.DialogLang[key]);
}
function writeButtonMessage(btnIds, keys){
	var btnArr = btnIds.split(";");
	var keyArr = keys==null?btnArr:keys.split(";");
	for(var i=0; i<btnArr.length;i++){
		document.getElementById(btnArr[i]).value = Com_Parameter.DialogLang[keyArr[i]];
	}
}
var dialogObject = parent.dialogObject;
</script>

<script>
Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
Com_IncludeFile("data.js");
var optData;
var optDataBackup = null;
function setOptData(data, isSearch){
	var obj = document.getElementById("btnClear");
	if(isSearch){
		if(optDataBackup==null)
			optDataBackup = optData;
		obj.disabled = false;
	}else{
		optDataBackup = null;
		obj.disabled = true;
	}
	if(data!=null)
		optData = data.Format("id:name:info");
	if(!(optData instanceof KMSSData))
		optData = new KMSSData(optData);
	optData.PutToSelect("F_OptionList", "id", "name");
}
function showDescription(data, index){
	var hashMapArr = data.GetHashMapArray();
	if(hashMapArr[index]!=null)
		document.getElementById("Span_MoreInfo").innerHTML = hashMapArr[index].info;
}
function searchUseXML(){
	var obj = document.getElementsByName("F_Keyword")[0];
	if(obj.value==""){
		alert(Com_Parameter.DialogLang.requiredKeyword);
		obj.focus();
		return;
	}
	var beanURL = dialogObject.searchBeanURL.replace(/!\{keyword\}/g, encodeURIComponent(obj.value));
	setOptData(new KMSSData().AddXMLData(beanURL), true);
}
window.onload = function(){
	if(dialogObject.searchBeanURL!=null){
		document.getElementById("Span_Search").style.display = "none";
		document.getElementById("TB_Search").style.display = "";
	}
	if(dialogObject.notNull){
		document.getElementById("btnSelectNone").style.display = "none";
	}
	setOptData(dialogObject.optionData);
	if(dialogObject.valueData!=null){
		var data = dialogObject.valueData;
		if(data!=null)
			document.getElementById("Span_CurValue").innerHTML = Com_Parameter.DialogLang.currentValue+data;
		//var data = dialogObject.valueData.GetHashMapArray();
		//if(data!=null && data.length>0 && data[0]["name"]!=null && data[0]["name"]!="")
		//	document.getElementById("Span_CurValue").innerHTML = Com_Parameter.DialogLang.currentValue+data[0]["name"];
	}
	writeButtonMessage("btnSearch;btnClear;btnOk;btnCancel;btnSelectNone;updateFunc;addFunc");
}
function Com_DialogReturnValue(){
	var rtnVal = new Array;
	var obj = document.getElementsByName("F_OptionList")[0];
	if(obj.selectedIndex==-1){
		alert(Com_Parameter.DialogLang.requiredSelect);
	}else{
		//rtnVal[0] = optData.GetHashMapArray()[obj.selectedIndex];
		rtnVal[0] = obj.value;
		rtnVal[1] = obj.options[obj.selectedIndex].text;
		parent.Com_DialogReturn(rtnVal);
	}
}
function Com_DialogUpdateFunc(){
	var rtnVal = new Array;
	var obj = document.getElementsByName("F_OptionList")[0];
	if(obj.selectedIndex==-1){
		alert(Com_Parameter.DialogLang.requiredFuncSelect);
	}else{
		var updateUrl = dialogObject.url+"?method=edit&fdId="+ obj.value;
		window.open(updateUrl);
	}
}
function Com_DialogAddFunc(){
	var categoryId = parent.treeFrame.getCategoryId();
	if(categoryId){
		var addUrl = dialogObject.url+"?method=add&categoryId="+categoryId;
		window.open(addUrl);
	}else{
		alert(Com_Parameter.DialogLang.requiredCateSelect);
	}
}
function Com_DialogReturnEmpty(){
	parent.Com_DialogReturn(new Array());
}
</script>
</head>
<body topmargin=10>
<span id="Span_CurValue"></span>
<table id="TB_Search" width=100% border=0 cellspacing=0 cellpadding=0 style="display:none">
	<tr valign=middle height=30>
		<td width=50><script>writeMessage("keyword");</script></td>
		<td>
			<input name="F_Keyword" value="" class="inputdialog" style="width:100%"
				onkeydown="if (Com_GetEventObject().keyCode==13){searchUseXML();return false;}">
		</td>
		<td width=100 align=right>
			<input id="btnSearch" type=button onclick="searchUseXML();" class="btndialog">
			<input id="btnClear" type=button onclick="setOptData(optDataBackup);" class="btndialog" disabled>
		</td>
	</tr>
</table>
<span id="Span_Search"><br></span>
<table border=1 cellspacing=2 cellpadding=0 bordercolor=#003048 width=100%>
	<tr valign=middle height=25 align=center>
		<td width=50%><script>writeMessage("optList");</script></td>
	</tr>
	<tr valign=middle align=center>
		<td style="padding:0px">
			<select name="F_OptionList" class="namelist" style="width:100%; height:200px;" size=2
				ondblclick="if(selectedIndex>-1)Com_DialogReturnValue();"
				onclick="showDescription(optData, selectedIndex);"
				onchange="showDescription(optData, selectedIndex);">
			</select>
		</td>
	</tr>
	<tr valign=middle height=35>
		<td align=center>
			<input id="btnOk" type=button class="btndialog" style="width:50px"
				onclick="Com_DialogReturnValue();">&nbsp;
			<input id="btnCancel" type=button class="btndialog" style="width:50px"
				onclick="parent.Com_DialogReturn();">
			<input id="btnSelectNone" type="hidden" class="btndialog" style="width:80px"
				onclick="Com_DialogReturnEmpty();">
			<input id="updateFunc" type=button class="btndialog" style="width:50px"
				onclick="Com_DialogUpdateFunc();">&nbsp;
			<input id="addFunc" type=button class="btndialog" style="width:50px"
				onclick="Com_DialogAddFunc();">&nbsp;
		</td>
	</tr>
	<tr valign=top height=75>
		<td style="padding:3px">
			<script>writeMessage("description");</script><span id="Span_MoreInfo"></span>
		</td>
	</tr>
</table>
</body>
</html>
