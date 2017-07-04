<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSupplierCategoryForm, 'deleteall');">
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
				<sunbor:column property="kmSupplierCategory.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.fdOrder">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.docCreateTime">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.docAlterTime">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.docCreator.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.docAlteror.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.docAlteror"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierCategory.docAuthor.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierCategory.docAuthor"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSupplierCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do" />?method=view&fdId=${kmSupplierCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSupplierCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSupplierCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmSupplierCategory.fdOrder}" />
				</td>
				<td>
					<kmss:showDate value="${kmSupplierCategory.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmSupplierCategory.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmSupplierCategory.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmSupplierCategory.docAlteror.fdName}" />
				</td>
				<td>
					<c:out value="${kmSupplierCategory.docAuthor.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>