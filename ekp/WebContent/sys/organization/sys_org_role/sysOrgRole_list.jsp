<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function List_ConfirmInvalid(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message bundle="sys-organization" key="organization.invalidatedAll.comfirm" />");
}
</script>
<html:form action="/sys/organization/sys_org_role/sysOrgRole.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role/sysOrgRole_simulator.jsp"/>','_blank');">
		<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role/sysOrgRole.do" />?method=add');">
		</kmss:auth>
		<!-- 
		<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysOrgRoleForm, 'deleteall');">
		</kmss:auth>
		 -->
		<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do.do?method=invalidatedAll" requestMethod="POST">
			<input type="button" value="<bean:message key="organization.invalidated" bundle="sys-organization"/>"
					onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgRoleForm, 'invalidatedAll');">
		</kmss:auth>		
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysOrgRole.fdOrder">
					<bean:message  bundle="sys-organization" key="sysOrgRole.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysOrgRole.fdName">
					<bean:message  bundle="sys-organization" key="sysOrgRole.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysOrgRole.fdDescription">
					<bean:message  bundle="sys-organization" key="sysOrgRole.fdDescription"/>
				</sunbor:column>
				<sunbor:column property="sysOrgRole.fdIsAvailable">
					<bean:message  bundle="sys-organization" key="sysOrgRole.fdIsAvailable"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysOrgRole" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_role/sysOrgRole.do" />?method=edit&fdId=${sysOrgRole.fdId}">
				<td>
					<c:if test="${sysOrgRole.fdIsAvailable}">
						<input type="checkbox" name="List_Selected" value="${sysOrgRole.fdId}">
					</c:if>
					<c:if test="${!sysOrgRole.fdIsAvailable}">
						<input type="checkbox" name="List_Selected" value="${sysOrgRole.fdId}" disabled="disabled">
					</c:if>
				</td>
				<td>${vstatus.index+1}</td>
				<td width="10%">
					<c:out value="${sysOrgRole.fdOrder}" />
				</td>
				<td width="25%">
					<c:out value="${sysOrgRole.fdName}" />
				</td>
				<td width="55%">
					<c:out value="${sysOrgRole.fdMemo}" />
				</td>
				<td width="10%">
					<sunbor:enumsShow value="${sysOrgRole.fdIsAvailable}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>