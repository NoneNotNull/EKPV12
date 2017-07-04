<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width="15%"><b>微信通知:</b></td>
		<td>
			<xform:checkbox  property="value(lwe.notify.type.todo.enabled)" dataType="boolean"  subject="微信通知"  htmlElementProperties="id=\"value(kmss.notify.type.todo.enabled)\"" onValueChange="config_notify_configNotify()"  showStatus="edit">
				<xform:simpleDataSource value="true">启用</xform:simpleDataSource>
			</xform:checkbox>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">微信发送失败自动转发:</td>
		<td>
		    <xform:checkbox property="value(lwe.notify.type.emil.enabled)" subject="Email" dataType="boolean"  htmlElementProperties="id=\"value(kmss.notify.type.email.enabled)\"" onValueChange="config_notify_configNotify()" showStatus="edit">
				<xform:simpleDataSource value="true">Email</xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="value(lwe.notify.type.mobile.enabled)" subject="短消息" dataType="boolean" htmlElementProperties="id=\"value(kmss.notify.type.mobile.enabled)\"" onValueChange="config_notify_configNotify()" showStatus="edit">
				<xform:simpleDataSource value="true">短消息</xform:simpleDataSource>
			</xform:checkbox>
			<span class="txtstrong">*</span>
			<div class="message">(说明:成功启用该配置项的前置条件是基础配置下的消息机制配置中的Email,短消息被勾选上)</div>
		</td>
	</tr>
	
</table>