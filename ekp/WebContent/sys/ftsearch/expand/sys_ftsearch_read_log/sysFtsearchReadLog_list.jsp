<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do">
	<div id="optBarDiv">
		<%-- 
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do" />?method=add');">
		</kmss:auth>
		--%>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchReadLogForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchReadLog.fdSearchWord">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdSearchWord"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdDocSubject">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdDocSubject"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdHitPosition">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdHitPosition"/>
				</sunbor:column>
				<%-- 
				<sunbor:column property="sysFtsearchReadLog.fdUrl">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdModelId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdModelName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdCategoryHierarchyId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdCategoryHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdReaderId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReaderId"/>
				</sunbor:column>
				--%>
				<sunbor:column property="sysFtsearchReadLog.fdReaderName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReaderName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchReadLog.fdReadTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchReadLog.fdReadTime"/>
				</sunbor:column>
				
				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchReadLog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do" />?method=view&fdId=${sysFtsearchReadLog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchReadLog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td width="30%">
					<c:out value="${sysFtsearchReadLog.fdSearchWord}" />
				</td>
				<td width="30%">
					<c:out value="${sysFtsearchReadLog.fdDocSubject}" />
				</td>
				<%-- 
				<td>
					<c:out value="${sysFtsearchReadLog.fdUrl}" />
				</td>
				<td>
					<c:out value="${sysFtsearchReadLog.fdModelId}" />
				</td>
				<td>
					<c:out value="${sysFtsearchReadLog.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysFtsearchReadLog.fdCategoryHierarchyId}" />
				</td>
				<td>
					<c:out value="${sysFtsearchReadLog.fdReaderId}" />
				</td>
				--%>
				<td>
					<c:out value="${sysFtsearchReadLog.fdHitPosition}" />
				</td>
				<td>
					<c:out value="${sysFtsearchReadLog.fdReaderName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchReadLog.fdReadTime}" />
				</td>
				
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>