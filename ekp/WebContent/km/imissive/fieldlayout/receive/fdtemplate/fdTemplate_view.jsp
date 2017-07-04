<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String displayMode = parse.getParamValue("displayMode");
    //空
    if(displayMode == null || displayMode.trim().length() == 0){
    	displayMode = "fullPath";
    }
    request.setAttribute("displayMode",displayMode);
%>	
<c:if test="${displayMode eq 'fullPath'}">
	<c:out value="${kmImissiveReceiveMainForm.fdCategoryName}"/>/<c:out value="${kmImissiveReceiveMainForm.fdTemplateName}"/>
</c:if>
<c:if test="${displayMode eq 'category'}">
	<c:out value="${kmImissiveReceiveMainForm.fdCategoryName}"/>
</c:if>
<c:if test="${displayMode eq 'template'}">
	<c:out value="${kmImissiveReceiveMainForm.fdTemplateName}"/>
</c:if>