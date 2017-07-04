<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%
	//out.print(request.getHeader("User-Agent"));
	if(request.getHeader("User-Agent").toUpperCase().indexOf("MSIE")>-1){
		request.setAttribute("isIE",true);
	}else if(request.getHeader("User-Agent").toUpperCase().indexOf("TRIDENT")>-1){
		request.setAttribute("isIE",true);
	}else{
		request.setAttribute("isIE",false);
	}
	request.setAttribute("jgOcxUrl",JgWebOffice.getJGDownLoadUrl("ocx"));
	request.setAttribute("jgOcxVersion",JgWebOffice.getJGVersion("ocx"));
	request.setAttribute("jgMulVersion",JgWebOffice.getJGVersion("mul"));
%>
<c:if test="${isIE}">
	<object 
		id="JGWebOffice_${param.fdKey}" 
		width="100%" classid="clsid:8B23EA28-2009-402F-92C4-59BE0E063499"
		height="100%"
		codebase="<c:url value='${jgOcxUrl}'/>#version=${jgOcxVersion}" 
		<c:if test="${param.attHeight==null}">height="800"</c:if>
		<c:if test="${param.attHeight!=null}">height="${param.attHeight}"</c:if>
		<c:if test="${param.fdAttType != 'office'}"> style="display:none"</c:if>>
	</object>
</c:if>
<c:if test="${!isIE}">
	<object 
		id="JGWebOffice_${param.fdKey}" 
		type="application/kg-activex" 
		width="100%" clsid="{8B23EA28-2009-402F-92C4-59BE0E063499}" 
		height="100%"
		copyright="${jgMulVersion}"
		<c:if test="${param.attHeight==null}">height="800"</c:if>
		<c:if test="${param.attHeight!=null}">height="${param.attHeight}"</c:if>
		<c:if test="${param.fdAttType != 'office'}"> style="display:none"</c:if>>
	</object>
</c:if>