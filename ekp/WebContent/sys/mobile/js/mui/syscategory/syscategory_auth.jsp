<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.common.service.IXMLDataBean"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%
	List authIds = null;
	IXMLDataBean authCategoryTreeService = (IXMLDataBean) SpringBeanUtil
			.getBean("sysCategoryAuthTreeService");
	List authList = authCategoryTreeService
			.getDataList(new RequestContext(request));
	if (authList != null && !authList.isEmpty()) {
		Object[] authArr = (Object[]) authList.get(0);
		authIds = ArrayUtil.convertArrayToList(authArr);
	}
	if (authIds != null) {
		pageContext.setAttribute("_authIds", StringUtil.join(authIds,
				";"));
	} else {
		pageContext.setAttribute("_authIds", "");
	}
%>