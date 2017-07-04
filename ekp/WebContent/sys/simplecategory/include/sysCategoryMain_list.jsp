<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
<!--
Com_Parameter.IsAutoTransferPara = true;
//-->
</script>
<%
String ru = request.getParameter("requestURL");
String a = ru.substring(ru.lastIndexOf("/")+1);
a = a.substring(0,a.length()-3);
request.setAttribute("a",a);
%>

<html:form action="${param.requestURL}">
	<div id="optBarDiv">
		<kmss:auth
		requestURL="${param.requestURL}?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="${param.requestURL}" />?method=add');">
		</kmss:auth>
		<kmss:auth
		requestURL="${param.requestURL}?method=deleteall"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.${param.formName}, 'deleteall');">
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

				<sunbor:column property="${a}.fdName">
					<bean:message bundle="sys-simplecategory" key="sysSimpleCategory.fdName" />
				</sunbor:column>

				<sunbor:column property="${a}.hbmParent.fdName">
					<bean:message bundle="sys-simplecategory" key="sysSimpleCategory.fdParentName" />
				</sunbor:column>
				
				<sunbor:column property="${a}.fdOrder">
					<bean:message key="model.fdOrder" />
				</sunbor:column>
				
				<sunbor:column property="${a}.docCreator.fdName">
					<bean:message key="model.fdCreator" />
				</sunbor:column>
				
				<sunbor:column property="${a}.docCreateTime">
					<bean:message key="model.fdCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysCategoryMain"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="${param.requestURL}" />?method=view&fdId=${sysCategoryMain.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${sysCategoryMain.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${sysCategoryMain.fdName}" /></td>
				<td><c:out value="${sysCategoryMain.fdParent.fdName}" />
				</td>
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
