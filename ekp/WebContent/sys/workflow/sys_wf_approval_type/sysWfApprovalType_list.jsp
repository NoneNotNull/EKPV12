<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
<!--
Com_Parameter.IsAutoTransferPara = true;
//-->
</script>
<html:form action="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do?fdModelName=${param.fdModelName }&fdKey=${param.fdKey }">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do" />?method=add&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysWfApprovalTypeForm, 'deleteall');">
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
				<sunbor:column property="sysWfApprovalType.fdOrder">
					<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysWfApprovalType.fdName">
					<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysWfApprovalType" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do" />?method=view&fdId=${sysWfApprovalType.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysWfApprovalType.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td width="30%">
					<c:out value="${sysWfApprovalType.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysWfApprovalType.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>