<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function sysAuthConfirm(checkName){
	return List_CheckSelect(checkName) && confirm('<bean:message bundle="sys-authorization" key="sysAuthArea.invalidateAll.comfirm"/>');
}
</script>
<html:form action="/sys/authorization/sys_auth_area/sysAuthArea.do">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
<%-- 				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
--%>				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysAuthArea.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthArea.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysAuthArea.fdParent.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthArea.fdParent"/>
				</sunbor:column>
				<td>
					<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaOrg"/>
				</td>
				<td>
					<bean:message bundle="sys-authorization" key="sysAuthArea.authAreaAdmin"/>
				</td>
<%--				<sunbor:column property="sysAuthArea.fdIsAvailable">
					<bean:message bundle="sys-authorization" key="sysAuthArea.fdIsAvailable"/>
				</sunbor:column>
--%>			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysAuthArea" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/authorization/sys_auth_area/sysAuthArea.do" />?method=edit&fdId=${sysAuthArea.fdId}">
<%--				<td>
					<input type="checkbox" name="List_Selected" value="${sysAuthArea.fdId}">
				</td>
--%>				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysAuthArea.fdName}" />
				</td>
				<td>
					<c:out value="${sysAuthArea.fdParent.fdName}" />
				</td>
				<td>
					<kmss:joinListProperty value="${sysAuthArea.authAreaOrg}" properties="fdName" />
				</td>
				<td>
					<kmss:joinListProperty value="${sysAuthArea.authAreaAdmin}" properties="fdName" />
				</td>
<%--				<td>
					<xform:select value="${sysAuthArea.fdIsAvailable}" property="fdIsAvailable" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:select>
				</td>
--%>			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>