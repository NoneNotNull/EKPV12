<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}
if(request.getHeader("accept")!=null){
	if(request.getHeader("accept").indexOf("application/json") >=0){
		out.write(msgWriter.DrawJsonMessage(false).toString());
		return;
	}
}
response.setHeader("lui-status","true");
%>