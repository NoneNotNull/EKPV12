<%-- 默认题头 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
    <%
	    String fdTableHead = parse.getParamValue("fdTableHead");
	    String defaultFdTableHead = parse.acquireValue("fdTableHead",fdTableHead);
	%>
<input type="hidden" name="fdTableHead" value="<%=defaultFdTableHead%>"/>
<p class="txttitle"><%=defaultFdTableHead%></p>