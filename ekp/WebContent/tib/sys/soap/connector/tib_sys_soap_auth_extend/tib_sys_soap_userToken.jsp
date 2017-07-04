<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>

<xform:editShow>
<!-- 加密类型 -->
	<tr id="passwordTypeTr" <c:if test="${tibSysSoapSettingForm.fdCheck=='false' || tibSysSoapSettingForm.fdAuthMethod!='userToken'}">style="display: none;"</c:if>  >
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.passwordType"/>
		</td><td width="85%" colspan="3">
			<xform:text property="passwordType" style="width:35%" />
			<span><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.passwordType.ep"/></span>
		</td>
	</tr>
</xform:editShow>

<xform:viewShow>

<c:if test="${tibSysSoapSettingForm.fdCheck eq 'true' }">	
		<!-- 密码类型 -->
	<c:if test="${tibSysSoapSettingForm.fdAuthMethod == 'userToken' }">
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
	<tr id="passwordTypeTr">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.passwordType"/>
		</td><td width="85%" colspan="3">
			${tibSysSoapSettingForm.passwordType}
		</td>
	</tr>
	</c:if>
	</c:if>
	</xform:viewShow>