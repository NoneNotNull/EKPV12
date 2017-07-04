<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/category/sys_category_main/sysCategoryMain.do">
	<div id="optBarDiv">
		<kmss:auth
		requestURL="/sys/category/sys_category_main/sysCategoryMain.do?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth
		requestURL="/sys/category/sys_category_main/sysCategoryMain.do?method=deleteall"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysCategoryMainForm, 'deleteall');">
		</kmss:auth>
	</div>
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

				<sunbor:column property="sysCategoryMain.fdName">
					<bean:message bundle="sys-category" key="sysCategoryMain.fdName" />
				</sunbor:column>

				<sunbor:column property="sysCategoryMain.hbmParent.fdName">
					<bean:message bundle="sys-category" key="sysCategoryMain.fdParentName" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryMain.fdOrgTree.fdName">
					<bean:message bundle="sys-category" key="sysCategoryMain.fdOrgTreeName" />
				</sunbor:column>
					
				<sunbor:column property="sysCategoryMain.fdOrder">
					<bean:message key="model.fdOrder" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryMain.docCreator.fdName">
					<bean:message key="model.fdCreator" />
				</sunbor:column>
				
				<sunbor:column property="sysCategoryMain.docCreateTime">
					<bean:message key="model.fdCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysCategoryMain"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/category/sys_category_main/sysCategoryMain.do" />?method=view&fdId=${sysCategoryMain.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${sysCategoryMain.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${sysCategoryMain.fdName}" /></td>
				<td><c:out value="${sysCategoryMain.fdParent.fdName}" />
				</td>
				<td><c:out value="${sysCategoryMain.fdOrgTree.fdName}" /></td>
				<td><c:out value="${sysCategoryMain.fdOrder}" /></td>
				<td><c:out value="${sysCategoryMain.docCreator.fdName}" /></td>
				<td><kmss:showDate value="${sysCategoryMain.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
