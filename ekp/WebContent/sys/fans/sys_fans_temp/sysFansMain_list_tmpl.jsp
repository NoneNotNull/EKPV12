<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<a class="lui_fans_listfollow_btn" id="fans_follow_btn" href="javascript:void(0)" is-follow-person="true" attent-model-name="${param.userModelName}" 
		fans-model-name="${param.userModelName}" data-action-id="${param.fdId }" data-fans-sign="sys_fans" data-action-type="${param.actionType}">
        <span class="lui_fans_btn_focus" id="fans_btn" title="${lfn:message('sys-fans:sysFansMain.follow') }">
        + ${lfn:message('sys-fans:sysFansMain.follow') }</span>
</a>