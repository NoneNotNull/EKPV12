<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
var relationMain = {};
var relationEntrys = {};
function createRelationMain(){
	return {fdId:"",fdOtherUrl:"",fdKey:"",fdModelName:"",fdModelId:"",fdParameter:"",relationEntrys:{}};
}
if(typeof window.dialogArguments == "undefined" || window.dialogArguments == null) {
	relationMain = createRelationMain();
} else {
	relationMain = window.dialogArguments;
	// 将数组转成对象, 说明：relationEntrys在单关联中是json存储，但在多关联中为了排序改成数组。
	for (var i = 0; i < relationMain.relationEntrys.length; i++) {
		relationEntrys[relationMain.relationEntrys[i].fdId] = relationMain.relationEntrys[i];
	}
}
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
	content.push("<input type=\"text\" name=\""+entryPrefix+"["+index+"].fdModuleName\" class=\"inputsgl\" value=\""+Relation_HtmlEscape(rtnVal.fdModuleName)+"\" style=\"width:90%\"/>&nbsp;<span class=\"txtstrong\">*</span>" + cellOneHTML);
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
	// 延迟初始化关联项
	setTimeout("initRelationEntry()", 200);
});
//初始化关联项
function initRelationEntry() {
	for (var fdId in relationEntrys) {
		addRelationEntryHTML(relationEntrys[fdId]);
	}
}
function SysRelation_RefreshIndex() {
	var index = document.getElementById("sysRelationZone").rows.length - noDataLength;
	var _fdId, tempArr = [], tempObj = {};
	for (var i = 0; i < index; i++) {
		_fdId = document.getElementsByName(entryPrefix+"["+i+"].fdId")[0];
		tempArr.push(_fdId.value);
	}
	for(var j = 0; j < tempArr.length; j++) {
		tempObj[tempArr[j]] = relationEntrys[tempArr[j]];
	}
	relationEntrys = tempObj;
}
function doOK(){
	var index = document.getElementById("sysRelationZone").rows.length - noDataLength;
	var _fdId, _fdName, tempArr = [], tempObj = [];
	for (var i = 0; i < index; i++) {
		_fdId = document.getElementsByName(entryPrefix+"["+i+"].fdId")[0];
		_fdName = document.getElementsByName(entryPrefix+"["+i+"].fdModuleName")[0];
		if (_fdName.value == "") { // 分类名称不能为空
			_fdName.focus();
			alert('<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdName" />');
			return false;
		}
		tempArr.push(_fdId.value); // 重新排序
		for (var fdId in relationEntrys) { // 设置分类名称
			if (fdId == _fdId.value) {
				relationEntrys[fdId].fdModuleName = _fdName.value;
				break;
			}
		}
	}
	// 将对象转成数组，说明：relationEntrys在单关联中是json存储，但在多关联中为了排序改成数组。
	for (var j = 0; j < tempArr.length; j++) {
		tempObj[j] = relationEntrys[tempArr[j]];
	}
	if (tempObj.length >= 0) {
		relationMain.relationEntrys = tempObj;
		returnValue = relationMain;
	}
	window.close();
	return true;
}
// 上传背景图片 begin
Com_IncludeFile("data.js|util.js", null, "js");
function isEnabledImgType(file) { // 判断是否图片类型
	var access = false;
	var types = ["gif", "jpg", "jpeg", "bmp", "png"];
	var ftype = file.substring(file.lastIndexOf(".") + 1).toLowerCase();
	for (var i = 0; i < types.length; i ++) {
		if (types[i] == ftype) {
			access = true;
			break;
		}
	}
	if (!access) {
		alert('<bean:message bundle="sys-relation" key="validate.imgTypeOnly" />');
		return access;
	}
	return access;
}
function doOK_uploadImgFirst(){
	var _file = document.getElementsByName("file")[0];
	if(_file && _file.value) { // 上传图片
		var upload_form = document.getElementsByName("sysRelationFileUploadForm")[0];
		if (!isEnabledImgType(_file.value)) {
			return false;
		}
		document.getElementById("upload_table").style.display = "none";
		document.getElementById("bar").style.display = "block";
		Com_Submit(upload_form, "upload"); //提交
	} else { // 不用上传图片
		var fdId = "", _imgId = document.getElementsByName("imgId")[0];
		if (_imgId) {
			fdId = _imgId.value;
		}
		relationMain.fdParameter = escape(getParam(fdId));
		doOK();
	}
	return true;
}
function afterUpload(errorNumber, fdId) { //上传完毕 由后台js回调
	switch (errorNumber) {
		case 1 :	// 上传成功
			alert('<bean:message bundle="sys-relation" key="sysRelationFileUploadForm.uploadSuccess" />');
			relationMain.fdParameter = escape(getParam(fdId));
			doOK();
			break;
		default :   // 上传失败
			alert('<bean:message bundle="sys-relation" key="sysRelationFileUploadForm.uploadFailed" />');
			return;
	}
}
function getParam(fdId) {
	var i, imgPos = "1";
	var _imgPosition = document.getElementsByName("imgPosition");
	for(i = 0; i < _imgPosition.length; i ++) {
		if(_imgPosition[i].checked) {
			imgPos = _imgPosition[i].value;
			break;
		}
	}
	var rtnObj = {imgId : fdId, imgPos : imgPos};
	return json2str(rtnObj).replace(/\'/g,"\"");
}
function initParam() { // 初始化
	if (relationMain.fdParameter && relationMain.fdParameter) {
		var par = str2json(unescape(relationMain.fdParameter));
		if (par.imgId && par.imgId) { // 图片ID
			deleteDiv.style.display = "";
			var _imgId = document.getElementsByName("imgId")[0];
			if (_imgId) {
				_imgId.value = par.imgId;
			}
		}
		if (par.imgPos && par.imgPos) { // 图片位置
			var _imgPosition = document.getElementsByName("imgPosition");
			if (_imgPosition) {
				for (var i = 0; i < _imgPosition.length; i ++) {
					if (_imgPosition[i].value == par.imgPos) {
						_imgPosition[i].checked = true;
						break;
					}
				}
			}
		}
	}
}
Com_AddEventListener(window, "load", function(){
	initParam();
});
function confirmDelete(msg){
	var del = confirm('<bean:message bundle="sys-relation" key="sysRelationFileUploadForm.comfirmDeleteImg"/>');
	return del;
}
function deleteImg(){
	var _imgId = document.getElementsByName("imgId")[0];
	if (_imgId && _imgId.value) {
		var kmssdata = new KMSSData();
		kmssdata.SendToUrl(
			Com_Parameter.ContextPath+"sys/relation/sys_relation_main/sysRelationFileUpload.do?method=delete&fdId=" + _imgId.value,
			function(http_request){
				var responseText = http_request.responseText;
				if (responseText == "1") {
					var _imgId = document.getElementsByName("imgId")[0];
					if (_imgId) {
						_imgId.value = ""; // 删除图片后清空
					}
					document.getElementById("deleteDiv").innerHTML = '<bean:message bundle="sys-relation" key="sysRelationFileUploadForm.deleteSuccess" />';
				} else {
					document.getElementById("deleteDiv").innerHTML = '<bean:message bundle="sys-relation" key="sysRelationFileUploadForm.deleteFailed" />' + responseText;
				}
			}
		);
	}
}
//上传背景图片 end
</script>