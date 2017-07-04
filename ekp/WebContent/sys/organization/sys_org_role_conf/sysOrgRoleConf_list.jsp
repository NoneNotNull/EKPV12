<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function List_ConfirmInvalid(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message bundle="sys-organization" key="organization.invalidatedAll.comfirm" />");
}
</script>
<html:form action="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do" />?method=add');">
		</kmss:auth>
		<!--<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysOrgRoleConfForm, 'deleteall');">
		</kmss:auth>-->
		<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=invalidatedAll" requestMethod="POST">
			<input type="button" value="<bean:message key="organization.invalidated" bundle="sys-organization"/>"
					onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgRoleConfForm, 'invalidatedAll');">
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
				<sunbor:column property="sysOrgRoleConf.fdOrder">
					<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysOrgRoleConf.fdName">
					<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysOrgRoleConf.fdIsAvailable">
					<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdIsAvailable"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysOrgRoleConf" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do" />?method=view&fdId=${sysOrgRoleConf.fdId}">
				<td>
					<c:if test="${sysOrgRoleConf.fdIsAvailable}">
						<input type="checkbox" name="List_Selected" value="${sysOrgRoleConf.fdId}">
					</c:if>
					<c:if test="${!sysOrgRoleConf.fdIsAvailable}">
						<input type="checkbox" name="List_Selected" value="${sysOrgRoleConf.fdId}" disabled="disabled">
					</c:if>
					
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysOrgRoleConf.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysOrgRoleConf.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysOrgRoleConf.fdIsAvailable}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>