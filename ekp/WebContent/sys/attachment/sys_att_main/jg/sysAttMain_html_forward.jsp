<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
	String fdId = request.getParameter("fdId");
	String _isMobile =  request.getParameter("_mobile");
	File file = JgWebOffice.getFile(fdId,fdId + ".htm");
	if(file.exists()){
		String absFilePath = file.getAbsolutePath();
		absFilePath = absFilePath.replace("\\","/");
		if(absFilePath.indexOf("/JG_HTML/")!=-1){
			absFilePath = absFilePath.substring(absFilePath.indexOf("/JG_HTML/"));
			String redirectUrl = request.getContextPath() + (absFilePath.startsWith("/")?absFilePath:("/"+absFilePath));
			if("1".equalsIgnoreCase(_isMobile)){
				response.setHeader("contentType","text/plain; charset=UTF-8");
				response.setHeader("lui-status","true");
				JSONObject urljson= new JSONObject();
				urljson.accumulate("url",redirectUrl);
				out.println(urljson.toString());
			}else{
				response.sendRedirect(redirectUrl);
			}
		}
	}
%>

