<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do" />?method=add&categoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapSettCategoryForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapSettCategory.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettCategory.fdName"/>
				</sunbor:column>
				
				<sunbor:column property="tibSysSoapSettCategory.fdParent.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapSettCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do" />?method=view&fdId=${tibSysSoapSettCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapSettCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapSettCategory.fdName}" />
				</td>
				<!-- 
				<td>
					<c:out value="${tibSysSoapSettCategory.fdHierarchyId}" />
				</td>
			    -->	
				<td>
					<c:out value="${tibSysSoapSettCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>