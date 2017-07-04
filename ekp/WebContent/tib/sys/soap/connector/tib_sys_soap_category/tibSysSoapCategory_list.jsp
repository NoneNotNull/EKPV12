<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapCategory.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapCategory.fdOrder">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapCategory.fdParent.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory.do" />?method=view&fdId=${tibSysSoapCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibSysSoapCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${tibSysSoapCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
