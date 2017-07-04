<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.list">
	<template:replace name="toolbar">
			<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<kmss:auth requestURL="/example/rules/example_rules_category/exampleRulesCategory.do?method=add">
					<ui:button text="${ lfn:message('button.add') }" 
						onclick="Com_OpenWindow('${LUI_ContextPath}/example/rules/example_rules_category/exampleRulesCategory.do?method=add');">
					</ui:button>
				</kmss:auth>
				<kmss:auth requestURL="/example/rules/example_rules_category/exampleRulesCategory.do?method=deleteall">
					<ui:button text="${ lfn:message('button.delete') }"
						onclick="if(!List_ConfirmDel())return;Com_Submit(document.exampleRulesCategoryForm, 'deleteall');">
					</ui:button>
				</kmss:auth>
			</ui:toolbar>
	</template:replace>
 
	<template:replace name="content">
	
<html:form action="/example/rules/example_rules_category/exampleRulesCategory.do">
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
				<sunbor:column property="exampleRulesCategory.fdName">
					<bean:message bundle="example-rules" key="exampleRulesCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="exampleRulesCategory.fdOrder">
					<bean:message bundle="example-rules" key="exampleRulesCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="exampleRulesCategory.docCreateTime">
					<bean:message bundle="example-rules" key="exampleRulesCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="exampleRulesCategory.fdParent.fdName">
					<bean:message bundle="example-rules" key="exampleRulesCategory.fdParent"/>
				</sunbor:column>
				<sunbor:column property="exampleRulesCategory.docCreator.fdName">
					<bean:message bundle="example-rules" key="exampleRulesCategory.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="exampleRulesCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/example/rules/example_rules_category/exampleRulesCategory.do" />?method=view&fdId=${exampleRulesCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${exampleRulesCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${exampleRulesCategory.fdName}" />
				</td>
				<td>
					<c:out value="${exampleRulesCategory.fdOrder}" />
				</td>
				<td>
					<kmss:showDate value="${exampleRulesCategory.docCreateTime}" />
				</td>
				<td>
					<c:out value="${exampleRulesCategory.fdParent.fdName}" />
				</td>
				<td>
					<c:out value="${exampleRulesCategory.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>

	</template:replace>
</template:include>