<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/organization/sys_org_dept/sysOrgDept.do">
<%@ include file="/sys/organization/sysOrg_listtop.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<div id="optBarDiv">
	<%
		String url = request.getParameter("parent");
		url = "/sys/organization/sys_org_dept/sysOrgDept.do?"+(url==null?"":"parent="+url+"&");
		pageContext.setAttribute("actionUrl", url);
	%>
	<kmss:auth requestURL="${actionUrl}method=add" requestMethod="GET">
		<input type="button" name="method"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do" />?method=add');"
			value="<bean:message key="button.add"/>" />
	</kmss:auth>
	<c:if test="${param.available != '0'}">
	<kmss:auth requestURL="${actionUrl}method=invalidatedAll" requestMethod="POST">
		<input type="button"  name="method"
			onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgDeptForm, 'invalidatedAll');"
			value="<bean:message bundle="sys-organization" key="organization.invalidated" />">
	</kmss:auth>
	</c:if>
	<c:if test="${param.all != 'true'}">
	<kmss:auth requestURL="${actionUrl}method=quickSort" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-organization" key="sysOrgQuickSort.button" />"
			onclick="Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/organization/sys_org_quick_sort/SysOrgQuickSort.do?method=quickSort&type=2&parentId=${param.parent}'),'650','500');">
	</kmss:auth>
	</c:if>
</div>
<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp" %>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp" %>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysOrgDept.fdOrder">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdOrder" />
				</sunbor:column>
				<sunbor:column property="sysOrgDept.hbmParent.fdName">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdParent" />
				</sunbor:column>
				<sunbor:column property="sysOrgDept.fdName">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdName" />
				</sunbor:column>
				<sunbor:column property="sysOrgDept.hbmThisLeader">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdThisLeader"/>
				</sunbor:column>
				<sunbor:column property="sysOrgDept.hbmSuperLeader">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdSuperLeader"/>
				</sunbor:column>
				<sunbor:column property="sysOrgDept.fdMemo">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdMemo" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysOrgDept" name="queryPage" property="list"
			indexId="index">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do" />?method=view&fdId=<bean:write name="sysOrgDept" property="fdId"/>">
				<td><input type="checkbox" name="List_Selected"
					value="<bean:write name="sysOrgDept" property="fdId" />"></td>
				<td width="80px"><bean:write name="sysOrgDept" property="fdOrder" /></td>
				<td width="160px"><c:out value="${sysOrgDept.fdParent.fdName}" /></td>
				<td width="160px"><bean:write name="sysOrgDept" property="fdName" /></td>
				<td width="160px"><c:out value="${sysOrgDept.hbmThisLeader.fdName}" /></td>
				<td width="160px"><c:out value="${sysOrgDept.hbmSuperLeader.fdName}" /></td>
				<td kmss_wordlength="40">${sysOrgDept.fdMemo}</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>