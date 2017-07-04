<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<title>${kmsWikiMainForm.docSubject}</title>
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_displayVersion_js.jsp"%>
</head>
<c:set var="cardPicURL" value="${kmsResourcePath }/theme/default/img/header_r.gif" />
<c:set var="attForms" value="${kmsWikiMainForm.attachmentForms['spic'] }" />
<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
	<c:if test="${vsStatus.first }">
		<c:set var="fdAttId" value="${sysAttMain.fdId }" />
		<c:set var="cardPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
	</c:if>
</c:forEach>
<body onscroll="scrollSyn()" style="overflow-x:hidden">
<div class="p_con" id="contentDiv">
<c:if test="${not empty kmsWikiMainForm.docCardContent}">
			<div class="compversion_edit_title">
				<h3>
					<a>词条名片</a>
				</h3>
			</div>
			<div class="summary" >
				<div class="summary1" >
					<a title="" class="compversion_img_f" href="javascript:void(0)" >
						<img id="cardPic" src="${cardPicURL }" onload="javascript:drawImage(this,this.parentNode)">
					</a>
				</div>
				<div class="compversion_content" >
					<p>${kmsWikiMainForm.docCardContent}</p>
				</div>
				<div class="clear"></div>
			</div>
</c:if>

<c:forEach
	items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm">
	<div class="edit_box">
	<div class="edit_title">
		<h2><a name="viewable_${kmsWikiCatelogForm.fdId}">${kmsWikiCatelogForm.fdName}</a></h2>
	</div>
	<div class="edit_page" valign="top">
		${kmsWikiCatelogForm.docContent}
	<div class="spctrl"></div>
	</div>
	</div>
	<!-- end edit_box -->
</c:forEach></div>
<!-- end p_con -->
<script>
	function scrollSyn() {
		var g = window.parent || window, arrIframe = g.document.frames, id;
		for ( var i = 0; i < arrIframe.length; i++) {
			if (window == arrIframe[i]) {
				id = g.document.getElementsByTagName('iframe')[i].id;
			}
		}
		if (id == 'right') {
			g.document.frames('left').document.body.scrollTop = g.document
					.frames('right').document.body.scrollTop;
		} else if (id == 'left') {
			g.document.frames('right').document.body.scrollTop = g.document
					.frames('left').document.body.scrollTop;

		}
	}
</script>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>