<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/tag/sys_tag_category/sysTagCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/tag/sys_tag_category/sysTagCategory.do" />?method=add&fdCategoryId=${param.fdCategoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_category/sysTagCategory.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTagCategoryForm, 'deleteall');">
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
				<sunbor:column property="sysTagCategory.fdName">
					<bean:message  bundle="sys-tag" key="sysTagCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysTagCategory.fdManager.fdName">
					<bean:message  bundle="sys-tag" key="sysTagCategory.fdManagerId"/>
				</sunbor:column>
				<sunbor:column property="sysTagCategory.fdTagQuoteTimes">
					<bean:message  bundle="sys-tag" key="sysTagCategory.fdTagQuoteTimes"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/tag/sys_tag_category/sysTagCategory.do" />?method=view&fdId=${sysTagCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTagCategory.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTagCategory.fdName}" />
				</td>
				<td>
					<c:out value="${sysTagCategory.fdManager.fdName}" />
				</td>
				<td>
					<c:out value="${sysTagCategory.fdTagQuoteTimes}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>