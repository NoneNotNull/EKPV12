<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.*,java.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
if (window.FlowChartObject == null) {
	FlowChartObject = {};
}
lbpm = {nodedescs: {}, nodeDescMap: {}};

<c:import url="/sys/lbpm/engine/desc_generator.jsp" charEncoding="UTF-8">
	<c:param name="modelName">${param.modelName}</c:param>
</c:import>

FlowChartObject.NodeDescMap = lbpm.nodeDescMap;
FlowChartObject.NodeTypeDescs = lbpm.nodedescs;