<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_alter/kmsIntegralAlter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_alter/kmsIntegralAlter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_alter/kmsIntegralAlter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_alter/kmsIntegralAlter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralAlterForm, 'deleteall');">
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
				<sunbor:column property="kmsIntegralAlter.fdSubject">
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralAlter.fdStatus">
					<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralAlter.fdValue">
					<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdValue"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralAlter.fdType">
					<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdType"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralAlter.fdCreate.fdName">
					<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdCreate"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralAlter.fdCreateTime">
					<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralAlter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_alter/kmsIntegralAlter.do" />?method=view&fdId=${kmsIntegralAlter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsIntegralAlter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="40%">
					<c:out value="${kmsIntegralAlter.fdSubject}" />
				</td>
				<td width="10%">
					<c:if test="${kmsIntegralAlter.fdStatus == true}">
						<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.true"/>
					</c:if>
					<c:if test="${kmsIntegralAlter.fdStatus == false}">
						<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.false"/>
					</c:if>
				</td>
				<td width="10%">
					<c:out value="${kmsIntegralAlter.fdValue}" />
				</td>
				<td width="10%">
					<c:if test="${kmsIntegralAlter.fdType == 1}">
						<bean:message bundle="kms-integral" key="kms_integral_alter_type_exp"/>
					</c:if>
					<c:if test="${kmsIntegralAlter.fdType == 2}">
						<bean:message bundle="kms-integral" key="kms_integral_alter_type_riches"/>
					</c:if>
				</td>
				<td width="8%">
					<c:out value="${kmsIntegralAlter.fdCreate.fdName}" />
				</td>
				<td width="12%">
					<kmss:showDate value="${kmsIntegralAlter.fdCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>