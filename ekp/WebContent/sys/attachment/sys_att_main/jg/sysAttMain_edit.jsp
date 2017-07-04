<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="org.apache.struts.taglib.TagUtils,com.landray.kmss.sys.attachment.forms.*,java.util.*"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="com.landray.kmss.sys.attachment.service.*"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
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
String docStatus = null;
try{
	docStatus = (String)org.apache.commons.beanutils.PropertyUtils.getProperty(formBean,"docStatus");
}catch(Exception e){}
if(docStatus==null) docStatus = "30";
pageContext.setAttribute("_docStatus", docStatus);

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
%>
<c:set var="fdKey" value="${param.fdKey}" />
<c:set var="attForms" value="${_formBean.attachmentForms[fdKey]}" />
<table class="tb_noborder">
<tr><td id="_button_${param.fdKey}_JG_Attachment_TD"></td>
</tr>
</table>
<html:hidden property="attachmentForms.${param.fdKey}.fdModelId" />
<html:hidden property="attachmentForms.${param.fdKey}.fdModelName"
	value="${param.fdModelName}" />
<html:hidden property="attachmentForms.${param.fdKey}.fdKey"
	value="${param.fdKey}" />
<html:hidden property="attachmentForms.${param.fdKey}.fdAttType"
	value="${param.fdAttType}" />
<html:hidden property="attachmentForms.${param.fdKey}.fdMulti"
	value="${param.fdMulti}" />
<html:hidden property="attachmentForms.${param.fdKey}.deletedAttachmentIds" />
<html:hidden property="attachmentForms.${param.fdKey}.attachmentIds" />
<%@ include file="sysAttMain_OCX.jsp"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("jg_attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<%
	//synchronize deletedAttachmentIds,attachmentIds and attachments
	AttachmentDetailsForm _attForms = (AttachmentDetailsForm)pageContext.getAttribute("attForms");
	if(_attForms != null){
		try{
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
<c:set var="fdFileName" value="${_fileName}"/>	
<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
		<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
		<c:if test="${empty _fileName}">
		  <c:set var="fdFileName" value="${sysAttMain.fdFileName}"/>
		</c:if>
</c:forEach>
<script type="text/javascript">
var jg_attachmentObject_${param.fdKey} = new JG_AttachmentObject("${attachmentId}", "${param.fdKey}", "${param.fdModelName}", "${param.fdModelId}", "${param.fdAttType}", "edit");
jg_attachmentObject_${param.fdKey}.userName = "<%=com.landray.kmss.util.UserUtil.getUser().getFdName()%>";
<c:if test="${not empty param.isTemplate && param.isTemplate == 'true'}">
	jg_attachmentObject_${param.fdKey}.isTemplate = true;
</c:if>
<c:if test="${not empty param.fdTemplateModelId}">
	jg_attachmentObject_${param.fdKey}.fdTemplateModelId = "${param.fdTemplateModelId}";
</c:if>
<c:if test="${not empty param.fdTemplateModelName}">
	jg_attachmentObject_${param.fdKey}.fdTemplateModelName = "${param.fdTemplateModelName}";
</c:if>
<c:if test="${not empty param.fdTemplateKey}">
	jg_attachmentObject_${param.fdKey}.fdTemplateKey = "${param.fdTemplateKey}";
</c:if>
<c:if test="${not empty param.editMode}">
	jg_attachmentObject_${param.fdKey}.editMode = "${param.editMode}";
</c:if>
<c:if test="${not empty param.buttonDiv}">
	jg_attachmentObject_${param.fdKey}.buttonDiv = "${param.buttonDiv}";
</c:if>
<c:if test="${empty _docStatus || _docStatus == '10'}">
	jg_attachmentObject_${param.fdKey}.trackRevisions = false;
</c:if>
<c:if test="${not empty param.bookMarks}">
	jg_attachmentObject_${param.fdKey}.bookMarks = "${param.bookMarks}";
</c:if>
<c:if test="${_docStatus == '20'}">
jg_attachmentObject_${param.fdKey}.showRevisions = true;
</c:if>
<c:if test="${not empty param.forceRevisions}">
jg_attachmentObject_${param.fdKey}.forceRevisions = false;
</c:if>
<c:if test="${not empty param.bindSubmit}">
jg_attachmentObject_${param.fdKey}.bindSubmit = false;
</c:if>
<%--文档转图片页面--%>
<c:if test="${param.isToImg == 'true' and param.bindSubmit != 'false'}">
Com_Parameter.event["confirm"].push(function() {
	jg_attachmentObject_${param.fdKey}.ocxObj.Active(true);
	return jg_attachmentObject_${param.fdKey}.saveAsImage();
});
</c:if>
Com_AddEventListener(window, "load", function() {
	if("${param.fdAttType}" == "office") {
		setTimeout(function(){
			jg_attachmentObject_${param.fdKey}.load(encodeURIComponent("${fdFileName}"), "${param.officeType}");
			jg_attachmentObject_${param.fdKey}.show();
			jg_attachmentObject_${param.fdKey}.ocxObj.Active(true);
		},100)
	}
});
Com_AddEventListener(window, "unload", function() {
	jg_attachmentObject_${param.fdKey}.unLoad();
});
</script>