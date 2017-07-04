<%-- 来文文号 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "95%"); 
  required = Boolean.parseBoolean(parse.getParamValue("control_required", "true"));%>
<c:if test="${kmImissiveReceiveMainForm.fdDeliverType=='0'}">
	   <xform:xtext property="fdDocNum" required="<%=required%>" showStatus="edit" style="<%=parse.getStyle()%>"/>	
</c:if>
<c:if test="${kmImissiveReceiveMainForm.fdDeliverType!='0'}">
	   <c:if test="${not empty kmImissiveReceiveMainForm.fdDocNum}">
	        <input type="hidden" name="fdDocNum" value="${kmImissiveReceiveMainForm.fdDocNum}"/>
			<xform:xtext property="fdDocNum" required="<%=required%>" showStatus="view" style="<%=parse.getStyle()%>"/>	
	   </c:if>	
	   <c:if test="${empty kmImissiveReceiveMainForm.fdDocNum}">
	 	   ${lfn:message("km-imissive:kmImissiveReceiveMain.fdDocNum.title")}
	   </c:if>
</c:if>

