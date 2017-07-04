<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page
	import="com.landray.kmss.kms.wiki.model.KmsWikiMain"%>
<%@page
	import="com.landray.kmss.kms.wiki.util.KmsWikiUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sunbor.web.tag.Page"%> 
<%@page import="java.util.List"%>
<%	
	String _categoryId = request.getParameter("categoryId");
	JSONObject jsonSetTop = new JSONObject();
 
	Page p = (Page) request.getAttribute("queryPage");
	List<KmsWikiMain> list = p.getList();
	
	for (KmsWikiMain kmsWikiMain : list) {
		
		String topCategoryId = kmsWikiMain.getFdTopCategoryId();
		String docSubject = kmsWikiMain.getDocSubject();
		String _setTopTitle = ResourceUtil.getString("kmsWiki.setTopSign", "kms-wiki");
		String _setTopSign = "<span class='lui_icon_s lui_icon_s_icon_settop' title='"+_setTopTitle+"'></span>";
		if(StringUtil.isNotNull(_categoryId)){
			if(StringUtil.isNotNull(topCategoryId)&&topCategoryId.contains(_categoryId)){
				jsonSetTop.element(kmsWikiMain.getFdId(),_setTopSign);
			}else{
				jsonSetTop.element(kmsWikiMain.getFdId(),"");
			}
		}else{
			Boolean docIsIndexTop = kmsWikiMain.getDocIsIndexTop();
			if(docIsIndexTop!=null&&docIsIndexTop){
				jsonSetTop.element(kmsWikiMain.getFdId(),_setTopSign);
			}else{
				jsonSetTop.element(kmsWikiMain.getFdId(),"");
			}
		}
	}
	request.setAttribute("jsonSetTop", jsonSetTop);
%>


<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdFirstId" escape="false">
			<c:if test="${item.docStatus == '30' }">
				${item.fdFirstId }
			</c:if>			
		</list:data-column>
		<%--作者--%>
		<list:data-column property="docAuthor.fdId" >
		</list:data-column>
		<list:data-column col="docAuthor.fdName"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docAuthor') }" escape="false">
			<c:if test="${not empty item.docAuthor.fdId  }">
				<ui:person personId="${item.docAuthor.fdId }" personName="${item.docAuthor.fdName }"></ui:person>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId  }">
				<a class="com_author" href="javascript:void(0);">${item.outerAuthor}</a> 
			</c:if>
		</list:data-column>
		<%-- 部门 --%>
		<%--
		<list:data-column property="docDept.fdName"
			title="所属部门"> 
		</list:data-column>--%>
		<%--词条名 --%>
		<list:data-column col="icon" escape="false" title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}">
			<c:if test="${item.docIsIntroduced==true}">
		  	 	<span class="lui_icon_s lui_icon_s_icon_essence" title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}"></span>
			 </c:if>
			 <c:if test="${item.docStatus=='20'}">
			 	<span class="lui_icon_s lui_icon_s_icon_examine" title="${lfn:message('status.examine')}"></span>
			 </c:if>
			 <c:if test="${item.docStatus=='10'}">
			 	<span class="lui_icon_s lui_icon_s_icon_draft" title="${lfn:message('status.draft')}"></span>
			 </c:if>
			 <c:if test="${item.docStatus=='00'}">
			 	<span class="lui_icon_s lui_icon_s_icon_discard" title="${lfn:message('status.discard')}"></span>
			 </c:if>
			 <c:if test="${item.docStatus=='11'}">
			 	<span class="lui_icon_s lui_icon_s_icon_refuse" title="${lfn:message('status.refuse')}"></span>
			 </c:if>
			 <c:if test="${item.docStatus=='40'}">
			 	<span class="lui_icon_s lui_icon_s_icon_expire" title="${lfn:message('status.expire')}"></span>
			 </c:if>
			 ${jsonSetTop[item.fdId]}
		</list:data-column>
		<list:data-column property="docIsIntroduced">
		</list:data-column>
		<list:data-column property="docSubject" title="${lfn:message('kms-wiki:kmsWiki.list.subject') }">
		</list:data-column>
		<%--最后完善时间 --%>
		<list:data-column col="fdLastModifiedTime" 
			title="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }">
			<kmss:showDate value="${item.docAlterTime}" type="date"></kmss:showDate>
		</list:data-column>
		<%--浏览次数 --%>
		<list:data-column col="docReadCount" 
			title="${lfn:message('kms-wiki:kmsWiki.list.readCount') }" escape="false">
			<span class="com_number">${item.docReadCount}</span>
		</list:data-column>
		<%--完善次数 --%>
		<list:data-column col="editTimes" title="${lfn:message('kms-wiki:kmsWiki.list.addVersionTimes') }" escape="false">
				<span class="com_number">${editTimesJson[item.fdId] > 0 ? editTimesJson[item.fdId] - 1 : 0}</span>
		</list:data-column>
		<%--最后完善人
		<list:data-column property="docCreator.fdName" col="fdLastCreator"
			title="${lfn:message('kms-wiki:kmsWiki.list.lastEditor') }">
		</list:data-column>
		<list:data-column  col="_fdLastCreator"
			title="${lfn:message('kms-wiki:kmsWiki.list.lastEditor') }" escape="false">
			<ui:person personId="${item.docCreator.fdId }" personName="${item.docCreator.fdName }"></ui:person>
		</list:data-column> --%>
		<%--创建者 --%>
		<list:data-column col="docCreator" title="${lfn:message('kms-wiki:kmsWikiTemplate.docCreator') }">
				${creatorsJson[item.fdId]}
		</list:data-column>
		<%--摘要 --%>
		<list:data-column col="fdDescription" title="${lfn:message('kms-wiki:kmsWiki.wikiCard') }" property="fdDescription">
		</list:data-column>
		<%--所属分类--%> 
		<list:data-column property="docCategory.fdName"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docCategory') }" >
		</list:data-column>
		<%--评分--%>
		<list:data-column col="docScore" title="${lfn:message('kms-wiki:kmsWiki.list.score') }" escape="false">
			<span class="com_number">${not empty scoreJson[item.fdId]? scoreJson[item.fdId]: 0}</span>
		</list:data-column>
		<%--文档状态--%>
		<list:data-column col="docStatus" title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docStatus') }" escape="false">
			 <sunbor:enumsShow enumsType="common_status" value="${item.docStatus}"/>
		</list:data-column>
		<%--头像 --%>
		<list:data-column col="fdImageUrl" title="头像">
			<c:if test="${loadImg == 'true'}">
				<%
					Object wikiObejct = pageContext.getAttribute("item");
					if(wikiObejct != null) {
						KmsWikiMain kmsWikiMain = (KmsWikiMain)wikiObejct;
						out.print(KmsWikiUtil.getImgUrl(kmsWikiMain,request));
					}
				%>
			</c:if>
		</list:data-column>
		<%--标签 --%>
		<list:data-column col="tags" title="标签" escape="false">
			${tagsJson[item.fdId]}
		</list:data-column>
		<list:data-column property="docCategory.fdId" col="docCategoryId"
			title="${lfn:message('kms-wiki:kmsWiki.list.category') }" >
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>