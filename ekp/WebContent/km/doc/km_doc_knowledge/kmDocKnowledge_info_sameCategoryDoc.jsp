<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<link href="<c:url value="/km/doc"/>/resource/style/sidebar/sideBox.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="contentDiv">
	<c:if test="${queryPage.totalrows<=0}">
		<bean:message bundle="km-doc" key="km.doc.result.notData"/>
	</c:if>
	<c:if test="${queryPage.totalrows>0}">
		<ul class="docList">
			<c:forEach items="${queryPage.list}" var="kmDocKnowledge" varStatus="vstatus">
				<li>
					<a href="<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=view&fdId=${kmDocKnowledge.fdId}" />" target="_blank">
						<c:out value="${kmDocKnowledge.docSubject}" />
						<span class="colorGray">
							${kmDocKnowledge.docCreator.fdName}
							<kmss:showDate value="${kmDocKnowledge.docCreateTime}" type="date" />
						</span>
					</a>
				</li>
			</c:forEach>
		</ul>
	</c:if>
</div>
</body>
</html>
<script>
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById('contentDiv');
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch(e) {
	}
}
dyniFrameSize();
</script>