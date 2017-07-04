<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%
String formBeanName = request.getParameter("formBeanName");
Object formBean = null;

if(formBeanName != null && formBeanName.trim().length() != 0){
	formBean = pageContext.getAttribute(formBeanName);
	if(formBean == null){
		formBean = request.getAttribute(formBeanName);
	}
	if(formBean == null){
		formBean = session.getAttribute(formBeanName);
	}
	pageContext.setAttribute("_formBean", formBean);
}else{
	formBeanName = "org.apache.struts.taglib.html.BEAN";
}
Object originFormBean = pageContext.getAttribute("org.apache.struts.taglib.html.BEAN");
pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", formBean);
if(formBean == null){
	formBean = org.apache.struts.taglib.TagUtils.getInstance().lookup(pageContext,
			formBeanName, null);
	pageContext.setAttribute("_formBean", formBean);
}
%>
<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="attachmentId" value=""/>
<c:set var="fdFileName" value=""/>
<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
	<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
	<c:set var="fdFileName" value="${sysAttMain.fdFileName}"/>
</c:forEach>
 <iframe id="IFrame_Content" width="100%" height="100%"
		frameborder="0" scrolling="no" src="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${attachmentId}&viewer=aspose_htmlviewer&showAllPage=true"/>">
 </iframe>
