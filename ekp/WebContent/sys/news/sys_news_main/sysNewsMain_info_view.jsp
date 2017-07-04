<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/info_view_top.jsp"%>
<link rel=stylesheet href="<c:url value="/sys/news/resource/style/${sysNewsMainForm.fdStyle}/document.css" />">
<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
	charEncoding="UTF-8">
	<c:param name="fdSubject" value="${sysNewsMainForm.docSubject}" />
	<c:param name="fdModelId" value="${sysNewsMainForm.fdId}" />
	<c:param name="fdModelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
</c:import>
<script>
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
function locationTop() {
		var url = location.href;
		if(url.lastIndexOf("#")==url.length-1){
			location = url;
		}else{
			location = url + "#";
		}
}
var a = 1;
function ZoomContent(zoomValue) {
	var z = document.getElementById("contentDiv").style.zoom;
	if (z==null || z == "") { z = 1.0;}
	if (typeof z == 'string') z = parseFloat(z);
	$(document.getElementById("contentDiv")).css({
     zoom:z+zoomValue
	});
	//兼容谷歌和火狐放大缩小
	$(document.getElementById("mainDiv")).css("-moz-transform-origin",'left top');
	$(document.getElementById("mainDiv")).css("-moz-transform",'scale('+parseFloat(a+zoomValue)+')');
	$(document.getElementById("mainDiv")).css("-webkit-transform-origin",'left top');
	$(document.getElementById("mainDiv")).css("-webkit-transform",'scale('+parseFloat(a+zoomValue)+')');
	a=parseFloat(a+zoomValue);
}
function ResetContent(){
	$(document.getElementById("contentDiv")).css({
	     zoom:1
		});
	   //兼容谷歌和火狐放大缩小
		$(document.getElementById("mainDiv")).css("-moz-transform-origin",'left top');
		$(document.getElementById("mainDiv")).css("-moz-transform",'scale(1)');
		$(document.getElementById("mainDiv")).css("-webkit-transform-origin",'left top');
		$(document.getElementById("mainDiv")).css("-webkit-transform",'scale(1)');
		a=1;
}


<%-- 换用zoom实现

	function changeFont(size) {
		contentDiv.style.fontSize = size;
	}
	
	function SetFont(size) {
		var root = document.getElementById("contentDiv");
		if (! root) return;
		SetFontSize(root, size);
	}

	function SetFontSize(node, size) {
		if (node.nodeType == 1 && node.style) node.style.fontSize = size + "px";
		var cnodes = node.childNodes;
		for (var i = 0; i < cnodes.length; i ++) {
			SetFontSize(cnodes[i], size);
		}
	}
--%>
</script>
<kmss:windowTitle
	subject="${sysNewsMainForm.docSubject}"
	moduleKey="sys-news:news.moduleName" />
	
<div id="optBarDiv">
	<c:if test="${sysNewsMainForm.docStatus!='00' }">
		<kmss:auth
			requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=edit&fdId=${param.fdId}"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysNewsMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<kmss:auth
		requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=delete&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysNewsMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.more"/>"
		onclick="Com_OpenWindow('sysNewsMain.do?method=view&fdId=${param.fdId}&more=true','_self');">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<center>
