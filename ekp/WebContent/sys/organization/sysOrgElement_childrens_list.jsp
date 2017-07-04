<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ page import="com.landray.kmss.constant.SysOrgConstant"%> 
<html:form action="/sys/organization/sys_org_dept/sysOrgDept.do">
<script>Com_IncludeFile("dialog.js");</script>
<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp" %>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp" %>
	<center>
		<p style="color: red;">
			<bean:message bundle="sys-organization" key="sysOrgDept.error.existChildren"/>
			<bean:message bundle="sys-organization" key="sysOrgDept.error.existChildren.msg"/>
		</p>
	</center>
	<table id="List_ViewTable">
		<tr>
			<td><bean:message bundle="sys-organization" key="organization.invalidated.parent"/></td>
			<td><bean:message bundle="sys-organization" key="organization.invalidated.child"/></td>
		</tr>
		<logic:iterate id="sysOrgElement" name="queryPage" property="list" indexId="index">
			<tr
				<logic:equal value="<%=String.valueOf(SysOrgConstant.ORG_TYPE_ORG)%>" name="sysOrgElement" property="fdOrgType">
					kmss_href="<c:url value="/sys/organization/sys_org_org/sysOrgOrg.do" />?method=view&fdId=${sysOrgElement.fdId }"
				</logic:equal>
				<logic:equal value="<%=String.valueOf(SysOrgConstant.ORG_TYPE_DEPT)%>" name="sysOrgElement" property="fdOrgType">
					kmss_href="<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do" />?method=view&fdId=${sysOrgElement.fdId }"
				</logic:equal>
				<logic:equal value="<%=String.valueOf(SysOrgConstant.ORG_TYPE_POST)%>" name="sysOrgElement" property="fdOrgType">
					kmss_href="<c:url value="/sys/organization/sys_org_post/sysOrgPost.do" />?method=view&fdId=${sysOrgElement.fdId }"
				</logic:equal>
				<logic:equal value="<%=String.valueOf(SysOrgConstant.ORG_TYPE_PERSON)%>" name="sysOrgElement" property="fdOrgType">
					kmss_href="<c:url value="/sys/organization/sys_org_person/sysOrgPerson.do" />?method=view&fdId=${sysOrgElement.fdId }"
				</logic:equal>
				>
				<td width="80px">${sysOrgElement.fdParent.fdName }</td>
				<td width="80px">${sysOrgElement.fdName }</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>