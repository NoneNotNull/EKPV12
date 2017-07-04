<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.list">
	<template:replace name="toolbar">
			<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<kmss:auth requestURL="/work/cases/work_cases_category/workCasesCategory.do?method=add">
					<ui:button text="${ lfn:message('button.add') }" 
						onclick="Com_OpenWindow('${LUI_ContextPath}/work/cases/work_cases_category/workCasesCategory.do?method=add');">
					</ui:button>
				</kmss:auth>
				<kmss:auth requestURL="/work/cases/work_cases_category/workCasesCategory.do?method=deleteall">
					<ui:button text="${ lfn:message('button.delete') }"
						onclick="if(!List_ConfirmDel())return;Com_Submit(document.workCasesCategoryForm, 'deleteall');">
					</ui:button>
				</kmss:auth>
			</ui:toolbar>
	</template:replace>
 
	<template:replace name="content">
	
<html:form action="/work/cases/work_cases_category/workCasesCategory.do">
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
				<sunbor:column property="workCasesCategory.fdName">
					<bean:message bundle="work-cases" key="workCasesCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="workCasesCategory.fdOrder">
					<bean:message bundle="work-cases" key="workCasesCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="workCasesCategory.docCreateTime">
					<bean:message bundle="work-cases" key="workCasesCategory.docCreateTime"/>
				</sunbor:column>
				<%-- <sunbor:column property="workCasesCategory.fdHierarchyId">
					<bean:message bundle="work-cases" key="workCasesCategory.fdHierarchyId"/>
				</sunbor:column> --%>
				<sunbor:column property="workCasesCategory.docCreator.fdName">
					<bean:message bundle="work-cases" key="workCasesCategory.docCreator"/>
				</sunbor:column>
				<sunbor:column property="workCasesCategory.fdParent.fdName">
					<bean:message bundle="work-cases" key="workCasesCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="workCasesCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/work/cases/work_cases_category/workCasesCategory.do" />?method=view&fdId=${workCasesCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${workCasesCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${workCasesCategory.fdName}" />
				</td>
				<td>
					<c:out value="${workCasesCategory.fdOrder}" />
				</td>
				<td>
					<kmss:showDate value="${workCasesCategory.docCreateTime}" />
				</td>
				<%-- <td>
					<c:out value="${workCasesCategory.fdHierarchyId}" />
				</td> --%>
				<td>
					<c:out value="${workCasesCategory.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${workCasesCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>

	</template:replace>
</template:include>