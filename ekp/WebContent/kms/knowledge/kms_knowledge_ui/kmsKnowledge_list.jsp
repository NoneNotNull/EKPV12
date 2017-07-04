<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page
	import="com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil"%>
<%@page
	import="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="com.landray.kmss.util.NumberUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%> 
<%
	String _categoryId = request.getParameter("categoryId");
	JSONObject jsonSetTop = new JSONObject();
	
	Page p = (Page) request.getAttribute("queryPage");
	List<KmsKnowledgeBaseDoc> list = p.getList();
	String fdIds = "";
	int i = 0;
	for (KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc : list) {
		fdIds += i == 0 ? "'" + kmsKnowledgeBaseDoc.getFdId() + "'"
				: ",'" + kmsKnowledgeBaseDoc.getFdId() + "'";
		i++;
		String topCategoryId = kmsKnowledgeBaseDoc.getFdTopCategoryId();
		String docSubject = kmsKnowledgeBaseDoc.getDocSubject();
		String _setTopTitle = ResourceUtil.getString("kmsMultidoc.setTop", "kms-multidoc");
		String _setTopSign = "<span class='lui_icon_s lui_icon_s_icon_settop' title='"+_setTopTitle+"'></span>";
		if(StringUtil.isNotNull(_categoryId)){
			if(StringUtil.isNotNull(topCategoryId)&&topCategoryId.contains(_categoryId)){
				jsonSetTop.element(kmsKnowledgeBaseDoc.getFdId(),_setTopSign);
			}else{
				jsonSetTop.element(kmsKnowledgeBaseDoc.getFdId(),"");
			}
		}else{
			Boolean docIsIndexTop = kmsKnowledgeBaseDoc.getDocIsIndexTop();
			if(docIsIndexTop!=null&&docIsIndexTop){
				jsonSetTop.element(kmsKnowledgeBaseDoc.getFdId(),_setTopSign);
			}else{
				jsonSetTop.element(kmsKnowledgeBaseDoc.getFdId(),"");
			}
		}
	}
	request.setAttribute("jsonSetTop", jsonSetTop);
	
	JSONObject scoreJson = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");
		String _sql = "select e.fd_model_id,avg(5.0-e.fd_evaluation_score) from sys_evaluation_main e where  e.fd_model_id in ("
			+ fdIds + ") group by e.fd_model_id";
		SQLQuery _query = baseDao.getHibernateSession().createSQLQuery(
				_sql);
		for (Object obj : _query.list()) {
			Object[] k = (Object[]) obj;
			String key = k[0].toString();
			scoreJson
					.element(key, NumberUtil.roundDecimal(k[1], "#.#"));
		}
	}
	request.setAttribute("scoreJson", scoreJson);
%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdKnowledgeType"/>
		<list:data-column col="docAuthor.fdName"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docAuthor') }" escape="false">
			<c:if test="${not empty item.docAuthor.fdId  }">
				<ui:person personId="${item.docAuthor.fdId }" personName="${item.docAuthor.fdName }"></ui:person>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId  }">
				<a class="com_author" href="javascript:void(0);">${item.outerAuthor}</a> 
			</c:if>
		</list:data-column>
		<list:data-column col="docCategory.fdName" title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docCategory') }">
			${item.docCategory.fdName}
		</list:data-column>
		<list:data-column col="docPublishTime"
			title="${lfn:message('kms-knowledge:kmsKnowledge.docPublishTime') }">
			 <kmss:showDate value="${item.docPublishTime}" type="date" />
		</list:data-column>
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
		<list:data-column property="docSubject" title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.docSubjects')}">
		</list:data-column>
		<list:data-column property="fdDescription"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.fdDescription')}">
		</list:data-column>
		<list:data-column property="docIntrCount"
			title="${lfn:message('kms-knowledge:kmsKnowledge.intrCount') }">
		</list:data-column>
		<list:data-column property="docEvalCount"
			title="${lfn:message('kms-knowledge:kmsKnowledge.evalCount') }">
		</list:data-column>
		<list:data-column col="docReadCount"
			title="${lfn:message('kms-knowledge:kmsKnowledge.read') }" escape="false">
			<span class="com_number">${not empty item.docReadCount ? item.docReadCount : 0}</span>
		</list:data-column>
		<list:data-column col="fdImageUrl" title="imageLink" escape="false">
				<c:if test="${loadImg == true}">
				<%
					Object basedocObj = pageContext.getAttribute("item");
					if(basedocObj != null) {
						KmsKnowledgeBaseDoc basedoc = (KmsKnowledgeBaseDoc)basedocObj;
						out.print(KmsKnowledgeUtil.getImgUrl(basedoc));
					}
				%>
				</c:if>
		</list:data-column>
		<list:data-column
			title="${lfn:message('kms-knowledge:kmsKnowledge.score') }"
			col="docScore" escape="false">
			<span class="com_number">${not empty scoreJson[item.fdId]?scoreJson[item.fdId]:0}</span>
		</list:data-column>
		<list:data-column escape="false" col="docStatus" title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docStatus') }">
			<sunbor:enumsShow enumsType="common_status" value="${item.docStatus}"></sunbor:enumsShow>
		</list:data-column>
		<list:data-column col="docCategoryId" title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.docCategory') }">
			${item.docCategory.fdId}
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
