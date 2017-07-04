<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.context.ApplicationContext,
		org.springframework.web.context.support.WebApplicationContextUtils,
		com.landray.kmss.util.StringUtil,
		com.landray.kmss.common.service.IBaseService,
		com.landray.kmss.common.model.IBaseModel,
		com.landray.kmss.sys.lbpm.engine.service.ProcessExecuteService,
		com.landray.kmss.sys.lbpm.engine.service.ProcessInstanceInfo,
		com.landray.kmss.sys.lbpm.engine.persistence.model.LbpmProcess,
		com.landray.kmss.sys.lbpmservice.support.service.spring.InternalLbpmProcessForm,
		com.landray.kmss.sys.lbpmservice.interfaces.LbpmProcessForm" 
%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/view.jsp">
	<template:replace name="header">
		<script type="text/javascript" src="${KMSS_Parameter_ResPath}/js/common.js"></script>
		<script type="text/javascript">	
			Com_IncludeFile("jquery.js|docutil.js");
		</script>
		<header class="lui-header">
			<ul class="clearfloat">
				<li style="float: left;padding-left: 10px;">
					<a id="column_button" data-lui-role="button">
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon',
							onclick : "setTimeout(function(){history.go(-1)},0)"
						}
						</script>		
					</a>
				</li>
				<li class="lui-docSubject">
					<h2 class="textEllipsis">流程图</h2>
				</li>
			</ul>
		</header>
	</template:replace>
	<template:replace name="docContent">
		<%
			try{
				String processId = request.getParameter("processId");
				if(StringUtil.isNotNull(processId)){
					ApplicationContext ctx = WebApplicationContextUtils
							.getRequiredWebApplicationContext(request.getSession()
							.getServletContext());
					ProcessExecuteService processExecuteService = (ProcessExecuteService)ctx.getBean("lbpmProcessExecuteService");
					ProcessInstanceInfo processInstanceInfo = processExecuteService.load(processId);
					if(processInstanceInfo==null){
						out.println("没有找到对应的流程实例："+processId);
						return;
					}
					LbpmProcess lbpmProcess=(LbpmProcess)processInstanceInfo.getProcessInstance();
					InternalLbpmProcessForm internalForm = new InternalLbpmProcessForm(
							processInstanceInfo);
					request.setAttribute("sysWfBusinessForm", internalForm);
					request.setAttribute("lbpmProcess",lbpmProcess);
		%>
			<input type="hidden" id="sysWfBusinessForm.fdFlowContent" name="sysWfBusinessForm.fdFlowContent" value='<c:out value="${sysWfBusinessForm.fdFlowContent}" />' >
			<input type="hidden" id="sysWfBusinessForm.fdTranProcessXML" name="sysWfBusinessForm.fdTranProcessXML" value='<c:out value="${sysWfBusinessForm.fdTranProcessXML}" />' >
			<table class="tb_noborder" width="99%">
				<tr>
					<td id="workflowInfoTD" valign="top">
							<iframe scrolling="no" width="100%" id="WF_IFrame"></iframe>
					</td>
				</tr>
			</table>
			<script type="text/javascript">
				$(document).ready(function(){
					Doc_LoadFrame('workflowInfoTD', '<c:url value="/sys/lbpm/flowchart/page/panel.html">'
							+'<c:param name="edit" value="false" />'
							+'<c:param name="extend" value="oa" />'
							+'<c:param name="template" value="false" />'
							+'<c:param name="contentField" value="sysWfBusinessForm.fdFlowContent" />'
							+'<c:param name="statusField" value="sysWfBusinessForm.fdTranProcessXML" />'
							+'<c:param name="modelName" value="${lbpmProcess.fdModelName}" />'
							+'<c:param name="modelId" value="${lbpmProcess.fdModelId}" />'
							+'<c:param name="hasParentProcess" value="${sysWfBusinessForm.hasParentProcess}" />'
							+'<c:param name="hasSubProcesses" value="${sysWfBusinessForm.hasSubProcesses}" />'
						+'</c:url>');
				});
			</script>
		<%
				}else{
					out.println("没有找到对应的文档："+processId);
					return;
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		%>
	</template:replace>
</template:include>