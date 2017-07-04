<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcMappCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibJdbcMappCategory.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappCategory.fdHierarchyId">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappCategory.fdOrder">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappCategory.fdParent.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcMappCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory.do" />?method=view&fdId=${tibJdbcMappCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibJdbcMappCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibJdbcMappCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibJdbcMappCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${tibJdbcMappCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibJdbcMappCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>