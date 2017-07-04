<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.relation.util.SysRelationUtil" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationEntryForm" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationConditionForm" %>
<script type="text/javascript">
var relationEntrys = {};
//替换所有字符串
String.prototype.replaceAll  = function(s1,s2){
    return this.replace(new RegExp(s1,"gm"), s2);
};
//初始化关联项
<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
<%SysRelationEntryForm sysRelationEntryForm = (SysRelationEntryForm) pageContext.getAttribute("sysRelationEntryForm");%>
	relationEntrys["<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdId())%>"] = {
		fdId:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdId())%>",
		fdType:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdType())%>",
		fdModuleName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdModuleName())%>", //中文模块名
		fdModuleModelName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdModuleModelName())%>",
		fdOrderBy:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdOrderBy())%>",
		fdOrderByName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdOrderByName())%>",
		fdPageSize:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdPageSize())%>",
		fdParameter:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdParameter())%>",
		fdKeyWord:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdKeyWord())%>",
		docCreatorId:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getDocCreatorId())%>",
		docCreatorName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getDocCreatorName())%>",
		fdFromCreateTime:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdFromCreateTime())%>",
		fdToCreateTime:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdToCreateTime())%>",
		fdSearchScope:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdSearchScope())%>",
		fdOtherUrl:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getOtherUrlNoPattern())%>".replaceAll("<br>","\r\n")
	};
	var relationConditions={};
	<c:forEach items="${sysRelationEntryForm.sysRelationConditionFormList}" varStatus="vs" var="sysRelationConditionForm">
		<%SysRelationConditionForm sysRelationConditionForm = (SysRelationConditionForm) pageContext.getAttribute("sysRelationConditionForm");%>
		relationConditions["<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdItemName())%>"] = {
			fdId:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdId())%>",
			fdItemName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdItemName())%>",
			fdParameter1:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdParameter1())%>",
			fdParameter2:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdParameter2())%>",
			fdParameter3:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdParameter3())%>",
			fdBlurSearch:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdBlurSearch())%>",
			fdVarName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationConditionForm.getFdVarName())%>"
		};
	</c:forEach>
	relationEntrys["<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdId())%>"].relationConditions = relationConditions;
</c:forEach>

