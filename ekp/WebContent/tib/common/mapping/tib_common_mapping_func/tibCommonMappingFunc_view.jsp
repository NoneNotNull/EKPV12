<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibCommonMappingFunc.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_func/tibCommonMappingFunc.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibCommonMappingFunc.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-mapping" key="table.erp"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdTemplateId"/>
		</td><td width="35%">
			<xform:text property="fdTemplateId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdInvokeType"/>
		</td><td width="35%">
			<xform:text property="fdInvokeType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdFuncMark"/>
		</td><td width="35%">
			<xform:text property="fdFuncMark" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcImport"/>
		</td><td width="35%">
			<xform:text property="fdRfcImport" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcExport"/>
		</td><td width="35%">
			<xform:text property="fdRfcExport" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdJspSegmen"/>
		</td><td width="35%">
			<xform:text property="fdJspSegmen" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdQuartzId"/>
		</td><td width="35%">
			<xform:text property="fdQuartzId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdUse"/>
		</td><td width="35%">
			<xform:radio property="fdUse">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdQuartzTime"/>
		</td><td width="35%">
			<xform:datetime property="fdQuartzTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdRfcSetting"/>
		</td><td width="35%">
			<c:out value="${tibCommonMappingFuncForm.fdRfcSettingName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.fdMain"/>
		</td><td width="35%">
			<c:out value="${tibCommonMappingFuncForm.fdMainName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
