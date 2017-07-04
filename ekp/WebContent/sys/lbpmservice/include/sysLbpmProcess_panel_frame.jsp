<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!doctype html>
<html>
	<head>
		<meta http-equiv="x-ua-compatible" content="IE=5"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><bean:message key="lbpmProcess.extendRoleOptWindow.title" bundle="sys-lbpmservice"/></title>
	</head>
	<frameset framespacing=1 bordercolor=#003048 frameborder=1 rows="*">
		<frame frameborder="0" noresize scrolling="yes" id="topFrame"
			src="<c:url value="/sys/lbpmservice/include/sysLbpmProcess_panel.jsp" />?formName=${param.formName}&roleType=${param.roleType}&operationType=${param.operationType}&docStatus=${param.docStatus}&notifyType=${param.notifyType}&modelClassName=${param.modelName}">
	</frameset>
</html>
