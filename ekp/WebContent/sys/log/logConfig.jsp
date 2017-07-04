<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>日志参数</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">是否启用操作日志</td>
		<td>
			<label>
				<html:radio property="value(kmss.isLogAppEnabled)" value="true"/>启用
				<html:radio property="value(kmss.isLogAppEnabled)" value="false"/>禁用
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">是否启用登录(登出)日志</td>
		<td>
			<label>
				<html:radio property="value(kmss.isLogLoginEnabled)" value="true"/>启用
				<html:radio property="value(kmss.isLogLoginEnabled)" value="false"/>禁用
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">应用日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logAppBackupBefore)" subject="应用日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：7，说明：当前日志保存7天内容，7天前的自动备份到另外一个历史日志表</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">错误日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logErrorBackupBefore)" subject="错误日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：7，说明：当前日志保存7天内容，7天前的自动备份到另外一个历史日志表</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">后台日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logJobBackupBefore)" subject="后台日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：7，说明：当前日志保存7天内容，7天前的自动备份到另外一个历史日志表</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">登录(登出)日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logLoginBackupBefore)" subject="登录(登出)日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：7，说明：当前日志保存7天内容，7天前的自动备份到另外一个历史日志表</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">清除应用日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logAppDeleteBackBefore)" subject="清除应用日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：90，说明：清除备份日志表中90天前的数据</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">清除错误日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logErrorDeleteBackBefore)" subject="清除错误日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：90，说明：清除备份日志表中90天前的数据</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">清除后台日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logJobDeleteBackBefore)" subject="清除后台日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：90，说明：清除备份日志表中90天前的数据</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">清除登录(登出)日志备份天数</td>
		<td>
			<xform:text property="value(kmss.logLoginDeleteBackBefore)" subject="清除登录(登出)日志备份天数" required="true" style="width:150px" showStatus="edit"/>天<br>
			<span class="message">例：90，说明：清除备份日志表中90天前的数据</span>
		</td>
	</tr>
</table>
