<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script>
function config_dns_configDns(){
	var tbObj = document.getElementById("config_dns");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	var appsvrDns = document.getElementsByName("value(kmss.appsvr.dns)")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		config_dns_onloadDnsEnabled();
		if(!field.checked){
			appsvrDns.value = "";
			appsvrDns.disabled = true;
		}else{
			appsvrDns.disabled = false;
		}
	}
}

function config_dns_dnsEnabled(){
	var appsvrDns = document.getElementsByName("value(kmss.appsvr.dns)")[0];
	var dnsCheckBox  = document.getElementsByName("dnsCheckBox");
	//启用DNS
	var values = new Array();
	for(var i=0; i<dnsCheckBox.length; i++){
		config_dns_disableDnsElement(dnsCheckBox[i]);
		if(dnsCheckBox[i].checked){
			values[values.length] = dnsCheckBox[i].value;
		}
	}
	appsvrDns.value = values.join(";");
}

function config_dns_disableDnsElement(element) {
	var _index = element.value;
	var _checkFieldNames = [
			"value(kmss.appsvr." + _index + ".title)", 
			"value(kmss.appsvr." + _index + ".urlPrefix)",
			"value(kmss.mailsvr." + _index + ".urlPrefix)"
	];
	for (var i = 0, length = _checkFieldNames.length; i < length; i++) {
		var _arrFields = document.getElementsByName(_checkFieldNames[i]);
		if (_arrFields && _arrFields[0]) {
			_arrFields[0].disabled = !element.checked;
			if (_arrFields[0].disabled) KMSSValidation_HideWarnHint(_arrFields[0]);
		}
	}
}

function config_dns_onloadDnsEnabled(){
	var appsvrDns = document.getElementsByName("value(kmss.appsvr.dns)")[0].value;
	var dnsCheckBox  = document.getElementsByName("dnsCheckBox");
	for(var i=0; i<dnsCheckBox.length; i++){
		if(appsvrDns.indexOf("dns"+(i+1))>-1){
			dnsCheckBox[i].checked = true;
		}else{
			dnsCheckBox[i].checked = false;
		}
	}
	config_dns_dnsEnabled(dnsCheckBox);
}
config_addOnloadFuncList(config_dns_configDns);
</script>
<table class="tb_normal" width=100% id="config_dns">
	<tr>
		<td class="td_normal_title" colspan=4>
			<b>
				<label>
					<xform:checkbox property="value(kmss.appsvr.dnsEnabled)" onValueChange="config_dns_configDns()" showStatus="edit">
						<xform:simpleDataSource value="true">多域名支持</xform:simpleDataSource>
					</xform:checkbox>
					<html:hidden property="value(kmss.appsvr.dns)" />
				</label>
			</b>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="5%" align="center">操作</td>
		<td class="td_normal_title" width="35%" align="center">名称</td>
		<td class="td_normal_title" width="30%" align="center">应用服务器DNS</td>
		<td class="td_normal_title" width="30%" align="center">邮件服务器DNS</td>
	</tr>
	<tr>
		<td>
			<label>
				<input type="checkbox" name="dnsCheckBox" onclick="config_dns_dnsEnabled()" value="dns1"/>启用
			</label>
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns1.title)" subject="名称" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns1.urlPrefix)" subject="应用服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.mailsvr.dns1.urlPrefix)" subject="邮件服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="dnsCheckBox" onclick="config_dns_dnsEnabled()" value="dns2"/>启用
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns2.title)" subject="名称" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns2.urlPrefix)" subject="应用服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.mailsvr.dns2.urlPrefix)" subject="邮件服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="dnsCheckBox" onclick="config_dns_dnsEnabled()" value="dns3"/>启用
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns3.title)" subject="名称" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.appsvr.dns3.urlPrefix)" subject="应用服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
		<td>
			<xform:text property="value(kmss.mailsvr.dns3.urlPrefix)" subject="邮件服务器DNS" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/>
		</td>
	</tr>
</table>
