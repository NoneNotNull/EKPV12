<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.treeTable.css","${KMSS_Parameter_ContextPath}sys/lbpmservice/resource/","css",true);
Com_IncludeFile("jquery.js");
Com_IncludeFile("jquery.treeTable.js","${KMSS_Parameter_ContextPath}sys/lbpmservice/resource/","js",true);
function initialPage(){
	try {
		var arguObj = document.getElementById("auditNoteTable");
		if(arguObj != null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			var height = arguObj.offsetHeight + 0;
			if(height>0)
				window.frameElement.style.height = height + "px";
		}
		setTimeout(initialPage, 200);
	} catch(e) {
	}
}
Com_AddEventListener(window,'load',function() {
	$("#auditNoteTable").treeTable({
		initialState:"expanded",
		treeColumn:1
	});
	initialPage();
	setTimeout(initialPage, 600); // 可能加载附件比较慢，再次调整
});
</script>
</head>
<body>
<c:set var="mainForm" value="${requestScope[formBeanName]}" scope="page" />
<c:if test="${empty mainForm}">
<c:set var="mainForm" value="${sessionScope[formBeanName]}" scope="request" />
</c:if>
<style>
.tb_normal .td_normal_title {
	text-align: center;
}
</style>
<html:form action="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote.do">
	<table class="tb_normal" width="100%" id="auditNoteTable" >
		<tr class="tr_normal">
			<td width="12%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.date" />
			</td>
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdFactNodeName" />
			</td>
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdHandlerId" />
			</td>
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdActionKey" />
			</td>
			<td width="43%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdAuditNote" />
			</td>
			<%--  <c:if test="${requestScope['isPrivileger'] == true }">
			<td width="20%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdActionInfo" />
			</td>
			</c:if>--%>
		</tr>
		<c:forEach items="${auditNotes}" var="lbpmAuditNote" varStatus="vStatus">
			<tr 
				<c:if test="${lbpmAuditNote.fdActionKey == '_concurrent_branch'}">
					id="${lbpmAuditNote.fdExecutionId}"
					<c:if test="${empty rootExecutionId}">
						<c:set var="rootExecutionId" value="${lbpmAuditNote.fdParentExecutionId}" />
					</c:if>
					<c:if test="${lbpmAuditNote.fdParentExecutionId != rootExecutionId}">
						class="child-of-${lbpmAuditNote.fdParentExecutionId}"
					</c:if>
				</c:if>
				<c:if test="${lbpmAuditNote.fdActionKey != '_concurrent_branch'}">
					id="${lbpmAuditNote.fdId}"
					<c:if test="${not empty lbpmAuditNote.fdParentExecutionId}">
						class="child-of-${lbpmAuditNote.fdExecutionId}"
					</c:if>
				</c:if>
				>
				<td style="white-space: nowrap;word-break: keep-all;">
					<kmss:showDate type="datetime" value="${lbpmAuditNote.fdCreateTime}"/>
				</td>
				<td style="padding-left:14px;">
					<c:out value="${lbpmAuditNote.fdFactNodeName}" />
				</td>
				<td>
					<span title='<c:out value="${lbpmAuditNote.detailHandlerName}" />'>
						<c:out value="${lbpmAuditNote.handlerName}" />
					</span>
				</td>
				<td style="word-wrap: break-word;word-break: break-all;">
					<c:out value="${lbpmAuditNote.fdActionInfo}" />
				</td>
				<td>
					<c:if test="${lbpmAuditNote.fdIsHide=='2'}">
						<table class="tb_noborder" width="100%">
							<tr>
								<td style="word-wrap: break-word;word-break: break-all;">
								<kmss:showText value="${lbpmAuditNote.fdAuditNote}" />
								</td>
							</tr>
							<tr>
								<td>
							<c:forEach items="${lbpmAuditNote.auditNoteListsJsps4Pc}" var="auditNoteListsJsp" varStatus="vstatus">
								<c:import url="${auditNoteListsJsp}" charEncoding="UTF-8">
									<c:param name="auditNoteFdId" value="${lbpmAuditNote.fdId}" />
									<c:param name="modelName" value="${lbpmAuditNote.fdProcess.fdModelName}" />
									<c:param name="modelId" value="${lbpmAuditNote.fdProcess.fdModelId}" />
									<c:param name="formName" value="${formBeanName}"/>
								</c:import>
							</c:forEach>
								</td>
							</tr>
							<c:if test="${not empty mainForm.attachmentForms[lbpmAuditNote.fdId] and not empty mainForm.attachmentForms[lbpmAuditNote.fdId].attachments}">
							<tr>
								<td>
										<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						          <c:param name="formBeanName" value="${formBeanName}"/>
						          <c:param name="fdKey" value="${lbpmAuditNote.fdId}"/>
						          <c:param name="fdModelId" value="${lbpmAuditNote.fdProcess.fdModelId}"/>
						          <c:param name="fdModelName" value="${lbpmAuditNote.fdProcess.fdModelName}"/>
						          <c:param name="fdViewType" value="simple" />
						           <c:param name="fdForceDisabledOpt" value="edit" />
						        </c:import>
								</td>
							</tr>
							</c:if>
							<c:if test="${not empty lbpmAuditNote.auditNoteFrom}">
							<tr>
								<td align="right">
									<kmss:showText value="${lbpmAuditNote.auditNoteFrom}" />
								</td>
							</tr>
							</c:if>
						</table>
					</c:if>
					<c:if test="${lbpmAuditNote.fdIsHide=='1'}" >
						<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_1" /></font>
					</c:if>
					<c:if test="${lbpmAuditNote.fdIsHide=='3'}" >
						<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_3" /></font>
					</c:if>
				</td>
			<%--<c:if test="${requestScope['isPrivileger'] == true }">
				<td>
					<c:out value="${lbpmAuditNote.fdActionName}" />
				</td>
			</c:if>--%>
			</tr>
		</c:forEach>
	</table>
</html:form>
</body>
</html>