<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray,net.sf.json.JSONObject" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<%-- 显示团队积分排行 --%>
		<c:import url="/kms/integral/kms_integral_portlet_ui/kms_integral_portlet_team.jsp"
		          charEncoding="UTF-8">
					<c:param name="rowsize" value="${param.rowsize}"/>
					<c:param name="type" value="${param.type}"/>
					<c:param name="teamId" value="${param.teamId}"/>
					<c:param name="orderby" value="${param.orderby}"/>	
					<c:param name="showScore" value="${fdTotalScore}"/>
					<c:param name="showRiches" value="${fdTotalRiches}"/>
		</c:import>	
</ui:ajaxtext>