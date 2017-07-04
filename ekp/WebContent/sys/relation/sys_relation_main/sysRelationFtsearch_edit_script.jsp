<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
Com_IncludeFile("common.js|calendar.js|data.js|dialog.js|jquery.js", null, "js");
var relationEntry = {};
//初始化relationEntry
if(top.dialogObject == null || top.dialogObject.relationEntry==null
		|| parent.SysRelation_IsChangeType){
	// 新建，修改类型
	relationEntry = createRelationEntry();
} else {
	// 编辑
	relationEntry = top.dialogObject.relationEntry;
}
function createRelationEntry(){
	return {fdId:"<%=com.landray.kmss.util.IDGenerator.generateID()%>",fdType:"1",fdModuleName:"<bean:message bundle='sys-relation' key='sysRelationMain.fdDynamicUrl' />",
		fdParameter:"",fdKeyWord:"",docCreatorId:"",docCreatorName:"",fdFromCreateTime:"",fdToCreateTime:"",fdSearchScope:""};
}
//全选
function selectAll(obj){
	var _fdSearchScope = document.getElementsByName("fdSearchScope");
	for(var i = 0; i < _fdSearchScope.length; i++){
		if(obj.checked) {
			_fdSearchScope[i].checked = true;
		} else {
			_fdSearchScope[i].checked = false;
		}
	}
}
//单个的选择
function selectElement(element){
	var flag = true;
	var _fdSearchScope = document.getElementsByName("fdSearchScope");
	if(element && !element.checked){
		document.getElementById("checkAll").checked = false;
	} else {
		for (var j = 0; j < _fdSearchScope.length; j++){
			if(!_fdSearchScope[j].checked){
				flag = false;
				break;
			}
		}
		if(flag) { //勾选全选
			document.getElementById("checkAll").checked = true;
		} else {
			document.getElementById("checkAll").checked = false;
		}
	}
}
//清空字段
function clearField(fields){
	if (!fields) {
		return;
	}
	var fieldArr = fields.split(";");
	for (var i = 0, len = fieldArr.length; i < len; i++) {
		document.getElementsByName(fieldArr[i])[0].value="";
	}
}
// 替换所有字符串
String.prototype.replaceAll  = function(s1,s2){
    return this.replace(new RegExp(s1,"gm"), s2);
};
// 从页面的域中读取域值，并赋给对象的某个属性中
function Relation_GetDataFromField(data, propertyFilter, obj){
	function getFieldProperty(field){
		if(field.name==null || field.name=="")
			return null;
		if(propertyFilter!=null)
			return propertyFilter(field.name);
		return field.name;
	}
	var flag = false;
	if(obj==null)
		obj = document;
	var fields = obj.getElementsByTagName("INPUT");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		switch(fields[i].type){
			case "radio":
				if(fields[i].checked)
					data[property] = fields[i].value;
				break;
			case "checkbox":
				if(fields[i].checked){
					if(flag) {
						data[property] = data[property] + ";" + fields[i].value;
					} else {
						data[property] = fields[i].value;
						flag = true;
					}
				}
				break;
			default:
				data[property] = fields[i].value;
		}
	}
	fields = obj.getElementsByTagName("TEXTAREA");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		data[property] = fields[i].value;
	}
	fields = obj.getElementsByTagName("SELECT");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		data[property] = fields[i].options[fields[i].selectedIndex].value;
	}
}
// 将data对象的属性填充到页面的域中
function Relation_PutDataToField(data, fieldFilter){
	for(var o in data){
		var fieldName = o;
		if(fieldFilter!=null)
			fieldName = fieldFilter(fieldName);
		if(fieldName==null)
			continue;
		var fields = document.getElementsByName(fieldName);
		if(fields.length==0)
			continue;
		var value = data[o];
		switch(fields[0].tagName){
			case "INPUT":
				switch(fields[0].type){
					case "radio":
						for(var i=0; i<fields.length; i++)
							fields[i].checked = fields[i].value==value;
						break;
					case "checkbox":
						var valueArr = value.split(";");
						for (var m = 0, len1 = fields.length; m < len1; m++) {
							for (var n = 0, len2 = valueArr.length; n < len2; n++) {
								if (fields[m].value && valueArr[n] && (fields[m].value == valueArr[n])) {
									fields[m].checked = true;
									break;
								}
							}
						}
						break;
					default:
						fields[0].value = value;
				}
			break;
			case "TEXTAREA":
				fields[0].value = value;
			break;
			case "SELECT":
				for(var j=0; j<fields[0].options.length; j++)
					fields[0].options[j].selected = fields[0].options[j].value==value;
			case "SPAN":
				$(fields[0]).text(value);
			break;
		}
	}
}
function checkValueIsNull(str) {
	if(str && document.getElementsByName(str)[0] && document.getElementsByName(str)[0].value == ""){
		return true;
	}
	return false;
}
function doOK() {
	var _keyWord = document.getElementsByName("fdKeyWord")[0];
	if (checkValueIsNull("fdKeyWord")) {// 关键字
		_keyWord.focus();
		alert('<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdKeyword" />');
		return ;
	} else {
		var _fdKeyWord = document.getElementsByName("fdKeyWord")[0];
		if(_fdKeyWord && _fdKeyWord.value.length > 200) {<%-- 关键字长度不能大于200 --%>
			alert('<bean:message key="errors.maxLength" argKey0="sys-relation:sysRelationEntry.fdKeyword" arg1="200" />');
			return ;
		}
	}
	if(!checkValueIsNull("fdFromCreateTime") && !checkValueIsNull("fdToCreateTime") 
			&& compareDate(document.getElementsByName("fdFromCreateTime")[0].value, document.getElementsByName("fdToCreateTime")[0].value) > 0){
		alert('<bean:message bundle="sys-relation" key="validate.dateTimeCompare" />'); // 创建时间
		return ;
	}
	var flag = true, fdSearchScope = "", _fdSearchScope = document.getElementsByName("fdSearchScope");
	for (var i = 0, len = _fdSearchScope.length; i < len; i++) {
		if (_fdSearchScope[i].checked) {
			if(flag) {
				flag = false;
			}
			fdSearchScope += ";" + _fdSearchScope[i].value;
		}
	}
	if (flag) {// 搜索范围
		alert('<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdSearchScope" />');
		return ;
	} else {
		if(fdSearchScope.length - 1 > 4000) {<%-- 搜索范围长度不能大于4000 --%>
			alert('<bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.searchScope.tooLong" />');
			return ;
		}
	}
	Relation_GetDataFromField(relationEntry);
	top.Com_DialogReturn(relationEntry);
}
function dyniFrameSize() {
	try {
		// 调整高度
		
		var arguObj = document.getElementById("tb_ftsearch_Container");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 80) + "px";
			parent.resizeWindowHeight();
		}
	} catch(e) {
	}
}
Com_AddEventListener(window, "load", function(){
	Relation_PutDataToField(relationEntry);
	selectElement(); //如果全部范围都勾选，则选择全选checkbox
	dyniFrameSize();
});
</script>
