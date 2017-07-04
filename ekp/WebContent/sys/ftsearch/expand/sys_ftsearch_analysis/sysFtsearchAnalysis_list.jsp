<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchAnalysisForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchAnalysis.fdUserName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchAnalysis.fdUserName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchAnalysis.fdSearchTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchAnalysis.fdSearchTime"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchAnalysis.fdSearchWordSets">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchAnalysis.fdSearchWordSets"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchAnalysis" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do" />?method=view&fdId=${sysFtsearchAnalysis.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchAnalysis.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchAnalysis.fdUserName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchAnalysis.fdSearchTime}" />
				</td>
				<td>
					<c:out value="${sysFtsearchAnalysis.fdSearchWordSets}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>