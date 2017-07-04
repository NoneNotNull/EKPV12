<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/rss/sys_rss_main/sysRssMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/rss/sys_rss_main/sysRssMain.do?method=add" requestMethod="GET">
			<c:if test="${empty param.cateid}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/rss/sys_rss_main/sysRssMain.do" />?method=add');">
			</c:if>
			<c:if test="${not empty param.cateid}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/rss/sys_rss_main/sysRssMain.do?cateid=${param.cateid}" />&method=add');">
			</c:if>
		</kmss:auth>
		<kmss:auth requestURL="/sys/rss/sys_rss_main/sysRssMain.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysRssMainForm, 'deleteall');">
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
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysRssMain.fdOrder">
					<bean:message bundle="sys-rss" key="sysRssMain.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysRssMain.docSubject">
					<bean:message bundle="sys-rss" key="sysRssMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="sysRssMain.fdLink">
					<bean:message bundle="sys-rss" key="sysRssMain.fdLink"/>
				</sunbor:column>
				<sunbor:column property="sysRssMain.docCategory.fdName">
					<bean:message bundle="sys-rss" key="sysRssMain.docCategoryId"/>
				</sunbor:column>
				<sunbor:column property="sysRssMain.docCreator.fdName">
					<bean:message bundle="sys-rss" key="sysRssMain.docCreatorId"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysRssMain" varStatus="vstatus">
			<tr kmss_href="<c:url value="/sys/rss/sys_rss_main/sysRssMain.do" />?method=view&fdId=${sysRssMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysRssMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysRssMain.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysRssMain.docSubject}" />
				</td>
				<td>
					<c:out value="${sysRssMain.fdLink}" />
				</td>
				<td>
					<c:out value="${sysRssMain.docCategory.fdName}" />
				</td>
				<td>
					<c:out value="${sysRssMain.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
