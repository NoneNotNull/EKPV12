<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_module_label_view/pdaModuleLabelView.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_module_label_view/pdaModuleLabelView.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_label_view/pdaModuleLabelView.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_label_view/pdaModuleLabelView.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaModuleLabelViewForm, 'deleteall');">
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
				<sunbor:column property="pdaModuleLabelView.fdName">
					<bean:message bundle="third-pda" key="pdaModuleLabelView.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleLabelView.fdCfgView.fdKeyword">
					<bean:message bundle="third-pda" key="pdaModuleLabelView.fdCfgView"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaModuleLabelView" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_module_label_view/pdaModuleLabelView.do" />?method=view&fdId=${pdaModuleLabelView.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaModuleLabelView.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaModuleLabelView.fdName}" />
				</td>
				<td>
					<c:out value="${pdaModuleLabelView.fdCfgView.fdKeyword}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>