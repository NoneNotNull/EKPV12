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
	<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibCommonMappingModule.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibCommonMappingModule.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-mapping" key="table.tibCommonMappingModule"/></p>

<center>
<table class="tb_normal" width=95%>
	<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdServerName"/>
		</td><td width="35%">
			<xform:text property="fdServerName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdServerIp"/>
		</td><td width="35%">
			<xform:text property="fdServerIp" style="width:85%" />
		</td>
	</tr>
	--%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdModuleName"/>
		</td><td width="35%">
			<xform:text property="fdModuleName" style="width:85%" />
		</td>
     <td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdUse"/>
		</td><td width="35%">
			<xform:radio property="fdUse">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemplateName"/>
		</td><td width="35%">
			<xform:text property="fdTemplateName" style="width:85%" /><br>
			<xform:radio property="fdCate">
				<xform:enumsDataSource enumsType="tibCommonMappingModule_cate" />
			</xform:radio>
		</td>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdMainModelName"/>
		</td><td width="35%">
			<xform:text property="fdMainModelName" style="width:85%" />
		</td>
	</tr>
	<tr style="display: ${tibCommonMappingModuleForm.fdCate==0?'none':''}">
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemCateFieldName"/>
		</td><td width="35%">
		<xform:text property="fdTemCateFieldName" value="" style="width:70%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemNameFieldName"/>
		</td><td width="35%">
		<xform:text property="fdTemNameFieldName" value="" style="width:70%" />
		</td>
	</tr>
		<tr>
	<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdModelTemFieldName"/>
		</td><td width="25%">
		<xform:text property="fdModelTemFieldName" value="" style="width:85%"/>
		</td>
			<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdFormTemFieldName"/>
		</td><td width="25%">
		<xform:text property="fdFormTemFieldName" value="" style="width:70%" />
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdType"/>
		</td><td width="25%">
			 <xform:checkbox property="fdType" value="${tibCommonMappingModuleForm.fdType}" isArrayValue="true" showStatus="view">
		     <xform:customizeDataSource className="com.landray.kmss.tib.common.mapping.plugins.taglib.TibCommonPluginsDataSource"/>
		     </xform:checkbox>
		</td>
		<td class="td_normal_title" width=25%>

		</td><td width="25%">

		
		</td>
	</tr>	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
