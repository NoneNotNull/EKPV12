<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form
	action="/sys/category/sys_category_property/sysCategoryProperty.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/sys/category/sys_category_property/sysCategoryProperty.do?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/category/sys_category_property/sysCategoryProperty.do" />?method=add');">
	</kmss:auth> <kmss:auth
		requestURL="/sys/category/sys_category_property/sysCategoryProperty.do?method=deleteall"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysCategoryPropertyForm, 'deleteall');">
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

				<sunbor:column property="sysCategoryProperty.fdName">
					<bean:message bundle="sys-category"
						key="sysCategoryProperty.fdName" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryProperty.hbmParent.fdName">
					<bean:message bundle="sys-category" key="sysCategoryProperty.fdParentName" />
				</sunbor:column>

				<sunbor:column property="sysCategoryProperty.fdOrder">
					<bean:message 	key="model.fdOrder" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryProperty.docCreator.fdName">
					<bean:message key="model.docAlteror" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryProperty.docCreateTime">
					<bean:message key="model.fdAlterTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysCategoryProperty"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/category/sys_category_property/sysCategoryProperty.do" />?method=view&fdId=${sysCategoryProperty.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${sysCategoryProperty.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${sysCategoryProperty.fdName}" /></td>
				<td><c:out value="${sysCategoryProperty.fdParent.fdName}" />
				</td>
					<td><c:out value="${sysCategoryProperty.fdOrder}" /></td>
				<td><c:out value="${sysCategoryProperty.docCreator.fdName}" /></td>
				<td><sunbor:date value="${sysCategoryProperty.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
