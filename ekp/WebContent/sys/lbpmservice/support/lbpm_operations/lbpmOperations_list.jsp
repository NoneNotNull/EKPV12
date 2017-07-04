<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.lbpmOperationsForm, 'deleteall');">
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="lbpmOperations.fdOperName">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperName"/>
				</sunbor:column>
				<sunbor:column property="lbpmOperations.fdOperType">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperType"/>
				</sunbor:column>
				<sunbor:column property="lbpmOperations.fdOrder">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="lbpmOperations.fdOperator.fdName">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperations.fdOperator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="lbpmOperations" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/lbpmservice/support/lbpm_operations/lbpmOperations.do" />?method=view&fdId=${lbpmOperations.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${lbpmOperations.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${lbpmOperations.fdOperName}" />
				</td>
				<td>
					<c:out value="${lbpmOperations.fdOperType}" />
				</td>
				<td>
					<c:out value="${lbpmOperations.fdOrder}" />
				</td>
				<td>
					<c:out value="${lbpmOperations.fdOperator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>