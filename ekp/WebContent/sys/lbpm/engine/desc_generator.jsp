<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*,com.landray.kmss.sys.lbpm.engine.builder.*,java.util.*" %>
<%@ page import="com.landray.kmss.util.StringUtil" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.ResourceCache" %>
<%@ include file="/resource/jsp/common.jsp" %>
<%
	String modelName = request.getParameter("modelName");
	String descJsName = request.getParameter("descJsName");
	
	boolean needDescJs = StringUtil.isNotNull(descJsName);
	
	Collection nodeTypes = NodeTypeManager.getInstance().getType(modelName);
	Collection descs = needDescJs ? new HashSet() : Collections.emptySet();
	
	for (Iterator it = nodeTypes.iterator(); it.hasNext(); ) {
		NodeType nodeType = (NodeType) it.next();
		INodeDesc taskDesc = nodeType.getNodeDescType().getTaskDesc();
		String typeForNode = nodeType.getNodeDescType().getType();
%>
		lbpm.nodeDescMap["<%= nodeType.getType() %>"]="<%= typeForNode %>";
		lbpm.nodedescs["<%= typeForNode %>"]={};
		<% if (!ProxyNodeDefinition.class.isAssignableFrom(nodeType.getDefClass()) && needDescJs) { %>
		document.writeln("<script src='<c:url value="<%= ResourceCache.cache(nodeType.getNodeDescType().getNodeDescJs(), request) %>" />'></scr" + "ipt>");
		<% } %>
		lbpm.nodedescs["<%= typeForNode %>"].isHandler = function(){return <%= taskDesc.isHandler() %>};
		lbpm.nodedescs["<%= typeForNode %>"].isAutomaticRun = function(){return <%= taskDesc.isAutomaticRun() %>};
		lbpm.nodedescs["<%= typeForNode %>"].isSubProcess = function(){return <%= taskDesc.isSubProcess() %>};
		lbpm.nodedescs["<%= typeForNode %>"].isConcurrent = function(){return <%= taskDesc.isConcurrent() %>};
		lbpm.nodedescs["<%= typeForNode %>"].isBranch = function(){return <%= taskDesc.isBranch() %>};
		lbpm.nodedescs["<%= typeForNode %>"].uniqueMark = function(){return <%
			if (taskDesc.getUniqueMark() == null) { 
				%>null<%
			} else {
				%>"<%= taskDesc.getUniqueMark() %>"<%
			}%>};
		<% if (ProxyNodeDefinition.class.isAssignableFrom(nodeType.getDefClass())) { %>
		document.writeln("<script src='<c:url value="<%= ResourceCache.cache(nodeType.getNodeDescType().getNodeDescJs(), request) %>" />'></scr" + "ipt>");
        <% }
	}
%>