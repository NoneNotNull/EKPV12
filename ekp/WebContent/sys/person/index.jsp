<%@page import="javax.sound.midi.MidiDevice.Info"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*,
				com.landray.kmss.sys.person.model.*,
				com.landray.kmss.sys.person.actions.*,
				com.landray.kmss.sys.person.interfaces.*,
				java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
if (request.getAttribute(SysPersonSettingAction.SYS_PERSON_SETTING_ALL) == null) {
	SysPersonSettingAction.processLinkNav(request);
}
request.setAttribute("page_scene", "list");
SysPersonCfgLink defaultLink = (SysPersonCfgLink) request.getAttribute("SYS_PERSON_SETTING_LINK");
if (defaultLink != null) {
	request.getRequestDispatcher( defaultLink.getForwardUrl(request.getContextPath()) ).forward(request, response);
} else {%>
	<template:include ref="person.home">
	</template:include>
<%
}
%>