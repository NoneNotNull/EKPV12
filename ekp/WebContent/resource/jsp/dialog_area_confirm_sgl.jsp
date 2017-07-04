<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script type="text/javascript">
var Com_Parameter = {
	ContextPath:parent.Com_Parameter.ContextPath,
	ResPath:parent.Com_Parameter.ResPath,
	Style:parent.Com_Parameter.Style,
	StylePath:parent.Com_Parameter.StylePath,
	JsFileList:new Array,
	DialogLang:parent.Com_Parameter.DialogLang,
	Lang:parent.Com_Parameter.Lang
};
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
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche;
</script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript">
Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
window.onload = function(){
	if(dialogObject.valueData!=null){
		var data = dialogObject.valueData.GetHashMapArray();
		if(data!=null && data.length>0 && data[0]["name"]!=null && data[0]["name"]!=""){
			var s = Com_Parameter.DialogLang.currentValue+data[0]["name"];
			if(data.length>1)
				s += ";..."
			document.getElementById("Span_CurValue").innerHTML = s;
		}
	}
	writeButtonMessage("btnOk;btnCancel");
}
</script>
</head>
<body topmargin=10>
<center>
	<span id="Span_CurValue"></span><br><br style="font-size:8px">
	<input id="btnOk" type=button class="btndialog" style="width:50px"
		onclick="parent.treeFrame.Com_DialogReturnOK();">&nbsp;
	<input id="btnDefArea" value="<bean:message key="sysAuthDefaultArea.setting" bundle="sys-authorization" />" type=button class="btndialog" style="width:120px"
		onclick="parent.treeFrame.Com_DialogReturnDefArea();">&nbsp;	
	<input id="btnCancel" type=button class="btndialog" style="width:50px"
		onclick="parent.Com_DialogReturn();">

</center>
</body>
</html>