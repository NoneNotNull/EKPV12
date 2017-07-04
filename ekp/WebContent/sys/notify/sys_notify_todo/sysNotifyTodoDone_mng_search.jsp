<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.notify.actions.SysNotifyTodoAction"%>
 <%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("calendar.js|dialog.js", null, "js");
function CommitSearch(){
	var url = '<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=mngList&owner=${param.owner}&oprType=done"/>';
	//var target = "${param.s_target}";
	var target ="";
	
	var fdBeginCreateTime = document.getElementsByName("fdBeginCreateTime")[0];
	if(fdBeginCreateTime.value!="" && !isDate(fdBeginCreateTime,
			'<bean:message  bundle="sys-notify" key="sysNotifyTodo.beginTime"/>'))return;
	
	var fdEndCreateTime = document.getElementsByName("fdEndCreateTime")[0];
	if(fdEndCreateTime.value!="" && !isDate(fdEndCreateTime,
			'<bean:message  bundle="sys-notify" key="sysNotifyTodo.endTime"/>'))return;
	
	var fdBeginFinishTime = document.getElementsByName("fdBeginFinishTime")[0];
	if(fdBeginFinishTime.value!="" && !isDate(fdBeginFinishTime,
			'<bean:message  bundle="sys-notify" key="sysNotifyTodo.beginTime"/>'))return;
	
	var fdEndFinishTime = document.getElementsByName("fdEndFinishTime")[0];
	if(fdEndFinishTime.value!="" && !isDate(fdEndFinishTime,
			'<bean:message  bundle="sys-notify" key="sysNotifyTodo.endTime"/>'))return;
		
	url = setUrlParameters(url);
	if(url==null)
		return;
	var i = url.indexOf("?");
	if(url.length-url.indexOf("?")>1000)
		alert('<bean:message bundle="sys-search" key="search.conditionToLong" />');
	else{
		if(target=="")
			Com_OpenWindow(url,"_self");
		else
			Com_OpenWindow(url, target);
	}
}

function setUrlParameters(url){
	var fdSubject = document.getElementsByName("fdSubject")[0].value;
	url = Com_SetUrlParameter(url, "fdSubject",fdSubject );
	
	var fdModelName = document.getElementsByName("fdModelName")[0].value;
	url = Com_SetUrlParameter(url, "fdModelName", fdModelName);
	
	var fdType = document.getElementsByName("fdType")[0].value;
	url = Com_SetUrlParameter(url, "fdType", fdType);
	
	var fdBeginCreateTime = document.getElementsByName("fdBeginCreateTime")[0].value;
	url = Com_SetUrlParameter(url, "fdBeginCreateTime", fdBeginCreateTime);
	
	var fdEndCreateTime = document.getElementsByName("fdEndCreateTime")[0].value;
	url = Com_SetUrlParameter(url, "fdEndCreateTime", fdEndCreateTime);
	
	var fdBeginFinishTime = document.getElementsByName("fdBeginFinishTime")[0].value;
	url = Com_SetUrlParameter(url, "fdBeginFinishTime", fdBeginFinishTime);
	
	var fdEndFinishTime = document.getElementsByName("fdEndFinishTime")[0].value;
	url = Com_SetUrlParameter(url, "fdEndFinishTime", fdEndFinishTime);
	
	var s_path = "${fn:escapeXml(param.s_path)}";
	url = Com_SetUrlParameter(url, "s_path", s_path);
	return url;
}

function isDate(field, message){
	lq_DateValidations = function(){
		this.a0 = new Array(
			field.name,
			'<kmss:message key="errors.date" />'.replace("{0}", message),
			new Function ("varName",'this.datePattern="<bean:message key="date.format.date" />";  return this[varName];')
		);
	}
	return validateDate(document.forms[0]);
}

</script>
<center>
<p class="txttitle"><bean:message bundle="sys-notify" key="sysNotifyTodo.advance.search"/></p>
<form name="lq">
<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-notify" key="sysNotifySetting.fdLinkSubject"/>
			</td>
			<td>
				<input name="fdSubject" style="width:70%" class="inputSgl">
			</td>
		</tr>
		<c:if test="${empty param.fdType}">
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-notify" key="sysNotifyTodo.cate"/>
			</td>
			<td>
				<select name="fdType">
					<option value=""><bean:message  bundle="sys-notify" key="sysNotifyTodo.all"/></option>
					<option value="1"><bean:message  bundle="sys-notify" key="sysNotifyTodo.cate.audit"/></option>
					<option value="2"><bean:message  bundle="sys-notify" key="sysNotifyTodo.cate.copyto"/></option>
				</select>
				
			</td>
		</tr>
		</c:if>
		<c:if test="${not empty param.fdType}">
		<input type="hidden" name="fdType" value="${param.fdType}">
		</c:if>
		<c:if test="${empty param.fdModelName}">
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-notify" key="sysNotifyTodo.app"/>
			</td>
			<td>
					<select name="fdModelName" onchange="">
					<% new  SysNotifyTodoAction().getModuleCates(request,"done",false);%>
						<option value=""><bean:message  bundle="sys-notify" key="sysNotifyTodo.all"/></option>
						<c:forEach var="app" items="${map}" varStatus="vstatus">
							<c:forEach var="module" items="${map[app.key]}" step="1">
							<option value="${module.key}">${module.value}</option>
							</c:forEach>
						</c:forEach>
					</select>
			</td>
		</tr>
		</c:if>
		<c:if test="${not empty param.fdModelName}">
		<input type="hidden" name="fdModelName" value="${param.fdModelName }">
		</c:if>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-notify" key="sysNotifyTodo.fdCreateDate"/>
			</td>
			<td>
				<bean:message  bundle="sys-notify" key="sysNotifyTodo.beginTime"/>
						&nbsp;<input name="fdBeginCreateTime" class="inputSgl"><a href="#" onclick="selectDate('fdBeginCreateTime');"><bean:message key="dialog.selectTime" /></a>
				&nbsp;<bean:message  bundle="sys-notify" key="sysNotifyTodo.endTime"/>
						&nbsp;<input name="fdEndCreateTime" class="inputSgl"><a href="#" onclick="selectDate('fdEndCreateTime');"><bean:message key="dialog.selectTime" /></a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-notify" key="sysNotifyTodo.finishDate"/>
			</td>
			<td>
				<bean:message  bundle="sys-notify" key="sysNotifyTodo.beginTime"/>
						&nbsp;<input name="fdBeginFinishTime" class="inputSgl"><a href="#" onclick="selectDate('fdBeginFinishTime');"><bean:message key="dialog.selectTime" /></a>
				&nbsp;<bean:message  bundle="sys-notify" key="sysNotifyTodo.endTime"/>
						&nbsp;<input name="fdEndFinishTime" class="inputSgl"><a href="#" onclick="selectDate('fdEndFinishTime');"><bean:message key="dialog.selectTime" /></a>
			</td>
		</tr>
	</table>	

	<br>
<input type="button" value="<bean:message key="button.search"/>" onclick="CommitSearch();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" value="<bean:message key="button.reset" />" onclick="document.forms[0].reset();" />
	

</form>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>