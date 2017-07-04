<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibJdbcRelationForm, 'deleteall');">
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
				<sunbor:column property="tibJdbcRelation.fdUseExplain">
					<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdUseExplain"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcRelation.fdSyncType">
					<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdSyncType"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcRelation.tibJdbcMappCategory.docSubject">
					<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcMappCategory"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcRelation.tibJdbcTaskManage.fdId">
					<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcTaskManage"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcRelation" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do" />?method=view&fdId=${tibJdbcRelation.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibJdbcRelation.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibJdbcRelation.fdUseExplain}" />
				</td>
				<td>
					<c:out value="${tibJdbcRelation.fdSyncType}" />
				</td>
				<td>
					<c:out value="${tibJdbcRelation.tibJdbcMappCategory.docSubject}" />
				</td>
				<td>
					<c:out value="${tibJdbcRelation.tibJdbcTaskManage.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>