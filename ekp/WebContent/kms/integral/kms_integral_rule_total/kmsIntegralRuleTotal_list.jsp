<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_rule_total/kmsIntegralRuleTotal.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_rule_total/kmsIntegralRuleTotal.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_rule_total/kmsIntegralRuleTotal.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_rule_total/kmsIntegralRuleTotal.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralRuleTotalForm, 'deleteall');">
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
				<sunbor:column property="kmsIntegralRuleTotal.docAlterTime">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralRuleTotal.totalScore">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.totalScore"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralRuleTotal.totalRiches">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.totalRiches"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralRuleTotal.ruleId">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.ruleId"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralRuleTotal.user.fdName">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.user"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralRuleTotal.module.fdId">
					<bean:message bundle="kms-integral" key="kmsIntegralRuleTotal.module"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralRuleTotal" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_rule_total/kmsIntegralRuleTotal.do" />?method=view&fdId=${kmsIntegralRuleTotal.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralRuleTotal.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${kmsIntegralRuleTotal.docAlterTime}" />
				</td>
				<td>
					<c:out value="${kmsIntegralRuleTotal.totalScore}" />
				</td>
				<td>
					<c:out value="${kmsIntegralRuleTotal.totalRiches}" />
				</td>
				<td>
					<c:out value="${kmsIntegralRuleTotal.ruleId}" />
				</td>
				<td>
					<c:out value="${kmsIntegralRuleTotal.user.fdName}" />
				</td>
				<td>
					<c:out value="${kmsIntegralRuleTotal.module.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>