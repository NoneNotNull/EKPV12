<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%
	if(request.getHeader("User-Agent").toUpperCase().indexOf("MSIE")>-1){
		request.setAttribute("isIE",true);
	}else if(request.getHeader("User-Agent").toUpperCase().indexOf("TRIDENT")>-1){
		request.setAttribute("isIE",true);
	}else{
		request.setAttribute("isIE",false);
	}
	request.setAttribute("jgPDFUrl",JgWebOffice.getJGDownLoadUrl("pdf"));
	request.setAttribute("jgPDFVersion",JgWebOffice.getJGVersion("pdf"));
	request.setAttribute("jgMulVersion",JgWebOffice.getJGVersion("mul"));
%>
<c:if test="${isIE}">
<object id="JGWebPdf_${param.fdKey}" width="100%"
	classid="clsid:39E08D82-C8AC-4934-BE07-F6E816FD47A1"
	codebase="<c:url value='${jgPDFUrl}'/>#version=<c:url value='${jgPDFVersion}'/>" 
	<c:if test="${param.attHeight==null}">height="800"</c:if>
	<c:if test="${param.attHeight!=null}">height="${param.attHeight}"</c:if>
	VIEWASTEXT>
</object>
</c:if>
<c:if test="${!isIE}">
<object id="JGWebPdf_${param.fdKey}" width="100%" 
	type="application/kg-activex" 
	clsid="{39E08D82-C8AC-4934-BE07-F6E816FD47A1}" 
	copyright="${jgMulVersion}" 
	<c:if test="${param.attHeight==null}">height="800"</c:if> 
	<c:if test="${param.attHeight!=null}">height="${param.attHeight}"</c:if>
	VIEWASTEXT>
</object>
</c:if>
