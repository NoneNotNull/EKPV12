<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchUserParticipleForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchUserParticiple.fdParticiple">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.fdParticiple"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchUserParticiple.docCreateTime">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchUserParticiple.docCreator.fdName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchUserParticiple" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do" />?method=view&fdId=${sysFtsearchUserParticiple.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchUserParticiple.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchUserParticiple.fdParticiple}" />
				</td>
				<td>
					<kmss:showDate value="${sysFtsearchUserParticiple.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysFtsearchUserParticiple.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>