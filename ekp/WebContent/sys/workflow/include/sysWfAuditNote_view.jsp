<%@ include file="/resource/jsp/common.jsp"%>
<%
	new com.landray.kmss.sys.workflow.base.actions.SysWfApprovalTypeAction()
			.listAuditNote(request, response);
%>
<c:import
	url="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote_view.jsp"
	charEncoding="UTF-8" />
