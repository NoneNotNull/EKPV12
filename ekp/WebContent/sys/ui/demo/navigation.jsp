<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/navigation.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld"
	prefix="template"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%
	String LUI_ContextPath = request.getContextPath();
	request.setAttribute("LUI_ContextPath", LUI_ContextPath);
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/ekp/resource/js/sea.js"
	data-config="/ekp/resource/js/seaconfig.jsp#"></script>
<script type="text/javascript">
	seajs.use([ 'sys/ui/js/parser', 'lui/jquery', 'sys/ui/js/popup/popup','theme!icon' ],
			function(parser, $) {
				window.$ = $;
				$(document).ready(function() {
					parser.parse();
				});
			});
</script>
<title>ss</title>
</head>
<body style="margin: 0px; padding: 0px;">
<br>
<br>
<ui:navigation > 
	<ui:nav-link text="sss" href="#" icon="lui_icon_s_add" target="_blank"></ui:nav-link>
	<ui:nav-popup text="sadfsd" href="#" icon="lui_icon_s_add" target="_blank">
		asdf
		<span>aaa</span>
	</ui:nav-popup> 
	<ui:nav-item href="asd.jsp?id=!{value}&text=!{text}" icon="lui_icon_s_add" target="_blank">
		 <ui:source ref="sys.ui.navigation.test"></ui:source>
	</ui:nav-item>
</ui:navigation>
</body>
</html>
