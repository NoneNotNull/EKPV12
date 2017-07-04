<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_type/kmsIntegralType.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralTypesForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntegralTypesForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralTypesForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsIntegralTypesForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsIntegralTypesForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle" style="margin-bottom: 10px"><bean:message bundle="kms-integral" key="table.kmsIntegralType"/></p>
<center>
<div style="text-align:left;width:95%;">
<p style="margin-bottom: 5px;"><bean:message bundle="kms-integral" key="kmsIntegral.type.msg"/></p>
<p style="margin-bottom: 5px;"><bean:message bundle="kms-integral" key="kmsIntegral.type.unSelect.module"/>
<span id="unSelectModule"></span>
</p>
</div>
</center>
<center>
<table class="tb_normal" width=95% id="TABLE_DocList">
	<tr align="center">
		<td class="td_normal_title" width="30%">
			<bean:message bundle="kms-integral" key="kmsIntegralType.fdName"/>
		</td>
		<td class="td_normal_title" width="60%">
			<bean:message bundle="kms-integral" key="kmsIntegralType.fdModule"/>
		</td>
		<td class="td_normal_title" align="center" width=10%>
			<img src="${KMSS_Parameter_StylePath}icons/add.gif" onclick="addRow();" style="cursor:pointer;" />
		</td>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td>
			<xform:text property="kmsIntegralTypeForms[!{index}].fdName" style="width:95%" required="true" />
		</td>
		<td>
			<input type="hidden" name="kmsIntegralTypeForms[!{index}].moduleIds" />
			<xform:text showStatus="readOnly" property="kmsIntegralTypeForms[!{index}].moduleNames" htmlElementProperties="onclick='editRow(this.parentNode)'" style="width:95%" required="true" />
		</td>
		<td>
		   <center>
				<img src="${KMSS_Parameter_StylePath}icons/edit.gif" onclick="editRow(this.parentNode.parentNode.previousSibling);" style="cursor:pointer;">
				<img src="${KMSS_Parameter_StylePath}icons/delete.gif" onclick="deleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer;">
			</center>
		</td>
	</tr>
	<c:forEach items="${kmsIntegralTypesForm.kmsIntegralTypeForms}" var="kmsIntegralTypeForms" varStatus="vstatus">
		<tr KMSS_IsContentRow="1" id="${kmsIntegralTypeForms.fdId}" title="${kmsIntegralTypeForms.fdName}">
			<td>
				<input type="hidden" name="kmsIntegralTypeForms[${vstatus.index}].fdId" value="${kmsIntegralTypeForms.fdId}" />
				<input type="hidden" name="kmsIntegralTypeForms[${vstatus.index}].fdOrder" value="${kmsIntegralTypeForms.fdOrder}" />
				<xform:text property="kmsIntegralTypeForms[${vstatus.index}].fdName" style="width:95%" required="true" />
			</td>
			<td>
				<input type="hidden" name="kmsIntegralTypeForms[${vstatus.index}].moduleIds" value="${kmsIntegralTypeForms.moduleIds}"/>
				<xform:text showStatus="readOnly" property="kmsIntegralTypeForms[${vstatus.index}].moduleNames" htmlElementProperties="onclick='editRow(this.parentNode)'" style="width:95%" required="true" />
			</td>
			<td>
			   <center>
					<img src="${KMSS_Parameter_StylePath}icons/edit.gif" onclick="editRow(this.parentNode.parentNode.previousElementSibling);" style="cursor:pointer;">
					<img src="${KMSS_Parameter_StylePath}icons/delete.gif" onclick="deleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer;">
				</center>
			</td>
		</tr>						
	</c:forEach>
	<tr>
		<td>
			<span style="color:#1b83d8;padding-left:4px;"><bean:message bundle="kms-integral" key="kmsIntegralType.type.other"/></span>
		</td>
		<td>
			<span style="color:#1b83d8;padding-left:4px;"><bean:message bundle="kms-integral" key="kmsIntegralType.type.other.content"/></span>
		</td>
		<td>
		</td>
	</tr>	
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
Com_IncludeFile("dialog.js|doclist.js|data.js");
$KMSSValidation();

function addRow() {
	var fieldValues = new Object();
	fieldValues["kmsIntegralTypeForms[!{index}].fdName"] = "新积分类型";
	var row = DocList_AddRow("TABLE_DocList", null, fieldValues);
}

function editRow(td) {
	var fieldId = td.children[0].name;
	var fieldName = td.children[1].name;
	var url = 'kmsIntegralModuleTree';
	Dialog_List(true, fieldId, fieldName, ';', url, checkUnSelectModule,
			"", null, false, "模块选择");
}

//删除行
function deleteRow(tr) {
	DocList_DeleteRow(tr);
	checkUnSelectModule();
}

function checkUnSelectModule() {
	var postUrl = "kmsIntegralModuleTree";
	var data = new KMSSData();
	data.UseCache = false;
	data.AddBeanData(postUrl);
	var rtnVal = data.GetHashMapArray();
	var str;
	for ( var array in rtnVal) {
		str = str ? str + ";" + rtnVal[array].text : rtnVal[array].text;
	}
	var selectedModule="";
	$("input[name$='moduleNames']").each(function(){
		var moduleStr = this.value.split(";");
		for(var index in moduleStr){
			if(str.indexOf(moduleStr[index])>-1){
				str = str.replace(moduleStr[index],"");
			}
		}
	});
	var unSelectedStr="";
	var unSelected = str.split(";");
	for(var temp in unSelected){
		if(unSelected[temp]){
			unSelectedStr = !unSelectedStr?unSelected[temp]:unSelectedStr + "、" + unSelected[temp];
		}
	}
	$("#unSelectModule").text(unSelectedStr);
}

setTimeout(checkUnSelectModule,500);

</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>