<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%> 
<c:set var="sysNewsPublishMainForm" value="${requestScope[param.formName].sysNewsPublishMainForm}" />
<c:set var="docForm" value="${requestScope[param.formName]}" />
<c:if test="${sysNewsPublishMainForm.fdModelName!=null && 
sysNewsPublishMainForm.fdModelName!='' && sysNewsPublishMainForm.fdModelId!=null && sysNewsPublishMainForm.fdModelId!=''}"> 
	<c:set var="sysNewsPublishUrl"
		   value="/sys/news/sys_news_publish_main/sysNewsPublishMain_viewManualFrame.jsp?fdModelNameParam=${sysNewsPublishMainForm.fdModelName}&fdModelIdParam=${sysNewsPublishMainForm.fdModelId}" />
	<%
	    boolean isShowUiContent = !"false".equals(request.getParameter("isShowUiContent"));
	if(isShowUiContent){ %>
		<ui:content title="${lfn:message('sys-news:sysNewsPublishMain.tab.publish.label')}">
			 <%@ include file="sysNewsPublishMain_viewSimple.jsp"%>
		</ui:content>
	<%}else{ %>
	       <%@ include file="sysNewsPublishMain_viewSimple.jsp"%>
	<% }%>
</c:if>