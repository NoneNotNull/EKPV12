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
<input type="radio" name="mouldChoose"  value="NewSubmit" ${param.isDefualtNew?"checked=true":""}><bean:message bundle='sys-xform' key='sysFormTemplate.confirm.button.new'/></input>
<input type="radio" name="mouldChoose"  value="OldSubmit" ${param.isDefualtNew?"":"checked=true"}><bean:message bundle='sys-xform' key='sysFormTemplate.confirm.button.old'/></input>
<br/><br/>
<input type="button" class="btnopt" style="width:70px;" onclick="document.getElementsByName('mouldChoose')[0].checked?NewSubmit():OldSubmit();" value="<bean:message key='button.save'/>"></input>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="btnopt" style="width:70px;" onclick="CancelSubmit()" value="<bean:message  key='button.cancel'/>">
</div>

</center>
</body>
</html>