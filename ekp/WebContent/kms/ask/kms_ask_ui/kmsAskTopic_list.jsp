<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page
	import="com.landray.kmss.kms.ask.service.IKmsAskTopicService"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page
	import="com.landray.kmss.kms.ask.model.KmsAskTopic"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@page import="org.hibernate.SQLQuery"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>

<%	
	String _categoryId = request.getParameter("categoryId");
	JSONObject jsonDocSubject = new JSONObject();

	Page p = (Page) request.getAttribute("queryPage");
	List<KmsAskTopic> list = p.getList();
	
	for (KmsAskTopic kmsAskTopic : list) {
		
		String topCategoryId = kmsAskTopic.getFdTopCategoryId();
		String docSubject = kmsAskTopic.getDocSubject();
		String _setTopSign = ResourceUtil.getString("kmsAskTopic.setTopSign", "kms-ask");
		if(StringUtil.isNotNull(_categoryId)){
			if(StringUtil.isNotNull(topCategoryId)&&topCategoryId.contains(_categoryId)){
				String _docSubject = _setTopSign + docSubject;
				jsonDocSubject.element(kmsAskTopic.getFdId(),_docSubject);
			}else{
				jsonDocSubject.element(kmsAskTopic.getFdId(),docSubject);
			}
		}else{
			Boolean docIsIndexTop = kmsAskTopic.getDocIsIndexTop();
			if(docIsIndexTop!=null&&docIsIndexTop){
				String _docSubject = _setTopSign + docSubject;
				jsonDocSubject.element(kmsAskTopic.getFdId(),_docSubject);
			}else{
				jsonDocSubject.element(kmsAskTopic.getFdId(),docSubject);
			}
		}
	}
	request.setAttribute("jsonDocSubject", jsonDocSubject);

%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdScore" title="${lfn:message('kms-ask:kmsAskTopic.fdScore') }">
		</list:data-column>
		<list:data-column property="fdKmsAskCategory.fdName" title="${lfn:message('kms-ask:table.kmsAskCategory') }">
		</list:data-column>
		<list:data-column col="docSubject" title="${lfn:message('kms-ask:kmsAskTopic.topic') }">
			${jsonDocSubject[item.fdId]}
		</list:data-column>
		<list:data-column property="fdReplyCount" title="${lfn:message('kms-ask:kmsAskTopic.replyCount') }">
		</list:data-column>
		<list:data-column property="fdStatus" title="${lfn:message('kms-ask:kmsAskTopic.fdAskStatus') }">
		</list:data-column>
		<list:data-column col="docCreateTime"  title="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }">
			<kmss:showDate  isInterval="true" value="${item.docCreateTime}" />
		</list:data-column>
		<list:data-column col="fdLastPostTime" title="${lfn:message('kms-ask:kmsAskTopic.fdLastPostTime') }">
			<kmss:showDate isInterval="true" value="${item.fdLastPostTime}" />
		</list:data-column>
		<list:data-column col="fdPoster" title="${lfn:message('kms-ask:kmsAskTopic.fdPoster')}" escape="false">
			<ui:person personId="${item.fdPoster.fdId }" personName="${item.fdPoster.fdName }"></ui:person>
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>
