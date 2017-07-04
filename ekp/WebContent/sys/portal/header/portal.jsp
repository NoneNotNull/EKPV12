<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${ param['showPortal']==null || param['showPortal']=='true' }">
	<div class="lui_portal_header_zone_portal_switch"><%-- 切换门户 --%>
		<div class="lui_portal_header_text" data-lui-switch-class="lui_portal_header_text_over">
			${lfn:message('sys-portal:header.msg.switchportal')}<div class="lui_icon_s lui_portal_header_icon_arrow"></div>
			<ui:popup align="down-left" borderWidth="2">
				<div class="lui_portal_nav_top_switch_content">
					<ui:dataview>
						<ui:source type="AjaxJson">
							{"url":"/sys/portal/sys_portal_main/sysPortalMain.do?method=portal"}
						</ui:source>
						<ui:render ref="sys.ui.treeMenu.flat" />
					</ui:dataview>
				</div>
			</ui:popup>
		</div>
	</div><%-- 切换门户 --%>
</c:if>
 