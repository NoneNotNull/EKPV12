<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="org.apache.struts.taglib.TagUtils,com.landray.kmss.sys.attachment.forms.*,java.util.*"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="com.landray.kmss.sys.attachment.service.*"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= ResourceUtil.getLocaleStringByUser(request) %>";
</script>
<script>Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
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
if(formBean == null ){
	formBean = TagUtils.getInstance().lookup(pageContext,
			formBeanName, null);
	pageContext.setAttribute("_formBean", formBean);
}
String docStatus = null;
try{
docStatus = (String)org.apache.commons.beanutils.PropertyUtils.getProperty(formBean,"docStatus");
}catch(Exception e){}
if(docStatus==null) docStatus = "30";
pageContext.setAttribute("_docStatus", docStatus);

String templateBeanName = request.getParameter("templateBeanName");
Object templateBean = null;
if(templateBeanName!=null){
	templateBean = pageContext.getAttribute(templateBeanName);
	if(templateBean == null){
		templateBean = request.getAttribute(templateBeanName);
	}
	if(templateBean == null){
		templateBean = session.getAttribute(templateBeanName);
	}
	pageContext.setAttribute("_templateBean", templateBean);
}
String singleMaxSize = ResourceUtil.getKmssConfigString("sys.att.singMaxSize");
if(singleMaxSize==null || singleMaxSize.equals("")) singleMaxSize = "0";
String totalMaxSize = ResourceUtil.getKmssConfigString("sys.att.totalMaxSize");
if(totalMaxSize==null || totalMaxSize.equals("")) totalMaxSize = "0";
pageContext.setAttribute("_singleMaxSize", singleMaxSize);
pageContext.setAttribute("_totalMaxSize", totalMaxSize);
%>
<c:set var="fdKey" value="${param.fdKey}" />
<c:set var="attForms" value="${_formBean.attachmentForms[fdKey]}" />
<c:set var="fdTemplateKey" value="${param.fdTemplateKey}" />
<input id="attachmentKeyParam" type="hidden" name="attachmentKeyParam"  value="${param.fdKey}" />
<c:if test="${fdTemplateKey!=null && _templateBean!=null}">
	<c:set var="attTemplateForms" value="${_templateBean.attachmentForms[fdTemplateKey]}" />
</c:if>
<table class="tb_noborder">
<tr><td id="_button_${param.fdKey}_Attachment_TD"></td>
</tr>
</table>
<table id="_List_${param.fdKey}_Attachment_Table">
	<html:hidden property="attachmentForms.${fdKey}.fdModelId" />
	<html:hidden property="attachmentForms.${fdKey}.fdModelName"
		value="${param.fdModelName }" />
	<html:hidden property="attachmentForms.${fdKey}.fdKey"
		value="${param.fdKey }" />
	<html:hidden property="attachmentForms.${fdKey}.fdAttType"
		value="${param.fdAttType }" />
	<html:hidden property="attachmentForms.${fdKey}.fdMulti"
		value="${param.fdMulti }" />
	<html:hidden property="attachmentForms.${fdKey}.deletedAttachmentIds" />
	<html:hidden property="attachmentForms.${fdKey}.attachmentIds" />
<c:if test="${param.fdAttType != 'pic' && param.fdAttType!='office'}">
	<tr>
		<td class="td_normal_title">&nbsp;</td>
		<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdFileName" /></td>
		<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdSize" /></td>
		<%--<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdContentType" /></td>--%>
		<td></td>
	</tr>
</c:if>
</table>
<script type="text/javascript">
 var attachmentObject_${fdKey} = new  AttachmentObject("${fdKey}","${param.fdModelName}","${param.fdModelId}","${param.fdMulti}","${param.fdAttType}","edit");
 <c:if test="${param.fdImgHtmlProperty!=null && param.enabledFileType!=''}">
 	attachmentObject_${fdKey}.fdImgHtmlProperty = "${param.fdImgHtmlProperty}";
 </c:if>
 <c:if test="${param.fdShowMsg!=null && param.fdShowMsg!=''}">
 	attachmentObject_${fdKey}.fdShowMsg = ${param.fdShowMsg};
 </c:if> 
 <c:if test="${param.showDefault!=null && param.showDefault!=''}">
	attachmentObject_${fdKey}.showDefault= ${param.showDefault};
 </c:if>
 <c:if test="${param.uploadAfterSelect!=null && param.uploadAfterSelect!=''}">
	attachmentObject_${fdKey}.uploadAfterSelect= ${param.uploadAfterSelect};
 </c:if>
 <c:if test="${param.buttonDiv!=null && param.buttonDiv!=''}">
	attachmentObject_${fdKey}.buttonDiv= "${param.buttonDiv}";
 </c:if>
 <c:if test="${param.isTemplate!=null && param.isTemplate!=''}">
	attachmentObject_${fdKey}.isTemplate= ${param.isTemplate};
 </c:if>
 <c:if test="${param.enabledFileType!=null && param.enabledFileType!=''}">
	attachmentObject_${fdKey}.enabledFileType = "${param.enabledFileType}";
 </c:if>  
 <c:if test="${_docStatus == '20'}">
	attachmentObject_${fdKey}.showRevisions = true;
