<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_module_config_view/pdaModuleConfigView.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_module_config_view/pdaModuleConfigView.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_config_view/pdaModuleConfigView.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_config_view/pdaModuleConfigView.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaModuleConfigViewForm, 'deleteall');">
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
				<sunbor:column property="pdaModuleConfigView.fdKeyword">
					<bean:message bundle="third-pda" key="pdaModuleConfigView.fdKeyword"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigView.fdModelName">
					<bean:message bundle="third-pda" key="pdaModuleConfigView.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleConfigView.fdModule.fdName">
					<bean:message bundle="third-pda" key="pdaModuleConfigView.fdModule"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaModuleConfigView" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_module_config_view/pdaModuleConfigView.do" />?method=view&fdId=${pdaModuleConfigView.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaModuleConfigView.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaModuleConfigView.fdKeyword}" />
				</td>
				<td>
					<c:out value="${pdaModuleConfigView.fdModelName}" />
				</td>
				<td>
					<c:out value="${pdaModuleConfigView.fdModule.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>