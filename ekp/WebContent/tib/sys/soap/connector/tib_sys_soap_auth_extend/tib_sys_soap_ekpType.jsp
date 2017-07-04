<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<xform:editShow>
<tr id="wsUserPassword" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false' || tibSysSoapSettingForm.fdAuthMethod != 'ekpType' || tibSysSoapSettingForm.fdAuthMethod != 'soapHeaderType'||tibSysSoapSettingForm.fdAuthMethod != 'userToken' }">style="display: none"</c:if> >
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdUserName"/>
		
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdPassword"/>
		</td><td width="35%">
			<html:password property="fdPassword" style="width:85%" styleClass="inputsgl"/>
		</td>
</tr>
</xform:editShow>
<xform:viewShow>
<c:if test="${tibSysSoapSettingForm.fdCheck eq 'true' }">
<c:if test="${tibSysSoapSettingForm.fdAuthMethod == 'ekpType' || tibSysSoapSettingForm.fdAuthMethod == 'soapHeaderType'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdUserName"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdPassword"/>
		</td><td width="35%">
			<input type="password" name="fdPassword" value="${tibSysSoapSettingForm.fdPassword }" readonly="readonly" style="width: 85%; border: 0px solid #000000;"/>
		</td>
	</tr>
	</c:if>
</c:if>

</xform:viewShow>
