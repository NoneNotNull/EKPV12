<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<script>
Com_IncludeFile("data.js");
var saving = false;
function submitForm(){
	if(saving)
		return;
	saving = true;
	var fdConfig = document.getElementsByName("fdConfig")[0].value;
	if(Com_Trim(fdConfig)==""){
		alert("请先填写“SSO配置信息”信息！");
		return;
	}
	var fdTokenKey = document.getElementsByName("fdTokenKey")[0].value;
	var data = new KMSSData();
	data.AddHashMap({fdConfig:fdConfig, fdTokenKey:fdTokenKey});
	data.SendToUrl(Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=save", function(http){
		var result = eval("("+http.responseText+")");
		if(result.error!=null){
			alert(result.error);
			saving = false;
			return;
		}
		top.returnValue = true;
		window.close();
	});
}

function showHelp(obj){
	var field = document.getElementsByName("fdHelp")[0];
	if(field.style.display=="none"){
		field.style.display="";
		obj.innerHTML = "隐藏样例代码";
	}else{
		field.style.display="none";
		obj.innerHTML = "显示样例代码";
	}	
}
</script>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			SSO配置信息
		</td><td width=85%>
			<textarea name="fdConfig" style="width:100%; height:200px;"><c:out value="${fdConfig}" /></textarea>
			<span class="txtstrong">*</span><a href="#" onclick="showHelp(this);">显示样例代码</a>
			<textarea readonly name="fdHelp" style="width:100%; height:300px;display:none;">#可取值为DEBUG/WARN/ERROR
log.level = WARN

#过滤链，为以下的值的组合，用;分隔，com.landray.sso.client.filter包下面的类可不带包名，其它必须带包名，不能使用无包名的类
#注意：过滤链是有先后顺序的，建议不改变下面过滤器的先后的顺序
filter.chain = 

#===========================================
#TokenFilter
#功能：令牌环的识别与生成
#参数：密钥文件路径
#TokenFilter.keyFilePath = /KmssConfig/LRToken
#参数：注销URL，可选（若注销动作不在本服务器执行）
#TokenFilter.logoutURL = /logout.jsp
#===========================================

#===========================================
#CASURLFilter
#功能：CAS登录/注销验证器
#参数：cas服务器地址。
#CASURLFilter.cas.server = http://cas.landray.com.cn/cas-server
#参数：url中的ticket参数名，默认为ticket
#CASURLFilter.cas.ticket = ticket
#===========================================

#===========================================
#SSOServerAuthenticateFilter
#功能：将用户名密码提交给SSO服务器进行验证，验证结果将保存到session的EKPSSOAuthenticate变量中，为success或failure
#参数：服务器验证地址
#SSOServerAuthenticateFilter.server.authentication.URL = http://cas.landray.com.cn/cas-server/userValidate
#参数：本地登录页面中的用户名字段
#SSOServerAuthenticateFilter.local.form.username = username
#参数：本地登录页面中的密码字段
#SSOServerAuthenticateFilter.local.form.password = password
#参数：本地登录页面的提交地址（不含contextPath）
#SSOServerAuthenticateFilter.local.form.action = /loginServlet
#参数：登录失败页面URL
#SSOServerAuthenticateFilter.local.login.URL = /login.jsp
#===========================================

#===========================================
#UsernameConvertFilter
#功能：本地用户-统一用户的切换器
#参数：用户转换服务地址
#UsernameConvertFilter.serverAddress= http://cas.landray.com.cn/cas-server/userConvert?formApp=${FROM}&toApp=${TO}&usernames=${USERNAMES}
#参数：本地服务器的Key
#UsernameConvertFilter.localKey = KOA
#===========================================

#===========================================
#SSOLoginRedirectFilter
#功能：当判断到未登录时，进行页面跳转，若系统中存在匿名可访问的资源，不建议使用该过滤器，一般配在所有最后
#参数：跳转URL，使用“${URL}”替换原有地址
#SSOLoginRedirectFilter.login.URL = http://cas.landray.com.cn/login?service=${URL}
#参数：URL的编码格式，可不填，表示不将${URL}的值转码
#SSOLoginRedirectFilter.login.URLCharset = UTF-8
#参数：不进行跳转的URL，用;分隔多值，如：“/resource”表示所有以“/resource”开头的URL
#SSOLoginRedirectFilter.noRedirectURLs = /logout.jsp
#===========================================</textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			Token密钥文件
		</td><td width=85%>
			<textarea name="fdTokenKey" style="width:100%; height:150px;"><c:out value="${fdTokenKey}" /></textarea>
		</td>
	</tr>
</table>
<br>
<input type="button" value="提交" class="btnopt" onclick="submitForm();">&nbsp;&nbsp;
<input type="button" value="关闭" class="btnopt" onclick="window.close();">
</center>
<br>
</body>
</html>