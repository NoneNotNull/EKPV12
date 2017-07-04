<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/smissive/km_smissive_template/kmSmissiveTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/smissive/km_smissive_template/kmSmissiveTemplate.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/smissive/km_smissive_template/kmSmissiveTemplate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/smissive/km_smissive_template/kmSmissiveTemplate.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmSmissiveTemplateForm, 'deleteall');">
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
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="kmSmissiveTemplate.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveTemplate.fdOrder">
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveTemplate.fdParent.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdParentId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveTemplate.docCreator.fdName">
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="kmSmissiveTemplate.docCreateTime">
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmSmissiveTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/smissive/km_smissive_template/kmSmissiveTemplate.do" />?method=view&fdId=${kmSmissiveTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmSmissiveTemplate.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmSmissiveTemplate.fdName}" />
				</td>
				<td>
					<c:out value="${kmSmissiveTemplate.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmSmissiveTemplate.fdParent.fdName}" />
				</td>
				<td>
					<c:out value="${kmSmissiveTemplate.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmSmissiveTemplate.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>