<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray,net.sf.json.JSONObject" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%-- 显示个人积分排行 --%>
<ui:ajaxtext>
	<c:if test="${'yes' == showStar }">
		<c:import url="/kms/integral/kms_integral_portlet_ui/kms_integral_portlet_introduceStar.jsp" 
			charEncoding="UTF-8">
			<c:param name="type" value="${starType}"/>
			<c:param name="deptId" value="${deptId}"/> 
			<c:param name="personId" value="${personId}"/> 
		</c:import>
	</c:if>
	<c:if test='${ true == isMulti}'>
		<%-- 显示多个 --%>
		<ui:tabpanel layout="sys.ui.tabpanel.light" cfg-selectedIndex="${selectedIndex}">
			<c:forEach var="showItem" items="${showArray}">
				<ui:content title="${showItem.title}" >
					<c:import url="/kms/integral/kms_integral_portlet_ui/kms_integral_portlet_dep.jsp"
			          charEncoding="UTF-8">
						<c:param name="rowsize" value="${rowsize}"/>
						<c:param name="type" value="${showItem.type}"/>
						<c:param name="deptId" value="${deptId}"/> 
						<c:param name="showScore" value="${fdTotalScore}"/>
						<c:param name="showRiches" value="${fdTotalRiches}"/>
						<c:param name="orderby" value="${orderby}"/>	
					</c:import>	
				</ui:content>
			</c:forEach>
		</ui:tabpanel>
	</c:if>
	<%-- 显示单个 --%>
	<c:if test='${ false == isMulti}'>
		<c:import url="/kms/integral/kms_integral_portlet_ui/kms_integral_portlet_dep.jsp"
          			charEncoding="UTF-8">
			<c:param name="rowsize" value="${rowsize}"/>
			<c:param name="type" value="${showArray[0].type}"/>
			<c:param name="deptId" value="${deptId}"/> 
			<c:param name="showScore" value="${fdTotalScore}"/>
			<c:param name="showRiches" value="${fdTotalRiches}"/>
			<c:param name="orderby" value="${orderby}"/>	
		</c:import>	
	</c:if>
</ui:ajaxtext>
