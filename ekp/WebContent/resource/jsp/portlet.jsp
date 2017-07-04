<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgPortlet"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>
<%
	Date today = new Date();
	request.setAttribute("today", today.getMonth()+"/"+today.getDate()+"/"+(today.getYear()+1900));
	String portletName = request.getParameter("portlet");
	String cateId = request.getParameter("cateid");
	if(cateId==null)
		cateId = "";
	ArrayList portletList = new ArrayList();
	Map portletMap = SysConfigs.getInstance().getPortlets();
	for (Iterator it = portletMap.keySet().iterator(); it.hasNext(); ) {
		List list = (List) portletMap.get(it.next());
		for (Iterator i = list.iterator(); i.hasNext(); ) {
			portletList.add(i.next());
		}
	}
	SysCfgPortlet portlet = null;
	for(int i=0; i<portletList.size(); i++){
		portlet = (SysCfgPortlet)portletList.get(i);
		if(portlet.getMessageKey().equals(portletName))
			break;
		portlet = null;
	}
	if(StringUtil.isNotNull(portlet.getContentBean())){
		request.setAttribute("portlet", portlet);
		if(portlet.getMoreURL()!=null)
			request.setAttribute("MoreURL", StringUtil.replace(portlet.getMoreURL(), "!{cateid}", cateId));
		if(portlet.getContentBean()!=null)
			request.setAttribute("DataURL", StringUtil.replace(portlet.getContentBean(), "!{cateid}", cateId));
		if(portlet.getHeadBean()!=null)
			request.setAttribute("HeadURL", StringUtil.replace(portlet.getHeadBean(), "!{cateid}", cateId));
	}else if(StringUtil.isNotNull(portlet.getContentURL())){
		String url = portlet.getContentURL();
		url = url.replace("!{rowsize}","10");
		request.getRequestDispatcher(request.getContextPath()+url).forward(request,response);
	}
%>
<c:choose>
<c:when test="${param.forKK == 'true'}">
Com_IncludeFile("portal_kk.js|data.js");
</c:when>
<c:otherwise>
Com_IncludeFile("portal.js|data.js");
</c:otherwise>
</c:choose>
var S_PortalInfo = new Object();
S_PortalInfo.Path = "${KMSS_Parameter_ResPath}style/";
S_PortalInfo.StylePath = "${KMSS_Parameter_StylePath}";
S_PortalInfo.Style = "${KMSS_Parameter_Style}";
//S_PortalInfo.DesignMode = false;
S_PortalInfo.Today = new Date("${today}");
S_PortalInfo.TimeOutID = new Array;
//S_PortalInfo.QuickNewIndex = 0;
S_PortalInfo.CurUserID = "<%= UserUtil.getUser().getFdId() %>";
</script>
<c:choose>
<c:when test="${param.forKK == 'true'}">
<script src="${KMSS_Parameter_StylePath}portal/portlet_draw_kk.js"></script>
<link rel=stylesheet href="${KMSS_Parameter_StylePath}portal/portal_kk.css">
</c:when>
<c:otherwise>
<script src="${KMSS_Parameter_StylePath}portal/portlet_draw.js"></script>
<link rel=stylesheet href="${KMSS_Parameter_StylePath}portal/portal.css">
</c:otherwise>
</c:choose>
<style>#LKS_Portlet{behavior:url(${KMSS_Parameter_ResPath}htc/portlet.jsp)}</style>
</head>
<body>

<c:if test="${param.forKK == 'true'}">
<!-- 如果是被KK集成，则显示标题。苏轶 2010年7月1日 -->
<%
String messageKey = request.getParameter("portlet");
if (StringUtil.isNotNull(messageKey)) {
	String title = com.landray.kmss.util.ResourceUtil.getString(messageKey);
	if (StringUtil.isNotNull(title)) {
%>
<div style='font-weight:bold;color:black;'>
	<img src="${KMSS_Parameter_StylePath}portal/icon_title_kk.jpg" border='0' style="vertical-align:middle"><%=title %>
</div>
<%		
	}
}
%>
</c:if>

<DIV id=LKS_Portlet LKS_Info='NoBorder:true,RefreshTime:0,NewLine:${param.NewLine == null ? "false" : param.NewLine},NewDay:${param.NewDay == null ? "0" : param.NewDay},ShowCreated:${param.ShowCreated == null ? "false" : param.ShowCreated},ShowCreator:${param.ShowCreator == null ? "false" : param.ShowCreator},MoreURL:"${MoreURL}",MoreTarget:"${param.MoreTarget == null ? "_top" : param.MoreTarget}",DataURL:"${DataURL}",DocCount:${param.DocCount == null ? "8" : param.DocCount},HeadURL:"${HeadURL}",DocLink:"${portlet.docLink}",ShowHead:${param.ShowHead == null ? "false" : param.ShowHead},PositionInfo:"${param.PositionInfo == null ? "Extend_1" : param.PositionInfo}",icon:"<c:url value="/resource/style/default/portal/icon_red.gif"/>"'></DIV>
</body>
</html>

