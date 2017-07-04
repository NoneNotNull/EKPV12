<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link href="../resource/evaluation/evaluation.css" rel="stylesheet" type="text/css" />
<ul class="docList" id="docList">
<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {%>
	<center>
		<bean:message key="sysEvaluation.noData" bundle="sys-evaluation" />
	</center>
	</ul>
<%} else {%>
	<c:forEach items="${queryPage.list}" var="sysEvaluationMain" varStatus="vstatus">
		<li>
			<div id="evaluationContentDiv${vstatus.index}">
					<kmss:showText value="${sysEvaluationMain.fdEvaluationContent}" />
			</div>
			<span>
				${sysEvaluationMain.fdEvaluator.fdName}&nbsp;&nbsp;|&nbsp;&nbsp;
				<kmss:showDate value="${sysEvaluationMain.fdEvaluationTime}" />
			</span>
			<span class="evScoreList" title='<sunbor:enumsShow value="${sysEvaluationMain.fdEvaluationScore}" enumsType="sysEvaluation_Score" />'>
				<ul style="float: left;">
					<c:forEach var="indexVar" begin="0" end="4" step="1">
						<li class="${(indexVar<5-sysEvaluationMain.fdEvaluationScore)?'selected':'' }"></li>
					</c:forEach>
				</ul>
			</span>
		</li>
	</c:forEach>
</ul>
<!-- 翻页 -->
<%@ include file="/resource/jsp/pagenav.jsp"%>
<%@ include file="/resource/jsp/list_down.jsp"%>
<%}%>
<script>
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch(e) {
	}
}
Com_AddEventListener(window,"load",function(){
	dyniFrameSize();
});
</script>