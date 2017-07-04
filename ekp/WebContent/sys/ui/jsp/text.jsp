<%@ page language="java" pageEncoding="UTF-8" contentType="text/plain; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", -1);
%>
<ui:ajaxtext>
${requestScope['lui-text']}
</ui:ajaxtext>