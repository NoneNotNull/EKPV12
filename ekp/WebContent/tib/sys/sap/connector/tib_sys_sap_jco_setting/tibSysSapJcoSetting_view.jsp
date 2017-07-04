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
	<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSysSapJcoSetting.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSapJcoSetting.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-sap-connector" key="table.tibSysSapJcoSetting"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolName"/>
		</td><td width="35%">
			<xform:text property="fdPoolName" style="width:85%" />
		</td>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdTibSysSapCode"/>
		</td><td width="35%">
			<c:out value="${tibSysSapJcoSettingForm.fdTibSysSapCodeName}" />
		</td>
	
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolAdmin"/>
		</td><td width="35%">
			<xform:text property="fdPoolAdmin" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolSecret"/>
		</td><td width="35%">
			<input type="password" name="fdPoolSecret" value="${tibSysSapJcoSettingForm.fdPoolSecret}" readonly="readonly" style="width: 85%; border: 0px solid #000000;"/>
		</td>
		
	</tr>
	<tr>
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolStatus"/>
		</td><td width="35%">
			<xform:radio property="fdPoolStatus">
				<xform:enumsDataSource enumsType="status_type" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdConnectType"/>
		</td><td width="35%">
			<xform:radio property="fdConnectType">
				<xform:enumsDataSource enumsType="connect_type"/>
			</xform:radio>
		</td>
		
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolCapacity"/>
		</td><td width="35%">
			<xform:text property="fdPoolCapacity" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolNumber"/>
		</td><td width="35%">
			<xform:text property="fdPoolNumber" style="width:85%" />
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolTime"/>
		</td><td width="35%">
			<xform:text property="fdPoolTime" style="width:85%" />
		</td>
	
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdUpdateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdUpdateTime" />
		</td>
	</tr>
	<tr>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdDescribe"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdDescribe" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
