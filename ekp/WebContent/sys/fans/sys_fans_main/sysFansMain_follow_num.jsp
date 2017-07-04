<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/fans/sys_fans_main/sysFansMain_view_js.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/fans/sys_fans_main/style/view.css" />
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
<html:hidden property="showTabPanel" value="${empty param.showTabPanel ? 'true': param.showTabPanel}"/>
<html:hidden property="attentModelName" value="${param.attentModelName}"/>
<html:hidden property="fansModelName" value="${param.fansModelName}"/>

