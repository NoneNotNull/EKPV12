<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<html>
<head>
<meta name="viewport" content="width=device-width" />
</head>
<body>
	<%
		String userAgent=request.getHeader("User-Agent");
		boolean isPda=PdaFlagUtil.chkClientIsPdaByUA(request);
		if(isPda)
			out.println(ResourceUtil.getString("pda.license.ua.access","third-pda")+":"+userAgent);
		else
			out.println(ResourceUtil.getString("pda.license.ua.noAccess","third-pda")+userAgent);
	%>
</body>
</html>