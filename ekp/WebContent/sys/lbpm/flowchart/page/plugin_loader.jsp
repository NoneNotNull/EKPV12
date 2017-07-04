<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/common.jsp"%>

FlowChartObject.Lang.Include('sys-lbpm-engine'); // 加载资源

<c:import url="/sys/lbpm/flowchart/page/plugin_descs_loader.jsp" charEncoding="UTF-8">
	<c:param name="modelName">${param.modelName}</c:param>
</c:import>

<c:import url="/sys/lbpm/flowchart/page/plugin_chartjs_loader.jsp" charEncoding="UTF-8">
	<c:param name="modelName">${param.modelName}</c:param>
</c:import>

<c:import url="/sys/lbpm/flowchart/page/plugin_include_loader.jsp" charEncoding="UTF-8">
	<c:param name="modelName">${param.modelName}</c:param>
</c:import>