<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="content">
		<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
			<ui:content title="${lfn:message('sys-organization:table.sysOrgPersonAddressType')}">
					<html:form styleId="sysOrgPersonForm" action="/sys/organization/sys_org_person/sysOrgPerson.do">
						<script type="text/javascript">
							Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|doclist.js|dialog.js");
						</script>
						<table id="TABLE_DocList" class="tb_normal" width=100%>
							<tr>
								<td width="20%" align="center" class="td_normal_title"><bean:message  bundle="sys-organization" key="sysOrgPersonAddressType.fdName"/></td>
								<td width="65%" align="center" class="td_normal_title"><bean:message  bundle="sys-organization" key="sysOrgPersonAddressType.fdMemberName"/></td>
								<td width="15%" align="center" class="td_normal_title">
									<img src="${LUI_ContextPath}/resource/style/default/icons/add.gif" alt="add" onclick="DocList_AddRow();" style="cursor:pointer">
								</td>
							</tr>
							<!--基准行-->
							<tr KMSS_IsReferRow="1" style="display:none">
								<td width="20%">
									<input type="hidden" name="addressTypeList[!{index}].fdId">
									<xform:text property="addressTypeList[!{index}].fdName" required="true" style="90%" showStatus="edit"></xform:text>
								</td>
								<td width="65%">
									<input type="hidden" name="addressTypeList[!{index}].fdOrder">
									<xform:address propertyId="addressTypeList[!{index}].fdTypeMemberIds" 
											propertyName="addressTypeList[!{index}].fdTypeMemberNames" style="width:90%" 
											mulSelect="true" orgType="ORG_TYPE_ALL|64" showStatus="edit" required="true"></xform:address>
								</td>
								<td width="15%">
									<center>
										<img src="${LUI_ContextPath}/resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
										<img src="${LUI_ContextPath}/resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
										<img src="${LUI_ContextPath}/resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1);" style="cursor:pointer">
									</center>
								</td>
							</tr>
							<!--内容行-->
							<c:forEach items="${sysOrgPersonForm.addressTypeList}" var="addressTypeList" varStatus="vstatus">
								<tr KMSS_IsContentRow="1">
									<td width="20%">
										<input type="hidden" name="addressTypeList[${vstatus.index}].fdId">
										<xform:text property="addressTypeList[${vstatus.index}].fdName" required="true" showStatus="edit"></xform:text>
									</td>
									<td width="65%">
										<input type="hidden" name="addressTypeList[${vstatus.index}].fdOrder" value="${addressTypeList.fdOrder }">
										<xform:address propertyId="addressTypeList[${vstatus.index}].fdTypeMemberIds" 
											propertyName="addressTypeList[${vstatus.index}].fdTypeMemberNames" style="width:90%" 
											mulSelect="true" orgType="ORG_TYPE_ALL|64" showStatus="edit" required="true"></xform:address>
									</td>
									<td width="15%">
										<center>
											<img src="${LUI_ContextPath}/resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
											<img src="${LUI_ContextPath}/resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
											<img src="${LUI_ContextPath}/resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1);" style="cursor:pointer">
										</center>
									</td>
								</tr>
							</c:forEach>
						</table>
					</html:form>
					
					<div style="text-align: center; margin: 20px 0;">
						<ui:button text="${lfn:message('button.save')}" onclick="ajaxUpdate();">
						</ui:button>
					</div>
					<script>
					var valid = $KMSSValidation(document.forms['sysOrgPersonForm']);
					function ajaxUpdate() {

						if (!valid.validate())
							return;
						
						seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
							
							$("[name$='.fdOrder']").each(function(i) {
								this.value = i + 1;
							});
							
							var loading = dialog.loading('', $('body'));
							var data = $("#sysOrgPersonForm").serialize();
							$.ajax({
								type : "POST",
								url : Com_SetUrlParameter($("#sysOrgPersonForm").attr('action'), "method", 'updateAddress'),
								data : data,
								dataType : 'json',
								success : function(result) {
									loading.hide();
									dialog["success"](result.msg || "${lfn:message('return.optSuccess')}", $('body'));
								},
								error : function(result) {
									loading.hide();
									var msg = [];
									if (result.responseJSON) {
										var messages = result.responseJSON.message;
										for (var i = 0 ; i < messages.length; i ++) {
											msg.push(messages[i].msg);
										}
									}
									dialog["failure"](msg.join("") || "${lfn:message('return.optFailure')}", $('body'));
								}
							});
						});
					}
					document.forms['sysOrgPersonForm'].onsubmit = function() {
						return false;
					};
					</script>
			</ui:content>
		</ui:panel>
		
	</template:replace>
</template:include>