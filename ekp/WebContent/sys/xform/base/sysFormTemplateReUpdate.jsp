<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
body{
	margin:0px auto;
	text-align:center;
}
.con_div{
	position:absolute;
	top:50px;
	left:50%;
	margin:0 0 0 -200px;
	width:400px;
	height:100px;
}
.hit {
	text-align: left;
	line-height: 20px;
	color: red;
	width: 400px;
	margin-left: 50px;
}
</style>
<kmss:windowTitle
	subjectKey="sys-xform:sysFormTemplate.reUpdate.title"
	moduleKey="sys-xform:sysFormTemplate.config" />
	
<div class="con_div">
	<div>
	<p class="txttitle">
		<kmss:message key="sys-xform:sysFormTemplate.reUpdate.text" />
	</p>
	
	<p class="hit">
	<kmss:message key="sys-xform:sysFormTemplate.reUpdate.hit" />
	</p>
	
	<input class="btnopt" type=button 
		value="<kmss:message key="sys-xform:sysFormTemplate.reUpdate.btn" />" 
		onclick="DoUpdate(this);">
	</div>
</div>
	

<script>
function DoUpdate(btn) {
	if (confirm("<kmss:message key="sys-xform:sysFormTemplate.reUpdate.alert" />")) {
		btn.disabled = true;
		Com_OpenWindow('<c:url value="/sys/xform/sys_form_template/sysFormTemplate.do?method=reWriteAllTempates"/>', '_self');
	}
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>