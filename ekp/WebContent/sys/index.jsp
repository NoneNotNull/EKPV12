<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/index_top.jsp"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<script>
S_PortalInfo.appConfig = "${lfn:message('config.app')}";
S_PortalInfo.globalConfig = "${lfn:message('config.global')}";
<%
	if(UserUtil.getKMSSUser(request).isAdmin()){
		out.append("S_PortalInfo.sysConfig = '" + ResourceUtil.getString("config.sys")+"';");
 	}else{
		if("sys".equals(request.getParameter("type"))){
			throw new RuntimeException("您没有权限访问该页面");
		}
	}
%>
</script>
</head>
	<c:set var="type" value="${empty param.type ? 'app' : param.type}" />
	<frameset name="moduleMain" frameborder=0 border=0 rows="90,*">
	    <frame name="moduleTop" noresize scrolling=no src="${KMSS_Parameter_StylePath}head/syshead.html?type=${type}">
		<frameset name="moduleDown" frameborder=0 border=0 cols="180,8,*">
			<frame name="moduleTree" src="<c:url value="/sys/nav.jsp?type=${type}&module=${param.module}"/>">
			<frame name="moduleCtrl" noresize scrolling=no src="${KMSS_Parameter_StylePath}ctrlframe/varrowpage1.html">
		 	<frame name="moduleManager">
		</frameset>
	</frameset>
</html>