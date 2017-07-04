<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script>
function config_dns_getUrl(){
	var url = location.href;
	var i = url.indexOf("admin.do");
	var rtnUrl = document.getElementsByName("value(kmss.urlPrefix)")[0];
	rtnUrl.value = url.substring(0, i-1);
}
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>全局参数配置</b></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">服务器DNS</td>
		<td>
			<xform:text property="value(kmss.urlPrefix)" subject="服务器DNS" required="true" style="width:85%" showStatus="edit"/><input type="button" class="btnopt" value="自动获取" onclick="config_dns_getUrl()"/><br>
			<span class="message">访问本系统的URL，例：http://ekp.landray.com.cn:8080/ekp，其中，访问地址：http://ekp.landray.com.cn，访问端口：8080,访问应用：/ekp</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">管理员账号</td>
		<td>
			<xform:text property="value(kmss.admin.loginName)" subject="管理员账号" required="true" style="width:150px" showStatus="edit"/><br>
			<span class="message">请指定一个本系统超级管理员帐号，用于系统后台程序使用</span>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width="15%">视图默认显示行数</td>
		<td>
			<xform:text property="value(kmss.listpage.rowsize)" subject="视图默认显示行数" required="true" style="width:150px" showStatus="edit" validators="digits"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">周起始日</td>
		<td>
			<xform:select property="value(kmss.period.type.week.startdate)" subject="周起始日" showStatus="edit" showPleaseSelect="false">
				<xform:simpleDataSource value="1">星期日</xform:simpleDataSource>
				<xform:simpleDataSource value="2">星期一</xform:simpleDataSource>
				<xform:simpleDataSource value="3">星期二</xform:simpleDataSource>
				<xform:simpleDataSource value="4">星期三</xform:simpleDataSource>
				<xform:simpleDataSource value="5">星期四</xform:simpleDataSource>
				<xform:simpleDataSource value="6">星期五</xform:simpleDataSource>
				<xform:simpleDataSource value="7">星期六</xform:simpleDataSource>
			</xform:select>
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width="15%">获取客户端IP地址参数</td>
		<td>
			<xform:text property="value(kmss.clientip.request.headernames)" subject="获取客户端IP地址参数" required="false" style="width:150px" showStatus="edit"/><br>
			<span class="message">如出现获取客户端IP地址不正确（在日志中可查看），请在客户端用IE访问"服务器DNS/resource/jsp/testip.jsp"，在界面中可查看header的值，从中寻找与客户端IP匹配的参数名并填在此处（多值请以分号;分隔），如没有找到正确的客户端IP地址的参数则此处为空，系统将采用默认方式获取客户端IP地址</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">样式调试模式</td>
		<td>
			<label>
				<html:checkbox value="true" property="value(kmss.ui.theme.notmerge)" />
				开启
			</label>
			<br>
			<span class="message">
				生成环境不需要开启该项。不开启该项在做主题样式调整后样式文件不会立即生效，样式文件修改后需要点击UI模块【扩展资源】的【合并】按钮。
			</span>
		</td>
	</tr>		
</table>