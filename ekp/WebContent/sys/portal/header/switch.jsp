<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="lui_portal_header_text" data-lui-switch-class="lui_portal_header_text_over">
	${lfn:message('sys-portal:header.msg.switchportal')}<div class="lui_icon_s lui_portal_header_icon_arrow"></div>
	<ui:popup borderWidth="${ empty param['popupborder'] ? '2' : param['popupborder'] }" align="down-left">
		<div class="lui_portal_header_portal_content">
			<ui:dataview>
				<ui:source type="AjaxJson">
					{"url":"/sys/portal/sys_portal_main/sysPortalMain.do?method=portal"}
				</ui:source>
				<ui:render ref="sys.ui.treeMenu.flat" />
			</ui:dataview>
		</div>
	</ui:popup>
</div>