<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<%-- 知识地图 --%>
	n2 = n1.AppendURLChild(
		"知识地图"
	);
	<%-- 分类设置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="menu.kmsKmaps.categoryconfig"/>",
		"<c:url value="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do?method=list" />"
	); 
	<%--搜索设置  --%> 
	n3 = n2.AppendURLChild(
		"<bean:message bundle="kms-kmaps" key="kmsKmaps.tree.search.common"/>",
		"<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.kms.kmaps.model.KmsKmapsMain"/>"
	);
