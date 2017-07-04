<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
Com_IncludeFile("data.js|jquery.js");
Com_SetWindowTitle('<bean:message bundle="sys-search" key="search.export.select.column" />');
var optData;
var selData;
var isHasRtfData;
var	exportDialogObj = top.dialogArguments;
var total;
function setIsHasRtf(data){
	if(data!=null)
		isHasRtfData = data.Format("name:value");
	if(!(isHasRtfData instanceof KMSSData))
		isHasRtfData = new KMSSData(isHasRtfData);
	if(isHasRtfData.data.length!=0){
		if(isHasRtfData.data[0].value=='true'&&isHasRtfData.data[0].name=='isHasRtf'){
			$("#isHasRtf").show();
		}
	}
}
function setOptData(data){
	if(data!=null)
		optData = data.Format("id:name:info");
	if(!(optData instanceof KMSSData))
		optData = new KMSSData(optData);
	optData.PutToSelect("F_OptionList", "id", "name");
}
function setSelData(data){
	if(data!=null)
		selData = data.Format("id:name:info");
	if(!(selData instanceof KMSSData))
		selData = new KMSSData(selData);
	selData.PutToSelect("F_SelectedList", "id", "name");
	var v = "";
	var arr = selData.GetHashMapArray();
	for(var i=0;i<arr.length;i++){
		v += ";" + arr[i]["id"];
	}
	if(v != "") {
		refreshColumn(v.substring(1));
	}
}
function optionAdd(isAll){
	if(isAll){
		selData.AddKMSSData(optData);
	}else{
		var optHashMapArr = optData.GetHashMapArray();
		var obj = document.getElementsByName("F_OptionList")[0].options;
		for(var i=0; i<obj.length; i++){
			if(obj[i].selected)
				selData.AddHashMap(optHashMapArr[i]);
		}
	}
	setSelData();
}
function optionDelete(isAll){
	if(isAll)
		setSelData(new KMSSData());
	else{
		var obj = document.getElementsByName("F_SelectedList")[0].options;
		for(var i=obj.length-1; i>=0; i--){
			if(obj[i].selected)
				selData.Delete(i);
		}
		setSelData();
	}
}
function optionMove(direct){
	var obj = document.getElementsByName("F_SelectedList")[0].options;
	var i, j, tmpData;
	var selIndex = new Array;
	var n1 = 0;
	var n2 = obj.length - 1;
	for(i=direct>0?obj.length-1:0; i>=0 && i<obj.length; i-=direct){
		j = i + direct;
		if(obj[i].selected){
			if(j>=n1 && j<=n2){
				selData.SwitchIndex(i, j);
				selIndex[selIndex.length] = j;
			}else{
				if(direct<0)
					n1 = i + 1;
				else
					n2 = i - 1;
				selIndex[selIndex.length] = i;
			}
		}
	}
	setSelData();
	for(i=0; i<selIndex.length; i++)
		obj[selIndex[i]].selected = true;
}
function showDescription(data, index){
	var hashMapArr = data.GetHashMapArray();
	if(hashMapArr[index]!=null)
		document.getElementById("Span_MoreInfo").innerHTML = hashMapArr[index].info;
}
Com_AddEventListener(window, "load", function(){
	var beanURL = "sysSearchResultExportDictService&fdModelName=${param.fdModelName}&searchId=${param.searchId}";
	setIsHasRtf(new KMSSData().AddBeanData(beanURL + "&type=isHasRtf")); //获取当前数据字典是否包含RTF字段
	setOptData(new KMSSData().AddBeanData(beanURL + "&type=opt")); // 待选列表
	setSelData(new KMSSData().AddBeanData(beanURL + "&type=sel")); // 已选列表
	document.getElementsByName("fdNumStart")[0].value = 1;
	document.getElementsByName("fdNumEnd")[0].value = exportDialogObj.exportNum;
	total = exportDialogObj.exportNum;
});
function dialogReturn() {
	var fdNumStart = document.getElementsByName("fdNumStart")[0].value;
	var fdNumEnd = document.getElementsByName("fdNumEnd")[0].value;
	if(/[^\d]/.test(fdNumStart) || /[^\d]/.test(fdNumEnd) || fdNumStart < 1 || fdNumEnd < 1 || fdNumEnd < fdNumStart || fdNumEnd > total) {
		alert('<bean:message bundle="sys-search" key="search.export.num.error" />');
		return;
	}
	var selVal = selData.GetHashMapArray();
	if(selVal.length==0) {
		alert('<bean:message key="dialog.requiredSelect"/>');
		return;
	} else {
		var rtnMap = new Object;
		rtnMap["fdNumStart"] = fdNumStart;
		rtnMap["fdNumEnd"] = fdNumEnd;
		var fdKeepRtfStyle=document.getElementsByName("fdKeepRtfStyle")[0];
		rtnMap["fdKeepRtfStyle"] = fdKeepRtfStyle.checked;
		rtnMap["fdColumns"] = document.getElementsByName("fdColumns")[0].value;
		top.window.returnValue = rtnMap;
		top.window.close();
	}
}
function refreshColumn(v) {
	document.getElementsByName("fdColumns")[0].value = v;
}
</script>
<div style="margin-left: 3px; margin-top: -25px">
<form name="exportForm" action="" method="POST">
<table width=100% border=0 cellspacing=0 cellpadding=0 style="margin-top:12px">
	<tr valign=middle height=30>
		<td>&nbsp;&nbsp;<bean:message bundle="sys-search" key="search.export.num" />
			<bean:message bundle="sys-search" key="search.export.num.start" />
			<input name="fdNumStart" class="inputsgl" style="width:35px" />&nbsp;&nbsp;<bean:message key="page.row" />
			<bean:message bundle="sys-search" key="search.export.num.end" /> 
			<input name="fdNumEnd" class="inputsgl" style="width:35px" />&nbsp;&nbsp;<bean:message key="page.row" />
			<input type="hidden" name="fdColumns" />
		</td>
		<td id="isHasRtf" style="display: none">
			<label>
				<input type="checkbox" value="true" name="fdKeepRtfStyle" checked="checked"/>
				<bean:message bundle="sys-search" key="search.export.fdKeepRtfStyle" />
			</label>
		</td>
		<td width=70 align=right>
		</td>
	</tr>
