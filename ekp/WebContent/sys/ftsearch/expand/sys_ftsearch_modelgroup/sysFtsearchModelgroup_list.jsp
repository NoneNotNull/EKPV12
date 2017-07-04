<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchModelgroupForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchModelgroup.fdCategoryName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchModelgroup.fdCategoryName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchModelgroup.fdCategoryModel">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchModelgroup.fdCategoryModel"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchModelgroup" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do" />?method=view&fdId=${sysFtsearchModelgroup.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchModelgroup.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchModelgroup.fdCategoryName}" />
				</td>
				<td>
					<c:out value="${sysFtsearchModelgroup.fdCategoryModel}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>