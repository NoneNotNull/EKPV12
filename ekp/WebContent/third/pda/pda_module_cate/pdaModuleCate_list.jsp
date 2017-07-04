<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<form name="pdaModuleCateForm" method="post" action="${KMSS_Parameter_ContextPath}third/pda/pda_module_cate/pdaModuleCate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_module_cate/pdaModuleCate.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_cate/pdaModuleCate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_cate/pdaModuleCate.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaModuleCateForm, 'deleteall');">
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
				<sunbor:column property="pdaModuleCate.fdOrder">
					序号
				</sunbor:column>
				<sunbor:column property="pdaModuleCate.fdName">
					名称
				</sunbor:column>
				<sunbor:column property="pdaModuleCate.docCreator.fdName">
					创建者
				</sunbor:column>
				<sunbor:column property="pdaModuleCate.docCreateTime">
					创建时间
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaModuleCate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_module_cate/pdaModuleCate.do" />?method=view&fdId=${pdaModuleCate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaModuleCate.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${pdaModuleCate.fdOrder}" />
				</td>
				<td>
					<c:out value="${pdaModuleCate.fdName}" />
				</td>
				<td>
					<c:out value="${pdaModuleCate.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${pdaModuleCate.docCreateTime}"></kmss:showDate>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</form>
<%@ include file="/resource/jsp/list_down.jsp"%>