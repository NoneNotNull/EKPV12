<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	Com_IncludeFile("dialog.js");
</script>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
</c:import>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do">
<div id="optBarDiv">
	<kmss:authShow roles="ROLE_KMSMISSIVE_CREATE">
	<c:choose>
		<c:when test="${not empty param.categoryId}">
		
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=${param.categoryId}')" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=add&categoryId=${param.categoryId}');">
			</kmss:auth>
		
		</c:when>
		<c:otherwise>
		
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add" requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
				onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.smissive.model.KmSmissiveTemplate','<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=add&categoryId=!{id}');">
			</kmss:auth>
		
		</c:otherwise>
	</c:choose>
	</kmss:authShow>
	
	<c:choose>
		<c:when test="${param.status == '10'}">
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall&status=10" requestMethod="GET">
				<input type="button" value="<bean:message key="button.delete"/>"
					onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSmissiveMainForm, 'deleteall');">
			</kmss:auth>
		</c:when>
		<c:otherwise>
			<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall" requestMethod="GET">
				<input type="button" value="<bean:message key="button.delete"/>"
					onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSmissiveMainForm, 'deleteall');">
			</kmss:auth>
		</c:otherwise>
	</c:choose>
	
	<input type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">
	
</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="30pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="kmSmissiveMain.docSubject">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docCreator.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.fdMainDept.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docCreateTime">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.fdTemplate.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdTemplateId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveMain.docStatus">
					<bean:message  bundle="km-smissive" key="kmSmissiveMain.docStatus"/>
				</sunbor:column>								
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSmissiveMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=view&fdId=${kmSmissiveMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSmissiveMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td kmss_wordlength="36">
					<c:out value="${kmSmissiveMain.docSubject}" />
				</td>
				<td width="10%">
					${kmSmissiveMain.docCreator.fdName}
				</td>
				<td kmss_wordlength="12" width="10%">
					${kmSmissiveMain.fdMainDept.fdName}
				</td>
				<td width="15%">
					<kmss:showDate value="${kmSmissiveMain.docCreateTime}" type="datetime"/>
				</td>
				<td kmss_wordlength="20" width="15%">
					${kmSmissiveMain.fdTemplate.fdName}
				</td>
				<td width="10%">
					<sunbor:enumsShow value="${kmSmissiveMain.docStatus}" enumsType="common_status" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>