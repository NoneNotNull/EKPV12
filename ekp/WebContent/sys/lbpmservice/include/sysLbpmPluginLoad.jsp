<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*,java.util.*" %>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<script type="text/javascript">	
lbpm.nodeDescMap = {};
lbpm.nodedescs = {};

<c:import url="/sys/lbpm/engine/desc_generator.jsp" charEncoding="UTF-8">
	<c:param name="modelName">
	<%
	String modelName = (String)pageContext.getAttribute("modelClassName");
	if(StringUtil.isNull(modelName)){
		out.print(request.getParameter("modelClassName"));
	}else{
		out.print(modelName);
	}
	%>
	</c:param>
	<c:param name="descJsName">descs</c:param>
</c:import>
</script>