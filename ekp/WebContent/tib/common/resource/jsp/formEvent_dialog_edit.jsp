<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<style type="text/css">
body{margin:0px}
</style>
<script type="text/javascript">
Com_IncludeFile("data.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
var message_unknowfunc = "<bean:message bundle="sys-formula" key="validate.unknowfunc"/>";
var message_unknowvar = "<bean:message bundle="sys-formula" key="validate.unknowvar"/>";
var message_wait = "<bean:message bundle="sys-formula" key="validate.wait"/>";
var message_eval_error = "<bean:message bundle="sys-formula" key="validate.failure.evalError"/>";
</script>
<script src="<c:url value="/sys/formula/formula_edit.js"/>"></script>
</head>
<body>
<table cellpadding=0 cellspacing=0 style="height:100%; border-collapse:collapse;border: 0px #303030 solid;">
	<tr>
		<td valign="top" style="border:#303030 solid; border-width:0px 1px 0px 0px; border-collapse:collapse;">
			<iframe width=200 height=100% frameborder=0 scrolling=auto src='formEvent_dialog_tree.jsp'></iframe>
		</td>
		<td width="10px">&nbsp;</td>
		<td valign="baseline" width="80%">
		<br>
		<div class="txttitle"><bean:message bundle="sys-formula" key="formula.title"/></div><br>
<table class="tb_normal" width="100%">
	<tr>
		<td>
			<textarea id="expression" name="expression" style="width:100%;height:160px;"></textarea>
		</td>
	</tr>
    <tr>
		<td align=center>
			<br>
        		<input type=button value="<bean:message key="button.ok"/>" onclick="validateFormula(writeBack);">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button value="<bean:message bundle="sys-formula" key="button.clear"/>" 
					onclick="clearExp();">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="<bean:message key="button.cancel"/>" onClick="window.close();">&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>		
		</td>
	</tr>
</table>
</body>
</html>
