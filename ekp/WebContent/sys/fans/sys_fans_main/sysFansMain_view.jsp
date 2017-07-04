<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/fans/sys_fans_main/sysFansMain_view_js.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/fans/sys_fans_main/style/view.css" />
<%@page import="com.landray.kmss.sys.fans.service.ISysFansMainService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>

<%
	String userId = request.getParameter("userId");
	String currUserId = UserUtil.getUser().getFdId();
	String fans_TA = "TA的";
	if(StringUtil.isNotNull(userId) 
			&& currUserId.equals(userId)){
		fans_TA = "我的";
	}
	request.setAttribute("fans_TA",fans_TA);
%>

<html:hidden property="fans_TA" value="${fans_TA}"/>
<html:hidden property="showTabPanel" 
	value="${empty param.showTabPanel ? 'true': param.showTabPanel}"/>
<html:hidden property="attentModelName" value="${param.attentModelName}"/>
<html:hidden property="fansModelName" value="${param.fansModelName}"/>
<c:if test="${param.userId != KMSS_Parameter_CurrentUserId }">
	<div id="sys_fans_box" class="sys_fans_box">
		<ui:dataview id="fans_list_view">
			<ui:source type="AjaxJson">
				{url:"/sys/fans/sys_fans_main/sysFansMain.do?method=loadRlation&userId=${param.userId}"+
							"&attentModelName=${param.attentModelName}&fansModelName=${param.fansModelName}"+
							"&isFollowPerson=${param.isFollowPerson}"}
			</ui:source>
			<ui:render type="Template">
				<%@ include file="/sys/fans/sys_fans_main/sys_fans_follow_tmpl.jsp"%>
			</ui:render>
			<ui:event event="load">
				function followcallBack() {
					LUI('fans_list_view').refresh();
				}
				$('[fans-action-type]').bind("click", function(evt) {
					var $this = $(this);
					seajs.use(['sys/fans/resource/sys_fans'], function(follow) {
						var isFollowed = $this.attr("fans-action-type");
						var isFollowPerson = $this.parent().attr("is-follow-person");
						var attentModelName = $this.parent().attr("attent-model-name");
						var fansModelName = $this.parent().attr("fans-model-name");
						if(isFollowed) {
							var userId = $this.attr("fans-action-id");
							follow.fansFollow(userId , isFollowed, isFollowPerson, attentModelName, fansModelName, "lui_follow", followcallBack);
						}
					});
				});
			</ui:event>
		</ui:dataview>
	</div>
</c:if>