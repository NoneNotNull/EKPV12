<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function List_ConfirmInvalid(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message bundle="sys-organization" key="organization.invalidatedAll.comfirm" />");
}
</script>
<html:form action="/sys/organization/sys_org_group/sysOrgGroup.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/organization/sys_org_group/sysOrgGroup.do?method=add" requestMethod="GET">
		<input type="button" name="method"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do" />?method=add');"
			value="<bean:message key="button.add"/>" />
	</kmss:auth>
	<c:if test="${param.available != '0'}">
	<kmss:auth requestURL="/sys/organization/sys_org_group/sysOrgGroup.do?method=invalidatedAll" requestMethod="POST">
		<input type="button"  name="method"
			onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgGroupForm, 'invalidatedAll');"
			value="<bean:message bundle="sys-organization" key="organization.invalidated" />">
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
				<sunbor:column property="sysOrgGroup.fdOrder">
					<bean:message bundle="sys-organization" key="sysOrgGroup.fdOrder" />
				</sunbor:column>
				<sunbor:column property="sysOrgGroup.hbmGroupCate.fdName">
					<bean:message bundle="sys-organization" key="sysOrgGroup.fdGroupCate" />
				</sunbor:column>
				<sunbor:column property="sysOrgGroup.fdName">
					<bean:message bundle="sys-organization" key="sysOrgGroup.fdName" />
				</sunbor:column>
				<sunbor:column property="sysOrgGroup.fdMemo">
					<bean:message bundle="sys-organization" key="sysOrgGroup.fdMemo" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysOrgGroup" name="queryPage" property="list"
			indexId="index">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do" />?method=view&fdId=<bean:write name="sysOrgGroup" property="fdId"/>">
				<td><input type="checkbox" name="List_Selected"
					value="<bean:write name="sysOrgGroup" property="fdId" />"></td>
				<td width="80px"><bean:write name="sysOrgGroup" property="fdOrder" /></td>
				<td width="160px"><c:out value="${sysOrgGroup.fdGroupCate.fdName}" /></td>
				<td width="160px"><bean:write name="sysOrgGroup" property="fdName" /></td>
				<td kmss_wordlength="40">${sysOrgGroup.fdMemo}</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>