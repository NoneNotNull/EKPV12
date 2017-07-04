<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.flowchart.FlowchartIncludeManager" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.ResourceCache" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%
String modelName = request.getParameter("modelName");

FlowchartIncludeManager includes = FlowchartIncludeManager.getInstance();
for (Iterator it = includes.getFlowchartJsList(modelName).iterator(); it.hasNext(); ) {
%>
document.writeln("<script src='<c:url value="<%=ResourceCache.cache((String) it.next(), request)%>" />'></script>");
<%
}
%>
