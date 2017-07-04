<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<link href="<c:url value="/sys/relation"/>/resource/sidebar/sideBox.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div id="relation_div">
		<c:if test="${queryPage.totalrows<=0}">
			<bean:message key="sysRelationMain.noData" bundle="sys-relation" />
		</c:if>
		<c:if test="${queryPage.totalrows>0}">
			<ul class="docList">
				<c:forEach items="${queryPage.list}" var="relationMap" varStatus="vstatus">
					<li>
						<a href="<c:url value="${relationMap['linkUrl']}" />" target="_blank" title="${relationMap['docSubject']}">
							${relationMap['docSubject']}
							<span class="colorGray">${relationMap['docCreateInfo']}</span>
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
		var img = parent.document.getElementById("${param.imgId}");
		img.style.display = "none";
		// 调整高度
		if(window!=parent){
    		var arguObj = document.getElementById("relation_div");
    		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
				window.frameElement.style.height = arguObj.offsetHeight+ 20 + "px";
			}
         }
		var iframeId = "${param.iframeId}";
		parent.document.getElementById(iframeId).style.display = "block";
		setTimeout(dyniFrameSize,50);
	} catch(e) {
		
	}
}

window.onload = function(){
	dyniFrameSize();
}

</script>