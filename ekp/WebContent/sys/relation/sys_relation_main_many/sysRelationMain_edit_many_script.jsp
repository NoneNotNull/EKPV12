<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.landray.kmss.sys.relation.util.SysRelationUtil" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationEntryForm" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationConditionForm" %>
<script type="text/javascript">
Com_IncludeFile("util.js|jquery.js", null, "js");
//主表单对象
var Relation_docMainFormObj = eval("document.${param.formName}");
var relationMains = {};
//替换所有字符串
String.prototype.replaceAll  = function(s1,s2){
    return this.replace(new RegExp(s1,"gm"), s2);
};
<c:forEach items="${mainModelForm.sysRelationMainFormMap}" varStatus="vsMain" var="sysRelationMainForm">
	relationMains["<c:out value='${sysRelationMainForm.key}' />"]={
		fdId:"<c:out value='${sysRelationMainForm.value.fdId}' />",
		fdOtherUrl:"<c:out value='${sysRelationMainForm.value.otherUrlNoPattern}' />",
		fdKey:"<c:out value='${sysRelationMainForm.value.fdKey}' />",
		fdModelName:"<c:out value='${sysRelationMainForm.value.fdModelName}' />",
		fdModelId:"<c:out value='${sysRelationMainForm.value.fdModelId}' />",
		fdParameter:"<c:out value='${sysRelationMainForm.value.fdParameter}' />"
	};
	var relationEntrys = [];// 需要排序，改成数组
	<c:forEach items="${sysRelationMainForm.value.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
		<%SysRelationEntryForm sysRelationEntryForm = (SysRelationEntryForm) pageContext.getAttribute("sysRelationEntryForm");%>
		relationEntrys["${vstatus.index}"] = {
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
		relationEntrys["${vstatus.index}"].relationConditions = relationConditions;
	</c:forEach>
	relationMains["<c:out value='${sysRelationMainForm.key}' />"].relationEntrys = relationEntrys;
</c:forEach>
var mainPrefix = "sysRelationMainFormMap";
var entryPrefix = "sysRelationEntryFormList";
var conditionPrefix = "sysRelationConditionFormList";
function createRelationMain(){
	return {fdId:"",fdOtherUrl:"",fdKey:"",fdModelName:"",fdModelId:"",fdParameter:"",relationEntrys:[]};
}
//编辑关联机制，必须传入参数fdKey
function Relation_editRelation(fdKey){
	if(typeof fdKey == "undefined" || fdKey == null || fdKey == "" ){		
		alert('<bean:message bundle="sys-relation" key="relation.error.required.fdKey"/>');
		return;
	}	
	var url = Com_Parameter.ContextPath+"sys/relation/sys_relation_main_many/sysRelationMain_edit.jsp";
	url = Com_SetUrlParameter(url,"fdKey",fdKey);
	url = Com_SetUrlParameter(url,"currModelName","${param.currModelName}");
	url = Com_SetUrlParameter(url,"currModelId","${mainModelForm.fdId}");
	var rtnVal = showModalDialog(url, relationMains[fdKey], "dialogWidth:700px;resizable:yes");
	if(rtnVal==null)return ;
	rtnVal.fdKey = fdKey;
	rtnVal.fdModelName ="${param.currModelName}";
	rtnVal.fdModelId = "${mainModelForm.fdId}";
	relationMains[fdKey] = rtnVal;
}

//删除关联机制，必须传入参数fdKey
function Relation_deleteRelation(fdKey){
	if(typeof fdKey == "undefined" || fdKey == null || fdKey == "" ){		
		alert('<bean:message bundle="sys-relation" key="relation.error.required.fdKey"/>');
		return;
	}	
	delete relationMains[fdKey];
}
function isValidateRelationCondition(relationCondition){
	return (relationCondition.fdParameter1 == "" 
		&& relationCondition.fdParameter2 == ""
		&& relationCondition.fdParameter3 == ""
		&& relationCondition.fdVarName == "");
}
// 拼装表单的隐藏域
function getRelationMainElementsHTML() {
	var j = 0, k = 0;
	for(var fdKey in relationMains) {
		for(var mainProp in relationMains[fdKey]) {
			var mainValue = relationMains[fdKey][mainProp];
			if(typeof mainValue == "string") {
				Relation_docMainFormObj.appendChild(createHidden(mainPrefix + "." + fdKey + "." + mainProp,mainValue));
			} else if(typeof mainValue == "object") {
				for(var index = 0, len = mainValue.length; index < len; index++){
					for(var entryProp in mainValue[index]) {
						var entryValue = mainValue[index][entryProp];
						if(typeof entryValue == "string") {
							Relation_docMainFormObj.appendChild(createHidden(mainPrefix + "." + fdKey + "." + entryPrefix + "[" + j + "]." + entryProp, entryValue));					
						}
						if(typeof entryValue == "object") {
							var conditions = entryValue;				
							for(var condition in conditions){
								if(isValidateRelationCondition(condition)){
									continue;
								}		
								for(var condProp in conditions[condition]){									
									var conditionValue = conditions[condition][condProp];
									Relation_docMainFormObj.appendChild(createHidden(mainPrefix + "." + fdKey + "." + entryPrefix + "[" + j + "]." + conditionPrefix + "[" + k + "]." + condProp, conditionValue));	
								}
								k++;
							}
							k = 0;
						}
					}
					j++;
				}
				j=0;
			}			
		}		
	}		
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
//创建Hidden域
/*
function createHidden( name, value ){
	// 兼容多浏览器，ie下name是只读属性，故修改方案
	var e = document.createElement("input");
	e.setAttribute('type','hidden');
	e.setAttribute('name',name);
	e.setAttribute('value',Relation_HtmlEscape(value));
	//var e = document.createElement("<input type='hidden' name='" + name + "' value='" + Relation_HtmlEscape(value) + "' />");
	return e;
}*/

function createHidden( name, value ){	
	var e =$("<input type='hidden' name='" + name + "' value='" + Relation_HtmlEscape(value) + "' />")[0];
	return e;
}

String.prototype.trim= function(){    
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}

//清空 NAME属性名字包含有{attribute}的所有Hidden域
function removeElementByAttributeName(attribute){
	if(attribute==null || attribute.length == 0)return;
	var arr = new Array();
	var _name, _type, _elements = Relation_docMainFormObj.elements;
	for (var n = 0, len = _elements.length; n < len; n++) {
		_name = _elements[n].name;
		_type = _elements[n].type.toLowerCase();
		if(_type == "hidden" && _name != null && _name != "" && _name.trim().indexOf(attribute)!=-1){
			// 找到需要清空的hidden域
			arr.push(_name);
		}
	}
	for (var m = 0, le = arr.length; m < le; m++) {
		var elem = Relation_docMainFormObj.elements[arr[m]];
		elem.parentNode.removeChild(elem);
	}
}

//edit页面加载后，根据json对像，初始化sysRelationMainFormMap hidden元素
<c:if test="${fn:length(mainModelForm.sysRelationMainFormMap)>0}">
	Com_AddEventListener(window, "load", getRelationMainElementsHTML);
</c:if>
Com_Parameter.event["submit"].push(Relation_submit);

function Relation_submit() {
	//首先清空hidden域
	removeElementByAttributeName(mainPrefix);
	getRelationMainElementsHTML();
	return true;
}
</script>