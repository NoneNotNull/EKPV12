<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmCollaboratePartnerInfo.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmCollaboratePartnerInfo.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
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
			<c:out value="${kmCollaboratePartnerInfoForm.fdCommunicationMainName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdPerson"/>
		</td><td width="35%">
			<c:out value="${kmCollaboratePartnerInfoForm.fdPersonName}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>