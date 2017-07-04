<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do">


	<div id="optBarDiv">
	<%--
		<kmss:auth requestURL="/tib/sys/sap/connector/rfc_search_info/rfcSearchInfo.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/rfc_search_info/rfcSearchInfo.do" />?method=add');">
		</kmss:auth>
			 --%>
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcSearchInfoForm, 'deleteall');">
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="rfcSearchInfo.docSubject">
					<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.docSubject"/>
				</sunbor:column>
				<sunbor:column property="rfcSearchInfo.fdRfc.fdId">
					<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.fdRfc"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="rfcSearchInfo" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do" />?method=queryEdit&fdId=${rfcSearchInfo.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${rfcSearchInfo.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${rfcSearchInfo.docSubject}" />
				</td>
				<td>
					<c:out value="${rfcSearchInfo.fdRfc.fdFunctionName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
