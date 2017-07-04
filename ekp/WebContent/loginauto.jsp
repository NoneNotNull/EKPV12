<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="org.acegisecurity.ui.AbstractProcessingFilter"%>
<%@ page import="org.acegisecurity.ui.webapp.AuthenticationProcessingFilter"%>
<%@ page import="org.acegisecurity.AuthenticationException"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script type="text/javascript">
Com_IncludeFile("login.js", "style/"+Com_Parameter.Style+"/login/");
function kmss_submit(){
	if(document.forms[0].j_username.value=="" || document.forms[0].j_password.value==""){
		alert("<kmss:message key="login.inupt"/>");
		return;
	}
	document.forms[0].submit();
}
</script>
<title><kmss:message key="login.title"/></title>
</head>
<body topmargin=0 leftmargin=0 onload="document.forms[0].submit();">
	<center><br><br><br><br><br><br><br><br><br><br><br>
	<form action="<c:url value='j_acegi_security_check'/>" method="POST">
	<table class="tb_main" cellpadding="0px">
		<tr>
			<td class="td_logo">
				&nbsp;
			</td>
			<td>
				<br><br><br>
				<c:set var="securityMsg" value="${ACEGI_SECURITY_LAST_EXCEPTION.message}" />
				<kmss:message key="login.info"/>
				<c:choose>
					<c:when test="${securityMsg==null}">
						<kmss:message key="login.inupt"/>
					</c:when>
					<c:when test="${securityMsg=='Bad credentials'}">
						<kmss:message key="login.error.password"/>
					</c:when>
					<c:otherwise>
						<c:out value="${securityMsg}" />
					</c:otherwise>
				</c:choose>
				<br><br>
				<kmss:message key="login.username"/>
				<input type='text' name='j_username' class="inputsgl" value="admin"
					onfocus="select();" onkeydown="if(event.keyCode==13)document.forms[0].j_password.focus();">
				<br><br>
				<kmss:message key="login.password"/>
				<input type='password' name='j_password' class="inputsgl" value="1"
					onfocus="select();" onkeydown="if(event.keyCode==13)kmss_submit();">
				<br><br>
				<table border=0px cellspacing=0px cellpadding=0px>
					<tr>
						<td class="btn_left"></td>
						<td class="btn_middle" onclick="kmss_submit();">
							<kmss:message key="login.button.submit"/>
						</td>
						<td class="btn_right"></td>
						<td width="10px"></td>
						<td class="btn_left"></td>
						<td class="btn_middle" onclick="
								var i=location.href.lastIndexOf('/');
								window.external.AddFavorite(location.href.substring(0,i+1),document.title);">
							<kmss:message key="login.button.favorite"/>
						</td>
						<td class="btn_right" ></td>
						<td width="10px"></td>
						<td class="btn_left"></td>
						<td class="btn_middle" onclick="
								var i=location.href.lastIndexOf('/');
								style.behavior='url(#default#homepage)';
								setHomePage(location.href.substring(0,i+1));">
							<kmss:message key="login.button.home"/>
						</td>
						<td class="btn_right"></td>
					</tr>
				</table>
				<br><br>
			</td>
		</tr>
	</table>
	</form></center>
</body>
</html>
