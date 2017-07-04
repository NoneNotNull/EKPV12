<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<center>
<table  class="tb_normal" width="100%" id="TABLE_DocList" style="margin-top: -15px;TABLE-LAYOUT: fixed;WORD-BREAK: break-all;;margin-bottom: -15px;">
	<tr>
		<td KMSS_IsRowIndex="1" width="3%" class="td_normal_title"><bean:message key="page.serial" /></td>
		<td width="4%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaModuleLabelList.fdIsLink" /></td>
		<td class="td_normal_title" width="30%"><bean:message bundle="third-pda" key="pdaModuleLabelList.fdName"/></td>
		<td class="td_normal_title" width="10%"><bean:message bundle="third-pda" key="pdaModuleLabelList.fdNameExap"/></td>
		<td class="td_normal_title"  width="50%"><bean:message bundle="third-pda" key="pdaModuleLabelList.fdDataUrl"/></td>
		<td class="td_normal_title"  align="center" width="100px;">
			<img src="${KMSS_Parameter_StylePath}icons/add.gif"
				style="cursor:pointer" onclick="DocList_AddRow();" title="<bean:message key="button.insert"/>">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">${index+1}</td>
		<td width="5%">
			<input type="hidden" name="fdLabelList[!{index}].fdIsLink">
			<label><input type="checkbox" name="fdLabelList[!{index}].fdIsLinkCheck" onclick="clearLabelInfo('!{index}',this);"/>
			<bean:message key="message.yes" /></label>
		</td>
		<td width="30%">
			<input type="hidden" name="fdLabelList[!{index}].fdId" />
			<input type="hidden" name="fdLabelList[!{index}].fdOrder" />
			<input type="hidden" name="fdLabelList[!{index}].fdCountUrl" />
			<input type="hidden" name="fdLabelList[!{index}].fdModuleId" value="${pdaModuleConfigMainForm.fdId}"/>
			<input name="fdLabelList[!{index}].fdName" class="inputsgl" style="width: 90%" />
			&nbsp;<a href="javascript:void(0);" onclick="selectDataUrl('!{index}');"><bean:message key="button.select"/></a>
		</td>
		<td width="10%">
			<span name="fdLabelList[!{index}].fdNameExap"></span>
		</td>
		<td width="50%">
			<input name="fdLabelList[!{index}].fdDataUrl" class="inputsgl" style="width: 95%" onchange="clearLabelInfo('!{index}');"/>
		</td>
		<td align="center" width="100px;">
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0"  title="<bean:message key="button.delete"/>"/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0"  title="<bean:message key="button.moveup"/>"/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0"  title="<bean:message key="button.movedown"/>"/></a>
		</td>
	</tr>
	<!--内容行-->
	<c:forEach items="${pdaModuleConfigMainForm.fdLabelList}" varStatus="vstatus" var="pdaModuleLabelListForm">
		<tr KMSS_IsContentRow="1">
			<td KMSS_IsRowIndex="1">${vstatus.index+1}</td>
			<td width="4%">
				<input type="hidden" value="${pdaModuleLabelListForm.fdIsLink}" name="fdLabelList[${vstatus.index}].fdIsLink">
				<label><input type="checkbox" name="fdLabelList[${vstatus.index}].fdIsLinkCheck" onclick="clearLabelInfo('${vstatus.index}',this);" 
				<c:if test="${pdaModuleLabelListForm.fdIsLink=='1'}">checked</c:if>/><bean:message key="message.yes" /></label>
			</td>
			<td width="30%">
				<input type="hidden" name="fdLabelList[${vstatus.index}].fdId" value="${pdaModuleLabelListForm.fdId}"/>
				<input type="hidden" name="fdLabelList[${vstatus.index}].fdOrder" value="${pdaModuleLabelListForm.fdOrder}"/>
				<input type="hidden" name="fdLabelList[${vstatus.index}].fdCountUrl" value="${pdaModuleLabelListForm.fdCountUrl}"/>
				<input type="hidden" name="fdLabelList[${vstatus.index}].fdModuleId" value="${pdaModuleConfigMainForm.fdId}" />
				<input name="fdLabelList[${vstatus.index}].fdName" class="inputsgl" style="width: 90%" value="${pdaModuleLabelListForm.fdName}" />
				&nbsp;<a href="javascript:void(0);" onclick="selectDataUrl('${vstatus.index}');"><bean:message key="button.select"/></a>
			</td>
			<td width="10%">
				<span name="fdLabelList[${vstatus.index}].fdNameExap">
					${pdaModuleLabelListForm.fdName}<c:if test="${pdaModuleLabelListForm.fdCountUrl!=null && pdaModuleLabelListForm.fdCountUrl!=''}">(10)</c:if>
				</span>
			</td>
			<td width="50%">
				<input name="fdLabelList[${vstatus.index}].fdDataUrl" class="inputsgl" style="width: 95%"  value="${pdaModuleLabelListForm.fdDataUrl}" onchange="clearLabelInfo('${vstatus.index}');"/>
			</td>
			<td align="center" width="100px;">
				<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" title="<bean:message key="button.delete"/>" /></a>
				<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" title="<bean:message key="button.moveup"/>" /></a>
				<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" title="<bean:message key="button.movedown"/>" /></a>
			</td>
		</tr>
	</c:forEach>
</table>
</center>
