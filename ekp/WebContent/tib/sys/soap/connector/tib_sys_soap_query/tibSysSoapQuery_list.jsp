<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do">
	<div id="optBarDiv">
		<%-- <kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do" />?method=add');">
		</kmss:auth> --%>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapQueryForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapQuery.docSubject">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docSubject"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapQuery.docCreateTime">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapQuery.docCreator.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapQuery" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do" />?method=view&fdId=${tibSysSoapQuery.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapQuery.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapQuery.docSubject}" />
				</td>
				<td>
					<kmss:showDate value="${tibSysSoapQuery.docCreateTime}" />
				</td>
				<td>
					<c:out value="${tibSysSoapQuery.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
