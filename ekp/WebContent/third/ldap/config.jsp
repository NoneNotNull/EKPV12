<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
config_addCheckFuncList(function(){
	var omsIn = document.getElementsByName("value(kmss.oms.in.ldap.enabled)")[0].checked;
	if(omsIn){
		config_addUniqueParameter("com.landray.kmss.sys.oms:in","集成LDAP-组织架构数据同步（接入）");
	}
	return true;
});

function config_ldap_openDialog(){
	var oms = document.getElementsByName("value(kmss.oms.in.ldap.enabled)")[0];
	var auth= document.getElementsByName("value(kmss.authentication.ldap.enabled)")[0];
	var type="";
	if(oms.checked || auth.checked){
		if(auth.checked){
			type = "auth";
		}
		var style = "dialogWidth:100; dialogHeight:100; status:1; help:0; resizable:1";
		var url = "<c:url value="/resource/jsp/frame.jsp"/>";
			url = Com_SetUrlParameter(url, "url","<c:url value="/third/ldap/setting.do"/>?method=edit&type="+type);
		var rtnVal = window.showModalDialog(url, null, style);
	}else{
		alert("请先启用“组织架构数据同步（接入）”或“LDAP登录验证”再执行配置操作！");
	}
}

function config_ldap_chgDisplay(){
	var tbObj = document.getElementById("kmss.integrate.ldap");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	var omsIn = document.getElementsByName("value(kmss.oms.in.ldap.enabled)")[0];
	var ldapAuth = document.getElementsByName("value(kmss.authentication.ldap.enabled)")[0];
	if(!field.checked){
		omsIn.checked = false;
		ldapAuth.checked = false;
	}
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
	}
}

config_addOnloadFuncList(config_ldap_chgDisplay);
</script>
<table class="tb_normal" width=100% id="kmss.integrate.ldap">
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label>
					<html:checkbox property="value(kmss.integrate.ldap.enabled)" value="true" onclick="config_ldap_chgDisplay()"/>集成LDAP
				</label>
			</b>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">组织架构数据同步（接入）</td>
		<td>
			<label>
				<html:checkbox property="value(kmss.oms.in.ldap.enabled)" value="true"/>启用
			</label>
			<span class="message">（说明：从LDAP服务器导入组织架构信息）</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">LDAP登录验证</td>
		<td>
			<label>
				<html:checkbox property="value(kmss.authentication.ldap.enabled)" value="true"/>启用
			</label>
			<span class="message">（说明：通过LDAP进行用户登录认证）</span>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" class="btnopt" value="配置相关参数" onclick="config_ldap_openDialog()"/>
		</td>
	</tr>
</table>
