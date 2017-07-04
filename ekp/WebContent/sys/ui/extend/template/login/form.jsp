<%@page import="java.util.Locale"%>
<%@page import="org.apache.struts.Globals"%>
<%@page import="com.landray.kmss.sys.config.util.LanguageUtil"%>
<%@page import="org.acegisecurity.ui.webapp.AuthenticationProcessingFilter"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
String localeLang = request.getParameter("lang");
if (localeLang != null) {
	session.setAttribute(Globals.LOCALE_KEY, ResourceUtil.getLocale(localeLang));
}else{
	Locale xlocale = ((Locale)session.getAttribute(Globals.LOCALE_KEY));
	if(xlocale != null)
		localeLang = xlocale.getLanguage();
}
%>
<script>
Com_IncludeFile("security.js");
</script>
<script type="text/javascript">
function kmss_onsubmit(){
	var loginInput = "<%=ResourceUtil.getString(request.getSession(),"login.inupt")%>";
	if(document.forms[0].j_username.value==""){
		alert(loginInput);
		document.forms[0].j_username.focus();
		return false;
	}
	if(document.forms[0].j_password.value==""){
		alert(loginInput);
		document.forms[0].j_password.focus();
		return false;
	}
	<c:if test="${ need_validation_code == 'yes' }">
	if(document.forms[0].j_validation_code.value==""){
		alert("<%=ResourceUtil.getString(request.getSession(),"login.input.code")%>");
		document.forms[0].j_validation_code.focus();
		return false;
	}
	</c:if>
	document.getElementsByName("btn_submit")[0].disabled = true;	 
	encryptPassword();
	return true;
}
seajs.use(['lui/jquery'], function($) {
	window.onload = function(){
		var j_username = document.getElementsByName('j_username')[0].value;
		if(j_username==""){ 
			document.getElementsByName('j_username')[0].focus();
		}
		else{
			document.getElementsByName('j_password')[0].focus();
		}
		$(document).keypress(function(e) {
			//if (e.which == 13)
			//	$("form").submit();
		});
	}
});
function encryptPassword(){ 
	document.forms[0].j_password.value = desEncrypt(document.forms[0].j_password.value);
}
</script>
<form action="${ LUI_CentextPath }j_acegi_security_check" method="POST" onsubmit="return kmss_onsubmit();">
	<table class="lui_login_form_table">
		<%--系统提示--%> 
		<tr>
			<td colspan="2" class="lui_login_message_td">
				<div class="lui_login_message_div">
					<c:set var="securityMsg" value="${ACEGI_SECURITY_LAST_EXCEPTION.message}" />
					<%=ResourceUtil.getString(request.getSession(), "login.info")%>
					<c:choose>
						<c:when test="${securityMsg==null}">
							<%=ResourceUtil.getString(request.getSession(),"login.inupt")%>
						</c:when>
						<c:when test="${securityMsg=='Bad credentials'}">
							<%=ResourceUtil.getString(request.getSession(),"login.error.password")%>
						</c:when>
						<c:otherwise>
							<c:out value="${securityMsg}" />
						</c:otherwise>
					</c:choose>
				</div>
			</td>
		</tr>
		<%--用户名--%>
		<tr>
			<td class="lui_login_input_title"><%=ResourceUtil.getString(request.getSession(),"login.username")%></td>
			<td class="lui_login_input_td">
				<div class="lui_login_input_div">
						<c:choose>
							<c:when test="${not empty param.login_error}">
								 <% 
								 	pageContext.setAttribute("login_user_name",StringUtil.getString(StringUtil.XMLEscape((String)session.getAttribute(AuthenticationProcessingFilter.ACEGI_SECURITY_LAST_USERNAME_KEY))));
								 %> 
							</c:when>
							<c:otherwise>
								<c:set var="login_user_name" scope="page" value="${param.username}" />
							</c:otherwise>
						</c:choose>
					<input type='text' name='j_username' class="lui_login_input_username"  onfocus="select();" value='<c:out value="${ login_user_name }"></c:out>'>
				</div>
			</td>
		</tr>
		
		<%--密码--%>
		<tr>
			<td class="lui_login_input_title"><%=ResourceUtil.getString(request.getSession(),"login.password")%></td>
			<td class="lui_login_input_td">
				<div class="lui_login_input_div">
					<input type='password' name='j_password' class="lui_login_input_password"  onFocus="select();">
				</div>
			</td>
		</tr>
		
		<%-- 验证码 --%>
		<c:if test="${ need_validation_code == 'yes' }">
			<tr>
				<td class="lui_login_input_title"><%=ResourceUtil.getString(request.getSession(),"login.verifycode")%></td>
				<td class="lui_login_input_td">
					<div class="lui_login_input_div">				
						<input type='text' name='j_validation_code' class="lui_login_input_vcode" onFocus="select();"> <img onclick="this.src='vcode.jsp?xx='+Math.random()" style='cursor: pointer;' src='vcode.jsp'>
					</div>
				</td>
			</tr>
		</c:if>
	 
	 	<%-- 切换语言 --%>
	 	<% if (StringUtil.isNotNull(ResourceUtil.getKmssConfigString("kmss.lang.support"))) { %>
			<tr>
				<td class="lui_login_input_title"><%=ResourceUtil.getString(request.getSession(),"login.language")%></td>
				<td class="lui_login_input_td">
					<div class="lui_login_input_div">
						<%=LanguageUtil.getLangHtml(request, "j_lang",localeLang)%>
					</div>
					<script>
						//语言切换
						function changeLang(value){
							var url = document.location.href;
							url = Com_SetUrlParameter(url, "lang", value);
							url = Com_SetUrlParameter(url, "username", document.getElementsByName("j_username")[0].value);
							location.href = url;
						}
					</script>
				</td>
			</tr>
		<% } %>
		<%-- 登录按钮 --%>
		<tr>
			<td class="lui_login_button_td" colspan="2">
				<a href="javascript:document.getElementsByName('btn_submit')[0].click();">
					<div class="lui_login_button_div_l">
	                	<div class="lui_login_button_div_r">
	                         	<div class="lui_login_button_div_c"><%=ResourceUtil.getString(request.getSession(),"login.button.submit")%></div>
	                    </div>
	                </div>
             	 </a>
			</td>
		</tr>
	</table>		
<input type=hidden name="j_redirectto" value="<c:out value="${ACEGI_SECURITY_TARGET_URL}" />">
<input type=submit style="border: 0px; width: 0px; height: 0px; background: none;" name="btn_submit">
</form>