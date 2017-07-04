<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="com.sunbor.web.tag.Page" %>
 
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<script type="text/javascript">
 
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
</head>
<body>
<br style="font-size:5px"> 
<center>
<table width=100% cellspacing=0 border=0 cellpadding=0>
	<% if(request.getParameter("s_path")!=null){ %>
	<%--
	<tr>
		<td><span class=txtlistpath><bean:message key="page.curPath"/><%= request.getParameter("s_path") %></span></td>
	</tr>
	--%>
	<% } %>
	<tr>
		<td>
