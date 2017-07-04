<%@ page language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.common.service.IXMLDataBean"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%
	List authIds = new ArrayList();
	IXMLDataBean sysSimpleCategoryAuthList = (IXMLDataBean) SpringBeanUtil
			.getBean("sysSimpleCategoryAuthList");
	List authList = sysSimpleCategoryAuthList
			.getDataList(new RequestContext(request));
	if (authList != null && !authList.isEmpty()) {
		for (int i = 0; i < authList.size(); i++) {
			Map tmpMap = (Map) authList.get(i);
			authIds.add(tmpMap.get("v"));
		}
	}
	if (authIds != null && !authIds.isEmpty()) {
		pageContext.setAttribute("_authIds", StringUtil.join(authIds,
				";"));
	} else {
		pageContext.setAttribute("_authIds", "");
	}
%>