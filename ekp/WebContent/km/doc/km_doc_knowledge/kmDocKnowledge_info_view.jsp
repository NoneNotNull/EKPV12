<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>	
<%@ include file="/resource/jsp/info_view_top.jsp"%>
<%@ include file="kmDocKnowledge_script.jsp"%>
<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
	charEncoding="UTF-8">
	<c:param name="fdSubject" value="${kmDocKnowledgeForm.docSubject}" />
	<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}" />
	<c:param name="fdModelName"
		value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
</c:import>
<script type="text/javascript">
	Com_IncludeFile("jquery.js");
</script>
<script>
$(document).ready(function(){
	var maxWidth = $('#docSummary').width();
	$('#content').find('img,table').each(function(){
		var domElem = $(this);
		var width = domElem.width();
		var height = domElem.height();
		if(width > maxWidth){
			var resizeW = maxWidth-16;
			domElem.width(resizeW);	
			if(this.tagName=='IMG'){
				var pt = height/width ;
				domElem.height(resizeW*pt);
			}
		}
	});
});
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<kmss:windowTitle subject="${kmDocKnowledgeForm.docSubject}" moduleKey="km-doc:table.kmdoc" />

<div id="optBarDiv">
     <input type="button" value="<bean:message key="kmDoc.button.copyLink" bundle="km-doc"/>"
			onclick="copyLink();">
	<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit > '0' }">
		<kmss:auth
			requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=edit&fdId=${kmDocKnowledgeForm.fdId}"
			requestMethod="GET">
			<input
				type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmDocKnowledge.do?method=edit&fdId=${kmDocKnowledgeForm.fdId}','_self');">
		</kmss:auth> 
	</c:if>
	<kmss:auth
		requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=delete&fdId=${kmDocKnowledgeForm.fdId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmDocKnowledge.do?method=delete&fdId=${kmDocKnowledgeForm.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.more"/>"
		onclick="Com_OpenWindow('kmDocKnowledge.do?method=view&fdId=${kmDocKnowledgeForm.fdId}&more=true','_self');">
	<input type="button" 
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<center>
	<%-- 查看界面布局 --%>
	<div id="mainDiv">
		<%-- 文档内容     左侧 --%>
		<div id="docContent">
				<div id="navInfo">
					<%-- 导航 --%>
					<c:out value="${kmDocKnowledgeForm.fdDocTemplateName}"/>
				</div>
				<div id="docTitle">
					<%-- 标题 --%>
					<c:out value="${kmDocKnowledgeForm.docSubject}" />
					<c:if test="${isHasNewVersion=='true'}">
						<span class="redSty"  >
							(<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.thisHas" />
							<a href="#"  onclick="Com_OpenWindow('kmDocKnowledge.do?method=view&fdId=${kmDocKnowledgeForm.docOriginDocId}','_self');">
							<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.NewVersion" /></a>)
						</span>
					</c:if>
				</div>
				<div id="docSummary">
					<%-- 副标题内容 --%>
					<bean:message bundle="sys-doc" key="sysDocBaseInfo.docAuthor" />&nbsp;&nbsp;
					<c:out value="${kmDocKnowledgeForm.docAuthorName}" />&nbsp;&nbsp;
					<c:out value="${kmDocKnowledgeForm.docPublishTime}" />&nbsp;&nbsp;
					<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.read" />
					<span class="number">(<c:out value="${kmDocKnowledgeForm.docReadCount+1}" />)</span>&nbsp;&nbsp;
					<%-- 点评数--%>
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.button.evaluation" />
					<span class="number">${kmDocKnowledgeForm.evaluationForm.fdEvaluateCount}</span>
				</div>
				<c:if test="${not empty kmDocKnowledgeForm.fdDescription}">
					<div id="docDescRange">
						<div class="top_l"></div><div class="top_r"></div><div class="but_l"></div><div class="but_r"></div>
						<div id="docDesc">
							<%-- 文档描述信息 --%>
							<h3><bean:message key="kmDocKnowledge.fdDescription" bundle="km-doc" /></h3>
							<p><kmss:showText value="${kmDocKnowledgeForm.fdDescription}" /></p>
						</div>
					</div>
				</c:if>
				<div id="content">
					<%-- 文档内容 --%>
					${kmDocKnowledgeForm.docContent}
				</div>
				<div id="docAttach">
					<%-- 文档附件 --%>
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="viewType" value="link"/>
						<c:param name="fdMulti" value="true" />
						<c:param name="formBeanName" value="kmDocKnowledgeForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import>
				</div>
				<div id="docEvalute">
					<%-- 文档点评 --%>
					<c:import url="/sys/evaluation/include/sysEvaluationMain_doc_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmDocKnowledgeForm" />
					</c:import>
				</div>
				<div id="docMechanism">
					<%-- 文档机制 --%>
					<table id="Label_Tabel" width=100% LKS_LabelClass="info_view">
						<%-- 点评机制查看页面 --%>
						<c:import url="/sys/evaluation/include/sysEvaluationMain_doc_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmDocKnowledgeForm" />
						</c:import>
						<%-- 推荐机制 --%>
						<c:import url="/sys/introduce/include/sysIntroduceMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmDocKnowledgeForm" />
							<c:param name="fdKey" value="mainDoc" />
							<c:param name="toEssence" value="true" />
							<c:param name="toNews" value="true" />
							<c:param name="docSubject" value="${kmDocKnowledgeForm.docSubject}" />
							<c:param name="docCreatorName" value="${kmDocKnowledgeForm.docCreatorName}" />
						</c:import>
						<%-- 版本机制 --%>
						<c:import url="/sys/edition/include/sysEditionMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmDocKnowledgeForm" />
						</c:import>
						<%-- 权限机制 --%>
						<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
							<td>
							<table class="tb_normal" width=100%>
								<c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
									<c:param name="formName" value="kmDocKnowledgeForm" />
									<c:param name="moduleModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
								</c:import>
							</table>
							</td>
						</tr>
						<%-- 流程机制 --%>
						<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmDocKnowledgeForm" />
							<c:param name="fdKey" value="mainDoc" />
						</c:import>
						<%-- 阅读机制 --%>
						<c:import url="/sys/readlog/include/sysReadLog_view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmDocKnowledgeForm" />
						</c:import>
					</table>
				</div>
		</div>
		<%-- 文档关联内容     右侧 --%>
		<div id="docRelation" class="sidebar">
				<%-- 文档基本信息信息 --%>
				<div class="sideBox">
					<h2><bean:message key="kmDoc.kmDocKnowledge.docInfo" bundle="km-doc" /></h2>
					<div>
						<bean:message key="kmDoc.kmDocKnowledge.docAuthor" bundle="km-doc" />：<c:out value="${kmDocKnowledgeForm.docCreatorName}" /><br>
						<bean:message key="kmDoc.form.main.docDeptId" bundle="km-doc" />：<c:out value="${kmDocKnowledgeForm.docDeptName}" /><br>
						<%-- 所属场所 --%>
						<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
						<bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：<c:out value="${kmDocKnowledgeForm.authAreaName}" /><br>
						<% } %>
						<bean:message key="kmDoc.kmDocKnowledge.currenVersion" bundle="km-doc" />：${kmDocKnowledgeForm.editionForm.mainVersion}.${kmDocKnowledgeForm.editionForm.auxiVersion} 
						&nbsp;
						<c:if test="${isHasNewVersion=='true'}">
							<span class="redSty" >
							（<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.has"/>
							<a href="#"  onclick="Com_OpenWindow('kmDocKnowledge.do?method=view&fdId=${kmDocKnowledgeForm.docOriginDocId}','_self');">
							<bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.NewVersion" /></a>)
							</span>
						</c:if>
						<div class="docTag">
							<h3><img src="${KMSS_Parameter_ResPath}style/common/images/icon_pin.png" border="0"/><bean:message key="kmDoc.kmDocKnowledge.docTag" bundle="km-doc" />：</h3>
							<div id="docTag"></div>
						</div>
					</div>
				</div>
				<%-- 同分类文档 --%>
				<div class="sideBox" id="sameCategoryDocDiv">
					<h2><bean:message key="kmDoc.kmDocKnowledge.sameCategoryDoc" bundle="km-doc" /><span class="more" onclick="more('${kmDocKnowledgeForm.fdDocTemplateId}');"><bean:message key="kmDoc.title.more" bundle="km-doc" />></span></h2>
					<div>
						<iframe id="sameCategoryDoc" 
						src="<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=listChildren&categoryId=${kmDocKnowledgeForm.fdDocTemplateId}&excepteIds=${kmDocKnowledgeForm.fdId}&orderby=docPublishTime&ordertype=down&forward=sameCategoryDoc"
							frameborder="0" scrolling="no" width="100%" height="100%">
						</iframe>
					</div>
				</div>
				<%-- xx相关文档 --%>
				<c:import url="/sys/tag/include/sysTagMain_doc_view.jsp" charEncoding="UTF-8">
					<c:param name="tagNames" value="${kmDocKnowledgeForm.sysTagMainForm.fdTagNames}" />
					<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}" />
				</c:import>
				<%-- 关联机制 --%>
				<c:import url="/sys/relation/include/sysRelationMain_doc_view.jsp"
					charEncoding="UTF-8">
					<c:param name="mainModelForm" value="kmDocKnowledgeForm" />
					<c:param name="currModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
				</c:import>
		</div>
	</div>
</center>

<script>
$(document).ready(function(){
	var fdTagNames = "${kmDocKnowledgeForm.sysTagMainForm.fdTagNames}";
	var tagNames = fdTagNames.split(" ");
	var docTag = document.getElementById("docTag");
	var tagHtml = "";
	for(var i=0;i<tagNames.length;i++){
		var href = "<c:url value='/sys/tag/sys_tag_main/sysTagMain.do?method=searchMain'/>";
		href += "&queryString="+encodeURIComponent(tagNames[i])+"&queryType=normal";
		tagHtml += "<a href='"+href+"' target='_blank'>"+tagNames[i]+"</a>&nbsp;&nbsp;&nbsp;";
	}
	docTag.innerHTML = tagHtml;
	//将内容部分，图片宽度大于600的，限制在600内，避免过大图片把页面撑开
	$('#content').find('img').each(function(){
		var pt;
		if(this.height && this.height!="" && this.width && this.width != "")
			pt = parseInt(this.height)/parseInt(this.width);//高宽比
		if(this.width>600){
			this.width = 600;
			if(pt)
				this.height = 600 * pt;
		}
	});

});
function more(categoryId){
	var url = Com_Parameter.ContextPath+"moduleindex.jsp?nav=/km/doc/tree.jsp&main=/";
	var s_path = "${kmDocKnowledgeForm.fdDocTemplateName}";
	var s_pathEncode = encodeURIComponent(s_path);
	url += encodeURIComponent("km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listChildren&categoryId="+categoryId+"&orderby=docPublishTime&ordertype=down&nodeType=CATEGORY&s_path="+s_pathEncode);
	Com_OpenWindow(url);
}
</script>
<%@ include file="/resource/jsp/info_view_down.jsp"%>
