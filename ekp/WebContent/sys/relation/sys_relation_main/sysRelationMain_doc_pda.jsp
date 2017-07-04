<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/mechansm.js"/>'></script>
<script type="text/javascript">
	function rela_getViewHtml(docs){
		var html="";
		html+="<ul class='viewList'>";
		for ( var i = 0; i < docs.length; i++) {
			html += "<li class='leftShort'><div style='padding-bottom:3px;'>";
			if(docs[i]["url"]==null || docs[i]["url"]==''){
				html += "<a disabled='disabled'>";
				html += "<p class='font_gray'>";
				html += "<img src='"+ Com_Parameter.ContextPath + "third/pda/resource/images/icon/lock.png'/>&nbsp;";
			}else{
				var link=docs[i]["url"];
				if(link.indexOf("/")==0)
					html += "<a href=\"" + Com_Parameter.ContextPath + link.substring(1) + "\" target=\"_parent\">";
				else
					html += "<a href=\"" + link + "\" target=\"_parent\">";
				html += "<p>";
			}
			html += Com_HtmlEscape(docs[i]["subject"]);
			html += "</p></a>";
			html += "</div>";
			html += "<p class='list_summary'>"+docs[i]["summary"];
			html += "</p>";
			html += "</li>";
		}
		html += "</ul>";
		return html;
	}
	function dyniFrameSize() {
		try {
			parent.document.getElementById('relationIframe').style.height = document.body.offsetHeight+20+"px";
		} catch(e) {
		}
	}
	function showRelationInfo(thisObj,key){
		var isCell =thisObj.getAttribute("isCell");
		if(isCell=="1"){
			var divObj=document.getElementById(S_MechansmMap.get(key)["contentDiv"]);
			if(divObj!=null){
				divObj.style.display="none";
				thisObj.setAttribute("isCell","0");
				dyniFrameSize();
			}
			thisObj.setAttribute("class","div_releationTitle");
		}else{
			showMechansmInfo(null,key);
			thisObj.setAttribute("isCell","1");
			thisObj.setAttribute("class","div_releationCell");
		}
		
	}
	Com_AddEventListener(window,"load",dyniFrameSize);
</script>

</head>
<body style="min-height:0px;margin: 0px;background-color: #F2F2F2;">
<center>
	<c:if test="${!empty sysRelationMainForm && !empty sysRelationMainForm.sysRelationEntryFormList}">
		<c:forEach items="${sysRelationMainForm.sysRelationEntryFormList}" var="sysRelationEntryForm">
			<div id="div_releation_${sysRelationEntryForm.fdId}" class="div_operatePanel" style="display: block;">
				<div class="div_releationTitle" onclick="showRelationInfo(this,'releation_${sysRelationEntryForm.fdId}');">
					${sysRelationEntryForm.fdModuleName}
				</div>
				<div class="div_listArea" id="div_listReleation_${sysRelationEntryForm.fdId}" style="display: none;">
					<div style='margin: 10px 0px;'><bean:message key="sysRelationMain.list.loading" bundle="sys-relation"/></div>
				</div>
			</div>
			<script type="text/javascript">
				var tmpConfig={
					"listUrl":'<c:url value="/sys/relation/relation.do"/>?method=loadRelationResult',
					"parameter":"&rowsize=10&currModelId=${param.currModelId}"+
								"&currModelName=${param.currModelName}&sortType=time"+
								"&fdType=${sysRelationEntryForm.fdType}&moduleModelId=${sysRelationEntryForm.fdId}"+
								"&moduleModelName=${sysRelationEntryForm.fdModuleModelName}",
					"contentDiv":"div_listReleation_${sysRelationEntryForm.fdId}",
					"listDiv":"div_listReleation_${sysRelationEntryForm.fdId}",
					"getViewHtml":rela_getViewHtml,
					"afterDraw":dyniFrameSize,
					"needPage":"false"};
				if(window.addMechansmInfo){
					addMechansmInfo("releation_${sysRelationEntryForm.fdId}",tmpConfig);
				}else{
					if(window.S_MechansmMap!=null){
						S_MechansmMap.put("releation_${sysRelationEntryForm.fdId}",tmpConfig);
					}
				}
			</script>
		</c:forEach>
	</c:if>
	<c:if test="${empty sysRelationMainForm || empty sysRelationMainForm.sysRelationEntryFormList}">
		<div style="margin-top: 10px;">
		<bean:message key="sysRelationMain.noData" bundle="sys-relation"/>
		</div>
	</c:if>
</center>
</body>
</html>