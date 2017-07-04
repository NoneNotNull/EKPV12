<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
try{
	JgWebOffice.batchUpdateHtmlFile(request,response);
	out.println("批量转换html附件目录成功！");
}catch(Exception e){
	out.println("批量转换html附件目录报错：" + e);
}
%>

