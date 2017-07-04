<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do?method=add">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do" />?method=add');">
	</kmss:auth> <kmss:auth
		requestURL="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do?method=deleteall">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSapJcoSettingForm, 'deleteall');">
	</kmss:auth></div>
	<c:if test="${queryPage.totalrows==0}">
		<%@ include file="/resource/jsp/list_norecord.jsp"%>
	</c:if>
	<c:if test="${queryPage.totalrows>0}">
		<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
		<table id="List_ViewTable">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="10pt"><input type="checkbox" name="List_Tongle">
					</td>
					<td width="40pt"><bean:message key="page.serial" /></td>
					<sunbor:column property="tibSysSapJcoSetting.fdPoolName">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdPoolName" />
					</sunbor:column>
					<sunbor:column property="tibSysSapJcoSetting.fdTibSysSapCode.fdServerCode">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdTibSysSapCode" />
					</sunbor:column>
					<sunbor:column property="tibSysSapJcoSetting.fdPoolStatus">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdPoolStatus" />
					</sunbor:column>
					<sunbor:column property="tibSysSapJcoSetting.fdConnectType">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdConnectType" />
					</sunbor:column>

					<sunbor:column property="tibSysSapJcoSetting.fdPoolAdmin">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdPoolAdmin" />
					</sunbor:column>
					<sunbor:column property="tibSysSapJcoSetting.fdPoolNumber">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdPoolNumber" />
					</sunbor:column>
					<sunbor:column property="tibSysSapJcoSetting.fdUpdateTime">
						<bean:message bundle="tib-sys-sap-connector"
							key="tibSysSapJcoSetting.fdUpdateTime" />
					</sunbor:column>

				</sunbor:columnHead>
			</tr>
			<c:forEach items="${queryPage.list}" var="tibSysSapJcoSetting"
				varStatus="vstatus">
				<tr
					kmss_href="<c:url value="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do" />?method=view&fdId=${tibSysSapJcoSetting.fdId}">
					<td><input type="checkbox" name="List_Selected"
						value="${tibSysSapJcoSetting.fdId}"></td>
					<td>${vstatus.index+1}</td>
					<td><c:out value="${tibSysSapJcoSetting.fdPoolName}" /></td>
					<td><c:out value="${tibSysSapJcoSetting.fdTibSysSapCode.fdServerCode}" />
					</td>

					<td><sunbor:enumsShow value="${tibSysSapJcoSetting.fdPoolStatus}"
						enumsType="status_type" bundle="tib-sys-sap-connector"/></td>
					<td><sunbor:enumsShow value="${tibSysSapJcoSetting.fdConnectType}"
						enumsType="connect_type" bundle="tib-sys-sap-connector"/></td>


					<td><c:out value="${tibSysSapJcoSetting.fdPoolAdmin}" /></td>

					<td><c:out value="${tibSysSapJcoSetting.fdPoolNumber}" /></td>
					<td><kmss:showDate value="${tibSysSapJcoSetting.fdUpdateTime}" /></td>

				</tr>
			</c:forEach>
		</table>
		<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
