<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysOrgGroupCateForm, 'deleteall');">
		</kmss:auth>
	</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysOrgGroupCate.hbmParent.fdName">
					<bean:message bundle="sys-organization" key="sysOrgGroupCate.fdParent" />
				</sunbor:column>
				<sunbor:column property="sysOrgGroupCate.fdName">
					<bean:message bundle="sys-organization" key="sysOrgGroupCate.fdName" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysOrgGroupCate" name="queryPage" property="list"
			indexId="index">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do" />?method=view&fdId=<bean:write name="sysOrgGroupCate" property="fdId"/>">
				<td><input type="checkbox" name="List_Selected"
					value="<bean:write name="sysOrgGroupCate" property="fdId" />"></td>
				<td><c:out value="${sysOrgGroupCate.fdParent.fdName}" /></td>
				<td><bean:write name="sysOrgGroupCate" property="fdName" /></td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
