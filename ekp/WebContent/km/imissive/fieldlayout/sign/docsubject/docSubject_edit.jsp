<%-- 文档状态 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>	
    <%
	    String docSubject = parse.getParamValue("defaultValue");
	    String defaultDocSubject = parse.acquireValue("docSubject",docSubject);
		parse.addStyle("width", "control_width", "95%");
		required = Boolean.parseBoolean(parse.getParamValue("control_required", "true"));
	%>
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
	<input type="hidden" name="authAreaId" value="${param.id}"> 
<% } %>
<input type="hidden" name="fdTemplateId" value="${kmImissiveSignMainForm.fdTemplateId}"/>
<xform:xtext property="docSubject" required="<%=required%>" style="<%=parse.getStyle()%>" value="<%=defaultDocSubject%>"/>	