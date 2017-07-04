<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="org.acegisecurity.ui.AbstractProcessingFilter"%>
<%@ page
	import="org.acegisecurity.ui.webapp.AuthenticationProcessingFilter"%>
<%@ page import="org.acegisecurity.AuthenticationException"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page
	import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@ page import="org.apache.struts.Globals"%>
<%
	if(PdaFlagUtil.checkClientIsPdaApp(request)){
		response.setHeader("contentType","text/plain; charset=UTF-8");
		String key = request.getParameter("s_key");
		String errorMsg = StringUtil.isNotNull(key)? ResourceUtil.getString(request.getSession(),key) : ResourceUtil.getString(request.getSession(),"third-pda","phone.login.relogin");
%>
	<c:set var="ekpiMsg" value="${ACEGI_SECURITY_LAST_EXCEPTION.message}" />
	<c:set var="errorMsg" value='<%=errorMsg%>'/> 
	<c:if test="${ekpiMsg!=null}">
		<c:choose>
			<c:when test="${ekpiMsg=='Bad credentials'}">
				<c:set var="errorMsg" value='<%=ResourceUtil.getString(request.getSession(),"login.error.password")%>'/> 
			</c:when>
			<c:otherwise>
				<c:set var="errorMsg" value="${ekpiMsg}"/>
			</c:otherwise>
		</c:choose>
		{"success":"false","message":"${errorMsg}"}
	</c:if>
	<c:if test="${ekpiMsg==null}">
		{"errorPage":"true","message":"${errorMsg}","relogin":"true"}
	</c:if>
<%		
	}else{
%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%
	String localeLang = request.getParameter("lang");
	if (localeLang != null) {
		session.setAttribute(Globals.LOCALE_KEY, ResourceUtil
				.getLocale(localeLang));
	}
%>

<script type="text/javascript">
Com_IncludeFile("security.js");

function kmss_onsubmit(){
	var loginInput = '<bean:message key="login.inupt"/>';
	var j_username = document.getElementsByName('j_username')[0];
	var j_password = document.getElementsByName('j_password')[0];
	if(j_username.value==""){
		alert(loginInput);
		j_username.focus();
		return false;
	}
	if(j_password.value==""){
		alert(loginInput);
		j_password.focus();
		return false;
	}
	var password = j_password.value;
	j_password.value = desEncrypt(j_password.value);
	var expdate = new Date(); 
    expdate.setTime(expdate.getTime() + (86400 * 1000 * 1)); 
	if(document.getElementsByName('saveInfo')[0].checked){
		document.cookie="saveinfo=1"+";expires="+expdate.toGMTString();
		document.cookie="password=" + encodeURIComponent(password)+";expires="+expdate.toGMTString();
	}else{
		deleteCookie("saveinfo");
		deleteCookie("password");
	}
	document.cookie="username=" + encodeURIComponent(j_username.value)+";expires="+expdate.toGMTString();
	return true;
}
function deleteCookie(name) { 
       var expdate = new Date(); 
       expdate.setTime(expdate.getTime() - (86400 * 1000 * 1)); 
       document.cookie= name + "=;expires=" + expdate.toGMTString();
}

function GetCookie(name){
	var arr=document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	if(arr!=null)return decodeURIComponent(arr[2]);
	return null;
}
function scrolling(){
	window.scrollTo(0, 1); 
}
function changeDisplay(obj,optStr){
	var idStr=obj.getAttribute("name")+"_del";
	var optVar=document.getElementById(idStr);
	if(optVar!=null){
		if(obj.value.trim()==""){
			optVar.style.display="none";
		}else{
			optVar.style.display="block";
		}
	}
	if(optStr!=null){
		var otherVar=document.getElementById(optStr+"_del");
		if(otherVar!=null)
			otherVar.style.display="none";
	}
}
function focusInp(obj,optStr){
	obj.select();
	changeDisplay(obj,optStr);
}
function clearOpt(name){
	var inputObj=document.getElementsByName(name)[0];
	inputObj.value="";
	changeDisplay(inputObj);
	inputObj.focus();
}
window.onload=function(){
	var j_username=document.getElementsByName('j_username')[0];
	var j_password=document.getElementsByName('j_password')[0];
	if(GetCookie("saveinfo")=="1"){
		document.getElementsByName('saveInfo')[0].checked = true;
		j_password.value=GetCookie("password");
	}
	var username=GetCookie("username");
	if(username!=null && username!=""){
		j_username.value=username;
	}
	setTimeout(function(){window.scrollTo(0, 1); }, 100);
};

function changetype(obj){
	var url = "";
	if(obj == "pc"){
		url = '<c:url value="/login.jsp"/>';
	}
	if(obj == "pda"){
		url = '<c:url value="/third/pda/login.jsp"/>';
	}
	
	url = Com_SetUrlParameter(url, "loginType", obj);
	location.href = url;
}
</script>
<title>
	<bean:message key="login.title"/>
</title>
</head>
<body class="bodyBak">
<form action="<c:url value='/j_acegi_security_check'/>" method="POST" onsubmit="return kmss_onsubmit();" autocomplete="off">
	<center>
		<div class="div_form">
			<div class="div_loginLog"></div>
			<div class="div_error">
				<c:set var="securityMsg" value="${ACEGI_SECURITY_LAST_EXCEPTION.message}" />
				<c:choose>
					<c:when test="${securityMsg=='Bad credentials'}">
						<bean:message key="login.error.password"/>
					</c:when>
					<c:otherwise>
						<c:out value="${securityMsg}"/>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="div_userLogin">
				<center>
					<div class="div_loginArea">
						<div>
							<label>
								<bean:message key="login.username"/>
								<input class="inp_input" type='text' name='j_username' value="${param.username}" onfocus="focusInp(this,'j_password');"
								 onkeydown="changeDisplay(this);" onkeypress="changeDisplay(this);" onkeyup="changeDisplay(this);"/>
								<div id='j_username_del' class="inp_delete" onclick="clearOpt('j_username');"></div>
							</label>
						</div>
						<div>
							<label>
								<bean:message key="login.password"/>
								<input class="inp_input" type='password' name='j_password' onfocus="focusInp(this,'j_username');"
								  onkeydown="changeDisplay(this);" onkeypress="changeDisplay(this);" onkeyup="changeDisplay(this);"
								  onblur="scrolling();"/>
								<div id='j_password_del' class="inp_delete" onclick="clearOpt('j_password');"></div>
							</label>
						</div>
						<%
						if (request.getSession().getAttribute("need_validation_code") != null
								&& request.getSession()
										.getAttribute("need_validation_code").toString()
										.equals("yes")) {
						%>
						<div>
							<label><bean:message key="login.verifycode"/>
							<input type='text' name='j_validation_code' style="width: 100px;" class="inp_input"
								onblur="scrolling();"/> 
							<img src='<c:url value="/vcode.jsp"/>' align="middle"/>
							</label>
						</div>
						<%
							}
						%>
						<div>
							<label>
								<input name="saveInfo" id="saveInfoid" type="checkbox" value=""/>
								<bean:message bundle="third-pda" key="login.recordpassword"/>
							</label>
						</div>
					</div>
				</center>
			</div>
			<div style="padding-top: 10px;">
			    <i style="font-style:normal;color: #999;">移动版</i>|<a href="javascript:void(0)" id="pc" onclick="changetype(this.id);">桌面版</a>
			</div>   
			<div class="div_loginbtn">
				<center>
					<div class="btn_group">
						<input type="submit" class="btn_sumit" value="<bean:message bundle="third-pda" key="login.login"/>"/>
					</div>
				</center>
			</div>
		</div>
	</center>
	<div style="display: none">
		<input type=hidden name="j_redirectto" value='<c:out value="${ACEGI_SECURITY_TARGET_URL}"/>'/> 
	</div>
</form>
</body>
</html>
<%}%>