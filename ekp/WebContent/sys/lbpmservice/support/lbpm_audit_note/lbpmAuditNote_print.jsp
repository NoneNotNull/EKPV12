<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<table class="tb_normal" width="100%">
		<tr class="tr_normal">
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.date" />
			</td>
			<td width="10%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdFactNodeName" />
			</td>
			<td width="10%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdHandlerId" />
			</td>
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdActionKey" />
			</td>
			<td width="30%" class="td_normal_title">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.list.fdAuditNote" />
			</td>
		</tr>
		<c:forEach items="${auditNotes}" var="lbpmAuditNote" varStatus="vStatus">
			<tr>
				<td>
					<kmss:showDate type="datetime" value="${lbpmAuditNote.fdCreateTime}"/>
				</td>
				<td>
					<c:out value="${lbpmAuditNote.fdFactNodeName}" />
				</td>
				<td>
					<c:out value="${lbpmAuditNote.handlerName}" />
				</td>
				<td style="word-wrap: break-word;word-break: break-all;">
					<c:out value="${lbpmAuditNote.fdActionInfo}" />
				</td>
				<td>
					<c:if test="${lbpmAuditNote.fdIsHide=='2'}" >
					<table class="tb_noborder" width="100%">
						<tr>
							<td style="word-wrap: break-word;word-break: break-all;" style="border: none;">
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
									<c:param name="formName" value="${param.formName}"/>
								</c:import>
							</c:forEach>
						 </td>
						</tr>
						<tr>
								<td>
								    <c:set var="mainForm" value="${requestScope[param.formName]}" scope="page" />
									<c:set var="_workitemId_handlerId_key" value="${lbpmAuditNote.fdWorkitemId}_${lbpmAuditNote.fdHandler.fdId}" />
									<c:if test="${not empty mainForm.attachmentForms[_workitemId_handlerId_key] and not empty mainForm.attachmentForms[_workitemId_handlerId_key].attachments}">
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							          <c:param name="formBeanName" value="${formBeanName}"/>
							          <c:param name="fdKey" value="${lbpmAuditNote.fdWorkitemId}_${lbpmAuditNote.fdHandler.fdId}"/>
							          <c:param name="fdModelId" value="${lbpmAuditNote.fdProcess.fdModelId}"/>
							          <c:param name="fdModelName" value="${lbpmAuditNote.fdProcess.fdModelName}"/>
							          <c:param name="fdViewType" value="simple" />
							        </c:import>
							        </c:if>
							        <c:if test="${not empty mainForm.attachmentForms[lbpmAuditNote.fdId] and not empty mainForm.attachmentForms[lbpmAuditNote.fdId].attachments}">
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							          <c:param name="formBeanName" value="${formBeanName}"/>
							          <c:param name="fdKey" value="${lbpmAuditNote.fdId}"/>
							          <c:param name="fdModelId" value="${lbpmAuditNote.fdProcess.fdModelId}"/>
							          <c:param name="fdModelName" value="${lbpmAuditNote.fdProcess.fdModelName}"/>
							          <c:param name="fdViewType" value="simple" />
							        </c:import>
							        </c:if>
								</td>
							</tr>
					</table>
					</c:if>
					<c:if test="${lbpmAuditNote.fdIsHide=='1'}" >
						<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_1" /></font>
					</c:if>
					<c:if test="${lbpmAuditNote.fdIsHide=='3'}" >
						<font style="font-style:italic"><bean:message bundle="sys-lbpmservice-support" key="lbpmAuditNote.fdIsHide_3" /></font>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>