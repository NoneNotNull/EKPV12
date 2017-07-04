<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js" 
	data-config="${LUI_ContextPath}/resource/js/seaconfig.jsp#">
</script>
<script type="text/javascript">
seajs.use(['sys/ui/js/parser','lui/jquery'], function(parser,$) {
	$(document).ready(function(){
	 	parser.parse();
	});
});
</script>
</head>
<body>
<ui:panel>
	<ui:layout ref="sys.ui.panel.height" var-toggle="true"></ui:layout>
	<ui:content title="单标签">
		<ui:dataview format="sys.ui.classic">
			<ui:source type="AjaxXml">
				{"url":"/sys/common/dataxml.jsp?s_bean=sysNewsMainPortletService&cateid=&rowsize=8"}
			</ui:source>
		</ui:dataview>
	</ui:content>
</ui:panel>
<ui:panel>
	<ui:layout ref="sys.ui.panel.shallow" var-toggle="false"></ui:layout>
	<ui:content title="单标签2">
		<ui:dataview format="sys.ui.classic">
			<ui:source type="AjaxXml">
				{"url":"/sys/common/dataxml.jsp?s_bean=sysNewsMainPortletService&cateid=&rowsize=8"}
			</ui:source>
		</ui:dataview>
	</ui:content>
</ui:panel>
</body>
</html>