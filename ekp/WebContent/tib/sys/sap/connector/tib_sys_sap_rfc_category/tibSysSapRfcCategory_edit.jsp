<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js", null, "js");
Com_IncludeFile("jquery.js");
Com_Parameter.event["submit"].push(function() {
	var fdName = $("input[name='fdName']").val();
	if (fdName == "") {
		alert("类别名称 不能为空");
		return false;
	}
	return true;
});
</script>

<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapRfcCategory" /></p>

<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do"
	>
		<!-- onsubmit="return validateTibSysSapRfcCategoryForm(this);" -->
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="tibSysSapRfcCategoryForm" />
		</c:import>
<center>
<table class="Label_Tabel" width="95%">
	<!-- tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdParent"/>
		</td><td width="35%"><html:hidden property="fdParentId" />
			<html:text property="fdParentName" readonly="true"
				styleClass="inputsgl" style="width:34%" /> <a href="#" onclick="Dialog_Tree(false, 'fdParentId', 'fdParentName', ',', 'tibSysSapRfcCategoryTreeService&parentId=!{value}', 
			'<bean:message key="table.tibSysSapRfcCategory" bundle="tib-sys-sap-connector"/>', null, null, 
			'${tibSysSapRfcCategoryForm.fdId}', null, null, 
			'<bean:message  bundle="tib-sys-sap-connector" key="table.tibSysSapRfcCategory"/>');">
			<bean:message key="dialog.selectOther" /></a></td>
				<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcCategory.fdName"/>
		</td><td width="35%" id="_fdName">
			<xform:text property="fdName" required="true"  style="width:85%" />
		</td>
	</tr-->

	<c:import url="/sys/simplecategory/include/sysCategoryMain_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="tibSysSapRfcCategoryForm" />
		<c:param name="requestURL" value="tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do?method=add" />
		<c:param name="fdModelName" value="${param.fdModelName}" />
	</c:import>
</table>
</center>  
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
