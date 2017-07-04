<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.attachment.util.AttImageUtils"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<style>
.tab_img{ width:100%; zoom:1;}
.tab_img:after{ display:block; clear:both; visibility:hidden; line-height:0px; content:"clear";}
</style>
<%
	String formBeanName = request.getParameter("formBeanName");
	String attKey = request.getParameter("fdKey");
	Object formBean = null;
	if(formBeanName != null && formBeanName.trim().length()!= 0){
		formBean = pageContext.getAttribute(formBeanName);
		if(formBean == null)
			formBean = request.getAttribute(formBeanName);
		if(formBean == null)
			formBean = session.getAttribute(formBeanName);
	}
	//pageContext.setAttribute("_downLoadNoRight",new PdaRowsPerPageConfig().getFdAttDownload());
	pageContext.setAttribute("_formBean", formBean);
%>
<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="msgkey" value="${param.msgkey}"/>
<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
	<p class="tab_img">
	<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
		<c:if test="${sysAttMain.fdAttType=='pic'}">
				<img style="float: right" width="100" height="75" src='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' ></img>
		</c:if>
	</c:forEach>
	</p>
</c:if>
