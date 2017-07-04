<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.sys.portal.service.*"%>
<%@page import="com.landray.kmss.sys.portal.util.*"%>
<%@page import="com.landray.kmss.sys.portal.model.*"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%
String id = PortalUtil.getPortalInfo(request).getPortalPageId();
if(StringUtil.isNotNull(id)){
	ISysPortalMainService service = (ISysPortalMainService)SpringBeanUtil.getBean("sysPortalMainService");
	SysPortalMainPage mainPage = (SysPortalMainPage) service.findByPrimaryKey(id, SysPortalMainPage.class, true);
	if(mainPage!=null){
		List<String> paths = new ArrayList<String>();
		paths.add(mainPage.getFdName());
		for(SysPortalMain main = mainPage.getSysPortalMain(); main!=null; main = (SysPortalMain)main.getFdParent()){
			paths.add(main.getFdName());
		}
		Collections.reverse(paths);
		pageContext.setAttribute("paths", paths);
	}
}
%>

<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.portal.service.ISysPortalMainService"%><div class="lui_portal_header_zone_frame_h"></div>
<div class="lui_portal_header_zone_frame${ param['scene'] eq 'portal' ? '' : ' lui_portal_header_nofixed' }">
	<div style="width: ${ empty param['width'] ? '980px' : param['width'] };min-width:980px;" class="lui_portal_header_zone_content clearfloat">
		<div class="lui_portal_header_zone_logo">
			<portal:logo />
		</div>
		<div class="lui_portal_header_zone_portal">
			 <div class="lui_portal_header_zone_portal_switch"><%-- 切换门户 --%>
				<div class="lui_portal_header_text" data-lui-switch-class="lui_portal_header_text_over">
					<div class="lui_portal_nav_top_path">
						<c:forEach items="${paths}" var="path">
							<span class="lui_portal_nav_top_path_split"></span>
							<span class="lui_portal_nav_top_path_item"><c:out value="${path}"/></span>
						</c:forEach>
					</div>
					<div class="lui_icon_s lui_portal_header_icon_arrow"></div>
					<ui:popup align="down-left" borderWidth="2">
						<div style="width:600px; padding: 8px; background:white;">
							<ui:dataview format="sys.ui.treeMenu2">
								<ui:source type="AjaxJson">
									{"url":"/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=portalNavTree"}
								</ui:source>
								<ui:render ref="sys.ui.treeMenu2.portal"></ui:render>
							</ui:dataview>
						</div>
					</ui:popup>
				</div>
			</div><%-- 切换门户 --%>
		</div>
		<c:if test="${ param['showSearch']==null || param['showSearch']=='true' }">
			<div class="lui_portal_header_zone_search">
				<portal:widget file="/sys/ftsearch/portal/search.jsp"></portal:widget>
			</div>
		</c:if>
		<div class="lui_portal_header_zone_person">
			<c:if test="${ param['showNotify']==null  || param['showNotify']=='true' }">
				<div class="lui_portal_header_notify">
					<portal:widget file="/sys/notify/portal/count.jsp">
						<portal:param name="refreshTime" value="${empty param['refreshTime'] ? '5' : param['refreshTime'] }" />
					</portal:widget>
				</div>
			</c:if>
			<c:if test="${ param['showFavorite']==null  || param['showFavorite']=='true' }">
				<div class="lui_portal_header_favorite">
					<portal:widget file="/sys/bookmark/portal/favorite.jsp"></portal:widget>
				</div>
			</c:if>
			<c:if test="${ param['showPerson']==null  || param['showPerson']=='true' }">
				<div class="lui_portal_header_userinfo">
					<portal:widget file="/sys/person/portal/userinfo.jsp"></portal:widget>
				</div>
			</c:if>
		</div>
	</div>
</div>