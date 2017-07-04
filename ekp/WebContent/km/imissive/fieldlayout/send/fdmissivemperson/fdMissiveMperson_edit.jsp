<%-- 主送个人 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdMissiveMpersonIds = parse.getParamValue("fdMissiveMpersonIds");
    String fdMissiveMpersonNames = parse.getParamValue("fdMissiveMpersonNames");
    
    String defaultFdMissiveMpersonIds = parse.acquireValue("fdMissiveMpersonIds",fdMissiveMpersonIds);
    String defaultFdMissiveMpersonNames = parse.acquireValue("fdMissiveMpersonNames",fdMissiveMpersonNames);
	parse.addStyle("width", "control_width", "95%");
%>	
	<xform:address 
	            isLoadDataDict="false"
	            showStatus="edit"
	            mulSelect="false"
	            required="<%=required%>" style="<%=parse.getStyle()%>"
				idValue="<%=defaultFdMissiveMpersonIds%>"
				nameValue="<%=defaultFdMissiveMpersonNames%>"
				subject="${lfn:message('km-imissive:kmMissiveMainMperson.fdId')}"
				propertyId="fdMissiveMpersonIds" propertyName="fdMissiveMpersonNames"
				orgType='ORG_TYPE_PERSON' className="input">
	</xform:address>	