var entryPrefix = "${requestScope.sysRelationMainPrefix}sysRelationEntryFormList";
var conditionPrefix = "sysRelationConditionFormList";
var noDataLength = 1;
DocList_Info[DocList_Info.length] = "sysRelationZone";
//根据类型获取类型显示的名称
function getRelationTypeNameByType(type) {
	var typeName = "";
	switch(type) {
		case "1":
			typeName = '<bean:message bundle="sys-relation" key="sysRelationEntry.fdType1" />';
			break;
		case "2":
			typeName = '<bean:message bundle="sys-relation" key="sysRelationEntry.fdType2" />';
			break;
		case "3":
			typeName = '<bean:message bundle="sys-relation" key="sysRelationEntry.fdType3" />';
			break;
		case "4":
			typeName = '<bean:message bundle="sys-relation" key="sysRelationEntry.fdType4" />';
			break;
		default:
			typeName = '<bean:message bundle="sys-relation" key="sysRelationEntry.fdType2" />';
	}
	return typeName;
}
function Relation_HtmlEscape(s){
	if(s==null || s=="")
		return "";
	if(typeof s != "string")
		return s;
	var re = /\"/g;
	s = s.replace(re, "&quot;");
	re = /'/g;
	s = s.replace(re, '&#39;');
	re = /</g;
	s = s.replace(re, "&lt;");
	re = />/g;
	return s.replace(re, "&gt;");
}
// 拼装关联项字段
function getRelationEntryElementsHTML(index, fdId, exceptValue){
	var html = "";
	var entry = relationEntrys[fdId];
	for(var property in entry){
		if (exceptValue && property == exceptValue) {
			continue;
		}
		if(typeof entry[property] == "string"){
			html+="<input type=\"hidden\" name=\""+entryPrefix+"["+index+"]."+property+"\" value=\""+Relation_HtmlEscape(entry[property])+"\">";
		}
	}
	return html;
}
//拼装条件字段（避免动态行刷新，提交时在拼装）
function getRelationEntryConditionElementsHTML(index, fdId){
	var html = "";
	var conditions = relationEntrys[fdId].relationConditions;
	var count = 0;
	for(var condition in conditions){
		for(var condProp in conditions[condition]){
			html+="<input type=\"hidden\" name=\""+entryPrefix+"["+index+"]."+conditionPrefix+"["+(count)+"]."
				+condProp+"\" value=\""+Relation_HtmlEscape(conditions[condition][condProp])+"\">";
		}
		count++;
	}
	return html;
}
// 增加关联项
function addRelationEntry() {
	var url = Com_Parameter.ResPath+"jsp/frame.jsp";
	// currModelName是精确搜索时默认选中的模块
	url = Com_SetUrlParameter(url, "url",Com_Parameter.ContextPath+"sys/relation/sys_relation_main/sysRelationEntry.jsp?currModelName=${currModelName}");
	var rtnVal = window.showModalDialog(url, null, "dialogWidth:650px;resizable:yes;");
	if(rtnVal==null)return ;
	addRelationEntryHTML(rtnVal);
}
function addRelationEntryHTML(rtnVal) {
	relationEntrys[rtnVal.fdId] = rtnVal;
	var index = document.getElementById("sysRelationZone").rows.length - noDataLength;
	var cellOneHTML = getRelationEntryElementsHTML(index, rtnVal.fdId, "fdModuleName");
	var content = new Array();
	content.push("<input type=\"text\" name=\""+entryPrefix+"["+index+"].fdModuleName\" class=\"i_k\" value=\""+Relation_HtmlEscape(rtnVal.fdModuleName)+"\"  /><span class=\"xing2\">*</span>" + cellOneHTML);
	content.push(getRelationTypeNameByType(rtnVal.fdType));
	var row = DocList_AddRow("sysRelationZone", content);
	//row.cells[0].innerHTML = "<input type=\"text\" name=\""+entryPrefix+"["+index+"].fdModuleName\" class=\"inputsgl\" value=\""+rtnVal.fdModuleName+"\" style=\"width:90%\"/>&nbsp;<span class=\"txtstrong\">*</span>" + cellOneHTML;
	//row.cells[1].innerHTML = getRelationTypeNameByType(rtnVal.fdType);
}
// 修改关联项
function editRelationEntry(){
	var row = DocListFunc_GetParentByTagName("TR");
	var index = getRelationRowIndex(row) - noDataLength;
	var fdId = document.getElementsByName(entryPrefix+"["+index+"].fdId")[0].value;
	var relationEntry = relationEntrys[fdId];
	var url = Com_Parameter.ResPath+"jsp/frame.jsp";
	url = Com_SetUrlParameter(url, "url",Com_Parameter.ContextPath+"sys/relation/sys_relation_main/sysRelationEntry.jsp?currModelName=${currModelName}");
	var rtnVal = window.showModalDialog(url, relationEntry, "dialogWidth:650px;resizable:yes;");
	if(rtnVal==null)return ;
	delete relationEntrys[fdId];
	relationEntrys[rtnVal.fdId] = rtnVal;
	var cellOneHTML = getRelationEntryElementsHTML(index, rtnVal.fdId, "fdModuleName");
	row.cells[0].innerHTML = "<input type=\"text\" name=\""+entryPrefix+"["+index+"].fdModuleName\" class=\"inputsgl\" value=\""+Relation_HtmlEscape(rtnVal.fdModuleName)+"\" style=\"width:90%\">&nbsp;<span class=\"txtstrong\">*</span>" + cellOneHTML;
	row.cells[1].innerHTML = getRelationTypeNameByType(rtnVal.fdType);
}
// 获取行号
function getRelationRowIndex(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	return rowIndex;
}
// 删除关联项
function deleteRelationEntry(){
	if(confirm('<bean:message bundle="sys-relation" key="sysRelationEntry.alert.deleteEntry"/>')){
		var row = DocListFunc_GetParentByTagName("TR");
		var index = getRelationRowIndex(row) - noDataLength;
		var fdId = document.getElementsByName(entryPrefix+"["+index+"].fdId")[0].value;
		delete relationEntrys[fdId];
		DocList_DeleteRow(row);
	}
}
//提交校验
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
	var index = document.getElementById("sysRelationZone").rows.length - noDataLength;
	var _td, _fdId, _fdName;
	for (var i = 0; i < index; i++) {
		_fdId = document.getElementsByName(entryPrefix+"["+i+"].fdId")[0];
		if (_fdId != null &&  _fdId.value != "") {
			_td = DocListFunc_GetParentByTagName("TD", _fdId);
			// 拼装条件域
			_td.innerHTML += getRelationEntryConditionElementsHTML(i, _fdId.value);
		}
		_fdName = document.getElementsByName(entryPrefix+"["+i+"].fdModuleName")[0];
		if (_fdName.value == "") {
			// 分类名称不能为空
			_fdName.focus();
			alert('<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdName" />');
			return false;
		}
	}
	return true;
}
Com_IncludeFile("data.js", null, "js");
// string转成json
function stringToJSON(obj){
	return eval('(' + obj + ')');
}
// 从模板导入
function importFromTemplate() {
	var _relationEntrysTmp = new Array();
	var _relationEntrys = {};
	var _relationEntry = {};
	var _relationCondition = {};
	var url = Com_Parameter.ContextPath+"sys/relation/relation.do?method=importFromTemplate";
	new KMSSData().SendToUrl(url, function(http_request){
		_relationEntrysTmp = stringToJSON(unescape(http_request.responseText));
	}, false);
	if (_relationEntrysTmp.length == 0) {
		alert('<bean:message bundle="sys-relation" key="button.insertFromTemplate.alert" />');
	}
	// string转成json
	for (var i = 0; i < _relationEntrysTmp.length; i++) {
		_relationEntry = stringToJSON(_relationEntrysTmp[i]);
		_relationCondition = stringToJSON(_relationEntry.relationConditions);
		for (var fdItemName in _relationCondition) {
			_relationCondition[fdItemName] = stringToJSON(_relationCondition[fdItemName]);
		}
		_relationEntry.relationConditions = _relationCondition;
		_relationEntrys[_relationEntry.fdId] = _relationEntry;
		// 添加关联项
		addRelationEntryHTML(_relationEntrys[_relationEntry.fdId]);
	}
}
Com_AddEventListener(window, "load", function(){
	if ("${requestScope.sysRelationMainPrefix}" == "") {
		<%-- 系统模板中使用 --%>
		var table1 = document.getElementById("sysRelationZoneTop");
		var table2 = document.getElementById("sysRelationZone");
		var table3 = document.getElementById("sysRelationZoneFooter");
		table1.width = "95%";
		table2.width = "95%";
		table3.width = "95%";
	}
});
var xmlHttpRequest;
//Ajax创建XMLHttpRequest对象
function createXmlHttpRequest(){
	if (window.XMLHttpRequest) {
		xmlHttpRequest = new XMLHttpRequest();
		if (xmlHttpRequest.overrideMimeType) {
			xmlHttpRequest.overrideMimeType("text/xml");
		}
	} else if (window.ActiveXObject) {
		var activeName = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP"];
		for (var i = 0; i < activeName.length; i++) {
			try {
				xmlHttpRequest = new ActiveXObject(activeName[i]);
				break;
			} catch(e) {
			}
		}
	}
}
//得到分类搜索条件的参数
function getParams(){
	var params = "";
	var tbInfo = DocList_TableInfo['sysRelationZone'];
	var fdId = document.getElementsByName("sysRelationMainForm.fdId")[0];
	var fdKey = document.getElementsByName("sysRelationMainForm.fdKey")[0];
	var fdModelName = document.getElementsByName("sysRelationMainForm.fdModelName")[0];
	var fdModelId = document.getElementsByName("sysRelationMainForm.fdModelId")[0];
	var fdParameter = document.getElementsByName("sysRelationMainForm.fdParameter")[0];
	var moduleModelName = "";
	params += "&fdId="+fdId.value;
	params += "&fdKey="+fdKey.value;
	params += "&fdModelName="+fdModelName.value;
	params += "&fdModelId="+fdModelId.value;
	params += "&fdParameter="+fdParameter.value;
	var entryPrefix = "sysRelationMainForm.sysRelationEntryFormList";
	params += "&totalRow="+(tbInfo.lastIndex-1);//动态行总行数
	for(var i=0;i<tbInfo.lastIndex-1;i++){
		var fdId = document.getElementsByName(entryPrefix+"["+i+"].fdId")[0];
		var entry = relationEntrys[fdId.value];
		index = 0;
		for(var property in entry){
			if(typeof entry[property] == "string"){
				params += "&entry["+i+"]."+property+"="+encodeURIComponent(entry[property]);
				if(property == "fdModuleModelName")
					moduleModelName = encodeURIComponent(entry[property]);
			}
		}
		var conditions = relationEntrys[fdId.value].relationConditions;
		var count = 0;
		for(var condition in conditions){
			for(var condProp in conditions[condition]){
					params += "&entry["+i+"].condition["+(count)+"]."
						+condProp+"="+conditions[condition][condProp];
			}
			count++;
		}
		params += "&moduleModelName="+moduleModelName;
		params += "&entry["+i+"].count="+count;
		params += "&separator=0";//当做每一个分类的分割符
	}
	return params;
}
//预览
function preview() {
	var url = Com_Parameter.ContextPath+'sys/relation/sys_relation_main/sysRelationMain_preview.jsp';
	var params = getParams();
	window.showModalDialog(url, {p:params},"dialogWidth=800px;dialogHeight=600px");
}
</script>