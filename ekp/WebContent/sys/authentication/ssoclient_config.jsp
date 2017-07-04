<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript">
var config_ssoclient_hasError = false;
var config_ssoclient_status = null;
function config_ssoclient_chgEnabled(){
	var tbObj = document.getElementById("config_ssoconfig");
	var field = document.getElementsByName("_value(kmss.ssoclient.enabled)")[0];
	for(var i=0; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}

	if(!field.checked){
		document.getElementsByName("_value(kmss.ssoclient.redirect.enabled)")[0].checked = false;
		config_ssoclient_chgRedirect();
	}
}
function config_ssoclient_chgRedirect(){
	var tbObj = document.getElementById("config_ssoconfig_redirect");
	var field = document.getElementsByName("_value(kmss.ssoclient.redirect.enabled)")[0];
	for(var i=0; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
	}
	document.getElementsByName("value(kmss.ssoclient.redirect.loginURL)")[0].disabled = !field.checked;
	document.getElementsByName("value(kmss.ssoclient.redirect.logoutURL)")[0].disabled = !field.checked;
}

function config_ssoclient_loadMessage(){
	document.getElementById("btn_ssoclient_config").disabled = true;
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=getMessage", function(http){
		document.getElementById("btn_ssoclient_config").disabled = false;
		var result = eval("("+http.responseText+")");
		if(result.error!=null){
			alert(result.error);
			return;
		}
		config_ssoclient_status = result.status;
		config_ssoclient_hasError = result.hasError!=null;
		var tbObj = document.getElementById("config_ssoconfig");
		tbObj.rows[0].cells[1].innerHTML = "<span class=message>"+result.message+"</span>";
	});
}

function config_ssoclient_openDialog(type){
	var parameter = {
		localUrl:config_ssoclient_getFieldValue("value(kmss.urlPrefix)"),
		dominoDiiopServer:config_ssoclient_getFieldValue("value(kmss.domino.diiopServer)"),
		dominoLoginName:config_ssoclient_getFieldValue("value(kmss.domino.loginName)"),
		dominoPassword:config_ssoclient_getFieldValue("value(kmss.domino.password)") 
	};
	if(type!="all" && config_ssoclient_status=="2"){
		if(!confirm("您目前的SSO配置含有其它的功能，使用快速模式将会丢失这些功能，是否继续？"))
			return;
	}
	var url = Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=edit&type="+type;
	var result = Dialog_PopupWindow(url, 600, type=="all"?500:400, parameter);
	if(result){
		config_ssoclient_loadMessage();
	}
}

function config_ssoclient_getFieldValue(fieldName){
	var fields = document.getElementsByName(fieldName);
	if(fields.length==0)
		return null;
	return fields[0].value==""?null:fields[0].value;
}

