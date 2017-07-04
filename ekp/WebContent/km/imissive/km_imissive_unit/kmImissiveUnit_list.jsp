<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imissive/km_imissive_unit/kmImissiveUnit.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imissive/km_imissive_unit/kmImissiveUnit.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_unit/kmImissiveUnit.do" />?method=add&parentId=${param.parentId}');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imissive/km_imissive_unit/kmImissiveUnit.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveUnitForm, 'deleteall');">
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
				<sunbor:column property="kmImissiveUnit.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveUnit.fdCategory.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdCategoryId"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveUnit.fdShortName">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdShortName"/>
				</sunbor:column>

				<sunbor:column property="kmImissiveUnit.fdNature">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdNature"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveUnit.fdIsAvailable">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdIsAvailable"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveUnit.docCreator.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.docCreateId"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveUnit.docCreateTime">
					<bean:message  bundle="km-imissive" key="kmImissiveUnit.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveUnit" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_unit/kmImissiveUnit.do" />?method=view&fdId=${kmImissiveUnit.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImissiveUnit.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmImissiveUnit.fdName}" />
				</td>
				<td>
					<c:out value="${kmImissiveUnit.fdCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmImissiveUnit.fdShortName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImissiveUnit.fdNature}" enumsType="kmImissiveUnit.fdNature" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImissiveUnit.fdIsAvailable}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${kmImissiveUnit.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmImissiveUnit.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>