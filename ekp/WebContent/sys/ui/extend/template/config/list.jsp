<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list']);	
</script>
<script type="text/javascript">
Com_IncludeFile("list.js");
function List_CheckSelect(checkName){
	if(checkName==null)
		checkName = List_TBInfo[0].checkName;
	var obj = document.getElementsByName("List_Selected");
	for(var i=0; i<obj.length; i++)
		if(obj[i].checked)
			return true;
	alert("<bean:message key="page.noSelect"/>");
	return false;
}
function List_ConfirmDel(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key="page.comfirmDelete"/>");
}
</script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
	<template:block name="toolbar" />
	<template:block name="path" >
		<% if(request.getParameter("s_path")!=null){ %>
		 <span class=txtlistpath><bean:message key="page.curPath"/>${fn:escapeXml(param.s_path)}</span>
		<% } %>
	</template:block>
	<template:block name="content" /> 
</body>
</html>
