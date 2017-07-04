<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<script language="JavaScript">

</script>

<html:form action="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
	<div id="optBarDiv">
		<%--取消直接创建input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
					<c:param name="method" value="add" />
					<c:param name="fdModelName" value="${param.fdModelName}" />
					<c:param name="fdTemplateModel" value="${param.fdTemplateModel}" />
					<c:param name="fdKey" value="${param.fdKey}" />
				</c:url>');"--%>
	<kmss:auth
	requestURL="/sys/xform/base/sys_form_db_table/sysFormDbTable.do?method=deleteall&fdModelName=${param.fdModelName}&fdTemplateModel=${param.fdTemplateModel}&fdFormType=${param.fdFormType}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFormDbTableForm, 'deleteall');">
	</kmss:auth>
	</div>
	<c:if test="${queryPage.totalrows == 0}">
		<%@ include file="/resource/jsp/list_norecord.jsp"%>
	</c:if>
	<c:if test="${queryPage.totalrows != 0}">
		<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
		<table id="List_ViewTable">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
					<td width="40pt"><bean:message key="page.serial" /></td>
					<sunbor:column property="sysFormDbTable.fdName">
						<kmss:message key="sys-xform:sysFormDbTable.fdName" />
					</sunbor:column>
					<sunbor:column property="sysFormDbTable.fdTable">
						<kmss:message key="sys-xform:sysFormDbTable.fdTable" />
					</sunbor:column>
					<sunbor:column property="sysFormDbTable.docCreator.fdName">
						<kmss:message key="sys-xform:sysFormDbTable.docCreator" />
					</sunbor:column>
					<sunbor:column property="sysFormDbTable.docCreateTime">
						<kmss:message key="sys-xform:sysFormDbTable.docCreateTime" />
					</sunbor:column>
				</sunbor:columnHead>
			</tr>
			<c:forEach items="${queryPage.list}" var="sysFormDbTable" varStatus="vstatus">
				<tr kmss_href="<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do" />?method=view&fdId=${sysFormDbTable.fdId}&fdKey=${sysFormDbTable.fdKey}&fdModelName=${sysFormDbTable.fdModelName}&fdFormType=${sysFormDbTable.fdFormType}&fdTemplateModel=${sysFormDbTable.fdTemplateModel}&fdFormId=${sysFormDbTable.fdFormId}&fdModelId=${sysFormDbTable.fdModelId}">
					<td><input type="checkbox" name="List_Selected" value="${sysFormDbTable.fdId}"></td>
					<td>${vstatus.index + 1}</td>
					<td>
						<c:out value="${sysFormDbTable.fdName}" />
					</td>
					<td>
						<c:out value="${sysFormDbTable.fdTable}" />
					</td>
					<td>
						<c:out value="${sysFormDbTable.docCreator.fdName}" />
					</td>
					<td>
						<kmss:showDate value="${sysFormDbTable.docCreateTime}" type="datetime"/>
					</td>
				</tr>
			</c:forEach>
		</table>
		<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>