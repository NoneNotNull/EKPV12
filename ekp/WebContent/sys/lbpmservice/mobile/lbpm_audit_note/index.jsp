<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	com.landray.kmss.sys.lbpmservice.support.service.spring.LbpmAuditNoteLoader auditNoteLoader = (com.landray.kmss.sys.lbpmservice.support.service.spring.LbpmAuditNoteLoader) com.landray.kmss.util.SpringBeanUtil
			.getBean("lbpmAuditNoteLoader");

	pageContext.setAttribute("auditNotes",
			auditNoteLoader.notes4mobile(auditNoteLoader
					.notesFilter(auditNoteLoader
							.listNote(new RequestContext(
									request))), new RequestContext(request)));
%>
<script>
	var LbpmAuditNoteList = ${auditNotes};
</script>
<c:if test="${not empty auditNotes}">
	<c:forEach items="${auditNotes}" var="auditNote" varStatus="vstatus">
		<%
			JSONObject auditNote = (JSONObject) pageContext
							.getAttribute("auditNote");
		%>
		<c:if test="${auditNote.fdActionKey=='_concurrent_branch' }">
			<%
				if (auditNote.getBoolean("firstBlank")) {
			%>
			<div
				data-dojo-type="${LUI_ContextPath}/sys/lbpmservice/mobile/lbpm_audit_note/js/LbpmserviceAuditLabelItem.js"
				data-dojo-props="fdFactNodeName:'启动分支节点',toggle:true,fdExecutionId:'${auditNote.fdParentExecutionId }'"></div>
			<%
				}
			%>
			<div
				data-dojo-type="${LUI_ContextPath}/sys/lbpmservice/mobile/lbpm_audit_note/js/LbpmserviceAuditBranchItem.js"
				data-dojo-props="store:LbpmAuditNoteList['${vstatus.index }']"></div>
		</c:if>
		<c:if test="${auditNote.fdActionKey!='_concurrent_branch' }">
			<%
				if (auditNote.getBoolean("firstNode")) {
			%>
				<div
					data-dojo-type="${LUI_ContextPath}/sys/lbpmservice/mobile/lbpm_audit_note/js/LbpmserviceAuditLabelItem.js"
					data-dojo-props="store:LbpmAuditNoteList['${vstatus.index }']">
				</div>
			<%
				}
			%>
			<div
				data-dojo-type="${LUI_ContextPath}/sys/lbpmservice/mobile/lbpm_audit_note/js/LbpmserviceAuditNodeItem.js"
				data-dojo-props="store:LbpmAuditNoteList['${vstatus.index }']">
				<c:forEach items="${auditNote.auditNoteListsJsps4Mobile}"
					var="auditNoteListsJsp" varStatus="vstatus">
					<c:import url="${auditNoteListsJsp}" charEncoding="UTF-8">
						<c:param name="auditNoteFdId" value="${auditNote.fdId}" />
						<c:param name="modelName"
							value="${auditNote.fdProcess.fdModelName}" />
						<c:param name="modelId" value="${auditNote.fdProcess.fdModelId}" />
						<c:param name="formName" value="${formBeanName}" />
					</c:import>
				</c:forEach>

				<c:import url="/sys/attachment/mobile/import/view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="${ formBeanName}"></c:param>
					<c:param name="fdKey" value="${auditNote.fdId}"></c:param>
					<c:param name="fdViewType" value="simple"></c:param>
				</c:import>
			</div>
		</c:if>
	</c:forEach>
</c:if>