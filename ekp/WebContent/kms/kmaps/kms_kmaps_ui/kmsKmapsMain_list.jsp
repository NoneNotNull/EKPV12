<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page
	import="com.landray.kmss.kms.kmaps.service.IKmsKmapsMainService"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page
	import="com.landray.kmss.kms.kmaps.model.KmsKmapsMain"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.NumberUtil"%>
<%@page import="com.landray.kmss.kms.kmaps.util.KmsKmapsUtil"%>

<%
	Page p = (Page) request.getAttribute("queryPage");
	List<KmsKmapsMain> list = p.getList();
	String fdIds = "";
	int i = 0;
	for (KmsKmapsMain kmsKmapsMain : list) {
		fdIds += i == 0 ? "'" + kmsKmapsMain.getFdId() + "'"
				: ",'" + kmsKmapsMain.getFdId() + "'";
		i++;
	}
	
	JSONObject scoreJson = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");
	
		String _sql = "select e.fd_model_id,avg(5.0-e.fd_evaluation_score) from sys_evaluation_main e where e.fd_model_name = 'com.landray.kmss.kms.kmaps.model.KmsKmapsMain' and e.fd_model_id in ("
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
		<list:data-column property="docSubject" title="${lfn:message('kms-kmaps:kmsKmapsMain.docSubject') }">
		</list:data-column>
		<list:data-column property="docCategory.fdName" title="${lfn:message('kms-kmaps:kmsKmapsMain.docCategory') }">
		</list:data-column>
		<list:data-column col="docCategoryId" title="${lfn:message('kms-kmaps:kmsKmapsMain.docCategory') }">
			${item.docCategory.fdId}
		</list:data-column>
		<list:data-column col="docCreateTime"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.docCreateTime') }">
			 <kmss:showDate value="${item.docCreateTime}" type="date" />
		</list:data-column>
		<list:data-column col="docPublishTime"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.postTime') }">
			 <kmss:showDate value="${item.docPublishTime}" type="date" />
		</list:data-column>
		<list:data-column property="docReadCount" title="${lfn:message('kms-kmaps:km.kmap.readCount') }">
		</list:data-column>
		<list:data-column col="docAuthor.fdName"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.Author') }" escape="false">
			<c:if test="${not empty item.docAuthor.fdId  }">
				<ui:person personId="${item.docAuthor.fdId }" personName="${item.docAuthor.fdName }"></ui:person>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId  }">
				<a class="com_author" href="javascript:void(0);">${item.outerAuthor}</a> 
			</c:if>
		</list:data-column>
		<list:data-column col="docReadCount"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.read') }" escape="false">
			${item.docReadCount}
		</list:data-column>
		<list:data-column
			title="${lfn:message('kms-kmaps:kmsKmapsMain.score') }"
			col="docScore">
			${not empty scoreJson[item.fdId]? scoreJson[item.fdId]: 0}
		</list:data-column>
		<list:data-column col="fdImageUrl" title="imageLink">
			<c:if test="${loadImg == true}">
				<%
					Object basedocObj = pageContext.getAttribute("item");
					if(basedocObj != null) {
						KmsKmapsMain kmsKmapsMain 
										= (KmsKmapsMain)basedocObj;
						out.print(KmsKmapsUtil.getImgUrl(kmsKmapsMain,request));
					}
				%>
			</c:if>
		</list:data-column>
		<list:data-column col="fdTemplateName"
			title="${lfn:message('kms-kmaps:kmsKmapsMain.docCategory') }">
			${item.docCategory.fdName}
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>
