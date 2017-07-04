<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*" %>
<%@ page import="java.util.List,java.util.Iterator" %>
<%@ include file="/resource/jsp/common.jsp"%>

<%
String nodeType = request.getParameter("nodeType");
String modelName = request.getParameter("modelName");
List exts = NodeExtAttributeManager.getInstance().getExtAttributes(nodeType, modelName);
pageContext.setAttribute("extAttributes", exts);
%>

<c:forEach items="${extAttributes}" var="extAttr">
	<c:if test="${param.position eq extAttr.position}">
		<c:import url="${extAttr.includeJsp}" charEncoding="UTF-8" />
	</c:if>
</c:forEach>