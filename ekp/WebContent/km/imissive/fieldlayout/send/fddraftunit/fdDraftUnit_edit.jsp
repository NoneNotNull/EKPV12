<%-- 拟文单位 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdDraftUnitId = parse.getParamValue("fdDraftUnitId");
    String fdDraftUnitName = parse.getParamValue("fdDraftUnitName");
    
    String defaultDdDraftUnitId = parse.acquireValue("fdDraftUnitId",fdDraftUnitId);
    String defaultFdDraftUnitName = parse.acquireValue("fdDraftUnitName",fdDraftUnitName);
	parse.addStyle("width", "control_width", "45%");
%>
<xform:dialog propertyId="fdDraftUnitId"
              propertyName="fdDraftUnitName"
	          style="<%=parse.getStyle()%>" 
	          idValue="<%=defaultDdDraftUnitId %>"
	          nameValue="<%=defaultFdDraftUnitName %>"
	          className="inputsgl"
	          required="<%=required%>"
	          subject="${ lfn:message('km-imissive:kmImissiveSendMain.fdDraftDeptId') }">  
		      Dialog_TreeList(false, 'fdDraftUnitId', 'fdDraftUnitName', ';', 'kmImissiveUnitCategoryTreeService', 
		      '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive" />', 'kmImissiveUnitListService&parentId=!{value}');
</xform:dialog>