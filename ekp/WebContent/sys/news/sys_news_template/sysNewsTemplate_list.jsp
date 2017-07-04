<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/news/sys_news_template/sysNewsTemplate.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/sys/news/sys_news_template/sysNewsTemplate.do?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/news/sys_news_template/sysNewsTemplate.do" />?method=add&parentId=${param.parentId}');">
	</kmss:auth> <kmss:auth
		requestURL="/sys/news/sys_news_template/sysNewsTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysNewsTemplateForm, 'deleteall');">
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>

				<sunbor:column property="sysNewsTemplate.fdName">
					<bean:message bundle="sys-news" key="sysNewsTemplate.fdName" />
				</sunbor:column>
				
				<sunbor:column property="sysNewsTemplate.docCategory">
					<bean:message bundle="sys-news" key="sysNewsTemplate.fdCategoryId" />
				</sunbor:column>

				<sunbor:column property="sysNewsTemplate.fdOrder">
					<bean:message bundle="sys-news" key="sysNews.fdOrder" />
				</sunbor:column>
				
				<sunbor:column property="sysNewsTemplate.docCreator">
					<bean:message bundle="sys-news" key="sysNewsTemplate.docCreatorId" />
				</sunbor:column>

				
				<sunbor:column property="sysNewsTemplate.docCreateTime">
					<bean:message bundle="sys-news" key="sysNewsTemplate.docCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNewsTemplate"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/news/sys_news_template/sysNewsTemplate.do" />?method=view&fdId=${sysNewsTemplate.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${sysNewsTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${sysNewsTemplate.fdName}" /></td>
				<td><c:out value="${sysNewsTemplate.docCategory.fdName}" /></td>
				<td><c:out value="${sysNewsTemplate.fdOrder}" /></td>
				<td><c:out value="${sysNewsTemplate.docCreator.fdName}" /></td>
				<td><sunbor:date value="${sysNewsTemplate.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
