<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
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
//得到文档状态，用于控制留痕按钮在发布状态中不显示
String docStatus = null;
try{
docStatus = (String)org.apache.commons.beanutils.PropertyUtils.getProperty(formBean,"docStatus");
pageContext.setAttribute("_docStatus", docStatus);
}catch(Exception e){}

//得到文档标题,下载时取文档标题
String fileName= null;
try{
	String docSubject = (String)org.apache.commons.beanutils.PropertyUtils.getProperty(formBean,"docSubject"); 
	if(StringUtil.isNotNull(docSubject)){
		fileName = docSubject;
	}else{
		String fdName = (String)org.apache.commons.beanutils.PropertyUtils.getProperty(formBean,"fdName"); 
		if(StringUtil.isNotNull(fdName)){
			fileName = fdName;
		}
	}
	pageContext.setAttribute("_fileName", fileName);
}catch(Exception e){}

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
<c:set var="fdFileName" value="${_fileName}"/>
<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
	<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
	<c:if test="${empty _fileName}">
	  <c:set var="fdFileName" value="${sysAttMain.fdFileName}"/>
	</c:if>
	<c:set var="fdAttMainId" value="${sysAttMain.fdId}" scope="request"/>
</c:forEach>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<c:choose>
	<c:when test="${param.isShowImg}">
	   <%
	   //取fdAttMainId的值判断附件是否已经转换
	   if(JgWebOffice.isExistViewPath(request)){ 
	  %>
		    <%
			   boolean isExpand = "true".equals(request.getParameter("isExpand"));
			   if(isExpand){
		    %>
			   <iframe width="100%" height="100%" src='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${attachmentId}&viewer=aspose_htmlviewer&showAllPage=true"/>'
						frameborder="0" scrolling="no">
			   </iframe>
			 <%}else{ %>
			     <ui:event event="show">
			  	  document.getElementById('IFrame_Content').src = ("<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${attachmentId}&viewer=aspose_htmlviewer&showAllPage=true"/>");
			     </ui:event>
				 <iframe id="IFrame_Content" width="100%" height="100%"
						frameborder="0" scrolling="no">
				 </iframe>
			<%} %>	 
	 <%}else{ 
		 boolean showAsJG = !"false".equals(request.getParameter("showAsJG"));
		  if(showAsJG){
	 %>
           <%@ include file="sysAttMain_viewinclude.jsp"%>
         <%} %> 
	 <%} %>
	</c:when>
	<c:otherwise>
        <%@ include file="sysAttMain_viewinclude.jsp"%>
    </c:otherwise>
</c:choose>