<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/keydata/customer/km_customer_main/kmCustomerMain.do">
<script language="JavaScript">
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

		var url = '<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do" />?method=showUsed'+'&keydataId='+id;
		
		Com_OpenWindow(url);
	}
</script>

<c:import url="/sys/right/doc_right_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.customer.model.KmCustomerMain" />
	</c:import>
	<c:import url="/sys/simplecategory/include/doc_cate_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.customer.model.KmCustomerMain" />
		<c:param name="docFkName" value="kmCustomerCategory" />
		<c:param name="cateModelName"
			value="com.landray.kmss.km.keydata.customer.model.KmCustomerCategory" />
	</c:import>
	
	<div id="optBarDiv">
		
		<c:if test="${empty param.categoryId}">
			<kmss:auth
			requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=add"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.keydata.customer.model.KmCustomerCategory','<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</kmss:auth>
		</c:if>
		
	<c:if test="${not empty param.categoryId}">
		<kmss:auth
			requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=add"
			requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do" />?method=add&fdTemplateId=${param.categoryId}');">
		</kmss:auth>
	</c:if>
	<c:if test="${param.fdIsAvailable=='true'}">
		<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=disableAll">
			<input type="button" value="置为无效"
				onclick="Com_Submit(document.kmCustomerMainForm, 'disableAll');">
		</kmss:auth>
	</c:if>
	<c:if test="${param.fdIsAvailable=='false'}">
		<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=enableAll">
			<input type="button" value="置为有效"
				onclick="Com_Submit(document.kmCustomerMainForm, 'enableAll');">
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
				<sunbor:column property="kmCustomerMain.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerMain.fdCode">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdCode"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerMain.fdBrief">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdBrief"/>
				</sunbor:column>
				<sunbor:column property="kmCustomerMain.fdEnglishName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdEnglishName"/>
				</sunbor:column>
				<%-- 
				<sunbor:column property="kmCustomerMain.fdDescription">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdDescription"/>
				</sunbor:column>
				--%>
				<sunbor:column property="kmCustomerMain.docCreator.fdName">
					<bean:message bundle="km-keydata-customer" key="kmCustomerMain.docCreator"/>
				</sunbor:column>
				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCustomerMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do" />?method=showUsed&fdId=${kmCustomerMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCustomerMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmCustomerMain.fdName}" />
				</td>
				<td>
					<c:out value="${kmCustomerMain.fdCode}" />
				</td>
				
				<td>
					<c:out value="${kmCustomerMain.fdBrief}" />
				</td>
				<td>
					<c:out value="${kmCustomerMain.fdEnglishName}" />
				</td>
				<%--
				<td>
					<c:out value="${kmCustomerMain.fdDescription}" />
				</td>
				--%>
				<td>
					<c:out value="${kmCustomerMain.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>