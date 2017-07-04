<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js");
</script>
<title>${mainModel.docSubject}(${mainModel.docCreator.fdName})</title>
<style>
h1 {
	font-family : Arial, "宋体";
	font-size : 16px;
	text-align: center;
	padding: 0;
	margin: 5px;
}
</style>
</head>
<body>
<input type="hidden" name="sysWfBusinessForm.fdFlowContent" value='<c:out value="${lbpmProcessMainForm.sysWfBusinessForm.fdFlowContent}" />' >
<input type="hidden" name="sysWfBusinessForm.fdTranProcessXML" value='<c:out value="${lbpmProcessMainForm.sysWfBusinessForm.fdTranProcessXML}" />' >
<h1><a href="${mainModelUrl}">${mainModel.docSubject}(${mainModel.docCreator.fdName})</a></h1>
<iframe width="100%" height="100%" scrolling="no" 
	src="<c:url value="/sys/lbpm/flowchart/page/panel.html">
								<c:param name="edit" value="false" />
								<c:param name="extend" value="oa" />
								<c:param name="template" value="false" />
								<c:param name="contentField" value="sysWfBusinessForm.fdFlowContent" />
								<c:param name="statusField" value="sysWfBusinessForm.fdTranProcessXML" />
								<c:param name="modelName" value="${lbpmProcessMainForm.sysWfBusinessForm.fdModelName}" />
								<c:param name="modelId" value="${lbpmProcessMainForm.sysWfBusinessForm.fdModelId}" />
								<c:param name="hasParentProcess" value="${lbpmProcessMainForm.sysWfBusinessForm.internalForm.hasParentProcess}" />
								<c:param name="hasSubProcesses" value="${lbpmProcessMainForm.sysWfBusinessForm.internalForm.hasSubProcesses}" />
							</c:url>" ></iframe>

</body>
</html>