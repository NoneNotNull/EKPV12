<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
	<html:form action="/kms/common/kms_person_info/kmsPersonInfo.do?parentId=${param.parentId}">
		<div id="optBarDiv">
		<c:if test="${!empty search }">
			<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
		</c:if>
	   </div>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td>
					<bean:message key="page.serial" />
				</td>
				<sunbor:column property="sysOrgPerson.fdName">
					<bean:message bundle="kms-common" key="table.kmsPersonInfo.fdName" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdEmail">
					<bean:message bundle="kms-common" key="table.kmsPersonInfo.fdEmail" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdMobileNo">
					<bean:message bundle="kms-common" key="table.kmsPersonInfo.fdMobileNo" />
					</sunbor:column>
					<sunbor:column property="sysOrgPerson.fdWorkPhone">
					<bean:message bundle="kms-common" key="table.kmsPersonInfo.fdWorkPhone" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.hbmParent.fdName">
					<bean:message bundle="kms-common" key="table.kmsPersonInfo.fdDepartment" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysOrgPerson" varStatus="vstatus">
			<tr kmss_href="<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do" />?method=index&fdId=${sysOrgPerson.fdId}">
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="15%">
					<c:out value="${sysOrgPerson.fdName}" />
				</td>
				<td width="20%">
					<c:out value="${sysOrgPerson.fdEmail}" />
				</td>
				<td width="20%">
					<c:out value="${sysOrgPerson.fdMobileNo}" />
				</td>
				<td width="20%">
					<c:out value="${sysOrgPerson.fdWorkPhone}" />
				</td>
				<td width="25%">
					<c:out value="${sysOrgPerson.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}	%>
	</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
