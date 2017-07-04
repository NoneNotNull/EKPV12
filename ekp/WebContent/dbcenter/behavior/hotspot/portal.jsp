<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%
	String pageId = PortalUtil.getPortalInfo(request).getPageMd5();
	if(pageId!=null){
		request.setAttribute("SYS_PORTAL_HEADER_HTML", "<script>Com_Parameter.CurrentPageId = 'p" + 
				pageId + "';seajs.use('dbcenter/behavior/hotspot/hotspot.js');</script>");
	}
%>