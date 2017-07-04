<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style>

</style>
<script>
Com_IncludeFile("dialog.js|plugin.js");
</script>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<div style="width:900px;text-align: center;margin: 50px auto;">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable" style="width:70%">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsLogSearchDoc.docSubject">
					<bean:message bundle="kms-log" key="kmsLogSearchDoc.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsLogSearchDoc.fdModelName">
					<bean:message bundle="kms-log" key="kmsLogSearchDoc.fdModelName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsLogSearchDoc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/log/kms_log_search/kmsLogSearch.do" />?method=docview&fdModelId=${kmsLogSearchDoc.fdModelId}&fdModelName=${kmsLogSearchDoc.fdModelName}">
				<td  width="3%">
					<input type="checkbox" name="List_Selected" value="${kmsLogSearchDoc.fdId}">
				</td>
				<td  width="3%">
					${vstatus.index+1}
				</td>
				<td  width="44%">
					<c:out value="${kmsLogSearchDoc.docSubject}" />
				</td>
				<td  width="8%">
					<c:out value="${kmsLogSearchDoc.fdModelName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	</div>
</c:if>
<%@ include file="/resource/jsp/list_down.jsp"%>