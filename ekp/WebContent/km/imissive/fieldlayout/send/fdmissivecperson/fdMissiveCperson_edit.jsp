<%-- 抄送个人--%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdMissiveCpersonIds = parse.getParamValue("fdMissiveCpersonIds");
    String fdMissiveCpersonNames = parse.getParamValue("fdMissiveCpersonNames");
    
    String defaultFdMissiveCpersonIds = parse.acquireValue("fdMissiveCpersonIds",fdMissiveCpersonIds);
    String defaultFdMissiveCpersonNames = parse.acquireValue("fdMissiveCpersonNames",fdMissiveCpersonNames);
	parse.addStyle("width", "control_width", "95%");
%>	
	<xform:address 
	            isLoadDataDict="false"
	            showStatus="edit"
	            mulSelect="false"
				style="<%=parse.getStyle()%>"
				required="<%=required%>"
				idValue="<%=defaultFdMissiveCpersonIds%>"
				nameValue="<%=defaultFdMissiveCpersonNames%>"
				subject="${lfn:message('km-imissive:kmImissiveUnit.fdId')}"
				propertyId="fdMissiveCpersonIds" propertyName="fdMissiveCpersonNames"
				orgType='ORG_TYPE_PERSON' className="input">
	</xform:address>		