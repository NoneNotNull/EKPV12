<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcDataSetCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibJdbcDataSetCategory.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcDataSetCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcDataSetCategory.fdHierarchyId">
					<bean:message bundle="tib-jdbc" key="tibJdbcDataSetCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcDataSetCategory.fdOrder">
					<bean:message bundle="tib-jdbc" key="tibJdbcDataSetCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcDataSetCategory.fdParent.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcDataSetCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcDataSetCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory.do" />?method=view&fdId=${tibJdbcDataSetCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibJdbcDataSetCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibJdbcDataSetCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibJdbcDataSetCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibJdbcDataSetCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibJdbcDataSetCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>