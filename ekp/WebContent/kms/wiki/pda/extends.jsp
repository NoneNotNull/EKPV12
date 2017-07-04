<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>	
<% if(PdaFlagUtil.checkClientIsPdaApp(request))
	request.setAttribute("isAppflag","1"); 
%>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<link href="${kmsBasePath }/wiki/pda/css/wiki_pda.css" rel="stylesheet" type="text/css" />
</head>
<c:set var="cardPicURL" value="${KMSS_Parameter_ContextPath }/kms/common/resource/theme/default/img/header_r.gif" />
<c:set var="attForms" value="${kmsWikiMainForm.attachmentForms['spic'] }" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="fdAttId" value="${sysAttMain.fdId }" />
		<c:set var="cardPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<body>
	<section>
		<c:if test="${not empty kmsWikiMainForm.extendFilePath }">
			<section class="list_summary pd_10">
				<h2 class="catalog"><bean:message bundle="kms-wiki" key="kmsWikiMain.docProperty"/></h2>
				<table width="100%">
					<c:import url="/sys/property/include/sysProperty_pda.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="isPda" value="true" />
					</c:import>
				</table>
			</section>
		</c:if>
		<c:if test="${not empty kmsWikiMainForm.fdDescription || not empty fdAttId}">
			<section class="list_summary pd_10">
				<h2 class="catalog"><bean:message bundle="kms-wiki" key="kmsWikiMain.docCard"/></h2>
				<section class="clear"></section>
				<section class="card_sec">
					<a href="javascript:;">
						<img src="${ cardPicURL}"/>
					</a>
				</section>
				<section>
					<span ><c:out value="${kmsWikiMainForm.fdDescription}"></c:out></span>			
				</section>
			</section>
		</c:if>
		<section class="clear"></section>
		
		<section class="div_doctext" id="div_doctext">
			<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="__index">
				<article>
					<h2 class="catalog"><c:out value="${kmsWikiCatelogForm.fdName}" /></h2>
					<section >${kmsWikiCatelogForm.docContent }</section>
				</article>
			</c:forEach>
		</section>
	</section>
</body>
</html>

<script>
// 移动端对图片大小进行自适应处理
(function() {
	var text = document.getElementById('div_doctext'),
		articles = text.getElementsByTagName('article');
	for (var i = 0; i < articles.length; i++) {
		var imgs = articles[i].getElementsByTagName('img');
		for (var j = 0; j < imgs.length; j++) {
			var img = imgs[j];
			var __style = img.getAttribute('style');
			if (/max-width/.test(__style))
				__style = __style.replace(/(?:max-width\s*:\s*)([^;]+)(?=;|$)/ig, 'max-width:100%');
			else
				__style += ";max-width:100%";
			if (/height/.test(__style))
				__style = __style.replace(/(?:height\s*:\s*)([^;]+)(?=;|$)/ig, '');
			img.setAttribute('style', __style);
		}
	}
}());

</script>