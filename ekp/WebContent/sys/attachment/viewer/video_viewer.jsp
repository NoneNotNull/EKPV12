<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.net.URLEncoder"%>
<html>
<head>
<%
	String attId = request.getParameter("fdId");
	if (StringUtil.isNotNull(attId)) {
		String videoPath = request.getContextPath()
		+"/sys/attachment/sys_att_main/sysAttMain.do?method=view&filekey=VideoCompress_flv&fdId="
		+ attId;
		request.setAttribute("videoPath", URLEncoder.encode(videoPath));
		request.setAttribute("attId", attId);
	}
%>
</head>
<body scroll="no" style="margin: 0; padding: 0;">
<c:if test="${isAtt=='true'}">
	<div id="video" style="width:100%;height:565px;">
		<embed src="<%=request.getContextPath()%>/sys/attachment/sys_att_main/video/gddflvplayer.swf" flashvars="?&autoplay=false&sound=70&buffer=2&vdo=${videoPath}" 
		 width="100%" height="565" allowFullScreen="true" quality="best" wmode="transparent" 
		 allowScriptAccess="always"  pluginspage="http://www.macromedia.com/go/getflashplayer" 
		 type="application/x-shockwave-flash"></embed>
	</div>
</c:if>
</body>
</html>
