<%-- 核稿人 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdCheckerId = parse.getParamValue("fdCheckerId");
    String fdCheckerName = parse.getParamValue("fdCheckerName");
    String defaultFdCheckerId = parse.acquireValue("fdCheckerId",fdCheckerId);
    String defaultFdCheckerName = parse.acquireValue("fdCheckerName",fdCheckerName);
	parse.addStyle("width", "control_width", "45%");
    
%>	
  <xform:address 
            isLoadDataDict="false"
            showStatus="edit"
			required="<%=required%>"
		    style="<%=parse.getStyle()%>"
			idValue="<%=defaultFdCheckerId%>"
			nameValue="<%=defaultFdCheckerName%>"
			subject="${lfn:message('km-imissive:kmImissiveSendMain.fdCheckId')}"
			propertyId="fdCheckerId" propertyName="fdCheckerName"
			orgType='ORG_TYPE_PERSON' className="input">
   </xform:address>
   