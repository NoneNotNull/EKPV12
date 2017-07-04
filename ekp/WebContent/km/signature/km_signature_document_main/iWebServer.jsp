<%@page import="com.landray.kmss.km.signature.util.iWebRevision"%>
<%@page contentType="text/html; charset=gb2312"%>
<%
  iWebRevision iWebServer = new iWebRevision();
  iWebServer.ExecuteRun(request, response);
  out.clear(); //用于解决JSP页面中“已经调用getOutputStream()”问题
  out=pageContext.pushBody();  //用于解决JSP页面中“已经调用getOutputStream()”问题
%>