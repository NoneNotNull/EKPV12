<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_module_label_list/pdaModuleLabelList.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_module_label_list/pdaModuleLabelList.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_module_label_list/pdaModuleLabelList.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaModuleLabelListForm, 'deleteall');">
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
				<sunbor:column property="pdaModuleLabelList.fdName">
					<bean:message bundle="third-pda" key="pdaModuleLabelList.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleLabelList.fdDataUrl">
					<bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl"/>
				</sunbor:column>
				<sunbor:column property="pdaModuleLabelList.fdModule.fdName">
					<bean:message bundle="third-pda" key="pdaModuleLabelList.fdModule"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaModuleLabelList" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_module_label_list/pdaModuleLabelList.do" />?method=view&fdId=${pdaModuleLabelList.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaModuleLabelList.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaModuleLabelList.fdName}" />
				</td>
				<td>
					<c:out value="${pdaModuleLabelList.fdDataUrl}" />
				</td>
				<td>
					<c:out value="${pdaModuleLabelList.fdModule.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>