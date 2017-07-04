<%-- 密级程度设置 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
	<%
	    String fdSecretGradeId = parse.getParamValue("fdSecretGradeId");
	    String defaultValue = parse.acquireValue("fdSecretGradeId",fdSecretGradeId);
		parse.addStyle("width", "control_width", "auto");
		required = Boolean.parseBoolean(parse.getParamValue("control_required", "true"));
	%>
	<xform:select property="fdSecretGradeId" subject="${lfn:message('km-imissive:kmImissiveSignMain.fdSecretGrade')}" required="<%=required%>" style="<%=parse.getStyle()%>" showStatus="edit" value="<%=defaultValue%>">
		<xform:beanDataSource serviceBean="kmImissiveSecretGradeService"
						      selectBlock="fdId,fdName"
							  whereBlock="kmImissiveSecretGrade.fdIsAvailable=1"
							  orderBy="kmImissiveSecretGrade.fdOrder" />
	</xform:select>
