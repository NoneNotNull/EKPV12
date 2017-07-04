<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.List,com.landray.kmss.util.StringUtil,com.landray.kmss.util.ResourceUtil,com.landray.kmss.util.SpringBeanUtil,com.landray.kmss.util.UserUtil"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<c:if test="${empty param.fdModelId}">
	<c:set var="fdKey" value="${param.fdKey}" />
</c:if>
<c:if test="${not empty param.fdModelId}">
	<c:set var="fdKey" value="${param.fdKey}_${param.fdModelId}" />
</c:if>
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
<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="sysAttMains" value="${attForms.attachments}" />
<div id="attachmentObject_${fdKey}_content_div"></div>
<script type="text/javascript">
	var attachmentObject_${fdKey} = new  Swf_AttachmentObject("${fdKey}","${param.fdModelName}","${param.fdModelId}","${param.fdMulti}","${param.fdAttType}","view");
	<%
		//以下代码用于附件不通过form读取的方式
		List sysAttMains = (List)pageContext.getAttribute("sysAttMains");
		if(sysAttMains==null || sysAttMains.isEmpty()){
			try{
				String _modelName = request.getParameter("fdModelName");
				String _modelId = request.getParameter("fdModelId");
				String _key = request.getParameter("fdKey");
				if(StringUtil.isNotNull(_modelName) 
						&& StringUtil.isNotNull(_modelId) 
						&& StringUtil.isNotNull(_key)){
					ISysAttMainCoreInnerService sysAttMainService = (ISysAttMainCoreInnerService)SpringBeanUtil.getBean("sysAttMainService");
					sysAttMains = sysAttMainService.findByModelKey(_modelName,_modelId,_key);
				}
				if(sysAttMains!=null && !sysAttMains.isEmpty()){
					pageContext.setAttribute("sysAttMains",sysAttMains);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	%>
	//填充附件信息
	<c:forEach items="${sysAttMains}" var="sysAttMain"	varStatus="vstatus">
		attachmentObject_${fdKey}.addDoc("${sysAttMain.fdFileName}","${sysAttMain.fdId}",true,"${sysAttMain.fdContentType}","${sysAttMain.fdSize}","${sysAttMain.fdFileId}");
		<c:set var="attachmentId" value="${sysAttMain.fdId}"/>
	</c:forEach>
	<c:if test="${param.viewType!=null && param.viewType!=''}">
		//设置显示模式
		attachmentObject_${fdKey}.fdViewType="${param.viewType}";	
	</c:if>	
	<c:if test="${param.drawFunction!=null && param.drawFunction!=''}">
		//设置自定义列表显示函数
		attachmentObject_${fdKey}.drawFunction=${param.drawFunction};	
	</c:if>	
	<c:if test="${param.fdShowMsg !=null && param.fdShowMsg!=''}">
		//如果fdShowMsg参数为false,则默认不显示附件的信息
		attachmentObject_${fdKey}.fdShowMsg=${param.fdShowMsg};	
	</c:if>	
	<c:if test="${param.width!=null && param.width!=''}">
		//设置宽
		attachmentObject_${fdKey}.width="${param.width}";	
	</c:if>	
	<c:if test="${param.height!=null && param.height!=''}">
		//设置高
		attachmentObject_${fdKey}.height="${param.height}";	
	</c:if>
	<c:if test="${not empty param.fdViewType}">
		attachmentObject_${fdKey}.setFdViewType("${param.fdViewType}");
	</c:if>
	<c:if test="${param.fdImgHtmlProperty!=null && param.fdImgHtmlProperty!=''}">
		attachmentObject_${fdKey}.fdImgHtmlProperty="${param.fdImgHtmlProperty}";
	</c:if>
 
	<c:if test="<%=JgWebOffice.isJGPDFEnabled()%>">
		attachmentObject_${fdKey}.appendReadFile("pdf");
	</c:if>
	<c:if test='<%=StringUtil.isNotNull(ResourceUtil.getKmssConfigString("sys.att.smallMaxSize"))%>'>
		attachmentObject_${fdKey}.smallMaxSizeLimit = <%=ResourceUtil.getKmssConfigString("sys.att.smallMaxSize")%>;
	</c:if>
	<c:if test="${param.fdPicContentWidth!=null && param.fdPicContentWidth!=''}">
		attachmentObject_${fdKey}.fdPicContentWidth = "${param.fdPicContentWidth}";
	</c:if>
	<c:if test="${param.fdPicContentHeight!=null && param.fdPicContentHeight!=''}">
		attachmentObject_${fdKey}.fdPicContentHeight = "${param.fdPicContentHeight}";
	</c:if>
	<c:if test="${param.fdLayoutType!=null && param.fdLayoutType!=''}">
		attachmentObject_${fdKey}.setFdLayoutType("${param.fdLayoutType}");
	</c:if>
 	<c:if test="${param.fdForceDisabledOpt!=null && param.fdForceDisabledOpt!=''}">
		attachmentObject_${fdKey}.forceDisabledOpt = '${param.fdForceDisabledOpt}';
 	</c:if>
	
	//权限设置
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

	Com_AddEventListener(window,"load", function() {
		attachmentObject_${fdKey}.show();
	});
</script>
<%
	if (originFormBean != null) {
		pageContext.setAttribute("org.apache.struts.taglib.html.BEAN",
				originFormBean);
	}
%>