<%@ page language="java" contentType="text/xml; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.util.SpringBeanUtil,
	java.util.*
"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>

<%
IXMLDataBean bean = (IXMLDataBean) SpringBeanUtil.getBean("lbpmProcessDefinitionDetailService");

List detail = bean.getDataList(new RequestContext(request));

for (int i = 0; i < detail.size(); i ++) {
	out.println(detail.get(i));
}
%>
