<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css"> 
.onblur {color: #003048;text-decoration: none;padding: 2px;height: 20px;}
.onfocus {background-color: #FFFFCC;border: 1px solid gray #DFDFDF;color: #003048;text-decoration: none;padding: 2px;height: 20px;}
</style>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("data.js", null, "js");
//根据iframe里面内容高度，自动调整iframe窗口高度以及整个弹出窗口的高度
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("tb_relation_info");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch(e) {
	}
}
// 加载结果数据
function loadSysRelationEntiry(moduleModelId, fdType, fdModuleModelName,_this) {
	if (moduleModelId != null) {
		var url = '<c:url value="/sys/relation/relation.do" />'+'?method=result&currModelId=${param.currModelId}&currModelName=${param.currModelName}&fdKey=${param.fdKey}&sortType=time&fdType='+fdType+'&moduleModelId='+moduleModelId+'&moduleModelName='+fdModuleModelName+'&showCreateInfo=${param.showCreateInfo}';
		var iframe = document.getElementById("IF_sysRelation_content");
		iframe.setAttribute("src",encodeURI(url));
	}
	//设置A标签背景颜色
	var aTags = document.getElementsByName("relationModelName");
	if(_this){
		for(var i=0;i<aTags.length;i++){
			aTags[i].className = "onblur";
		}
		_this.className = "onfocus";
	}else if(aTags.length > 0){
		aTags[0].className = "onfocus";
	} 
}
// 加载结果数量
function loadSysRelationResultCount(moduleModelId, fdType, moduleModelName) {
	if(moduleModelId == null || fdType == null || moduleModelName == null) {
		return "(?)";
	}
	var kmssdata = new KMSSData();
	kmssdata.SendToUrl(
		Com_Parameter.ContextPath+"sys/relation/sys_relation_main/sysRelationMain.do?method=getResultCount&fdType=" + fdType + "&currModelId=${param.currModelId}&fdKey=${param.fdKey}&currModelName=${param.currModelName}&moduleModelId=" + moduleModelId + "&moduleModelName=" + moduleModelName,
		function(http_request){
			var responseText = http_request.responseText;
			document.getElementById(moduleModelId+"_count").innerHTML = "(" + responseText + ")";
		}
	);
}
function loadSysRelationData() {
	<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
		<c:if test="${vstatus.index == 0}">
			// 默认加载第一项
			loadSysRelationEntiry("${sysRelationEntryForm.fdId}", "${sysRelationEntryForm.fdType}", "${sysRelationEntryForm.fdModuleModelName}");
		</c:if>
		loadSysRelationResultCount("${sysRelationEntryForm.fdId}", "${sysRelationEntryForm.fdType}", "${sysRelationEntryForm.fdModuleModelName}");
	</c:forEach>
	dyniFrameSize();
}
Com_AddEventListener(window, "load", loadSysRelationData);
</script>
</head>
<body style="background-color: transparent">
<c:choose>
<c:when test="${empty sysRelationMainForm || empty sysRelationMainForm.sysRelationEntryFormList}">
	<center><br><bean:message bundle="sys-relation" key="sysRelationMain.showText.noneRecord" /></center>
</c:when>
<c:otherwise>
<table width="100%" cellspacing="0" cellpadding="0" border="0" align="center" id="tb_relation_info">
<tr>
	<td width="15%" valign="top" nowrap="nowrap" align="center">
		<div style="margin: 6px 0 6px 0; height:215px;overflow: auto; <c:if test='${param.isForDiv == "true"}'>width: 120px;</c:if>">
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
				<tr>
					<td style="padding: 0 6px 0 8px" height="23px">
						<nobr>
							<a name="relationModelName" href="javascript:void(0)" onclick="loadSysRelationEntiry('${sysRelationEntryForm.fdId}', '${sysRelationEntryForm.fdType}', '${sysRelationEntryForm.fdModuleModelName}',this);">
								<c:out value="${sysRelationEntryForm.fdModuleName}" />
								<span id="${sysRelationEntryForm.fdId}_count">
									<img src="${KMSS_Parameter_ResPath}style/common/images/loading.gif" border="0" align="bottom" />
								</span>
							</a>
						</nobr>
					</td>
				</tr>
			</c:forEach>
		</table>
		</div>
	</td>
	<td style="position: relative;border-left: 1px solid rgb(225, 225, 225);" valign="top">
		<iframe id="IF_sysRelation_content" allowTransparency="true" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling=no frameborder=0></iframe>
	</td>
</tr>
</table>
</c:otherwise>
</c:choose>
</body>
</html>
