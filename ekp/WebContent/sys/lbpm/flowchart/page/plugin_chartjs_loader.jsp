<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*,java.util.*" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.ResourceCache" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%
String modelName = request.getParameter("modelName");

Collection nodeTypes = NodeTypeManager.getInstance().getType(modelName);
Collection descs = new HashSet();

for (Iterator it = nodeTypes.iterator(); it.hasNext(); ) {
	NodeType nodeType = (NodeType) it.next();
	descs.add(nodeType.getNodeDescType());
}

for (Iterator it = descs.iterator(); it.hasNext(); ) {
	NodeDescType desc = (NodeDescType) it.next();
%>
document.writeln("<script src='<c:url value="<%=ResourceCache.cache(desc.getChartJs(), request) %>" />'></script>");
<%
}
%>
