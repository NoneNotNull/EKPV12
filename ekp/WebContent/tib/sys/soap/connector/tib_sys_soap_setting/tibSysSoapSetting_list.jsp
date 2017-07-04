<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do" />?method=add&categoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapSettingForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapSetting.docSubject">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.docSubject"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapSetting.fdWsdlUrl">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdWsdlUrl"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapSetting.fdEnable">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdEnable"/>
				</sunbor:column>
				<%-- <sunbor:column property="tibSysSoapSetting.fdSoapVerson">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdSoapVerson"/>
				</sunbor:column> --%>
				<sunbor:column property="tibSysSoapSetting.fdProtectWsdl">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdProtectWsdl"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapSetting.fdCheck">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdCheck"/>
				</sunbor:column>
				
				<sunbor:column property="tibSysSoapSetting.settCategory">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.settCategory"/>
				</sunbor:column>
				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapSetting" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do" />?method=view&fdId=${tibSysSoapSetting.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapSetting.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapSetting.docSubject}" />
				</td>
				<td>
					<c:out value="${tibSysSoapSetting.fdWsdlUrl}" />
				</td>
				<td>
					<xform:select value="${tibSysSoapSetting.fdEnable}" property="fdEnable" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:select>
				</td>
				<%-- <td>
					<c:out value="${tibSysSoapSetting.fdSoapVerson}" />
				</td> --%>
				<td>
					<xform:select value="${tibSysSoapSetting.fdProtectWsdl}" property="fdProtectWsdl" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:select>
				</td>
				<td>
					<xform:select value="${tibSysSoapSetting.fdCheck}" property="fdCheck" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:select>
				</td>
				
				<td>
				      <c:out value="${tibSysSoapSetting.settCategory.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
