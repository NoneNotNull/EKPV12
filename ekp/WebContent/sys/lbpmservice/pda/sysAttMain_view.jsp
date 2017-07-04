
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.common.model.IBaseModel"%>
<%@page import="com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm"%>
<%@page import="com.landray.kmss.sys.attachment.util.AttImageUtils"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="java.util.List,java.util.ArrayList,java.util.Collections"%>
<%@page import="java.util.Comparator"%>
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
<%
AttachmentDetailsForm detailsForm = (AttachmentDetailsForm) pageContext.getAttribute("attForms");
List attachments = new ArrayList(detailsForm.getAttachments());
Collections.sort(attachments, new Comparator(){
	public int compare(Object o1, Object o2) {
		IBaseModel b1 = (IBaseModel) o1;
		IBaseModel b2 = (IBaseModel) o2;
		return b1.getFdId().compareTo(b2.getFdId());
	}
});
%>
<p class="tab_img">
	<c:forEach var="sysAttMain" items="<%=attachments %>" varStatus="vsStatus">
		<c:if test="${sysAttMain.fdAttType=='pic'}">
			 <img width="100" height="75" src='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' ></img>
		</c:if>
	</c:forEach>
</p>
</c:if>
