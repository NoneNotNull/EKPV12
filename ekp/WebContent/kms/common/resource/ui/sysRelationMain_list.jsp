<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/resource/jsp/jsperror.jsp" %>
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css"> 
.onblur {color: #003048;text-decoration: none;padding: 2px;height: 20px;}
.onfocus {background-color: #FFFFff;border: 0px solid  #DFDFDF;color: #003048;text-decoration: none;padding: 2px;height: 20px; border-right:0px;}
.gray { float:left; background:#f7f7f7;   width:150px; min-height:185px; height:auto !important; height:185px; }
</style>
 
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("data.js", null, "js");
Com_IncludeFile("jquery.js");
//根据iframe里面内容高度，自动调整iframe窗口高度以及整个弹出窗口的高度
function dyniFrameSize(iframe) {
	var _iframe = iframe || "IF_sysRelation_content";
    var pTar = null;
    if (document.getElementById) {
        if (typeof _iframename == "string") {
			pTar = document.getElementById(_iframe);
        } else {
        	pTar = _iframe;
		}
    } else{
  	  	eval('pTar = ' + _iframe + ';');
    }
	try {
	    if (pTar && !window.opera) {
	        //begin resizing iframe
	        pTar.style.display = "block";
	        if (pTar.contentDocument && pTar.contentDocument.body.offsetHeight) {
	        	//ns6 syntax
				pTar.height = pTar.contentDocument.body.offsetHeight+20;
				//pTar.width = pTar.contentDocument.body.scrollWidth+20;
	        } else if (pTar.Document && pTar.Document.body.scrollHeight){
	       	 	//ie5+ syntax
				pTar.height = pTar.Document.body.scrollHeight;
				//pTar.width = pTar.Document.body.scrollWidth;
				// 调整父Iframe
				if ("${param.frameName}" != "") {
					if (parent.document.getElementById("${param.frameName}")) {
						parent.document.getElementById("${param.frameName}").style.height=document.body.scrollHeight+7;
					}
				}
	        }
	    }
	} catch(e) {
		pTar.width = "100%";
		pTar.height = "100%";
	}
}
// 加载结果数据
function loadSysRelationEntiry(moduleModelId, fdType, fdModuleModelName,_this) {
	if (moduleModelId != null) {
		var url = '<c:url value="/sys/relation/relation.do" />'+'?method=result&currModelId=${param.currModelId}&currModelName=${param.currModelName}&fdKey=${param.fdKey}&fdType='+fdType+'&moduleModelId='+moduleModelId+'&moduleModelName='+fdModuleModelName+'&showCreateInfo=${param.showCreateInfo}';
		var iframe = document.getElementById("IF_sysRelation_content");
		iframe.src = encodeURI(url);
	}
	//设置A标签背景颜色
	var aTags = $("td[name='relationModelName']");
	if(_this){
		//alert(aTags.length);
		//for(var i=0;i<aTags.length;i++){
		//	aTags[i].removeClass();// = "";
		//}
		//_this.className = "onfocus";
		aTags.removeClass() ;
		  // _this.style.backgroundColor="white";
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
<table width="100%" cellspacing="0" cellpadding="0" border="0" align="center"     >
<tr>
 
	<td width="18%" valign="top" nowrap="nowrap" align="center"  class='gray'   > 
		 <div style="margin: 0px 0 6px 0; height:215px;overflow: auto; <c:if test='${param.isForDiv == "true"}'>width: 120px;</c:if>">
		<table width="100%" cellspacing="0" cellpadding="0" border=0>
			<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
				<tr>
					<td style="border-bottom:1px solid #d7d7d7;cursor:pointer"   name="relationModelName" onclick="loadSysRelationEntiry('${sysRelationEntryForm.fdId}', '${sysRelationEntryForm.fdType}', '${sysRelationEntryForm.fdModuleModelName}',this);">
						<nobr>
							 
								<c:out value="${sysRelationEntryForm.fdModuleName}" />
								<span id="${sysRelationEntryForm.fdId}_count">
									<img src="${KMSS_Parameter_ResPath}style/common/images/loading.gif" border="0" align="bottom" />
								</span>
							 
						</nobr>
					</td>
				</tr>
			</c:forEach>
		</table> 
		</div>
	</td>
	<td style="position: relative;border-left: 0px solid rgb(225, 225, 225);" valign="top">
		<iframe id="IF_sysRelation_content" allowTransparency="true" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling=no frameborder=0 onload="dyniFrameSize(this);"></iframe>
	</td>
</tr>
</table>
</c:otherwise>
</c:choose>
</body>
</html>