</c:if>
attachmentObject_${fdKey}.setSingleMaxSize("${_singleMaxSize}");
attachmentObject_${fdKey}.setTotalMaxSize("${_totalMaxSize}");
 <%
	//synchronize deletedAttachmentIds,attachmentIds and attachments
	AttachmentDetailsForm _attForms = (AttachmentDetailsForm)pageContext.getAttribute("attForms");
	if(_attForms != null){
		try{
			List attachments = _attForms.getAttachments();
			int size = attachments.size();
			String _deleteAttachmentIds = _attForms.getDeletedAttachmentIds();
			String _attachmentIds = _attForms.getAttachmentIds();
			String[] attachmentIds = _attachmentIds==null?new String[]{}:_attachmentIds.split(";");
			String[] deleteAttachemntIds = _deleteAttachmentIds==null?new String[]{}:_deleteAttachmentIds.split(";");
			List attachmentIdsList = Arrays.asList(attachmentIds);
			//List deleteAttachemntIdsList = Arrays.asList(deleteAttachemntIds);
			List l_ids = new ArrayList();
			for(int i=0;i<attachmentIdsList.size();i++){
				String id = attachmentIdsList.get(i).toString();
				if(id != null && id.trim().length()>0)
					l_ids.add(attachmentIdsList.get(i).toString());
				
			}
			String[] _ids = (String[])l_ids.toArray(new String[l_ids.size()]);
			ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
		
			ISysAttMainCoreInnerService sysAttMainService = (ISysAttMainCoreInnerService)ctx.getBean("sysAttMainService");
			List sysAttMains=sysAttMainService.findByPrimaryKeys(_ids);
			for(Iterator it=sysAttMains.iterator();it.hasNext();){
				Object _obj = it.next();
				if(_attForms.getAttachments().contains(_obj))
					continue;
				_attForms.getAttachments().add(_obj);
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	%>
<c:set var="attachmentId" value=""/>
<c:set var="fdFileName" value=""/>	
<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
		attachmentObject_${fdKey}.addDoc("${sysAttMain.fdFileName}","${sysAttMain.fdId}",true,"${sysAttMain.fdContentType}","${sysAttMain.fdSize}");
		<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
		<c:set var="fdFileName" value="${sysAttMain.fdFileName}"/>
</c:forEach>
<c:if test="${not empty attachmentId}">
	<%-- 自定义表单中，附件权限区域可编辑情况下，如果没有主文档编辑权限不显示编辑按钮 --%>
	<c:set var="attCanEdit" value="false" />
	<kmss:auth requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=edit&fdId=${attachmentId}" requestMethod="GET">
		<c:set var="attCanEdit" value="true" />
	</kmss:auth>
	<c:if test="${'false' == attCanEdit}">
		attachmentObject_${fdKey}.canEdit = false;
	</c:if>
</c:if>
//是否开启pdf控件
<c:if test="<%=JgWebOffice.isJGPDFEnabled()%>">
attachmentObject_${fdKey}.appendReadFile("pdf");
</c:if>
Com_AddEventListener(window,"load", function() {
	attachmentObject_${fdKey}.show();
});
//-->
</script>
	<c:set var="editMode" value="2"/>
	<c:set var="trackRevisions" value="1"/>
	<c:if test="${param.editMode!=null}">
		<c:set var="editMode" value="${param.editMode}"/>
	</c:if>
	<c:set var="templateId" value=""/>
	<c:if test="${attachmentId==''}">
		<c:if test="${param.templateId!=null}">
			<c:set var="templateId" value="${param.templateId}"/>
		</c:if>
		<c:if test="${attTemplateForms!=null}">	
			<c:if test="${attTemplateForms.attachments!=null && fn:length(attTemplateForms.attachments) > 0}">						
				<c:set var="templateId" value="${attTemplateForms.attachments[0].fdId}"/>
			</c:if>
		</c:if>
	</c:if>
	<c:if test="${empty _docStatus || _docStatus=='10'}">
		<c:set var="trackRevisions" value="0"/>
	</c:if>
	<%-- 当文档状态为待审时默认显示留痕 --%>
	<c:if test="${_docStatus=='20'}">
		<c:set var="showRevisions" value="1"/>
	</c:if>
	<c:import url="/sys/attachment/sys_att_main/sysAttMain_OCX.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="${fdKey}" />
		<c:param name="fdAttType" value="${param.fdAttType}" />
		<c:param name="fdModelId" value="${param.fdModelId}" />
		<c:param name="fdModelName" value="${param.fdModelName}" />
		<c:param name="templateId" value="${templateId}" />
		<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
		<c:param name="docStatus" value="${_docStatus}" />
		<c:param name="editMode" value="${editMode}" />		
		<c:param name="attachmentId" value="${attachmentId}" />
		<c:param name="fdFileName" value="${fdFileName}" />
		<c:param name="trackRevisions" value="${trackRevisions}" />
		<c:param name="canPrint" value="1" />
		<c:param name="bookMarks" value="${param.bookMarks}" />
		<c:param name="width" value="${param.picWidth}" />
		<c:param name="height" value="${param.picHeight}" />
		<c:param name="proportion" value="${param.proportion}" />
		
		<c:param name="showRevisions" value="${showRevisions}" />
	</c:import>	  
<%
if(originFormBean != null){
	pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", originFormBean);
}
%>

