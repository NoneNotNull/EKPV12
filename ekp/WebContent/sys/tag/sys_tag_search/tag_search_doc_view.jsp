<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.sys.config.dict.SysDataDict,
	com.landray.kmss.sys.config.dict.SysDictModel" %> 
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<link href="<c:url value="/sys/tag"/>/resource/sidebar/sideBox.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="tag_search_div">
	<c:if test="${queryPage.totalrows<=0}">
		<bean:message key="sysTag.search.result.notData" bundle="sys-tag" />
	</c:if>
	<c:if test="${queryPage.totalrows>0}">
		<ul class="docList">
			<c:forEach items="${queryPage.list}" var="sysTagMain" varStatus="vstatus">
				<c:set var="fdModelId" value="${sysTagMain.fdModelId }"/>
			 	<c:set var="fdModelName" value="${sysTagMain.fdModelName }"/>
				 <%
				 	SysDictModel sysDictModel = SysDataDict.getInstance().getModel((String)pageContext.getAttribute("fdModelName"));
				 	String url = "";
				 	if(sysDictModel != null && sysDictModel.getUrl()!=null){
					 	url = sysDictModel.getUrl();
					 	url=url.substring(0,url.length()-7)+(String)pageContext.getAttribute("fdModelId");
				 	}
				 %>
				<li>
					<a href="${path}<%=url %>" target="_blank">
						${sysTagMain.docSubject}
						<span class="colorGray">
							${sysTagMain.docCreator.fdName}
							<kmss:showDate value="${sysTagMain.docCreateTime}" type="date" />
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
// 自适应高度
function dyniFrameSize(){
	if(window!=parent){
		var arguObj = document.getElementById("tag_search_div");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = arguObj.offsetHeight + 40 + "px";
		}
    }
}
dyniFrameSize();
</script>