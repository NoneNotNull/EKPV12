<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%
	response.setHeader("lui-status","false");
	if(PdaFlagUtil.checkClientIsPdaApp(request)){
		response.setHeader("contentType","text/plain; charset=UTF-8");
		out.println("{");
		out.println("\"errorPage\":\"true\",");
		out.println("\"message\":\""+ResourceUtil.getOfficialString("global.accessDenied")+"\"");
		out.println("}");
	}else{
%>
<%@include file="/third/pda/htmlhead.jsp"%>
		<script type="text/javascript">
			function redirectTo(){
				history.back();
			}
		</script>
		<title><bean:message key="return.systemInfo"/></title>
	</head>
	<body>
		<c:if test="${sessionScope['S_CurModule']!=null}">
			<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
				<c:param name="fdNeedReturn" value="true"/>
				<c:param name="fdModuleName" value="${sessionScope['S_CurModuleName']}"/>
				<c:param name="fdModuleId" value="${sessionScope['S_CurModule']}"/>
			</c:import>
		</c:if>
		<center>
			<div style="margin-top: 100px;width:120px;padding-left:65px;text-align:left;height:64px;background: url('<c:url value="/third/pda/resource/images/ico_error.png"/>') left no-repeat;">
				<br/>
				&nbsp;&nbsp;<b style="font-size: 15px;font-weight: bolder"><%=ResourceUtil.getOfficialString("global.accessDenied") %></b>
				<br/>
				<input name="inp_return" type="hidden" value="${sessionScope['S_DocLink']}"/>
				&nbsp;&nbsp;<a name='href_return' style="text-decoration: underline;cursor: pointer;" onclick="redirectTo();"><%=ResourceUtil.getOfficialString("third-pda:phone.view.back")%></a>
				<%=ResourceUtil.getOfficialString("third-pda:phone.return.msg1")%>
			</div>
		</center>
	</body>
</html>
<%}%>