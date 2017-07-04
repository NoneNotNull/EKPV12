<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<%@page import="com.landray.kmss.sys.organization.forms.SysOrgPersonInfoForm"%>
<%@page import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super/> - ${lfn:message('sys-organization:sysOrgPerson.button.changeInfo')}
	</template:replace>
	<template:replace name="content">
		<ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
			<ui:content title="${lfn:message('sys-organization:sysOrgPerson.button.changeInfo')}">
					<html:form styleId="sysOrgPersonInfoForm" 
							action="/sys/organization/sys_org_person/chgPersonInfo.do?method=saveInfo"
							onsubmit="return false;">
						<script type="text/javascript">
							Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|doclist.js|dialog.js");
						</script>
						<table class="tb_normal" style="border: #c0c0c0 1px solid;width: 100%;">
							<tr>
								<td width=30% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdName"/>
								</td><td width=70%>
									<html:text property="fdName" readonly="true" style="width:100%"/>
								</td>
							</tr>
							<tr>
								<td width=30% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdEmail"/>
								</td><td width=70%>
									<html:text property="fdEmail" readonly="true" style="width:100%"/>
								</td>
							</tr>
							<tr>
								<td width=30% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdMobileNo"/>
								</td><td width=70%>
									<html:text property="fdMobileNo" style="width:100%" />
								</td>
							</tr>
							<tr>
								<td width=30% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdWorkPhone" />
								</td><td width=70%>
									<html:text property="fdWorkPhone" style="width:100%" />
								</td>
							</tr>
							<tr>
								<td width=15% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdDefaultLang" />
								</td>
								<td width=35%>
								<%
									SysOrgPersonInfoForm sysOrgPersonForm = (SysOrgPersonInfoForm) request
											.getAttribute("sysOrgPersonInfoForm");
									out.write(SysOrgPersonForm.getLangSelectHtml(request,
											"fdDefaultLang", sysOrgPersonForm.getFdDefaultLang()));
								%>
								</td>
							</tr>
							<tr>
								<td width=30% class="td_normal_title">
									<bean:message bundle="sys-organization" key="sysOrgPerson.fdMemo"/>
								</td><td width=70%>
									<html:textarea property="fdMemo" style="width:100%"/>
								</td>
							</tr>
						</table>
						<script type="text/javascript">
							var valid = $KMSSValidation(document.forms['sysOrgPersonInfoForm']);
							
							function ajaxUpdate() {
								if (!valid.validate())
									return;
								
								seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
									var loading = dialog.loading('', $('#sysOrgPersonInfoForm'));
									var data = $("#sysOrgPersonInfoForm").serialize();
									$.ajax({
										type : "POST",
										url : $("#sysOrgPersonInfoForm").attr('action'),
										data : data,
										dataType : 'json',
										success : function(result) {
											loading.hide();
											dialog["success"](result.msg, $('#sysOrgPersonInfoForm'));
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
											dialog["failure"](msg.join(""), $('#sysOrgPersonInfoForm'));
										}
									});
								});
							}
						</script>
						<div style="text-align: center; margin: 20px 0;">
							<ui:button text="${lfn:message('button.save')}" onclick="ajaxUpdate();">
							</ui:button>
						</div>
					</html:form>
			</ui:content>
		</ui:panel>
		
	</template:replace>
</template:include>