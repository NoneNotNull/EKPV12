<%-- 收文单位 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "45%");%>
<xform:dialog propertyId="fdReceiveUnitId"
			  propertyName="fdReceiveUnitName" 
			  style="<%=parse.getStyle()%>"
			  className="inputsgl"
			  required="<%=required%>"
			  subject="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveUnit') }">
			  Dialog_TreeList(false, 'fdReceiveUnitId', 'fdReceiveUnitName', ';', 'kmImissiveUnitCategoryTreeService',
			                         '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive" />',
			                         'kmImissiveUnitListService&parentId=!{value}');
</xform:dialog>