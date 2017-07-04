<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
<!--
Com_Parameter.IsAutoTransferPara = true;
//-->
</script>
<html:form action="/component/dbop/compDbcp.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/component/dbop/compDbcp.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/component/dbop/compDbcp.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/component/dbop/compDbcp.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.compDbcpForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="compDbcp.fdName">
					<bean:message  bundle="component-dbop" key="compDbcp.fdName"/>
				</sunbor:column>
				<sunbor:column property="compDbcp.fdType">
					<bean:message  bundle="component-dbop" key="compDbcp.fdType"/>
				</sunbor:column>
				<sunbor:column property="compDbcp.compDbcp.fdDescription">
					<bean:message  bundle="component-dbop" key="compDbcp.fdDescription"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="compDbcp" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/component/dbop/compDbcp.do" />?method=view&fdId=${compDbcp.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${compDbcp.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td width="30%">
					<c:out value="${compDbcp.fdName}" />
				</td>
				<td>
					<c:out value="${compDbcp.fdType}" />
				</td>
				<td width="40%">
				<c:choose>
					<c:when test="${fn:length(compDbcp.fdDescription)>30 }">${fn:substring(compDbcp.fdDescription,0,29)}...</c:when>
					<c:otherwise>${compDbcp.fdDescription}</c:otherwise>
				</c:choose>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>