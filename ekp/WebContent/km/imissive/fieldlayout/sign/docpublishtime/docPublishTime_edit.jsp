<%-- 发布日期 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "45%"); %>
<xform:datetime property="docPublishTime"
				required="<%=required %>"
                showStatus="edit" 
                dateTimeType="date" 
                subject="${lfn:message('km-imissive:kmImissiveSignMain.docPublishTime')}"
                style="<%=parse.getStyle()%>"/>	
<br>
<%if(!required){ %>
	${lfn:message("km-imissive:kmImissiveSignMain.docPublishTime.info")}
<%} %>
