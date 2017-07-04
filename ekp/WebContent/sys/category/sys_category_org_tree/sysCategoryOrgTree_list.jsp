<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form
	action="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=add');">
	</kmss:auth> <kmss:auth
		requestURL="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do?method=deleteall"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysCategoryOrgTreeForm, 'deleteall');">
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

				<sunbor:column property="sysCategoryOrgTree.fdName">
					<bean:message bundle="sys-category"
						key="sysCategoryOrgTree.fdName" />
				</sunbor:column>

				<sunbor:column property="sysCategoryOrgTree.hbmParent.fdName">
					<bean:message bundle="sys-category" key="sysCategoryOrgTree.fdParentName" />
				</sunbor:column>

				<sunbor:column property="sysCategoryOrgTree.fdOrder">
					<bean:message key="model.fdOrder" />
				</sunbor:column>

				<sunbor:column property="sysCategoryOrgTree.docCreator.fdName">
					<bean:message key="model.fdCreator" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryOrgTree.docCreateTime">
					<bean:message key="model.fdCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysCategoryOrgTree"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/category/sys_category_org_tree/sysCategoryOrgTree.do" />?method=view&fdId=${sysCategoryOrgTree.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${sysCategoryOrgTree.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${sysCategoryOrgTree.fdName}" /></td>
				<td><c:out value="${sysCategoryOrgTree.fdParent.fdName}" />				
				<td><c:out value="${sysCategoryOrgTree.fdOrder}" /></td>
				<td><c:out value="${sysCategoryOrgTree.docCreator.fdName}" /></td>
				<td><sunbor:date value="${sysCategoryOrgTree.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
