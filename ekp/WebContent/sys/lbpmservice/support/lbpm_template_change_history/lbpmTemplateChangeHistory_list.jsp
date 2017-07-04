<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<style>
.lbpm_version_tb_tr{
	background-color: #F0F0F0;
}
</style>
<tr>
	<td class="td_normal_title" colspan="2">
	<label>
		<input type="checkbox" onclick="LBPM_Template_loadHistory('${lbpmTemplateForm.fdId}', '${lbpmTemplate_Key}');"/>
		<bean:message bundle="sys-lbpmservice-support" key="table.lbpmTemplateChangeHistory"/>
	</label>
	</td>
</tr>
<tr>
	<td colspan="2">
		<div id="lbpmTemplateChangeHistoryDiv${lbpmTemplate_Key}" style="display:none"></div>
	</td>
</tr>
<script>
LBPM_Template_History_Lang = {
		loading: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.loading"/>',
		serial: '<bean:message key="page.serial"/>',
		period: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.period"/>',
		common: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.fdCommon"/>',
		type: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.fdType"/>',
		isDefault: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.fdIsDefault"/>',
		creator: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.fdCreator"/>',
		createTime: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.fdCreateTime"/>',
		version: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.version"/>',
		versionNum: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.versionNum"/>',
		showVersion: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.showVersion"/>',
		hideVersion: '<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.hideVersion"/>'
};
// 加载变更记录
function LBPM_Template_loadHistory(templateId, key) {
	var div = $("#lbpmTemplateChangeHistoryDiv" + key);
	if(div.is(":hidden")) {
		div.show(); // 显示
		if(div.html()) { //已经加载
			return;
		}
		div.html('<img src="' + Com_Parameter.ResPath + 'style/common/images/loading.gif" border="0" />' + LBPM_Template_History_Lang.loading);
		$.getJSON(Com_Parameter.ContextPath+"sys/lbpm/engine/jsonp.jsp?s_bean=lbpmTemplateChangeHistoryService",
				{templateId: templateId, key: key, d: (new Date().getTime())}, function(json){
			var arr = [];
			arr.push('<table id="lbpmTemplateChangeHistoryTB" class="tb_normal" width="100%">');
			arr.push('<tr class="tr_normal_title">');
			arr.push('<td width="40pt" class="td_normal_title">' + LBPM_Template_History_Lang.serial + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.period + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.common + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.type + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.isDefault + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.creator + '</td>');
			arr.push('<td width="40%" class="td_normal_title">' + LBPM_Template_History_Lang.version + '</td>');
			arr.push('</tr>');
			for(var i = 0, n = json.length; i < n; i++) {
				arr.push('<tr>');
				arr.push('<td>' + (i+1) + '</td>');
				arr.push('<td>' + json[i].period + '</td>');
				arr.push('<td>' + json[i].common + '</td>');
				arr.push('<td>' + json[i].type + '</td>');
				arr.push('<td>' + json[i].isDefault + '</td>');
				arr.push('<td>' + json[i].creator + '</td>');
				arr.push('<td>');
				arr.push('<img src="' + Com_Parameter.ResPath + 'style/common/images/icon_add.png" border="0"' + ' style="cursor:pointer" title="' + LBPM_Template_History_Lang.showVersion
						+ '" onclick="LBPM_Template_loadVersion(this, \'' + json[i].id +  '\', \'' + json[i].refId + '\', \'' + json[i].startDate + '\', \'' + json[i].endDate  + '\');" />');
				arr.push('<div id="div_' + json[i].id + '" style="display:none"></div>');
				arr.push('</td>');
				arr.push('</tr>');
			}
			arr.push('</table>');
			div.html(arr.join(''));
	 	});
	} else {
		div.hide(); // 隐藏
	}
}
// 加载流程定义版本
function LBPM_Template_loadVersion(obj, histroyId, templateId, startDate, endDate) {
	var div = $("#div_" + histroyId +"");
	var img = $(obj);
	if(div.is(":hidden")) {
		img.attr("src", Com_Parameter.ResPath + "style/common/images/icon_cut.png");
		img.attr("title", LBPM_Template_History_Lang.hideVersion);
		div.show(); // 显示
		if(div.html()) { //已经加载
			return;
		}
		div.html('<img src="' + Com_Parameter.ResPath + 'style/common/images/loading.gif" border="0" />' + LBPM_Template_History_Lang.loading);
		$.getJSON(Com_Parameter.ContextPath+"sys/lbpm/engine/jsonp.jsp?s_bean=lbpmTemplateService",
				{templateId: templateId, startDate: startDate, endDate: endDate, d: (new Date().getTime())}, function(json){
			var arr = [];
			arr.push('<table id="tb_"' + histroyId + ' class="tb_normal" width="100%">');
			arr.push('<tr class="tr_normal_title">');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.versionNum + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.creator + '</td>');
			arr.push('<td class="td_normal_title">' + LBPM_Template_History_Lang.createTime + '</td>');
			arr.push('</tr>');
			for(var i = 0, n = json.length; i < n; i++) {
				arr.push('<tr style="cursor:pointer" id="' + json[i].id + '" templateId="' + json[i].templateId + '">');
				arr.push('<td>' + json[i].version + '</td>');
				arr.push('<td>' + json[i].creator + '</td>');
				arr.push('<td>' + json[i].createTime + '</td>');
				arr.push('</tr>');
			}
			arr.push('</table>');
			div.html(arr.join('')).find("tr:gt(0)").mouseover(function() {
				$(this).addClass("lbpm_version_tb_tr");
			}).mouseout(function() {
				$(this).removeClass("lbpm_version_tb_tr");
			}).click(function() {
				var fdId = $(this).attr("templateId"), defId = $(this).attr("id");
				Com_OpenWindow(Com_Parameter.ContextPath+'sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=viewHistory&fdId=' + fdId + "&defId=" + defId);
			});
							
		});
	} else {
		img.attr("src", Com_Parameter.ResPath + "style/common/images/icon_add.png");
		img.attr("title", LBPM_Template_History_Lang.showVersion);
		div.hide(); // 隐藏
	}
}
</script>