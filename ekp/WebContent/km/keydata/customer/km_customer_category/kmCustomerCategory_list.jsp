<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/keydata/customer/km_customer_category/kmCustomerCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/keydata/customer/km_customer_category/kmCustomerCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/keydata/customer/km_customer_category/kmCustomerCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/keydata/customer/km_customer_category/kmCustomerCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmCustomerCategoryForm, 'deleteall');">
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
				<sunbor:column property="kmCustomerCategory.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.fdOrder">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.docCreateTime">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.docAlterTime">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.docCreator.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.docAlteror.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.docAlteror"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerCategory.docAuthor.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerCategory.docAuthor"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCustomerCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/customer/km_customer_category/kmCustomerCategory.do" />?method=view&fdId=${kmCustomerCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCustomerCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmCustomerCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmCustomerCategory.fdOrder}" />
				</td>
				<td>
					<kmss:showDate value="${kmCustomerCategory.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmCustomerCategory.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmCustomerCategory.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmCustomerCategory.docAlteror.fdName}" />
				</td>
				<td>
					<c:out value="${kmCustomerCategory.docAuthor.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>