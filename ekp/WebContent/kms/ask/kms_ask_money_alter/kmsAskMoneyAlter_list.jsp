<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsAskMoneyAlterForm, 'deleteall');">
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
				<sunbor:column property="kmsAskMoneyAlter.fdMoneyAlter">
					<bean:message bundle="kms-ask" key="kmsAskMoneyAlter.fdMoneyAlter"/>
				</sunbor:column>
				<sunbor:column property="kmsAskMoneyAlter.fdAlterTime">
					<bean:message bundle="kms-ask" key="kmsAskMoneyAlter.fdAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsAskMoneyAlter.fdPersonList">
					<bean:message bundle="kms-ask" key="kmsAskMoneyAlter.fdPersonList"/>
				</sunbor:column>
				<sunbor:column property="kmsAskMoneyAlter.docCreator.fdName">
					<bean:message bundle="kms-ask" key="kmsAskMoneyAlter.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsAskMoneyAlter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/ask/kms_ask_money_alter/kmsAskMoneyAlter.do" />?method=view&fdId=${kmsAskMoneyAlter.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsAskMoneyAlter.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsAskMoneyAlter.fdMoneyAlter}" />
				</td>
				<td>
					<kmss:showDate value="${kmsAskMoneyAlter.fdAlterTime}" />
				</td>
				<td>
					<c:out value="${kmsAskMoneyAlter.fdPersonList}" />
				</td>
				<td>
					<c:out value="${kmsAskMoneyAlter.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>