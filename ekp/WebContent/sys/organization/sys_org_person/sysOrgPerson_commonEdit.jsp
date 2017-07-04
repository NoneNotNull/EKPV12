<%@ include file="/resource/jsp/common.jsp"%>
<%@ page
	import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdName" />
	</td>
	<td width=35%>
		<xform:text property="fdName" style="width:90%"></xform:text>
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdNo" />
	</td>
	<td width=35%>
	  <xform:text property="fdNo" style="width:90%"></xform:text>
	
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdParent" />
	</td>
	<td width=35%>
		<html:hidden property="fdParentId" />
		<html:text style="width:90%" property="fdParentName" readonly="true" styleClass="inputsgl" />
		<a href="#" onclick="Dialog_Address(false, 'fdParentId', 'fdParentName', null, ORG_TYPE_ORGORDEPT|ORG_FLAG_BUSINESSALL);">
			<bean:message key="dialog.selectOrg" />
		</a>
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdEmail" />
	</td>
	<td width=35%>
	<xform:text property="fdEmail" style="width:90%"></xform:text>
	
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdMobileNo" />
	</td>
	<td width=35%>
	<xform:text property="fdMobileNo" style="width:90%"></xform:text>
	
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdWorkPhone" />
	</td>
	<td width=35%>
	<xform:text property="fdWorkPhone" style="width:90%"></xform:text>
	
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdLoginName" />
	</td>
	<td width=35%>
	  <xform:text property="fdLoginName" style="width:90%"></xform:text>
		
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdDefaultLang" />
	</td>
	<td width=35%>
	<%
		SysOrgPersonForm sysOrgPersonForm = (SysOrgPersonForm) request
				.getAttribute("sysOrgPersonForm");
		out.write(sysOrgPersonForm.getLangSelectHtml(request,
				"fdDefaultLang", sysOrgPersonForm.getFdDefaultLang()));
	%>
	</td>
</tr>
<c:if test="${sysOrgPersonForm.method_GET=='add'}">
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdPassword" />
		</td>
		<td width=35%>
			<html:text style="width:90%" property="fdNewPassword" />
		</td>
		<td width=15% class="td_normal_title"></td>
		<td width=35%></td>
	</tr>
</c:if>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdKeyword" />
	</td>
	<td width=35%>
	<xform:text property="fdKeyword" style="width:90%"></xform:text>
	
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdOrder" />
	</td>
	<td width=35%>
		<xform:text property="fdOrder" style="width:90%"></xform:text>
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdIsBusiness" />
	</td>
	<td width=35%>
		<sunbor:enums property="fdIsBusiness" enumsType="common_yesno" elementType="radio" />
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdPosts" />
	</td>
	<td width=35%>
        <html:hidden property="fdPostIds" />
		<html:text property="fdPostNames" readonly="true" styleClass="inputsgl" style="width:90%" />
		<a href="#" onclick="Dialog_Address(true,'fdPostIds', 'fdPostNames', ';', ORG_TYPE_POST | ORG_FLAG_BUSINESSALL);">
			<bean:message key="dialog.selectOrg" />
		</a>		
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdRtxNo" />
	</td>
	<td width=35%>
	<xform:text property="fdRtxNo" style="width:90%"></xform:text>
	
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdCardNo" />
	</td>
	<td width=35%><html:text style="width:90%" property="fdCardNo" />
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdSex" />
	</td>
	<td width="35%">
	    <sunbor:enums property="fdSex" enumsType="sys_org_person_sex" elementType="radio" />
	</td>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdWechatNo" />
	</td>
	<td width=35%>
		<xform:text property="fdWechatNo" style="width:90%"></xform:text>
	</td>
</tr>
<c:if test="${sysOrgPersonForm.method_GET=='edit'}">
	<kmss:auth
		requestURL="/sys/organization/sys_org_person/sysOrgPerson.do?method=invalidated&fdId=${sysOrgPersonForm.fdId}"
		requestMethod="GET">
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdIsAvailable" />
		</td>
		<td width="35%">
		    <sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
		</td>
		<td width=15% class="td_normal_title"></td>
		<td width=35%></td>
	</tr>
	</kmss:auth>
</c:if>
<c:if test="${personImportType=='inner'}">
	<c:import url="${personExtendFormUrl}" charEncoding="UTF-8" />
</c:if>
<tr>
	<td width=15% class="td_normal_title">
		<bean:message bundle="sys-organization" key="sysOrgPerson.fdMemo" />
	</td>
	<td colspan=3>
		<xform:textarea property="fdMemo" style="width:100%"></xform:textarea>
	</td>
</tr>