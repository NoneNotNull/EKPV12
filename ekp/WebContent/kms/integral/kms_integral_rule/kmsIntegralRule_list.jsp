<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_rule/kmsIntegralRule.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/integral/kms_integral_rule/kmsIntegralRule.do?method=add">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_rule/kmsIntegralRule.do" />?method=add');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/integral/kms_integral_rule/kmsIntegralRule.do?method=deleteall">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralRuleForm, 'deleteall');">
	</kmss:auth>
</div>
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
			<sunbor:column property="kmsIntegralRule.fdName">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdName"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdStatus">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdStatus"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdUpdateTime">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdUpdateTime"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdExpValue">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdExpValue"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdRichesValue">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdRichesValue"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdObjectExpValue">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectExpValue"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdObjectRichesValue">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectRichesValue"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdModelName">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdModelName"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdOperateName">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdOperateName"/>
			</sunbor:column>
			<sunbor:column property="kmsIntegralRule.fdCategory">
				<bean:message bundle="kms-integral" key="kmsIntegralRule.fdCategory"/>
			</sunbor:column>
		</sunbor:columnHead>
	</tr>
	<c:forEach items="${queryPage.list}" var="kmsIntegralRule" varStatus="vstatus">
		<tr
			kmss_href="<c:url value="/kms/integral/kms_integral_rule/kmsIntegralRule.do" />?method=view&fdId=${kmsIntegralRule.fdId}">
			<td>
				<input type="checkbox" name="List_Selected" value="${kmsIntegralRule.fdId}">
			</td>
			<td>
				${vstatus.index+1}
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdName}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdStatus}" />
			</td>
			<td>
				<kmss:showDate value="${kmsIntegralRule.fdUpdateTime}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdExpValue}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdRichesValue}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdObjectExpValue}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdObjectRichesValue}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdModelName}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdOperateName}" />
			</td>
			<td>
				<c:out value="${kmsIntegralRule.fdCategory}" />
			</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>