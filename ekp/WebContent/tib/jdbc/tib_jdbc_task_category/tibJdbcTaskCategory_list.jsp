<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcTaskCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibJdbcTaskCategory.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcTaskCategory.fdHierarchyId">
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcTaskCategory.fdOrder">
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcTaskCategory.fdParent.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcTaskCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcTaskCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do" />?method=view&fdId=${tibJdbcTaskCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibJdbcTaskCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibJdbcTaskCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibJdbcTaskCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibJdbcTaskCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibJdbcTaskCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>