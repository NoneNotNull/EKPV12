<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<div id="__my_bookmark__" data-lui-switch-class="lui_portal_header_text_over" class="lui_portal_header_text">
	${ lfn:message('sys-bookmark:header.msg.myfavorite') }
	<div class="lui_portal_header_icon_arrow lui_icon_s"></div>
</div>

<ui:popup borderWidth="${ empty param['popupborder'] ? '2' : param['popupborder'] }" align="down-left" positionObject="#__my_bookmark__" style="background:white;">
		<div style="width:260px;" >
			<div class="clearfloat">
				<div style="float: right;padding: 5px;margin-right:20px;">
					<ui:button styleClass="lui_toolbar_btn_gray" text="${ lfn:message('sys-bookmark:header.msg.favoritemng') }"
						href="/sys/person/setting.do?setting=sys_bookmark_person_cfg" target="_blank"></ui:button>
				</div>
			</div>
			<ui:menu layout="sys.ui.menu.ver.default">
				<ui:menu-source autoFetch="true" target="_blank">
					<ui:source type="AjaxJson">
						{"url":"/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=portlet&parentId=!{value}"}
					</ui:source>
				</ui:menu-source>
			</ui:menu>
		</div>
</ui:popup>
