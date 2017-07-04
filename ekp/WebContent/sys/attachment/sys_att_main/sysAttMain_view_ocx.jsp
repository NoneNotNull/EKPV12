<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="org.apache.struts.taglib.TagUtils"%>
<%@ page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<script>Com_IncludeFile("rightmenu.js");</script>
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
}catch(Exception e){}
pageContext.setAttribute("_docStatus", docStatus);
Object originFormBean = pageContext.getAttribute("org.apache.struts.taglib.html.BEAN");
pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", formBean);
if(formBean == null ){
	formBean = TagUtils.getInstance().lookup(pageContext,
			formBeanName, null);
	pageContext.setAttribute("_formBean", formBean);
}
%>
<c:if test="${empty param.fdModelId}">
	<c:set var="fdKey" value="${param.fdKey}" />
	<input id="attachmentKeyParam" type="hidden" name="attachmentKeyParam"  value="${param.fdKey}" />
</c:if>
<c:if test="${not empty param.fdModelId}">
	<c:set var="fdKey" value="${param.fdKey}_${param.fdModelId}" />
	<input id="attachmentKeyParam" type="hidden" name="attachmentKeyParam"  value="${fdKey}" />
</c:if>
<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />

<table class="tb_noborder">
<tr><td id="_button_${fdKey}_Attachment_TD"></td>
</tr>
</table>
<table id="_List_${fdKey}_Attachment_Table">
	<c:if test="${param.fdAttType != 'pic'  && param.fdAttType!='office' }">
		<c:if test="${not empty attForms.attachments}">
		<tr>
			<td class="td_normal_title">&nbsp;</td>
			<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdFileName" /></td>
			<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdSize" /></td>
			<%--<td class="td_normal_title"><bean:message bundle="sys-attachment" key="sysAttMain.fdContentType" /></td>--%>
			<td></td>
		</tr>		
		</c:if>
	</c:if>
</table>
<script type="text/javascript">
var attachmentObject_${fdKey} = new  AttachmentObject("${fdKey}","${param.fdModelName}","${param.fdModelId}","${param.fdMulti}","${param.fdAttType}","view");
<c:set var="attachmentId" value=""/>
<c:set var="fdFileName" value=""/>	
<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
	attachmentObject_${fdKey}.addDoc("${sysAttMain.fdFileName}","${sysAttMain.fdId}",true,"${sysAttMain.fdContentType}","${sysAttMain.fdSize}");
	<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
	<c:set var="fdFileName" value="${sysAttMain.fdFileName}"/>
</c:forEach>
 <c:if test="${param.fdImgHtmlProperty!=null && param.fdImgHtmlProperty!=''}">
 	attachmentObject_${fdKey}.fdImgHtmlProperty = "${param.fdImgHtmlProperty}";
 </c:if>
 <c:if test="${param.fdShowMsg!=null && param.fdShowMsg!=''}">
 	attachmentObject_${fdKey}.fdShowMsg = ${param.fdShowMsg};
 </c:if> 
 <c:if test="${param.showDefault!=null && param.showDefault!='' }">
	attachmentObject_${fdKey}.showDefault= ${param.showDefault};
 </c:if>
 <c:if test="${param.buttonDiv!=null && param.buttonDiv!=''}">
	attachmentObject_${fdKey}.buttonDiv= "${param.buttonDiv}";
 </c:if>
 <c:if test="${param.isTemplate!=null && param.isTemplate!=''}">
	attachmentObject_${fdKey}.isTemplate= ${param.isTemplate};
 </c:if>
//得到文档状态，用于控制留痕按钮在发布状态中不显示
<c:if test="${_docStatus=='30'}">
	attachmentObject_${fdKey}.hiddenRevisions=false;
 </c:if>
<c:if test="${attachmentId!=null && attachmentId!=''}">
<kmss:auth
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=print&fdId=${attachmentId}"
	requestMethod="GET">
	attachmentObject_${fdKey}.canPrint=true;
	<c:set var="canPrint" value="1"/>			
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${attachmentId}"
			requestMethod="GET">
	attachmentObject_${fdKey}.canDownload=true;		
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=read&fdId=${attachmentId}"
			requestMethod="GET">
	attachmentObject_${fdKey}.canRead=true;		
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=copy&fdId=${attachmentId}"
			requestMethod="GET">
	attachmentObject_${fdKey}.canCopy=true;	
	<c:set var="canCopy" value="1"/>	
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=edit&fdId=${attachmentId}"
			requestMethod="GET">
	attachmentObject_${fdKey}.canEdit=true;
</kmss:auth>
</c:if>

Com_AddEventListener(window,"load", function() {
	attachmentObject_${fdKey}.show();
});
<%--
//是否开启flash在线预览
<c:if test="<%=SysAttSwfUtils.isSwfEnabled()%>">
	attachmentObject_${fdKey}.isSwfEnabled = true;
	attachmentObject_${fdKey}.resetReadFile(".doc;.xls;.ppt;.docx;.xlsx;.pptx;.pdf");
</c:if>
--%>
//是否开启pdf控件
<c:if test="<%=JgWebOffice.isJGPDFEnabled()%>">
attachmentObject_${fdKey}.appendReadFile("pdf");
</c:if>
</script>
	<c:set var="editMode" value="3"/>
	<c:if test="${param.editMode!=null}">
		<c:set var="editMode" value="${param.editMode}"/>
	</c:if>	
	<c:import url="/sys/attachment/sys_att_main/sysAttMain_OCX.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="${fdKey}" />
		<c:param name="fdAttType" value="${param.fdAttType}" />
		<c:param name="fdModelId" value="${param.fdModelId}" />
		<c:param name="fdModelName" value="${param.fdModelName}" />
		<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
		<c:param name="docStatus" value="${param.docStatus}" />
		<c:param name="editMode" value="${editMode}" />
		<c:param name="attachmentId" value="${attachmentId}" />
		<c:param name="fdFileName" value="${fdFileName}" />
		<c:param name="canPrint" value="${canPrint}" />
		<c:param name="canCopy" value="0" />
		<c:param name="Mode" value="${param.Mode}" />
	</c:import>
<%
if(originFormBean != null){
	pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", originFormBean);
}
%>