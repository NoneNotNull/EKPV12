<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
</script>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do">
	<div id="optBarDiv">
		
			<c:if test="${empty param.categoryId}">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory','<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</c:if>
			<c:if test="${not empty param.categoryId}">
				<c:set var="flg" value="no"/>
				<kmss:auth requestMethod="GET"
					requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=add&fdTemplateId=${param.categoryId}">
					<input type="button" value="<bean:message key="button.add"/>"
						onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do" />?method=add&fdTemplateId=${param.categoryId}');">
					<c:set var="flg" value="yes"/>
				</kmss:auth>
				<c:if test="${flg eq 'no'}">
					<input type="button" value="<bean:message key="button.add"/>"
						onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory','<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
				</c:if>
			</c:if>
		
		<kmss:auth requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapRfcSettingForm, 'deleteall');">
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
				<sunbor:column property="tibSysSapRfcSetting.fdUse">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdUse"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.fdFunctionName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdFunctionName"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.fdFunction">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdFunction"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.fdWeb">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdWeb"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.fdDescribe">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdDescribe"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.docCategory.fdName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.docCategory"/>
				</sunbor:column>
				<sunbor:column property="tibSysSapRfcSetting.fdPool.fdPoolName">
					<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdPool"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSapRfcSetting" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do" />?method=view&fdId=${tibSysSapRfcSetting.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSapRfcSetting.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<sunbor:enumsShow value="${tibSysSapRfcSetting.fdUse}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcSetting.fdFunctionName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcSetting.fdFunction}" />
				</td>
				<td>
					<sunbor:enumsShow value="${tibSysSapRfcSetting.fdWeb}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcSetting.fdDescribe}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcSetting.docCategory.fdName}" />
				</td>
				<td>
					<c:out value="${tibSysSapRfcSetting.fdPool.fdPoolName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
