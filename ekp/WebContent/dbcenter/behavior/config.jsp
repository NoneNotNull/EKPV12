<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
	function behavior_changeEnable(){
		var enabledField = document.getElementsByName('value(kmss.behavior.enabled)')[0];
		var enabledCheck = document.getElementById('kmss.behavior.enabled');
		var tbody = document.getElementById('tbody_behavior');
		enabledField.value = enabledCheck.checked;
		tbody.style.display = enabledCheck.checked?'':'none';
		var fields = tbody.getElementsByTagName('input');
		for(var i=0; i<fields.length; i++){
			fields[i].disable = !enabledCheck.checked;
		}
	}
	function behavior_onload(){
		var enabledField = document.getElementsByName('value(kmss.behavior.enabled)')[0];
		var enabledCheck = document.getElementById('kmss.behavior.enabled');
		enabledCheck.checked = (enabledField.value == 'true');
		behavior_changeEnable();
	}
	config_onloadFuncList.push(behavior_onload);
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2>
			<label><input id="kmss.behavior.enabled" type="checkbox" value="true" onclick="behavior_changeEnable();"><b>启用运营日志采集</b></label>
			<html:hidden property="value(kmss.behavior.enabled)"/>
		</td>
	</tr>
	<tbody id="tbody_behavior" style="display:none;">
	<tr>
		<td class="td_normal_title" width="15%">日志存放位置</td>
		<td>
			<xform:text property="value(kmss.behavior.logPath)" subject="日志存放位置" style="width:85%" showStatus="edit"/><br>
			<span class="message">
				日志文件保存路径，例：windows环境为“c:/landray/kmss/resource/behavior”,linux和unix为“/usr/landray/kmss/resource/behavior”<br>
				不填写则默认保存在“附件存放位置”目录下的“behavior”子文件夹
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">日志存放天数</td>
		<td>
			<xform:text property="value(kmss.behavior.dayToDel)" subject="日志存放天数" validators="digits" showStatus="edit"/><br>
			<span class="message">
				默认日志将保留30天
			</span>
		</td>
	</tr>
	</tbody>
	<tr>
		<td class="td_normal_title" width="15%">说明</td>
		<td>
			<span class="message">
				<b>运营日志可以完全替代系统操作日志的功能</b>，开启运营日志后，可以禁用系统操作日志（在“基础设置-日志参数”设定）<br><br>
				日志文件容量估算：一般的，每个节点每天将产生大约100M的日志文件（若系统访问量比较大，可能会到达200M），超过200M的日志已经说明单台服务器的请求已经超负荷<br>
				若现有系统有5个节点，日志保留30天，则日志文件容量大概为：5 * ( 30 + 1 ) * 100M = 15500M（30+1中的1是当天的日志）
			</span>
		</td>
	</tr>
</table>