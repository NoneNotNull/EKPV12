<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/task/sys_task_overrule/sysTaskOverrule.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=deleteall" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskOverruleForm, 'deleteall');">
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
				<sunbor:column property="sysTaskOverrule.sysTaskMain.docSubject">
					<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
				</sunbor:column>
				<td width="450pt">
					<bean:message  bundle="sys-task" key="sysTaskOverrule.fdReason"/>
				</td>
				<sunbor:column property="sysTaskOverrule.docCreator.fdName">
					<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreator"/>
				</sunbor:column>
				<sunbor:column property="sysTaskOverrule.docCreateTime">
					<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTaskOverrule" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/task/sys_task_overrule/sysTaskOverrule.do" />?method=view&fdId=${sysTaskOverrule.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTaskOverrule.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTaskOverrule.sysTaskMain.docSubject}" />
				</td>
				<td>
					<c:out value="${sysTaskOverrule.fdReason}" />
				</td>
				<td>
					<c:out value="${sysTaskOverrule.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTaskOverrule.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>