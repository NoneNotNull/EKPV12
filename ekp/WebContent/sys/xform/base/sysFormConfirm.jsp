<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<title><bean:message bundle='sys-xform' key='sysFormTemplate.confirm.title'/></title>
<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<script type="text/javascript">
var retValue = {submit:false, isNew:false};
window.onbeforeunload = function() {
	window.returnValue = retValue;
}
function CancelSubmit() {
	retValue = {submit:false, isNew:false};
	window.close();
}
function NewSubmit() {
	retValue = {submit:true, isNew:true};
	window.close();
}
function OldSubmit() {
	retValue = {submit:true, isNew:false};
	window.close();
}
window.onload = function() {
	parent.document.title = document.title;
}
</script>
</head>
<body>
<center>

<table class="tb_normal" width=95% style="margin-top: 20px;">
<tr><td>
<bean:message bundle='sys-xform' key='sysFormTemplate.confirm.saveAsANewEdition'/>
</td></tr>
</table>
<div style="margin-top: 10px;">
<input type="button" class="btnopt" onclick="NewSubmit()" value="<bean:message bundle='sys-xform' key='sysFormTemplate.confirm.button.new'/>">&nbsp;
<input type="button" class="btnopt" onclick="OldSubmit()" value="<bean:message bundle='sys-xform' key='sysFormTemplate.confirm.button.old'/>">&nbsp;
<input type="button" class="btnopt" onclick="CancelSubmit()" value="<bean:message bundle='sys-xform' key='sysFormTemplate.confirm.button.cancel'/>">
</div>

</center>
</body>
</html>