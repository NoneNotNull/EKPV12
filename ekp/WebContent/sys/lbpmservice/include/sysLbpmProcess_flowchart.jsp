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
<%@ include file="/resource/jsp/htmlhead.jsp" %>
	<style>
		body{margin:0px;padding:0px;}
	</style>
	<script type="text/javascript">
		Com_IncludeFile("jquery.js|docutil.js");
	</script>
</head>
<body>
<%
	try{
		String processId = request.getParameter("processId");
		if(StringUtil.isNull(processId)){
			processId = (String)request.getAttribute("processId");
		}
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
	<table class="tb_noborder" width=99% style="margin: 0px;border-collapse: collapse;padding: 0px;border: 0px;">
		<tr>
			<td id="workflowInfoTD" valign="top" style="padding: 0px;border: 0px;">
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
</body>
</html>