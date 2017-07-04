<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<script>
			function returnMessge(id, name, type){
				returnValue = {text:name, value:id, nodeType:type};
				window.close();
			}
		</script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Pragma" content="No-Cache">
	</head>
	<frameset frameborder=0 border=0>
  		<frame src="sysOrgRoleLine.do?${param.query}">
	</frameset>
</html>