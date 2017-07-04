<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/organization/sys_org_post/sysOrgPost">
<%@ include file="/sys/organization/sysOrg_listtop.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<div id="optBarDiv">
	<%
		String url = request.getParameter("parent");
		url = "/sys/organization/sys_org_post/sysOrgPost.do?"+(url==null?"":"parent="+url+"&");
		pageContext.setAttribute("actionUrl", url);
	%>
	<kmss:auth requestURL="${actionUrl}method=add" requestMethod="GET">
		<input type="button" name="method"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_post/sysOrgPost.do" />?method=add');"
			value="<bean:message key="button.add"/>" />
	</kmss:auth>
	<c:if test="${param.available != '0'}">
	<kmss:auth requestURL="${actionUrl}method=invalidatedAll" requestMethod="POST">
		<input type="button"  name="method"
			onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgPostForm, 'invalidatedAll');"
			value="<bean:message bundle="sys-organization" key="organization.invalidated" />">
	</kmss:auth>
	</c:if>
	<c:if test="${param.all != 'true'}">
	<kmss:auth requestURL="${actionUrl}method=quickSort" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-organization" key="sysOrgQuickSort.button" />"
			onclick="Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/organization/sys_org_quick_sort/SysOrgQuickSort.do?method=quickSort&type=4&parentId=${param.parent}'),'650','500');">
	</kmss:auth>
	</c:if>	
</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysOrgPost.fdOrder">
					<bean:message bundle="sys-organization" key="sysOrgPost.fdOrder" />
				</sunbor:column>
				<sunbor:column property="sysOrgPost.hbmParent.fdName">
					<bean:message bundle="sys-organization" key="sysOrgPost.fdParent" />
				</sunbor:column>
				<sunbor:column property="sysOrgPost.fdName">
					<bean:message bundle="sys-organization" key="sysOrgPost.fdName" />
				</sunbor:column>
				<sunbor:column property="sysOrgPost.hbmThisLeader">
					<bean:message bundle="sys-organization" key="sysOrgPost.fdThisLeader"/>
				</sunbor:column>
				<sunbor:column property="sysOrgPost.fdMemo">
					<bean:message bundle="sys-organization" key="sysOrgPost.fdMemo" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysOrgPost" name="queryPage" property="list"
			indexId="index">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_post/sysOrgPost.do" />?method=view&fdId=<bean:write name="sysOrgPost" property="fdId"/>">
				<td width="10px">
					<input type="checkbox" name="List_Selected"
						value="<bean:write name="sysOrgPost" property="fdId" />">
				</td>
				<td width="80px"><bean:write name="sysOrgPost" property="fdOrder" /></td>
				<td width="160px"><c:out value="${sysOrgPost.fdParent.fdName}" /></td>
				<td width="160px"><bean:write name="sysOrgPost" property="fdName" /></td>
				<td width="160px"><c:out value="${sysOrgPost.hbmThisLeader.fdName}" /></td>
				<td kmss_wordlength="40">${sysOrgPost.fdMemo}</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>