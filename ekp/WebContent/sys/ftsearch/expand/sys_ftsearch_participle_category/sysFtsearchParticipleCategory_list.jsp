<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchParticipleCategoryForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchParticipleCategory.fdName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.docCreatorName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.docCreatorName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.docCreateTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.docCreateorId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.docCreateorId"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.docAlterTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.fdHierarchyId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.fdHierarchyId"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.fdOrder">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchParticipleCategory.fdParent.fdId">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticipleCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchParticipleCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory.do" />?method=view&fdId=${sysFtsearchParticipleCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchParticipleCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.fdName}" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.docCreatorName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchParticipleCategory.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.docCreateorId}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchParticipleCategory.docAlterTime}" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.fdHierarchyId}" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysFtsearchParticipleCategory.fdParent.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>