<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%
	if(PdaFlagUtil.checkClientIsPdaApp(request)){
		/*response.setHeader("contentType","text/plain; charset=UTF-8");
		JSONObject errorObj = new JSONObject();
		errorObj.accumulate("success","false");
		errorObj.accumulate("message",ResourceUtil.getString(request.getParameter("key")));
		errorObj.accumulate("relogin","true");
		out.println(errorObj.toString());*/
		String url = request.getContextPath() + "/third/pda/login.jsp?para_pda_redirectFlag=1";
		url += "&s_key=" + request.getParameter("key");
		response.sendRedirect(request.getContextPath() + "/logout.jsp?logoutUrl="+StringUtil.escape(url));
	}else{
%>
<%@include file="/third/pda/htmlhead.jsp"%>
		<script type="text/javascript">
			var time = 0;
			function opt_logout(){
				var redirect = '<c:url value="/third/pda/login.jsp?para_pda_redirectFlag=1"/>';
				redirect = encodeURI(redirect);
				location ='<c:url value="/logout.jsp"/>?logoutUrl='+ redirect;
			}
			function timeInteval(){
				var _timeArea = document.getElementById("_timeArea");
				if(time==5){
					opt_logout();
					return;
				}
				_timeArea.innerHTML = 5 - time;
				time ++;
				setTimeout("timeInteval()",1000);
			}
		</script>
		<title><bean:message bundle="third-pda" key="pda.license.warnning.title"/></title>
	</head>
	<body onload="timeInteval();">
		<div id="div_banner" class="div_banner">
			<div class="div_return" onclick="opt_logout();">
				<div>
					<bean:message key="phone.view.back" bundle="third-pda"/>
				</div>
				<div></div>
			</div>
		</div>
		<center>
			<div style="margin-top: 100px;width:200px;padding-left:65px;text-align:left;height:64px;background: url('<c:url value="/third/pda/resource/images/ico_error.png"/>') left no-repeat;">
				&nbsp;&nbsp;<b style="font-size: 15px;font-weight: bolder"><%=ResourceUtil.getString(request.getParameter("key"))%></b>
				<br/>
				&nbsp;&nbsp;<font style="color:purple;" id="_timeArea"></font><%=ResourceUtil.getString(request.getSession(),"third-pda", "phone.return.msg")%><a name='href_return' style="text-decoration: underline;cursor: pointer;" onclick="opt_logout();"><%=ResourceUtil.getString(request.getSession(),"third-pda", "phone.view.back")%></a>
			</div>
		</center>
	</body>
</html>
<%} %>