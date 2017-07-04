<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchFacetForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchFacet.fdSchema">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchFacet.fdSchema"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchFacet.fdField">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchFacet.fdField"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchFacet.fdType">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchFacet.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchFacet.fdRangfrom">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchFacet.fdRangfrom"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchFacet.fdRangto">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchFacet.fdRangto"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchFacet" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do" />?method=view&fdId=${sysFtsearchFacet.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchFacet.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchFacet.fdSchema}" />
				</td>
				<td>
					<c:out value="${sysFtsearchFacet.fdField}" />
				</td>
				<td>
					<c:out value="${sysFtsearchFacet.fdType}" />
				</td>
				<td>
					<c:out value="${sysFtsearchFacet.fdRangfrom}" />
				</td>
				<td>
					<c:out value="${sysFtsearchFacet.fdRangto}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>