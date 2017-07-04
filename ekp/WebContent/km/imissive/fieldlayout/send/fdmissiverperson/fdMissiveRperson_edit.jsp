<%-- 抄报个人 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdMissiveRpersonIds = parse.getParamValue("fdMissiveRpersonIds");
    String fdMissiveRpersonNames = parse.getParamValue("fdMissiveRpersonNames");
    
    String defaultFdMissiveRpersonIds = parse.acquireValue("fdMissiveRpersonIds",fdMissiveRpersonIds);
    String defaultFdMissiveRpersonNames = parse.acquireValue("fdMissiveRpersonNames",fdMissiveRpersonNames);
	parse.addStyle("width", "control_width", "95%");
%>	
	<xform:address 
	            isLoadDataDict="false"
	            showStatus="edit"
	            mulSelect="false"
			    required="<%=required%>" style="<%=parse.getStyle()%>"
				idValue="<%=defaultFdMissiveRpersonIds%>"
				nameValue="<%=defaultFdMissiveRpersonNames%>"
				subject="${lfn:message('km-imissive:kmImissiveUnit.fdId')}"
				propertyId="fdMissiveRpersonIds" propertyName="fdMissiveRpersonNames"
				orgType='ORG_TYPE_PERSON' className="input">
	</xform:address>	