</table>
<table border=1 cellspacing=2 cellpadding=0 bordercolor=#003048 width=100%>
	<tr>
		<td>
		</td>
	</tr>
	<tr valign=middle height=25 align=center>
		<td width=40%><bean:message key="dialog.optList"/></td>
		<td style="width:94px">&nbsp;</td>
		<td width=40%><bean:message key="dialog.selList"/></td>
	</tr>
	<tr valign=middle align=center>
		<td style="padding:0px">
			<select name="F_OptionList" multiple class="namelist" style="width:100%; height:216px;"
				ondblclick="optionAdd();"
				onclick="showDescription(optData, selectedIndex);"
				onchange="showDescription(optData, selectedIndex);">
			</select>
		</td>
		<td>
			<input id="btnAdd" type=button class="btndialog" style="width:70px" onclick="optionAdd();" value="<bean:message key="dialog.add"/>">
			<br><br>
			<input id="btnDelete" type=button class="btndialog" style="width:70px" onclick="optionDelete();" value="<bean:message key="dialog.delete"/>">
			<br><br>
			<input id="btnAddAll" type=button class="btndialog" style="width:70px" onclick="optionAdd(true);" value="<bean:message key="dialog.addAll"/>">
			<br><br>
			<input id="btnDeleteAll" type=button class="btndialog" style="width:70px" onclick="optionDelete(true);" value="<bean:message key="dialog.deleteAll"/>">
			<br><br>
			<input id="btnMoveUp" type=button class="btndialog" style="width:33px" onclick="optionMove(-1);" value="<bean:message key="dialog.moveUp"/>">
			<input id="btnMoveDown" type=button class="btndialog" style="width:33px" onclick="optionMove(1);" value="<bean:message key="dialog.moveDown"/>">
		</td>
		<td style="padding:0px">
			<select name="F_SelectedList" multiple class="namelist" style="width:100%; height:216px;"
				ondblclick="optionDelete();"
				onclick="showDescription(selData, selectedIndex);"
				onchange="showDescription(selData, selectedIndex);">
			</select>
		</td>
	</tr>
	<tr valign=middle height=35>
		<td colspan=3 align=center>
			<input id="btnOk" type=button class="btndialog" style="width:50px"
				onclick="dialogReturn();" value="<bean:message key="button.ok"/>">&nbsp;
			<input id="btnCancel" type=button class="btndialog" style="width:50px"
				onclick="window.parent.close();" value="<bean:message key="button.cancel"/>">
		</td>
	</tr>
	<tr valign=top height=75>
		<td colspan=3 style="padding:3px">
			<bean:message key="dialog.description"/><span id="Span_MoreInfo"></span>&nbsp;
		</td>
	</tr>
</table>
</form>
</div>
<%@ include file="/resource/jsp/edit_down.jsp"%>