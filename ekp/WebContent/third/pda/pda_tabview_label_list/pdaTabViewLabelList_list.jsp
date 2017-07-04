<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_tabview_label_list/pdaTabViewLabelList.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_tabview_label_list/pdaTabViewLabelList.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/third/pda/pda_tabview_label_list/pdaTabViewList.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/third/pda/pda_tabview_label_list/pdaTabViewLabelList.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaTabViewLabelListForm, 'deleteall');">
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
				<sunbor:column property="pdaTabViewLabelList.fdTabName">
					<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabName"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewLabelList.fdTabType">
					<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType"/>
				</sunbor:column>
				<sunbor:column property="pdaTabViewLabelList.fdTabModule.fdName">
					<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdSelectModule"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaTabViewLabelList" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaTabViewLabelList.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaTabViewLabelList.fdTabName}" />
				</td>	
				<td>
					<c:out value="${pdaTabViewLabelList.fdTabType}" />
				</td>
				<td>
					<c:if test="${pdaTabViewLabelList.fdTabType=='module' }">
						<c:out value="${pdaTabViewLabelList.fdTabModule.fdName}" />
					</c:if>
					<c:if test="${pdaTabViewLabelList.fdTabType=='home' }">
						<c:out value="${pdaTabViewLabelList.fdTabModule.fdName}" />
					</c:if>
					<c:if test="${pdaTabViewLabelList.fdTabType=='doc' }">
						<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabDoc" />
					</c:if>
					<c:if test="${pdaTabViewLabelList.fdTabType=='search' }">
						<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabSearch" />
					</c:if>
					<c:if test="${pdaTabViewLabelList.fdTabType=='list'||pdaTabViewLabelList.fdTabType=='listtab'}">
						<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabList" />
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>