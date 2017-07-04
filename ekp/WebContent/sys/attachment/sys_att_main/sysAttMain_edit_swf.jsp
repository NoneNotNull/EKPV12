<%@page import="com.landray.kmss.sys.attachment.util.SysAttUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.List,com.landray.kmss.util.StringUtil,com.landray.kmss.util.ResourceUtil,com.landray.kmss.util.SpringBeanUtil,com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm,com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<c:set var="fdKey" value="${param.fdKey}" />
<%-- 附件${fdKey}开始 --%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("swf_attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<%
	Object formBean = null;
	String fromBeanVar = "org.apache.struts.taglib.html.BEAN";
	String formBeanName = request.getParameter("formBeanName");
	//记录旧的formBean,主要是避免当前界面中对于formBean的修改，影响后续的使用
	Object originFormBean = pageContext.getAttribute(fromBeanVar);
	if(StringUtil.isNotNull(formBeanName)){
		formBean = pageContext.findAttribute(formBeanName);
	}else{
		formBean = pageContext.findAttribute(fromBeanVar);
	}
	//设置使用的formBean对象
	pageContext.setAttribute(fromBeanVar, formBean);
	pageContext.setAttribute("_formBean", formBean);
%>
<c:set var="attForms" value="${_formBean.attachmentForms[fdKey]}" /> 
<div id="_List_${param.fdKey}_Attachment_Table">
	<html:hidden property="attachmentForms.${fdKey}.fdModelId" />
	<html:hidden property="attachmentForms.${fdKey}.extParam"    value="${param.extParam }" />
	<html:hidden property="attachmentForms.${fdKey}.fdModelName" value="${param.fdModelName }" />
	<html:hidden property="attachmentForms.${fdKey}.fdKey"		 value="${param.fdKey }" />
	<html:hidden property="attachmentForms.${fdKey}.fdAttType"	 value="${param.fdAttType }" />
	<html:hidden property="attachmentForms.${fdKey}.fdMulti"	 value="${param.fdMulti }" />
	<html:hidden property="attachmentForms.${fdKey}.deletedAttachmentIds" />
	<html:hidden property="attachmentForms.${fdKey}.attachmentIds" />
</div> 
<%-- 附件列表展现区 --%>
<div id="attachmentObject_${fdKey}_content_div"></div>
<script type="text/javascript">
	//是否启用大附件
	var supportLarge = <%=SysAttUtil.isSupportAttLarge()?"true":"false"%>;
	<c:if test="${param.fdSupportLarge!=null && param.fdSupportLarge!=''}">
		supportLarge = ${param.fdSupportLarge};
	</c:if>
	 var attachmentObject_${fdKey} = new Swf_AttachmentObject("${fdKey}","${param.fdModelName}","${param.fdModelId}","${param.fdMulti}","${param.fdAttType}","edit",supportLarge,"${param.enabledFileType}");
	 //扩展信息
	 <c:if test="${not empty param.extParam}">
	 	attachmentObject_${fdKey}.extParam = "${param.extParam}";
	 </c:if>
	//参数设置
	 <c:if test="${param.fdImgHtmlProperty!=null && param.fdImgHtmlProperty!=''}">
	 	attachmentObject_${fdKey}.fdImgHtmlProperty = "${param.fdImgHtmlProperty}";
	 </c:if>
	 <c:if test="${param.fdShowMsg!=null && param.fdShowMsg!=''}">
	 	attachmentObject_${fdKey}.fdShowMsg = ${param.fdShowMsg};
	 </c:if> 
	 <c:if test="${param.showDefault!=null && param.showDefault!=''}">
		attachmentObject_${fdKey}.showDefault = ${param.showDefault};
	 </c:if>
	 <c:if test="${param.buttonDiv!=null && param.buttonDiv!=''}">
		attachmentObject_${fdKey}.buttonDiv = "${param.buttonDiv}";
	 </c:if>
	 <c:if test="${param.isTemplate!=null && param.isTemplate!=''}">
		attachmentObject_${fdKey}.isTemplate = ${param.isTemplate};
	 </c:if>
	 <c:if test="${param.fdRequired!=null && param.fdRequired!=''}">
		attachmentObject_${fdKey}.required = ${param.fdRequired};
	 </c:if>
	 <c:if test="${param.enabledFileType!=null && param.enabledFileType!=''}">
		attachmentObject_${fdKey}.enabledFileType = "${param.enabledFileType}";
	 </c:if> 
	 //是否选择附件后马上上传
	 <c:if test="${param.uploadAfterSelect!=null && param.uploadAfterSelect!=''}">
		attachmentObject_${fdKey}.uploadAfterSelect= ${param.uploadAfterSelect};
	 </c:if>
	//设置宽高
	 <c:if test="${param.width!=null && param.width!=''}">
	 	attachmentObject_${fdKey}.width = "${param.width}";	
	 </c:if>	
	 <c:if test="${param.height!=null && param.height!=''}">
	 	attachmentObject_${fdKey}.height = "${param.height}";	
	 </c:if>
	 <c:if test="${param.proportion!=null && param.proportion!=''}">
	 	attachmentObject_${fdKey}.proportion = "${param.proportion}";	
	 </c:if>
	 <c:if test="${not empty param.fdViewType}">
		attachmentObject_${fdKey}.setFdViewType("${param.fdViewType}");
	 </c:if>
	 <%-- 
	//是否开启flash在线预览
	<c:if test="<%=SysAttSwfUtils.isSwfEnabled()%>">
		attachmentObject_${fdKey}.isSwfEnabled = true;
		attachmentObject_${fdKey}.resetReadFile(".doc;.xls;.ppt;.docx;.xlsx;.pptx;.pdf");
	</c:if>
	--%>
	//是否启用PDF控件
	<c:if test="<%=JgWebOffice.isJGPDFEnabled()%>">
		attachmentObject_${fdKey}.appendReadFile("pdf");
	</c:if>
	//设置常用附件的最大限制
	<c:if test='<%=StringUtil.isNotNull(ResourceUtil.getKmssConfigString("sys.att.smallMaxSize"))%>'>
		attachmentObject_${fdKey}.setSmallMaxSizeLimit(<%=ResourceUtil.getKmssConfigString("sys.att.smallMaxSize")%>);
	</c:if>
	//设置图片附件的最大限制
	<c:if test='<%=StringUtil.isNotNull(ResourceUtil.getKmssConfigString("sys.att.imageMaxSize"))&& "pic".equals(request.getParameter("fdAttType"))%>'>
		attachmentObject_${fdKey}.setSmallMaxSizeLimit(<%=ResourceUtil.getKmssConfigString("sys.att.imageMaxSize")%>);
	</c:if>

	<%
		//以下代码用于附件上传刷新后时，页面中根据附件ID信息，或modelname，modelID，key展现附件
		AttachmentDetailsForm _attForms = (AttachmentDetailsForm)pageContext.getAttribute("attForms");
		if(_attForms!=null){
			try{
				ISysAttMainCoreInnerService sysAttMainService = (ISysAttMainCoreInnerService)SpringBeanUtil.getBean("sysAttMainService");
				String _attachmentIds = _attForms.getAttachmentIds();
				List sysAttList = _attForms.getAttachments();
				if(sysAttList.isEmpty()){
					if(StringUtil.isNotNull(_attachmentIds)){
						sysAttList = sysAttMainService.findByPrimaryKeys(_attachmentIds.split(";"));
					}else{
						String _modelName = request.getParameter("fdModelName");
						String _modelId = request.getParameter("fdModelId");
						String _key = request.getParameter("fdKey");
						if(StringUtil.isNotNull(_modelName) 
								&& StringUtil.isNotNull(_modelId) 
								&& StringUtil.isNotNull(_key)){
							sysAttList = sysAttMainService.findByModelKey(_modelName,_modelId,_key);
						}
					}
					if(sysAttList!=null && !sysAttList.isEmpty()){
						_attForms.getAttachments().addAll(sysAttList);
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	%>
	//填充附件信息
	<c:forEach items="${attForms.attachments}" var="sysAttMain"	varStatus="vstatus">
		attachmentObject_${fdKey}.addDoc("${sysAttMain.fdFileName}","${sysAttMain.fdId}",true,"${sysAttMain.fdContentType}","${sysAttMain.fdSize}","${sysAttMain.fdFileId}");
		<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
	</c:forEach>
	<c:if test="${param.fdPicContentWidth!=null && param.fdPicContentWidth!=''}">
		attachmentObject_${fdKey}.fdPicContentWidth = "${param.fdPicContentWidth}";
	</c:if>
	<c:if test="${param.fdPicContentHeight!=null && param.fdPicContentHeight!=''}">
		attachmentObject_${fdKey}.fdPicContentHeight = "${param.fdPicContentHeight}";
	</c:if>
	<c:if test="${param.fdLayoutType!=null && param.fdLayoutType!=''}">
		attachmentObject_${fdKey}.setFdLayoutType("${param.fdLayoutType}");
	</c:if>
	//权限设置
	<c:if test="${attachmentId!=null && attachmentId!=''}">
		attachmentObject_${fdKey}.canPrint=false;
		<kmss:auth
			requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=print&fdId=${attachmentId}"
			requestMethod="GET">
			attachmentObject_${fdKey}.canPrint=true;
		</kmss:auth>
		attachmentObject_${fdKey}.canDownload=false;	
		<kmss:auth	
			requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${attachmentId}"
					requestMethod="GET">
			attachmentObject_${fdKey}.canDownload=true;		
		</kmss:auth>
		attachmentObject_${fdKey}.canRead=false;
		<kmss:auth	
			requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=read&fdId=${attachmentId}"
					requestMethod="GET">
			attachmentObject_${fdKey}.canRead=true;		
		</kmss:auth>
		attachmentObject_${fdKey}.canCopy = false;	
		<kmss:auth	
			requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=copy&fdId=${attachmentId}"
					requestMethod="GET">
			attachmentObject_${fdKey}.canCopy = true;	
			<c:set var="canCopy" value="1"/>	
		</kmss:auth>
		attachmentObject_${fdKey}.canEdit = false;	
		<kmss:auth	
			requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=edit&fdId=${attachmentId}"
					requestMethod="GET">
			attachmentObject_${fdKey}.canEdit=true;
		</kmss:auth>
	</c:if>
	
	//页面加载完成后呈现附件界面
	<c:if test="${empty ____content____ }">
		Com_AddEventListener(window,"load", function() {
			attachmentObject_${fdKey}.show();
		});
	</c:if>
</script>
<!-- 判断是否处于content标签中--防止flash移动导致出错 -->
<c:if test="${not empty ____content____ }">
	<ui:event event="show">
		attachmentObject_${fdKey}.show();
	</ui:event>
</c:if>
<%-- 附件${fdKey}结束 --%>
<%
if(originFormBean != null){
	pageContext.setAttribute(fromBeanVar, originFormBean);
}
%>
