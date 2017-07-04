<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do">
<div id="optBarDiv">
	<c:if test="${kmCollaboratePartnerInfoForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmCollaboratePartnerInfoForm, 'update');">
	</c:if>
	<c:if test="${kmCollaboratePartnerInfoForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmCollaboratePartnerInfoForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmCollaboratePartnerInfoForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaboratePartnerInfo"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdCreateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsRead"/>
		</td><td width="35%">
			<xform:radio property="fdIsRead">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdReadTime"/>
		</td><td width="35%">
			<xform:datetime property="fdReadTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsFollow"/>
		</td><td width="35%">
			<xform:radio property="fdIsFollow">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdFollowTime"/>
		</td><td width="35%">
			<xform:datetime property="fdFollowTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdOperatorId"/>
		</td><td width="35%">
			<xform:text property="fdOperatorId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdOperateType"/>
		</td><td width="35%">
			<xform:text property="fdOperateType" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdCommunicationMain"/>
		</td><td width="35%">
			<xform:select property="fdCommunicationMainId">
				<xform:beanDataSource serviceBean="kmCollaborateMainService" selectBlock="fdId,docSubject" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdPerson"/>
		</td><td width="35%">
			<xform:address propertyId="fdPersonId" propertyName="fdPersonName" orgType="ORG_TYPE_ALL" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>