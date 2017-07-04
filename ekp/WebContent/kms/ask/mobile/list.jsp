<%@page import="java.util.List"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.kms.ask.model.KmsAskTopic"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>

<%
	Page p = (Page) request.getAttribute("queryPage");
	List<KmsAskTopic> list = p.getList();
	String fdIds = "";
	int i = 0;
	for (KmsAskTopic kmsAksTopic : list) {
		fdIds += i == 0 ? "'" + kmsAksTopic.getFdId() + "'" : ",'"
				+ kmsAksTopic.getFdId() + "'";
		i++;
	}
	JSONObject tagJson = new JSONObject();
	JSONObject thumbJson = new JSONObject();
	if (StringUtil.isNotNull(fdIds)) {
		IBaseDao baseDao = (IBaseDao) SpringBeanUtil
				.getBean("KmssBaseDao");
		String sql = "select m.fd_model_id,r.fd_tag_name from sys_tag_main_relation r left join sys_tag_main m on r.fd_main_id = m.fd_id where m.fd_model_id in ("
				+ fdIds + ")";
		SQLQuery query = baseDao.getHibernateSession().createSQLQuery(
				sql);
		
		for (Object obj : query.list()) {
			Object[] k = (Object[]) obj;
			String key = k[0].toString();
			if (tagJson.get(key) != null) {
				tagJson.element(key, tagJson.getString(key) + "<em>|</em>"
						+ k[1]);
			} else {
				tagJson.element(key, k[1]);
			}
		}

		String thumbSql = "select m.fd_model_id,m.fd_id from sys_att_rtf_data m "
				+ "where m.fd_model_id in (" + fdIds + ")";
		SQLQuery thumbQuery = baseDao.getHibernateSession()
				.createSQLQuery(thumbSql);
		for (Object obj : thumbQuery.list()) {
			Object[] k = (Object[]) obj;
			String key = k[0].toString();
			if (thumbJson.get(key) != null) {
				thumbJson.element(key, thumbJson.getString(key) + ","
						+ k[1]);
			} else {
				thumbJson.element(key, k[1]);
			}
		}
	}
	request.setAttribute("thumbJson", thumbJson);
	request.setAttribute("tagJson", tagJson);
%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdScore"
			title="${lfn:message('kms-ask:kmsAskTopic.fdScore') }">
		</list:data-column>
		<list:data-column property="fdKmsAskCategory.fdName"
			title="${lfn:message('kms-ask:table.kmsAskCategory') }">
		</list:data-column>
		<list:data-column property="docSubject" col="label"
			title="${lfn:message('kms-ask:kmsAskTopic.topic') }">
		</list:data-column>
		<list:data-column property="fdReplyCount"
			title="${lfn:message('kms-ask:kmsAskTopic.replyCount') }">
		</list:data-column>
		<list:data-column property="fdStatus"
			title="${lfn:message('kms-ask:kmsAskTopic.fdAskStatus') }">
		</list:data-column>
		<list:data-column col="created"
			title="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }">
			<kmss:showDate isInterval="true" value="${item.docCreateTime}" />
		</list:data-column>
		<list:data-column col="fdLastPostTime"
			title="${lfn:message('kms-ask:kmsAskTopic.fdLastPostTime') }">
			<kmss:showDate isInterval="true" value="${item.fdLastPostTime}" />
		</list:data-column>
		<list:data-column col="creator" title="创建者" property="fdPoster.fdName">
		</list:data-column>
		<list:data-column col="href" escape="false">
			/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=${item.fdId}
		</list:data-column>
		<!--头像-->
		<list:data-column col="icon" escape="false">
			<person:headimageUrl personId="${item.fdPoster.fdId}" size="90" />
		</list:data-column>
		<!--标签-->
		<list:data-column col="tagName" escape="false">
			${tagJson[item.fdId]}
		</list:data-column>
		<list:data-column property="fdPostFrom">
		</list:data-column>
		<list:data-column col="thumbs">
			${thumbJson[item.fdId]}
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
