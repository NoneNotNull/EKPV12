<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiVarKind"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%
	JSONArray vs = (JSONArray)request.getAttribute("vars");
	for (int i = 0; i < vs.size(); i++) {
		JSONObject var = vs.getJSONObject(i);
		SysUiVarKind varkind = SysUiPluginUtil.getVarKindById(var.getString("kind"));
		var.put("varkind", varkind);
	}
	pageContext.setAttribute("vars-config-list",vs);
	pageContext.setAttribute("jsname",request.getParameter("jsname"));
%>
<script>var ${jsname} = new VariableSetting();</script>
<c:if test="${not empty pageScope['vars-config-list'] }">
<table class='tb_normal' width="100%">
	<tr class="tr_normal_title"><td colspan="2">${ lfn:message('sys-ui:ui.vars.config') }</td></tr>
	<c:forEach items="${ pageScope['vars-config-list'] }" var="var" varStatus="vstatus">
		<%--<tr><td colspan="2">${ var['varkind']['fdFile'] }</td></tr> --%>
		<c:import url="${ var['varkind']['fdFile'] }" charEncoding="UTF-8">
			<c:param name="var" value="${ var }"></c:param>
			<c:param name="jsname" value="${jsname}"></c:param>
			<c:param name="code" value="${param['fdId']}"></c:param>
		</c:import>
	</c:forEach>
</table>
</c:if>