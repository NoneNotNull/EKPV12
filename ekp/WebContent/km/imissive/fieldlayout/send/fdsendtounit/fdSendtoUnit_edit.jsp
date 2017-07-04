<%-- 发文单位 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="java.net.URLEncoder" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
  <%
	    String fdMissiveUnitListIds = parse.getParamValue("fdMissiveUnitListIds");
	    String fdMissiveUnitListNames = parse.getParamValue("fdMissiveUnitListNames");
	    String fdMissiveUnitId = parse.getParamValue("fdMissiveUnitId");
	    String fdMissiveUnitName = parse.getParamValue("fdMissiveUnitName");

	    String defaultValueId = parse.acquireValue("fdMissiveUnitId",fdMissiveUnitId);
	    String defaultValueName = parse.acquireValue("fdMissiveUnitName",fdMissiveUnitName);
		parse.addStyle("width", "control_width", "45%");
	%>
	
	
<xform:dialog propertyId="fdSendtoUnitId"
			  idValue="<%=defaultValueId%>"
			  nameValue="<%=defaultValueName%>"
	          propertyName="fdSendtoUnitName" 
	          required="<%=required%>"
	          style="<%=parse.getStyle()%>" 
	          className="inputsgl"
	          subject="${ lfn:message('km-imissive:kmImissiveSendMain.fdSendtoDept') }">
		      Dialog_Tree(false, 'fdSendtoUnitId', 'fdSendtoUnitName', ',', 
		                         'kmImissiveUnitUseTreeService&ids=<%=fdMissiveUnitListIds%>&names=<%=URLEncoder.encode(fdMissiveUnitListNames,"UTF-8")%>',
		                         '<bean:message key="kmImissiveSendMain.fdSendtoDept" bundle="km-imissive" />', 
		                         null, null, '', null, null, '<bean:message bundle="km-imissive" key="kmImissiveSendMain.fdUnitId" />');
</xform:dialog>
