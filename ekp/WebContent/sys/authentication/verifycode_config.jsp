<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
function config_redirectto_chgEnabled(){
	var tbObj = document.getElementById("redirectto_div");
	var field = document.getElementsByName("_value(kmss.redirectto.check)")[0];
	if(field.checked){
		tbObj.style.display = "";
	}else{
		tbObj.style.display = "none";
	}
}
config_addOnloadFuncList(function(){
	config_redirectto_chgEnabled(); 
});
</script>
<table class="tb_normal" width=100%> 
	<tr>
		<td class="td_normal_title" colspan=2>
			<b>
				<label>
					系统安全 (以下选项仅在使用本系统身份验证时生效)
				</label>
			</b>
		</td>
	</tr> 
	<tr>
	<td class="td_normal_title" width="15%">是否开启验证码</td>
	<td>
		<xform:checkbox property="value(kmss.verifycode.enabled)" showStatus="edit">
						<xform:simpleDataSource value="true">开启 </xform:simpleDataSource>
					</xform:checkbox>
					<br>
					<span class="message">&nbsp;功能描述：当用户名密码输入错误3次之后会要求输入验证码才能登录。开启这个功能的旧版升级客户有定制登录页面的需要修改登录界面。</span>
	</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">用户密码最小长度</td>
		<td>
			<label>
			 <xform:text property="value(kmss.org.passwordlength)" required="true" validators="required digits min(1) max(20)" showStatus="edit"></xform:text>
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">用户密码强度要求</td>
		<td>
			<label>
			<xform:radio property="value(kmss.org.passwordstrength)" showStatus="edit">
			 	<xform:simpleDataSource value="1">一种类型</xform:simpleDataSource>
			 	<xform:simpleDataSource value="2">两种类型组合</xform:simpleDataSource>
			 	<xform:simpleDataSource value="3">三种类型组合</xform:simpleDataSource>
			 	<xform:simpleDataSource value="4">四种类型组合</xform:simpleDataSource>
			 </xform:radio>
			</label>
			<br>
			<span class="message">&nbsp;密码可以由:字母、数字、大写字母、符号，四种元素组成</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">强制要求修改密码</td>
		<td>
			<label>
			 <xform:checkbox property="value(kmss.org.passwordchange)" showStatus="edit">
			 	<xform:simpleDataSource value="true">开启 </xform:simpleDataSource>
			 </xform:checkbox>
			</label>
			<br>
			<span class="message">&nbsp;当用户登录时会检测密码强度，如果不符合要求会跳转到密码修改界面去。</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">登录跳转范围检查</td>
		<td>
			<label>
			 <xform:checkbox property="value(kmss.redirectto.check)" onValueChange="config_redirectto_chgEnabled()"  showStatus="edit">
			 	<xform:simpleDataSource value="true">开启 </xform:simpleDataSource>
			 </xform:checkbox>
			<br>
			<span class="message">&nbsp;检查当用户登录成功后的跳转地址是否在允许的范围内，不开启则允许跳转到任何地址。</span>
			</label>
			<div id="redirectto_div">
			允许的域:
			<xform:text property="value(kmss.redirectto.allowdomainnames)" showStatus="edit" style="width:90%"></xform:text><br>
			<span class="message">为空则只允许本域名地址。 输入域名需要包含协议，多值用分号隔开。例如:http://oa.xxx.com;http://erp.xxx.com</span>
			</div>
		</td>
	</tr>
</table>

