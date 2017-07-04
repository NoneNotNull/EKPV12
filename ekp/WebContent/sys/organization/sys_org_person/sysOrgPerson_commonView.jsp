<%@ include file="/resource/jsp/common.jsp"%>
<%@ page
	import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdName" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdName" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdNo" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm" property="fdNo" />
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdParent" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdParentName" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdEmail" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdEmail" /></td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdMobileNo" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdMobileNo" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdWorkPhone" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdWorkPhone" /></td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdLoginName" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdLoginName" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdDefaultLang" /></td>
	<td width=35%>
	<%
		SysOrgPersonForm sysOrgPersonForm = (SysOrgPersonForm) request
				.getAttribute("sysOrgPersonForm");
		out.write(sysOrgPersonForm.getLangDisplayName(request,
				sysOrgPersonForm.getFdDefaultLang()));
	%>
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdKeyword" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdKeyword" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdOrder" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdOrder" /></td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdIsBusiness" /></td>
	<td width=35%><sunbor:enumsShow
		value="${sysOrgPersonForm.fdIsBusiness}" enumsType="common_yesno" />
	</td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdPosts" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdPostNames" />
	</td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdRtxNo" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdRtxNo" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdCardNo" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdCardNo" /></td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdSex" /></td>
	<td width="35%"><sunbor:enumsShow
		value="${sysOrgPersonForm.fdSex}" enumsType="sys_org_person_sex" /></td>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdWechatNo" /></td>
	<td width=35%><bean:write name="sysOrgPersonForm"
		property="fdWechatNo" /></td>
</tr>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdIsAvailable" /></td>
	<td width="35%"><sunbor:enumsShow
		value="${sysOrgPersonForm.fdIsAvailable}" enumsType="common_yesno" /></td>
	<td width=15% class="td_normal_title"></td>
	<td width="35%"></td>
</tr>
<c:if test="${personImportType=='inner'}">
	<c:import url="${personExtendFormUrl}" charEncoding="UTF-8" />
</c:if>
<tr>
	<td width=15% class="td_normal_title"><bean:message
		bundle="sys-organization" key="sysOrgPerson.fdMemo" /></td>
	<td colspan=3><kmss:showText value="${sysOrgPersonForm.fdMemo}" />
	</td>
</tr>