<%-- 会签 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdCounterSignDeptIds = parse.getParamValue("fdCounterSignDeptIds");
    String fdCounterSignDeptNames = parse.getParamValue("fdCounterSignDeptNames");
    
    String defaultFdCounterSignDeptIds = parse.acquireValue("fdCounterSignDeptIds",fdCounterSignDeptIds);
    String defaultFdCounterSignDeptNames = parse.acquireValue("fdCounterSignDeptNames",fdCounterSignDeptNames);
	parse.addStyle("width", "control_width", "95%");
%>
<xform:dialog propertyId="fdCounterSignDeptIds" 
              propertyName="fdCounterSignDeptNames"
              idValue="<%=defaultFdCounterSignDeptIds%>"
              nameValue="<%=defaultFdCounterSignDeptNames%>"
	          style="<%=parse.getStyle()%>"
	          className="inputsgl"
	          required="true"
	          subject="${ lfn:message('km-imissive:kmImissiveSendMain.fdCounterSignDept') }">  
		      Dialog_TreeList(true, 'fdCounterSignDeptIds', 'fdCounterSignDeptNames', ';', 'kmImissiveUnitCategoryTreeService', 
		      '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive" />', 'kmImissiveUnitListService&parentId=!{value}');
</xform:dialog>