<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.flowchart.FlowchartIncludeManager" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>

<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|doclist.js|docutil.js|dialog.js|formula.js");
</script>
<script src="../js/workflow.js"></script>
<script src="../js/attribute.js"></script>
<script src="../js/node_attribute.js"></script>
<%
String nodeTypeParam = request.getParameter("nodeType");
String modelNameParam = request.getParameter("modelName");

FlowchartIncludeManager includes = FlowchartIncludeManager.getInstance();
pageContext.setAttribute("includes", includes.getNodeAttributeJsList(modelNameParam));
%>
<c:forEach items="${includes }" var="include">
<script src="<c:url value="${include }" />"></script>
</c:forEach>

</head>
<body onload="AttributeObject.initDocument();">
<br>
<center>
<kmss:message key="FlowChartObject.Lang.Node.id" bundle="sys-lbpm-engine" />: <input name="wf_id" class="inputread" size="4" readonly> <span id="nodeType"></span>

<%-- 读取扩展点，插入页面 --%>
<%
NodeType nodeType = NodeTypeManager.getInstance().getType(nodeTypeParam, modelNameParam);
String attributePage = nodeType.getAttributesJsp();
pageContext.setAttribute("attributePage", attributePage);
%>
<c:import url="${attributePage}" charEncoding="UTF-8">
	<c:param name="nodeType" value="${param.nodeType}" />
	<c:param name="modelName" value="${param.modelName }" />
</c:import>
<br><br>
<div id="DIV_EditButtons">
	<input name="btnOK" type="button" class="btnopt" onclick="if(AttributeObject.submitDocument())window.close();" 
		value="<kmss:message key="FlowChartObject.Lang.OK" bundle="sys-lbpm-engine" />">
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input name="btnCancel" type="button" class="btnopt" onclick="window.close();" 
		value="<kmss:message key="FlowChartObject.Lang.Cancel" bundle="sys-lbpm-engine" />">
</div>
<div id="DIV_ReadButtons">
	<input name="btnClose" type="button" class="btnopt" onclick="window.close();" 
		value="<kmss:message key="FlowChartObject.Lang.Close" bundle="sys-lbpm-engine" />">
</div>
<br><br>
</center>
</body>
</html>