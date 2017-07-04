<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">

Com_IncludeFile("dialog.js");

function showKeydataUsed(){
	var obj = document.getElementsByName("List_Selected");
	var count = 0;
	var id = null;
	for(var i=0; i<obj.length; i++){
		if(obj[i].checked){
			count++;
			id = obj[i].value;
		}
	}
	if(count==0){
		alert("您没有选择需要操作的数据");
		return false;
	}else if(count>1){
		alert("只能选择一条记录");
		return false;
	}

	var url = '<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do" />?method=showUsed'+'&keydataId='+id;
	
	Com_OpenWindow(url);
}

</script>
<html:form action="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do">

<c:import url="/sys/right/doc_right_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.supplier.model.KmSupplierMain" />
	</c:import>
	<c:import url="/sys/simplecategory/include/doc_cate_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.supplier.model.KmSupplierMain" />
		<c:param name="docFkName" value="kmSupplierCategory" />
		<c:param name="cateModelName"
			value="com.landray.kmss.km.keydata.supplier.model.KmSupplierCategory" />
	</c:import>
	
	<div id="optBarDiv">
		<c:if test="${empty param.categoryId}">
				<kmss:auth
			requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=add"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.keydata.supplier.model.KmSupplierCategory','<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</kmss:auth>
		</c:if>
		
	<c:if test="${not empty param.categoryId}">
		<kmss:auth
			requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=add&fdTemplateId=${param.categoryId}"
			requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do" />?method=add&fdTemplateId=${param.categoryId}');">
		</kmss:auth>
	</c:if>
	
	<c:if test="${param.fdIsAvailable=='true'}">
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=disableAll">
			<input type="button" value="置为无效"
				onclick="Com_Submit(document.kmSupplierMainForm, 'disableAll');">
		</kmss:auth>
	</c:if>
	<c:if test="${param.fdIsAvailable=='false'}">
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=enableAll">
			<input type="button" value="置为有效"
				onclick="Com_Submit(document.kmSupplierMainForm, 'enableAll');">
		</kmss:auth>
	</c:if>
		
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
				<sunbor:column property="kmSupplierMain.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierMain.fdCode">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdCode"/>
				</sunbor:column>
				
				<sunbor:column property="kmSupplierMain.fdLegal">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdLegal"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierMain.fdRegMoney">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdRegMoney"/>
				</sunbor:column>
				<sunbor:column property="kmSupplierMain.fdContactPerson">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdContactPerson"/>
				</sunbor:column>
				
				<sunbor:column property="kmSupplierMain.docCreator.fdName">
					<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSupplierMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do" />?method=showUsed&fdId=${kmSupplierMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSupplierMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmSupplierMain.fdName}" />
				</td>
				<td>
					<c:out value="${kmSupplierMain.fdCode}" />
				</td>
				
				<td>
					<c:out value="${kmSupplierMain.fdLegal}" />
				</td>
				<td>
					<c:out value="${kmSupplierMain.fdRegMoney}" />
				</td>
				<td>
					<c:out value="${kmSupplierMain.fdContactPerson}" />
				</td>
				
				<td>
					<c:out value="${kmSupplierMain.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>