<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% 	
	String jsname = "v_"+IDGenerator.generateID();
	request.setAttribute("jsname",jsname);
	request.setAttribute("vars", JSONArray.fromObject(request.getParameter("vars")));
%>
<script>
var VariableGetter = [];
function getConfigValues(){ 
	return ${jsname}.getValue();
}
function varDebug(){
	if(window.console)
		console.info(getConfigValues());
}
</script>
<script src="${ LUI_ContextPath }/sys/ui/js/var.js"></script>
<c:import url="/sys/ui/jsp/vars/variable.jsp">
	<c:param name="jsname" value="${ jsname }"></c:param>
</c:import>