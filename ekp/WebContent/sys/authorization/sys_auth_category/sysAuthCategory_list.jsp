<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/authorization/sys_auth_category/sysAuthCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/authorization/sys_auth_category/sysAuthCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/authorization/sys_auth_category/sysAuthCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/authorization/sys_auth_category/sysAuthCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysAuthCategoryForm, 'deleteall');">
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysAuthCategory.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysAuthCategory.fdOrder">
					<bean:message bundle="sys-authorization" key="sysAuthCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysAuthCategory.docCreator.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="sysAuthCategory.docCreateTime">
					<bean:message bundle="sys-authorization" key="sysAuthCategory.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysAuthCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/authorization/sys_auth_category/sysAuthCategory.do" />?method=view&fdId=${sysAuthCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysAuthCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysAuthCategory.fdName}" />
				</td>
				<td>
					<c:out value="${sysAuthCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysAuthCategory.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysAuthCategory.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>