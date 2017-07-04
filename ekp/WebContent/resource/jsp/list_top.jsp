<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="com.sunbor.web.tag.Page" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<% response.addHeader("X-UA-Compatible", "IE=edge"); %>
<link href="${KMSS_Parameter_ResPath}style/common/list/list.css?s_cache=${LUI_Cache}" rel="stylesheet" type="text/css" />
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__dataInitlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
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
<div class="listtable_box">
<table width="98%" cellspacing="0" border="0" cellpadding="0" align="center">
	<% if(request.getParameter("s_path")!=null){ %>
	<tr>
		<td><span class=txtlistpath><bean:message key="page.curPath"/>${fn:escapeXml(param.s_path)}</span></td>
	</tr>
	<% } %>
	<tr>
		<td height="100%" valign="top">