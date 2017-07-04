<%-- 签收人 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "45%");%>
  <xform:address 
            isLoadDataDict="false"
            showStatus="edit"
			required="<%=required%>" style="<%=parse.getStyle()%>"
			subject="${lfn:message('km-imissive:kmImissiveReceiveMain.fdSignerId')}"
			propertyId="fdSignerId" propertyName="fdSignerName"
			orgType='ORG_TYPE_PERSON' className="input">
   </xform:address>
   