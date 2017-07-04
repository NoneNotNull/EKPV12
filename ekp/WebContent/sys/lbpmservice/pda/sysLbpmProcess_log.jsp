<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="fdModelId" value="${requestScope[param.formName].fdId}" scope="request"/>
<%
com.landray.kmss.sys.lbpmservice.support.service.spring.LbpmAuditNoteLoader auditNoteLoader = 
	(com.landray.kmss.sys.lbpmservice.support.service.spring.LbpmAuditNoteLoader) 
		com.landray.kmss.util.SpringBeanUtil.getBean("lbpmAuditNoteLoader");
pageContext.setAttribute("auditNotes", 
		auditNoteLoader.listNote(new com.landray.kmss.common.actions.RequestContext(request)));
%>
<c:if test="${not empty auditNotes}">
<table class="docView" style="width:100%;">
<c:forEach items="${auditNotes}" var="auditNote" varStatus="vstatus">
	<tr>
		<td class="td_common">
			<p>
				<label style="color:#337498;">${auditNote.handlerName}</label>&nbsp;&nbsp;&nbsp;&nbsp;
				<label class="list_summary"><bean:write name="auditNote" property="fdCreateTime" format="M-dd HH:mm" /></label>
			</p>
			<p style="margin-top: 3px;margin-bottom: 3px;">
				<c:if test="${ auditNote.fdIsHide=='2'}">
					<c:if test="${not empty auditNote.fdAuditNote}">
						<label style="font-size: 16px;font-weight: bolder;"><kmss:showText value="${auditNote.fdAuditNote}"/></label>
						<br/>
					</c:if>
					<c:forEach items="${auditNote.auditNoteListsJsps4Pda}" var="auditNoteListsJsp" varStatus="vstatus">
						<c:import url="${auditNoteListsJsp}" charEncoding="UTF-8">
							<c:param name="auditNoteFdId" value="${auditNote.fdId}" />
							<c:param name="modelName" value="${auditNote.fdProcess.fdModelName}" />
							<c:param name="modelId" value="${auditNote.fdProcess.fdModelId}" />
							<c:param name="formName" value="${param.formName}"/>
						</c:import>
					</c:forEach>
					<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="${auditNote.fdId}" />
						<c:param name="formBeanName" value="${param.formName}"/>
					</c:import>
				</c:if>
				<c:if test="${auditNote.fdIsHide=='1'}" >
					<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_1" /></font>
				</c:if>
				<c:if test="${auditNote.fdIsHide=='3'}" >
					<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_3" /></font>
				</c:if>
			</p>
			<p>
				<label class="list_summary"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdActionKey" />: ${auditNote.fdActionInfo}&nbsp;&nbsp;&nbsp;&nbsp;
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdFactNodeName" />: ${auditNote.fdFactNodeName}
				</label>
			</p>
		</td>
	</tr>
</c:forEach>
</table>
</c:if>
