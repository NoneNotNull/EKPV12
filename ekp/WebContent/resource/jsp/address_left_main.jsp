<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/nav_top.jsp" %>
var startWithParameter = top.dialogObject.addressBookParameter.startWith;
startWithParameter = startWithParameter==null?"":startWithParameter;
var navBarInfo = new Array(
	"<bean:message bundle="sys-organization" key="sysOrg.address.nav1"/>|address_left_1.jsp?s_css=${fn:escapeXml(param.s_css)}&startWith="+startWithParameter,
	"<bean:message bundle="sys-organization" key="sysOrg.address.nav2"/>|address_left_2.jsp?s_css=${fn:escapeXml(param.s_css)}",
	"<bean:message bundle="sys-organization" key="sysOrg.address.nav3"/>|address_left_3.jsp?s_css=${fn:escapeXml(param.s_css)}"
);
<%@ include file="/resource/jsp/nav_down.jsp" %>