<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="msg_key" value="sys-person:tab.category.${sysPersonSysTabCategoryForm.fdType}.setting" />
<template:include
		file="/sys/person/sys_person_systab_category/sysPersonSysTabCategory_edit.jsp"
		actionPath="/sys/person/sys_person_systab_category/sysPersonSysTabCategory.do"
		formName="sysPersonSysTabCategoryForm"
		moduleName="${lfn:message('sys-person:module.name') }"
		modelName="${lfn:message(msg_key) }"
		linkType="${sysPersonSysTabCategoryForm.fdType }"
		shortName="true">
		
		<template:replace name="title">
			<c:if test="${sysPersonSysTabCategoryForm.method_GET=='add'}">
				<kmss:message bundle="sys-person" key="tab.category.${sysPersonSysTabCategoryForm.fdType}.create" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
			<c:if test="${sysPersonSysTabCategoryForm.method_GET=='edit'}" >
				<c:out value="${sysPersonSysTabCategoryForm.fdName}" />
				-
				<kmss:message bundle="sys-person" key="module.name" />
			</c:if>
		</template:replace>
		
		<template:replace name="txttitle">
			<bean:message bundle="sys-person" key="tab.category.${sysPersonSysTabCategoryForm.fdType}.setting" />
		</template:replace>
		
		<template:replace name="links">
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysTabPage.content.from" />
				</td>
				<td colspan="3">
					<xform:text property="fdPages[0].fdId" showStatus="noShow" />
					<xform:text property="fdPages[0].fdConfig" showStatus="noShow" />
					<input type="hidden" name="portlet_input_source_format" class="portlet_input_source_format" />
					<input type="hidden" name="portlet_input_source_id" class='portlet_input_source_id' />
					<xform:dialog propertyId="" propertyName="fdPages[0].fdName" style="width:90%" required="true" subject="内容来源">
						openPortletSourceDialog();
					</xform:dialog>
					<div id="portlet_input_source_opt" style="display:none;width:80%;margin-top: 8px;">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.contentOpt') }</div>
					
					<script>
					var dialogWin = window; 
					seajs.use(['lui/dialog','lui/jquery', 'lui/var', 'resource/js/json2.js'], function(dialog, $, varjs, json2) {
						var lodingImg = "<img src='${LUI_ContextPath}/sys/ui/js/ajax.gif'/>";
						window.buildSourceOptHtml = function(portalObj) {
							$("#portlet_input_source_opt").html(lodingImg).show()
								.load("${LUI_ContextPath}/sys/ui/jsp/vars/source.jsp?scene=portal&x="+(new Date().getTime()),{"fdId":portalObj.sourceId, jsname:'sourceOptObj'}, function() {
									if (portalObj.sourceOpt) {
										window.sourceOptObj.setValue(portalObj.sourceOpt);
									}
								});
						};
						window.buildRenderOptHtml = function(portalObj) {
							$("#portlet_input_render_opt").html(lodingImg).show()
								.load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?scene=portal&x="+(new Date().getTime()),{"fdId":portalObj.renderId, jsname:'renderOptObj'}, function() {
									if (portalObj.renderOpt) {
										window.renderOptObj.setValue(portalObj.renderOpt);
									}
								});
						};
						window.openPortletSourceDialog = function(ele){
							dialog.iframe("/sys/portal/designer/jsp/selectportletsource.jsp", 
									"${ lfn:message('sys-portal:sysPortalPage.desgin.selectsource') }", function(portalObj){
								if(!portalObj) {
									return;
								}
								delete portalObj.uuid;
								$("[name='fdPages[0].fdConfig']").val(JSON.stringify(portalObj));
								$("[name='fdPages[0].fdName']").val(portalObj.sourceName);
								$("[name='portlet_input_source_format']").val(portalObj.sourceFormat);
								$("[name='portlet_input_source_id']").val(portalObj.sourceId);
								$("[name='portlet_input_render_id']").val(portalObj.renderId);
								$("[name='portlet_input_render_name']").val(portalObj.renderName);
								var title = $('[name="fdName"]');
								if (title.val() == '') {
									title.val(portalObj.sourceName);
								}
								buildSourceOptHtml(portalObj);
								buildRenderOptHtml(portalObj);
								
							}, {width:750,height:550});
						};
						window.openPortletRenderSetting = function(checkbox) {
							$('#portlet_render_opt_tr').each(function() {
								this.style.display = checkbox.checked ? "" : "none";
							});
						};
						
						window.openPortletRenderDialog = function(ele){
							var format = $("[name='portlet_input_source_format']").val();
							if($.trim(format) == ""){
								seajs.use(['lui/dialog'],function(dialog){
									dialog.alert("${ lfn:message('sys-portal:sysPortalPage.desgin.selectsource') }");
								});
								return;
							}
							seajs.use(['lui/dialog','lui/jquery'],function(dialog){
								dialog.iframe("/sys/portal/designer/jsp/selectportletrender.jsp?scene=portal&format="+format, "${ lfn:message('sys-portal:sysPortalPage.desgin.selectrender') }", function(val){
									if(!val){
										return;
									}
									if(val.renderId != $("[name='portlet_input_render_id']").val()){
										$("[name='portlet_input_render_id']").val(val.renderId);
										$("[name='portlet_input_render_name']").val(val.renderName);
										delete window.renderOptObj;
										buildRenderOptHtml(val);
									}
								}, {width:750,height:550});
							});
						};
						
						$(document).ready(function() {
							var cfg = $("[name='fdPages[0].fdConfig']");
							if (cfg.val() == '') {
								return;
							}
							var portalObj = JSON.parse(cfg.val());
							$("[name='portlet_input_source_format']").val(portalObj.sourceFormat);
							$("[name='portlet_input_source_id']").val(portalObj.sourceId);
							$("[name='portlet_input_render_id']").val(portalObj.renderId);
							$("[name='portlet_input_render_name']").val(portalObj.renderName);
							buildSourceOptHtml(portalObj);
							buildRenderOptHtml(portalObj);
						});
						
						Com_Parameter.event["submit"].push(function() {
							var cfg = $("[name='fdPages[0].fdConfig']");
							if (cfg.val() == '') {
								return false;
							}
							if (window.sourceOptObj && !window.sourceOptObj.validation()) {
								return false;
							}
							if (window.renderOptObj && !window.renderOptObj.validation()) {
								return false;
							}
							var portalObj = JSON.parse(cfg.val());
							portalObj.renderId = $("[name='portlet_input_render_id']").val();
							portalObj.renderName = $("[name='portlet_input_render_name']").val();
							if (window.sourceOptObj) {
								portalObj.sourceOpt = window.sourceOptObj.getValue();
							}
							if (window.renderOptObj) {
								portalObj.renderOpt = window.renderOptObj.getValue();
							}
							$("[name='fdPages[0].fdConfig']").val(JSON.stringify(portalObj));
							return true;
						});
					});
					</script>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" colspan="4">
					<label><input type="checkbox" onclick="openPortletRenderSetting(this);" /><bean:message bundle="sys-person" key="sysPersonSysTabPage.advanced.setting" /></label>
				</td>
			</tr>
			<tr id="portlet_render_opt_tr" style="display:none;">
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysTabPage.render.setting" />
				</td>
				<td colspan="3">
					<xform:dialog propertyId="portlet_input_render_id" propertyName="portlet_input_render_name" style="width:90%" required="true" subject="${lfn:message('sys-person:sysPersonSysTabPage.render') }">
						openPortletRenderDialog();
					</xform:dialog>
					<div id="portlet_input_render_opt" style="display:none;width:80%;margin-top: 8px;">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.renderOpt') }</div>
				</td>
			</tr>
		</template:replace>
</template:include>

