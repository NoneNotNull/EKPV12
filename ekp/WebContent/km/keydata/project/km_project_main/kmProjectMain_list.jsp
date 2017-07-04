<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
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

	var url = '<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do" />?method=showUsed'+'&keydataId='+id;
	
	Com_OpenWindow(url);
}

</script>
<html:form action="/km/keydata/project/km_project_main/kmProjectMain.do">

	<c:import url="/sys/right/doc_right_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.project.model.KmProjectMain" />
	</c:import>
	<c:import url="/sys/simplecategory/include/doc_cate_change_button.jsp"
		charEncoding="UTF-8">
		<c:param name="modelName"
			value="com.landray.kmss.km.keydata.project.model.KmProjectMain" />
		<c:param name="docFkName" value="kmProjectCategory" />
		<c:param name="cateModelName"
			value="com.landray.kmss.km.keydata.project.model.KmProjectCategory" />
	</c:import>
	
	<div id="optBarDiv">
	
		<c:if test="${empty param.categoryId}">
			<kmss:auth
			requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=add"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.keydata.project.model.KmProjectCategory','<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</kmss:auth>
		</c:if>
		
	<c:if test="${not empty param.categoryId}">
		<kmss:auth
			requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=add&fdTemplateId=${param.categoryId}"
			requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do" />?method=add&fdTemplateId=${param.categoryId}');">
		</kmss:auth>
		
	</c:if>
	
	<c:if test="${param.fdIsAvailable=='true'}">
		<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=disableAll">
			<input type="button" value="置为无效"
				onclick="Com_Submit(document.kmProjectMainForm, 'disableAll');">
		</kmss:auth>
	</c:if>
	<c:if test="${param.fdIsAvailable=='false'}">
		<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=enableAll">
			<input type="button" value="置为有效"
				onclick="Com_Submit(document.kmProjectMainForm, 'enableAll');">
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
				<sunbor:column property="kmProjectMain.fdName">
					<bean:message bundle="km-keydata-project" key="kmProjectMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmProjectMain.fdCode">
					<bean:message bundle="km-keydata-project" key="kmProjectMain.fdCode"/>
				</sunbor:column>
				<sunbor:column property="kmProjectMain.fdExecutiveDept.fdName">
					<bean:message bundle="km-keydata-project" key="kmProjectMain.fdExecutiveDept"/>
				</sunbor:column>
				<sunbor:column property="kmProjectMain.fdStatus">
					<bean:message bundle="km-keydata-project" key="kmProjectMain.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="kmProjectMain.docCreator.fdName">
					<bean:message bundle="km-keydata-project" key="kmProjectMain.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmProjectMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do" />?method=showUsed&fdId=${kmProjectMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmProjectMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmProjectMain.fdName}" />
				</td>
				<td>
					<c:out value="${kmProjectMain.fdCode}" />
				</td>
				<td>
					<c:out value="${kmProjectMain.fdExecutiveDept.fdName}" />
				</td>
				<td>
					<xform:select value="${kmProjectMain.fdStatus}" property="fdStatus" showStatus="view">
						<xform:enumsDataSource enumsType="km_keydata_project_status" />
					</xform:select>
				</td>
				<td>
					<c:out value="${kmProjectMain.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>