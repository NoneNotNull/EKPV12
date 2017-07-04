<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<div class="lui_portal_header_zone_frame_h"></div>
<div class="lui_portal_header_zone_frame">
	<div style="width: ${ empty param['width'] ? '980px' : param['width'] };min-width:980px;" class="lui_portal_header_zone_content clearfloat">
		<div class="lui_portal_header_zone_logo">
			<portal:logo />
		</div>
		<div class="lui_portal_header_zone_portal">
			<portal:widget file="/sys/portal/header/portal.jsp">
				<c:if test="${ param['showPortal']==null || param['showPortal']=='true' }">
					<portal:param name="showPortal" value="true"/>
				</c:if>
			</portal:widget>
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
	<div>
		<portal:widget file="/sys/portal/header/page.jsp"> 
			<portal:param name="width" value="${ empty param['width'] ? '980px' : param['width'] }"/> 
		</portal:widget>
	</div>
</div>