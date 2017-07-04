<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/sap/mapping/plugins/controls/list/tib_sap_mapping_list_control_main/tibSapMappingListControlMain.do">
<div id="optBarDiv">
	<c:if test="${tibSapMappingListControlMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSapMappingListControlMainForm, 'update');">
	</c:if>
	<c:if test="${tibSapMappingListControlMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSapMappingListControlMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSapMappingListControlMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sap-mapping-plugins-controls-list" key="table.tibSapMappingListControlMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-mapping-plugins-controls-list" key="tibSapMappingListControlMain.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-mapping-plugins-controls-list" key="tibSapMappingListControlMain.fdKey"/>
		</td><td width="35%">
			<xform:text property="fdKey" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-mapping-plugins-controls-list" key="tibSapMappingListControlMain.fdShowData"/>
		</td><td width="35%">
			<xform:textarea property="fdShowData" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sap-mapping-plugins-controls-list" key="tibSapMappingListControlMain.fdIndex"/>
		</td><td width="35%">
			<xform:text property="fdIndex" style="width:85%" />
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