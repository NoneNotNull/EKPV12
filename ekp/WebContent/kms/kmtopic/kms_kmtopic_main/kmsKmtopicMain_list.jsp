<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="java.util.List"%>
<%@page
	import="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="com.landray.kmss.util.NumberUtil"%>
<%@page import="com.landray.kmss.kms.kmtopic.util.KmsKmtopicUtil"%>

<%
	String _categoryId = request.getParameter("categoryId");
	JSONObject jsonSetTop = new JSONObject();
	
	Page p = (Page) request.getAttribute("queryPage");
	List<KmsKmtopicMain> list = p.getList();
	String fdIds = "";
	int i = 0;
	for (KmsKmtopicMain kmsKmtopicMain : list) {
		fdIds += i == 0 ? "'" + kmsKmtopicMain.getFdId() + "'"
				: ",'" + kmsKmtopicMain.getFdId() + "'"; 
		i++;
	}
	
	JSONObject scoreJson = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");

		String _sql = "select e.fd_model_id,avg(5.0-e.fd_evaluation_score) from sys_evaluation_main e where e.fd_model_name = 'com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain' and e.fd_model_id in ("
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
		<list:data-column col="icon" escape="false" title="${lfn:message('kms-kmtopic:kmsKmtopic.tree.introduced')}">
		  	 <c:if test="${item.docIsIntroduced==true}">
		  	 	<span class="lui_icon_s lui_icon_s_icon_essence" title="${lfn:message('kms-kmtopic:kmsKmtopic.tree.introduced')}"></span>
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
		</list:data-column>
		<list:data-column property="docSubject"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.topic.docSubject')}">
		</list:data-column>
		
		<list:data-column col="_docAuthor.fdName"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.docAuthor') }" escape="false">
			<c:if test="${not empty item.docAuthor.fdId  }">
				<ui:person personId="${item.docAuthor.fdId }" personName="${item.docAuthor.fdName }"></ui:person>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId  }">
				${item.outerAuthor }
			</c:if>
		</list:data-column>
		
		<list:data-column col="docAuthor.fdName"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.docAuthor') }" escape="false">
			<c:if test="${not empty item.docAuthor.fdId  }">
				<ui:person personId="${item.docAuthor.fdId }" personName="${item.docAuthor.fdName }"></ui:person>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId  }">
				<a class="com_author" href="javascript:void(0);">${item.outerAuthor}</a> 
			</c:if>
		</list:data-column>
		
		<list:data-column col="docPublishTime"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.docPublishTime') }">
			 <kmss:showDate value="${item.docPublishTime}" type="date" />
		</list:data-column>
		
		<list:data-column col="docReadCount"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.read') }" escape="false">
			<span class="com_number">${item.docReadCount}</span>
		</list:data-column>
		
		<list:data-column
			title="${lfn:message('kms-kmtopic:kmsKmtopic.score') }"
			col="docScore" escape="false">
			<span class="com_number">${not empty scoreJson[item.fdId]? scoreJson[item.fdId]: 0}</span>
		</list:data-column>
		
		<list:data-column col="docCategory.fdName" title="${lfn:message('kms-kmtopic:kmsKmtopic.docCategory') }">
			${item.docCategory.fdName}
		</list:data-column>
		
		<list:data-column property="fdDescription"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.description')}">
		</list:data-column>
		
		<list:data-column col="fdImageUrl" title="imageLink">
				<c:if test="${loadImg == true}">
				<%
					Object basedocObj = pageContext.getAttribute("item");
					if(basedocObj != null) {
						KmsKmtopicMain kmsKmtopicMain
										= (KmsKmtopicMain)basedocObj;
						out.print(KmsKmtopicUtil.getImgUrl(kmsKmtopicMain));
					}
				%>
				</c:if>
		</list:data-column>
		
		<list:data-column col="docCategoryId" title="${lfn:message('kms-kmtopic:kmsKmtopicMain.docCategory') }">
			${item.docCategory.fdId}
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>