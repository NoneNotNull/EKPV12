<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:set var="validateAuth" value="false" />
<kmss:auth
	requestURL="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=delete&fdModelName=${param.fdModelName}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
	<c:set var="validateAuth" value="true" />
</kmss:auth>
<script type="text/javascript">
 
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}

function expandView() {
	if(document.all.disReview.style.display!=null && document.all.disReview.style.display!="") {
		document.all.disReview.style.display = "";
		document.all.viewsrc.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
		setParentDisFlag("disReview","true");
	}else{
		document.all.disReview.style.display = "none";
		document.all.viewsrc.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
		setParentDisFlag("disReview","false");
	}
	iframeAutoFit();
}

 function setParentDisFlag(elMidName,elValue){
 	var elName = "_"+elMidName+"DisFlag";
 	var el = parent.document.getElementById(elName);
 	el.value = elValue;
 }
 function resetDivDisplay(){
 	var imgNames = ["viewsrc"];
 	var divNames=["disReview"];
 	for(var i=0;i<imgNames.length;i++){
	 	var elName = "_"+divNames[i]+"DisFlag";
 		var el = parent.document.getElementById(elName);
 		var imgSrcObj = document.getElementById(imgNames[i]);
		var divSrcObj = document.getElementById(divNames[i]);
 		if(el.value=="true"){
 			divSrcObj.style.display = "";
			imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
 		}else{
 			divSrcObj.style.display = "none";
			imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
 		}
 	}
 }
 
 function iframeAutoFit(){
 	try{
 	// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
     } catch (ex){}
 }
 
 Com_AddEventListener(window,"load",function(){
 	 resetDivDisplay();
 	 iframeAutoFit();
 });
</script>
<style>
	.tdstyle {}
	.thstyle {background-image:url(${KMSS_Parameter_StylePath}icons/topTit_bg.png)}
</style>
<table cellspacing=5 width=100% width="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr valign="top">
		<td colspan="4" align="left"><bean:message bundle="sys-evaluation" key="sysEvaluationMain.evaluation.title" /> <img id="viewsrc"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" onclick="expandView()"
			style="cursor:pointer"><br>
		<hr width=100% align="left" style="border:1px dot #000000"></hr>
		</td>
	</tr>
	<tr>
		<td width="100%" align="center" id="disReview" style="display:none">
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
			<c:forEach items="${queryPage.list}" var="sysEvaluationMain"
				varStatus="vstatus">
				<tr>
					<td width="40%" class="thstyle"><c:out
						value="${sysEvaluationMain.fdEvaluator.fdName}" /></td>
					<td width=15% class="thstyle"><sunbor:enumsShow
						value="${sysEvaluationMain.fdEvaluationScore}"
						enumsType="sysEvaluation_Score" /></td>
					<td width=30% class="thstyle">
					<kmss:showDate value="${sysEvaluationMain.fdEvaluationTime}" type="datetime" />
					</td>
					<c:if
						test="${validateAuth=='true'}">
					<td width="10%" class="thstyle"><a href="#"
							onClick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do"/>?method=delete&isNews=yes&fdId=${sysEvaluationMain.fdId}&fdModelId=${sysEvaluationMain.fdModelId}&fdModelName=${sysEvaluationMain.fdModelName}','_self');"><bean:message
							key="button.delete" /></a></td>
					</c:if>
				</tr>
				<tr>
					<td colspan="4"><c:out
						value="${sysEvaluationMain.fdEvaluationContent}" /></td>
				</tr>
			</c:forEach>
		</table>
		<c:if test="${queryPage.totalrows ne 0 }">
			<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
		</c:if>
		</td>
	</tr>
</table>