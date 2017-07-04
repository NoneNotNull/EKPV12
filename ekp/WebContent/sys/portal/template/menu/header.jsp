<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<div class="lui_portal_header_menu_frame">
	<div style="width: ${ empty param['width'] ? '980px' : param['width'] };min-width:980px;" class="lui_portal_header_menu_content clearfloat">
		<div class="lui_portal_header_menu_logo">
			<portal:logo />
		</div>		
		<div class="lui_portal_header_menu_search">
			<c:if test="${ param['showSearch']==null || param['showSearch']=='true' }">
				<portal:widget file="/sys/ftsearch/portal/search.jsp"></portal:widget>
			</c:if>
		</div>
		<c:if test="${ param['showNotify']!='' || param['showFavorite']!='' || param['showPerson']!='' || param['showPortal']!='' }">
		<div class="lui_portal_header_menu_person">
			<div class="lui_portal_header_menu_person_h_l">
				<div class="lui_portal_header_menu_person_h_r">
					<div class="lui_portal_header_menu_person_h_c"></div>
				</div>
			</div>
			<div class="lui_portal_header_menu_person_c_l">
				<div class="lui_portal_header_menu_person_c_r">
					<div class="lui_portal_header_menu_person_c_c">
						<c:if test="${ param['showNotify']==null  || param['showNotify']=='true' }">
							<div class="lui_portal_header_notify">
								<portal:widget file="/sys/notify/portal/count.jsp">
									<portal:param name="refreshTime" value="${empty param['refreshTime'] ? '5' : param['refreshTime'] }" />
								</portal:widget>
							</div>
						</c:if>
						<c:if test="${ param['showFavorite']==null  || param['showFavorite']=='true' }">
							<div class="lui_portal_header_favorite">
								<portal:widget file="/sys/bookmark/portal/favorite.jsp?popupborder=1"></portal:widget>
							</div>
						</c:if>
						<c:if test="${ param['showPerson']==null  || param['showPerson']=='true' }">
							<div class="lui_portal_header_userinfo">
								<portal:widget file="/sys/person/portal/userinfo.jsp?popupborder=1"></portal:widget>
							</div>
						</c:if>
						<c:if test="${ param['showPortal']==null || param['showPortal']=='true' }">
							<div class="lui_portal_header_portal">
								<portal:widget file="/sys/portal/header/switch.jsp?popupborder=1"></portal:widget>
							</div>
						</c:if>
					</div>
				</div>
			</div>
			<div class="lui_portal_header_menu_person_f_l">
				<div class="lui_portal_header_menu_person_f_r">
					<div class="lui_portal_header_menu_person_f_c"></div>
				</div>
			</div>
		</div>
		</c:if>
	</div>
	<div style="width: ${ empty param['width'] ? '980px' : param['width'] };" class="lui_portal_header_menu_menu clearfloat">
		<portal:widget file="/sys/portal/header/menu.jsp"></portal:widget>
	</div>
</div>