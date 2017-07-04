<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("data.js");
function preSubmit(method){
	// 校验角色分类唯一
	var fdName = document.getElementsByName("fdName")[0];
	if(fdName != null) {
		var data = new KMSSData();
	    data.AddBeanData("sysAuthCategoryService&fdId=${sysAuthCategoryForm.fdId}&fdName=" + encodeURIComponent(fdName.value));
	    var selectData = data.GetHashMapArray();
	    if (selectData != null && selectData[0] != null) {
	    	if(selectData[0]['isDuplicate'] == "true") {
				alert('<bean:message bundle="sys-authorization" key="sysAuthCategory.fdName.duplicate" />');
				return false;
			}
		}
	}
	Com_Submit(document.sysAuthCategoryForm, method);
}
</script>
<html:form action="/sys/authorization/sys_auth_category/sysAuthCategory.do">
<div id="optBarDiv">
	<c:if test="${sysAuthCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="preSubmit('update');">
	</c:if>
	<c:if test="${sysAuthCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="preSubmit('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="preSubmit('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-authorization" key="table.sysAuthCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthCategory.fdName"/>
		</td><td colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
		</td><td width="35%">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthCategory.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>