<div id="mainDiv">
	<!-- 模板 -->
	<div id="templateNameDiv">
		<c:out value="${sysNewsMainForm.fdTemplateName}" />
	</div>
	<!-- 其它信息 -->
	<div id="infoDiv">
		<bean:write name="sysNewsMainForm" property="fdAuthorName" />&nbsp;
		<%-- <bean:write name="sysNewsMainForm" property="docPublishTime" />&nbsp; --%>&nbsp;
		【<bean:message bundle="sys-news" key="font.zoom" />
		<a href="#" onclick="ZoomContent(0.2);"><bean:message key="font.zoom.big" bundle="sys-news" /></a>&nbsp;&nbsp;
		<a href="#" onclick="ZoomContent(-0.2);"><bean:message key="font.zoom.small" bundle="sys-news" /></a>&nbsp;&nbsp;
		<a href="#" onclick="ResetContent();"><bean:message key="font.zoom.original" bundle="sys-news" /></a>】
		<bean:message bundle="sys-news" key="sysNewsMain.docHits" />&nbsp;&nbsp;&nbsp;
		<c:out value="${sysNewsMainForm.docReadCount+1}" />
	</div>
	
	<!-- 标题 -->
	<c:if test="${sysNewsMainForm.fdIsHideSubject == false}">
		<div id="subjectDiv">
			<c:out value="${sysNewsMainForm.docSubject}" />
		</div>
		
		<!-- 来源 -->
		<c:if test="${sysNewsMainForm.fdNewsSource!=null}">
		<div id="sourceDiv">
			<c:out value="${sysNewsMainForm.fdNewsSource}" />
		</div>
		</c:if>
	</c:if>
	<c:if test="${not empty sysNewsMainForm.fdDescription}">
		<div id="docDescRange">
			<div class="top_l"></div><div class="top_r"></div><div class="but_l"></div><div class="but_r"></div>
			<div id="docDesc">
				<%-- 文档描述信息 --%>
				<h3><bean:message key="sysNewsMain.fdDescription" bundle="sys-news" /></h3>
				<p><kmss:showText value="${sysNewsMainForm.fdDescription}" /></p>
			</div>
		</div>
	</c:if>
	<!-- 内容 -->
	<div id="contentDiv">
		<c:choose>
		<c:when test="${not empty sysNewsMainForm.fdIsLink}">
			<bean:message bundle="sys-news" key="SysNewsMain.linkNews" />
			<a href='<c:url value="${sysNewsMainForm.fdLinkUrl}"/>'/>
				${sysNewsMainForm.docContent}
			</a>
		</c:when>
		<c:otherwise>
			<c:if test="${sysNewsMainForm.fdContentType=='rtf'}">
				${sysNewsMainForm.docContent}
			</c:if>
			<c:if test="${sysNewsMainForm.fdContentType=='word'}">
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){
					if (com.landray.kmss.sys.attachment.util.JgWebOffice.isExistFile(request)){%>
					<iframe id="IFrame_Content" src="<c:url value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdId}"/>" height=100% onload="resizeContentFrameWidth();" frameborder=0 scrolling="no" width="100%">
					</iframe>
					<script>
					$(document).ready(function (){
						var frame = document.getElementById("IFrame_Content");
						//获取所有a元素
						var elems = frame.contentWindow.document.getElementsByTagName("a");
						for(var i = 0;i<elems.length;i++){
							elems[i].setAttribute("target","_top");
						}
					});
						function resizeContentFrame(){
							try{
								var frame = document.getElementById("IFrame_Content");
								var tmpHeight = (frame.contentWindow.document.body.scrollHeight + 10 )+"px";
								document.getElementById("contentDiv").style.height = tmpHeight;
								frame.style.width = frame.contentWindow.document.body.scrollWidth + 20;
							}catch(e){
							}
						}
						function resizeContentFrameWidth(){
							setTimeout("resizeContentFrame();",100);
						}
					</script>
				<%  }
					else{%>
					${sysNewsMainForm.fdHtmlContent}
				<% }
				  } else { %>
					${sysNewsMainForm.fdHtmlContent}
				<%} %>
			</c:if>
		</c:otherwise>
		</c:choose>
	</div>
	<!-- 跳到顶部 -->
	<div id="toTopDiv">
		<a href="#" onclick="locationTop();return false;"><img
			src="<c:url value="/sys/news/resource/style/${sysNewsMainForm.fdStyle}/btn_top.gif" />"
			border="0" /></a>
	</div>
	<!-- 附件 -->
	<div id="attachmentDiv">
		<%-- 
		<c:set var="attachmentList" value="${sysNewsMainForm.attachmentForms['fdAttachment'].attachments }" />
		<c:if test="${not empty attachmentList}">
			&nbsp;<bean:message key="tip.news.download.attachment" bundle="sys-news"/>
			<c:forEach items="${attachmentList}" var="attachment" varStatus="vStatus">
				<br>${vStatus.index+1}.
				<a href="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${attachment.fdId}" />">${attachment.fdFileName}</a>
			</c:forEach>
		</c:if> --%>
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_link_view.jsp" charEncoding="UTF-8">
			<c:param name="fdMulti" value="true" />
			<c:param name="formBeanName" value="sysNewsMainForm" />
			<c:param name="fdKey" value="fdAttachment" />
		</c:import>
	</div>
	
	<div id="docEvalute">
		<%-- 文档点评 --%>
		<c:import url="/sys/evaluation/include/sysEvaluationMain_doc_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsMainForm" />
		</c:import>
	</div>
	
	<table id="Label_Tabel" width=100% LKS_LabelClass="info_view">
		<!-- 点评 -->
		<c:import url="/sys/evaluation/include/sysEvaluationMain_doc_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="sysNewsMainForm" />
		</c:import>
		<%-- 关联 --%>
		<tr
			LKS_LabelName="<bean:message bundle='sys-news' key='news.document.relation'/>">
			<c:set var="mainModelForm" value="${sysNewsMainForm}" scope="request" />
			<c:set var="currModelName"
				value="com.landray.kmss.sys.news.model.SysNewsMain" scope="request" />
			<c:set var="moduleModelName"
				value="com.landray.kmss.sys.news.model.SysNewsMain" scope="request" />
			<td><%@ include
				file="/sys/relation/include/sysRelationMain_view.jsp"%></td>
		</tr>
		
	</table>
</div>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
