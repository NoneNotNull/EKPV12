<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.lic.SystemParameter"%>
<script>
	Com_IncludeFile("data.js");
	config_addOnloadFuncList(function(){
		config_cluster_switchMultisystem();
	});
	function config_cluster_genKey(){
		var data = new KMSSData();
		data.SendToUrl(Com_Parameter.ContextPath+"resource/sys/cluster/config.do?method=key", function(http){
			var result = http.responseText;
			document.getElementsByName("value(kmss.cluster.security)")[0].value = result;
		});
	}
	function config_cluster_switchMultisystem(){
		var enabled = false;
		var fields = document.getElementsByName("value(kmss.cluster.multisystem)");
		if(fields.length>0){
			enabled = fields[0].checked;
		}
		var tbody = document.getElementById('cluster_multisystem');
		tbody.style.display = enabled?'':'none';
		fields = tbody.getElementsByTagName('input');
		for(var i=0; i<fields.length; i++){
			fields[i].disabled = !enabled;
		} 
	}
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width="15%">功能开关</td>
		<td>
			<% if("true".equals(SystemParameter.get("license-cluster-multisystem"))){ %>
				<label>
					<html:checkbox property="value(kmss.cluster.multisystem)" value="true" onclick="config_cluster_switchMultisystem();"/>启动多子系统功能
				</label>&nbsp;&nbsp;
			<% } %>
			<label>
				<html:checkbox property="value(kmss.isClusterEnabled)" value="true"/>启用EKP群集
			</label>
		</td>
	</tr>
	<tbody id="cluster_multisystem" style="display:none;">
	<tr>
		<td class="td_normal_title" width="15%">子系统通讯密钥</td>
		<td>
			<xform:text property="value(kmss.cluster.security)" subject="子系统通讯密钥" required="true" style="width:400px" showStatus="edit" />
			<input type="button" value="生成密钥" class="btnopt" onclick="config_cluster_genKey();"><br>
			<span class="message">每个子系统的通讯密钥必须一致，第一个子系统，请点击“生成密钥”按钮</span>
		</td>
	</tr>
	</tbody>
	<tr>
		<td class="td_normal_title" width="15%">节点标识</td>
		<td>
			<xform:text property="value(kmss.cluster.serverName)" subject="节点标识" style="width:400px" showStatus="edit"/><br>
			<span class="message">服务器节点的唯一标识，不同的节点应该设置不同的值，例：ekp_server1，为了配置方便，建议在JVM的参数中通过：-DLandray.kmss.cluster.serverName=ekp_server1 进行设置</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">起始端口</td>
		<td>
			<xform:text property="value(kmss.cluster.tcp.startport)" subject="起始端口号" required="true" style="width:400px" showStatus="edit" /><br>
			<span class="message">样例：7800，请保证服务器的集群起始端口以及后续的的20个端口号（如：7800~7820）已经开通，并且不被其它程序占用</span>
		</td>
	</tr>
</table>
