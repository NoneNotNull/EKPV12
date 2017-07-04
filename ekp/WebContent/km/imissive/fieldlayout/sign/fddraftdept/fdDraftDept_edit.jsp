<%-- 拟部门 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "45%"); %>
 <xform:address 
        propertyId="fdDraftDeptId"
        propertyName="fdDraftDeptName"
        orgType="ORG_TYPE_DEPT"
        required="<%=required%>" 
        style="<%=parse.getStyle()%>"
        className="inputsgl">
</xform:address>