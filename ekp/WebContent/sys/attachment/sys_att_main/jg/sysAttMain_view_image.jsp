<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
	Com_IncludeFile("jquery.js");
</script>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%
	if (JgWebOffice.isExistFile(request)) {
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
<%-- 正文图片存在 --%>
<div id="optButtonDiv" style="text-align: right"></div>
<iframe id="IFrame_Content"
	src="<c:url value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdModelId}"/>" width="100%" height="100%"
	onload = "javascript:iFrameAutoHeight('IFrame_Content')" frameborder="0" scrolling="no">
</iframe>
<%-- 
//下载时通过金格控件对象设置正文为只读，而图片状态下控件对象为空，所以图片状态下不显示下载和打印按钮，
<c:if test="${not empty attachmentId}">
<script>
	var optBarObj = document.getElementById("optButtonDiv");
	var blank = document.createElement("SPAN");
	blank.innerHTML = "&nbsp;&nbsp;";
	//打印按钮
	<kmss:auth requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=print&fdId=${attachmentId}" requestMethod="GET">
		var _printButton = document.createElement("input");
		_printButton.setAttribute("type","button");
		_printButton.className="btnopt";
		_printButton.value = Attachment_MessageInfo["button.print"];
		_printButton.setAttribute("name","printButton");
		_printButton.onclick = function() {
			Com_OpenWindow('<c:url value="/sys/attachment/sys_att_main/sysAttMain.do"/>?method=print&fdId=${attachmentId}','_blank');
		};
		optBarObj.insertBefore(_printButton,optBarObj.firstChild);
		optBarObj.insertBefore(blank,optBarObj.firstChild);  
	</kmss:auth>
	// 下载
	<kmss:auth requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${attachmentId}" requestMethod="GET">
		var _downloadButton =  document.createElement("input");
		_downloadButton.setAttribute("type","button");
		_downloadButton.className="btnopt";
		_downloadButton.value = Attachment_MessageInfo["button.download"];
		_downloadButton.setAttribute("name","downloadButton");
		_downloadButton.onclick = function() {
			Com_OpenWindow('<c:url value="/sys/attachment/sys_att_main/sysAttMain.do"/>?method=download&fdId=${attachmentId}','_blank');
		};
		optBarObj.insertBefore(_downloadButton,optBarObj.firstChild);
	</kmss:auth>
</script>
</c:if>
 --%>
<script>

	function iFrameAutoHeight(iframeId) {
		var ifm = document.getElementById(iframeId);
		var subWeb = ifm.contentWindow ? ifm.contentWindow.document: ifm.contentDocument;
		if (ifm != null && subWeb != null) {
			html = subWeb.documentElement, 
		    body = subWeb.body;
			ifm.height = Math.max( body.scrollHeight,html.scrollHeight);
		}
	}
</script>

<%-- 正文图片不存在 --%>
<%
	} else {
%>
<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_view.jsp"
	charEncoding="UTF-8">
	<c:param name="fdKey" value="${param.fdKey}" />
	<c:param name="fdAttType" value="${param.fdAttType}" />
	<c:param name="fdModelId" value="${param.fdModelId}" />
	<c:param name="fdModelName" value="${param.fdModelName}" />
	<c:param name="formBeanName" value="${param.formBeanName}" />
</c:import>
<%
	}
%>