config_addCheckFuncList(function(){
	var field = document.getElementsByName("_value(kmss.ssoclient.enabled)")[0];
	if(!field.checked)
		return true;
	if(config_ssoclient_hasError){
		alert("多服务器验证的配置信息存在错误，请查阅信息摘要中的红色字体部分信息，修正后再提交！");
		return false;
	}
	if(true){
		config_addUniqueParameter("com.landray.kmss.sys.authentication:redirectURL","多服务器验证:启用未登录时跳转");
	}
	return true;
});
function config_ssoclient_chgFilterDisable(){
	var field = document.getElementsByName("_value(kmss.authentication.processing.filter.disable)")[0];
	document.getElementsByName("value(kmss.authentication.processing.filter.exclude.user)")[0].disabled = !field.checked;
}
config_addOnloadFuncList(function(){
	config_ssoclient_chgEnabled();
	config_ssoclient_loadMessage();
	config_ssoclient_chgRedirect();
});
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>本系统身份验证</b>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">禁用本系统数据库的身份验证</td>
		<td>
			<xform:checkbox property="value(kmss.authentication.processing.filter.disable)" showStatus="edit"  onValueChange="config_ssoclient_chgFilterDisable()" >
				<xform:simpleDataSource value="true">禁用</xform:simpleDataSource>
			</xform:checkbox><br>
			<span class="message">说明：如有启用多服务器验证或与其他系统做单点登录，可以禁用本系统数据库的身份验证，禁用后将只有例外人员可以使用本系统数据库密码验证，如在没有启用多服务器验证或与其他系统做单点登录情况下禁用本系统数据库身份认证，则会导致所有人员无法登录本系统（除例外人员）</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">例外人员</td>
		<td>
			<xform:text property="value(kmss.authentication.processing.filter.exclude.user)" style="width:85%" showStatus="edit"/><br>
			<span class="message">禁用本系统数据库的身份验证后，还可以使用本系统数据库密码验证的人员。配置必须为帐号，多个帐号时以分号隔开。例：admin;zhangsan;lisi</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label>
					<xform:checkbox property="value(kmss.ssoclient.enabled)" onValueChange="config_ssoclient_chgEnabled()" showStatus="edit">
						<xform:simpleDataSource value="true">启用多服务器验证</xform:simpleDataSource>
					</xform:checkbox>
				</label>
			</b>
		</td>
	</tr>
	<tbody id="config_ssoconfig"> 
		<tr>
			<td class="td_normal_title" width="15%">配置信息摘要</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">操作</td>
			<td>
				<input id="btn_ssoclient_config" type="button" value="快速配置" class="btnopt" onclick="config_ssoclient_openDialog('part');">
				<span class="message">快速配置适用于无蓝凌EKP-SSO服务器的情况，通过令牌环的方式实现系统间的SSO，其它功能被限制。参与SSO的服务器之间必须同域（如：所有的服务器的DNS为*.landray.com.cn）。</span>
				<br><br style="font-size: 5px;">
				<input type="button" value="完整配置" class="btnopt" onclick="config_ssoclient_openDialog('all');">
				<span class="message">完整配置用于拷贝已经配置好的参数，比如在有蓝凌EKP-SSO服务器的情况下，可以在SSO服务器上进行参数配置并导出的配置文件，然后用记事本打开拷贝到本系统。</span>
			</td>
		</tr>
		
		<tr>
			<td class="td_normal_title" width="15%">说明</td>
			<td>
				<span class="message">若您期望多台EKP-J服务器实现SSO，请在一台服务器配置好“多服务器验证”的参数，然后通过“完整配置”操作，将这些参数拷贝到其它服务器中。</span>
			</td>
		</tr>
		
		<tr>
			<td class="td_normal_title" width="15%">未登录时跳转</td>
			<td>
				<xform:checkbox property="value(kmss.ssoclient.redirect.enabled)" showStatus="edit" onValueChange="config_ssoclient_chgRedirect()" >
					<xform:simpleDataSource value="true">启用</xform:simpleDataSource>
				</xform:checkbox>
			</td>
		</tr>
	</tbody>
	<tbody id="config_ssoconfig_redirect"> 
		<tr>
			<td class="td_normal_title" width="15%">未登录时跳转地址</td>
			<td>
				<xform:text property="value(kmss.ssoclient.redirect.loginURL)" style="width:85%" required="true" showStatus="edit" subject="未登录时跳转地址"/><br>
				<span class="message">
				完整路径请复制SSO配置助手生成的配置文件的SSOLoginRedirectFilter.login.URL属性内容。<br>
				例如：http://sso.company.com/login?service=\${URL}
				</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">用户注销是跳转地址</td>
			<td>
				<xform:text property="value(kmss.ssoclient.redirect.logoutURL)" style="width:85%" showStatus="edit" subject="用户注销是跳转地址"/><br>
				<span class="message">
				完整路径请复制SSO配置助手生成的配置文件的CASURLFilter.cas.server属性内容加上/logout。<br/>
				例如：http://sso.company.com/Logout
				</span>
			</td>
		</tr>
	</tbody>
</table>

