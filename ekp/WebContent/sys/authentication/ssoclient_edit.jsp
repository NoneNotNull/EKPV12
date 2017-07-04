<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
var saving = false;
<%-- 提交表单 --%>
function submitForm(){
	if(saving)
		return;
	
	var value = parseInt(getFieldValue("cookie.maxAge"));
	if(isNaN(value) || value<1){
		alert("有效期必填，并且必须为正整数！");
		return;
	}
	
	var type = getFieldValue("instance.class");
	var fdTokenKey = "instance.class="+type;
	
	value = getTBTokenKeyInfo("TB_Common");
	if(value==null)
		return;
	fdTokenKey += value;

	value = getTBTokenKeyInfo("TB_"+type);
	if(value==null)
		return;
	fdTokenKey += value;
	
	var fdConfig = "log.level = WARN\r\nfilter.chain = TokenFilter\r\nTokenFilter.keyFilePath = /LRToken\r\nTokenFilter.logoutURL = /logout.jsp\r\n";
	saving = true;
	
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

<%-- 获取一个tbody中的配置信息 --%>
function getTBTokenKeyInfo(id){
	var obj = document.getElementById(id);
	var fields = obj.getElementsByTagName("INPUT");
	var rtnVal = "";
	var value;
	for(var i=0; i<fields.length; i++){
		if(fields[i].type!="text")
			continue;
		value = Com_Trim(fields[i].value);
		if(value=="" && fields[i].name!="domino.user.key"){
			alert("请完整填写所有必填项，再执行提交操作！");
			return null;
		}
		rtnVal += "\r\n"+fields[i].name + "=" + value;
	}
	return rtnVal;
}

<%-- window onload事件，初始化所有值，并且更新页面显示 --%>
window.onload = function(){
	var values = getFieldValue("fdTokenKey").split("\n");;
	for(var i=0; i<values.length; i++){
		var index = values[i].indexOf("=");
		if(index==-1)
			continue;
		setFieldValue(Com_Trim(values[i].substring(0, index)), Com_Trim(values[i].substring(index+1)));
	}
	changeDisplay();
};

<%-- 获取某个字段的值 --%>
function getFieldValue(fieldName){
	var fields = document.getElementsByName(fieldName);
	if(fields.length==0)
		return null;
	if(fields[0].type=="radio"){
		for(var i=0; i<fields.length; i++){
			if(fields[i].checked)
				return fields[i].value;
		}
	}else{
		return Com_Trim(fields[0].value);
	}
}

<%-- 设置某个字段的值 --%>
function setFieldValue(fieldName, fieldValue){
	var fields = document.getElementsByName(fieldName);
	if(fields.length==0)
		return;
	if(fields[0].type=="radio"){
		for(var i=0; i<fields.length; i++){
			if(fields[i].value==fieldValue){
				fields[i].checked = true;
				break;
			}
		}	
	}else{
		fields[0].value = fieldValue;
	}
}

<%-- 更新页面显示 --%>
function changeDisplay(){
	var value = getFieldValue("instance.class");
	var TB_LRTokenGenerator = document.getElementById("TB_LRTokenGenerator");
	var TB_LtpaTokenGenerator = document.getElementById("TB_LtpaTokenGenerator");
	//var BTN_Domain = document.getElementById("BTN_Domain");
	//var SEL_MaxAge = document.getElementById("SEL_MaxAge");
	var BTN_GenKeyDomino = document.getElementById("BTN_GenKeyDomino");
	if(value=="LRTokenGenerator"){
		TB_LRTokenGenerator.style.display = "";
		TB_LtpaTokenGenerator.style.display = "none";
		//BTN_Domain.style.display = "";
		//SEL_MaxAge.style.display = "";
		BTN_GenKeyDomino.style.display = "none";
	}else{
		TB_LRTokenGenerator.style.display = "none";
		TB_LtpaTokenGenerator.style.display = "";
		//BTN_Domain.style.display = "none";
		//SEL_MaxAge.style.display = "none";
		BTN_GenKeyDomino.style.display = "";
	}
}

<%-- 自动获取作用域 --%>
function getDomain(){
	<%-- 获取DNS --%>
	var url = dialogArguments.localUrl;
	var index = url.indexOf("//");
	if(index==-1){
		url = location.href;
		index = url.indexOf("//");
	}
	url = url.substring(index+2);
	index = url.indexOf("/");
	if(index>-1){
		url = url.substring(0, index);
	}
	index = url.indexOf(":");
	if(index>-1){
		url = url.substring(0, index);
	}
	<%-- 判断是否为DNS --%>
	var s = url.split(".");
	if(s.length==1){
		alert("无法自动获取作用域，请在“服务器DNS”配置选项中设置为域名访问方式！");
		return;
	}
	var isIP = s.length==4;
	if(isIP){
		for(var i = 0; i<4; i++){
			var n = parseInt(s[i]);
			if(isNaN(n) || n<0 || n>255){
				isIP = false;
				break;
			}
		}
	}
	if(isIP){
		alert("无法自动获取作用域，请在“服务器DNS”配置选项中设置为域名访问方式！");
		return;
	}
	<%-- 写值 --%>
	setFieldValue("cookie.domain", url.substring(url.indexOf(".")+1));
}

<%-- 生成公钥和私钥 --%>
function genKeyPair(){
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=genKeyPair", function(http){
		var result = eval("("+http.responseText+")");
		if(result.error!=null){
			alert(result.error);
			return;
		}
		for(var item in result){
			setFieldValue(item, result[item]);
		}
	});
}


<%-- 生成LTPAToken秘钥 --%>
function genLTPATokenKey(){
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=genLTPATokenKey", function(http){
		var result = eval("("+http.responseText+")");
		if(result.error!=null){
			alert(result.error);
			return;
		}
		for(var item in result){
			setFieldValue(item, result[item]);
		}
	});
}

<%-- 导入Domino的信息 --%>
function genKeyDomino(){
	var url = Com_Parameter.ContextPath+"sys/authentication/ssoclient_domino.jsp";
	var result = Dialog_PopupWindow(url, 600, 300, dialogArguments);
	if(result==null){
		return;
	}
	for(var item in result){
		setFieldValue(item, result[item]);
	}
}
</script>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			密钥类型
		</td><td width=85%>
		    <label><input type="radio" name="instance.class" onclick="changeDisplay();" value="LtpaTokenGenerator" checked>Domino系统的LtpaToken</label>
			<label><input type="radio" name="instance.class" onclick="changeDisplay();" value="LRTokenGenerator">EKP系统的LRToken</label>
			
		</td>
	</tr>
	<tbody id="TB_Common">
		<tr>
			<td class="td_normal_title" width=15%>
				作用域
			</td><td width=85%>
				<input name="cookie.domain" value="" class="inputsgl" style="width: 320px;">
				<span class="txtstrong">*</span>
				<input id="BTN_Domain" type="button" value="自动获取" class="btnopt" onclick="getDomain();"><br>
				<br style="font-size:5px;">
				如：landray.com.cn表示生成的令牌环对所有DNS为*.landray.com.cn的服务器都有效。
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				有效期
			</td><td width=85%>
				<input name="cookie.maxAge" value="" class="inputsgl">秒
				<span class="txtstrong">*</span>
				<select id="SEL_MaxAge" onchange="if(value!='') setFieldValue('cookie.maxAge', parseInt(value)*3600);">
					<option value="">快速选择</option>
					<option value="1">1小时</option>
					<option value="2">2小时</option>
					<option value="3">3小时</option>
					<option value="4">4小时</option>
					<option value="6">6小时</option>
					<option value="12">12小时</option>
				</select><br>
				<br style="font-size:5px;">
				令牌环有效期，一旦登录后，超过此时间的所有令牌将失效，需重新登录。
			</td>
		</tr>
	</tbody>
	<tbody id="TB_LRTokenGenerator">
		<tr>
			<td class="td_normal_title" width=15%>
				令牌环名称
			</td><td width=85%>
				<input name="cookie.name" value="" class="inputsgl" style="width: 320px;">
				<span class="txtstrong">*</span>
				<input type="button" value="默认值" class="btnopt" onclick="setFieldValue('cookie.name', 'LRToken');"><br>
				<br style="font-size:5px;">
				若您需要将同一作用域下的不同的SSO服务器组进行区分，请设置不同的令牌环名称。
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				密钥
			</td><td width=85%>
				公钥：<input name="security.key.public" value="" class="inputsgl" style="width: 284px;">
				<span class="txtstrong">*</span><br>
				私钥：<input name="security.key.private" value="" class="inputsgl" style="width: 284px;">
				<span class="txtstrong">*</span>
				<input type="button" value="生成密钥" class="btnopt" onclick="genKeyPair();"><br>
				<br style="font-size:5px;">
				一旦公钥和私钥被泄露，其它系统很容易伪造令牌环，因此请妥善保管好。
			</td>
		</tr>
	</tbody>
	<tbody id="TB_LtpaTokenGenerator">
		<tr>
				<td class="td_normal_title" width=15%>
					令牌环名称
				</td><td width=85%>
					<input name="domino.cookie.name" value="" class="inputsgl" style="width: 320px;">
					<span class="txtstrong">*</span>
					<input type="button" value="默认值" class="btnopt" onclick="setFieldValue('domino.cookie.name', 'LtpaToken');">
					<br style="font-size:5px;">
					若与Domino系统集成，请将该值设置为LtpaToken。
				</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				密钥
			</td><td width=85%>
				<input name="domino.security.key" value="" class="inputsgl" style="width: 320px;">
				<span class="txtstrong">*</span>
				<input type="button" value="生成密钥" class="btnopt" onclick="genLTPATokenKey();">
				<br style="font-size:5px;">
				一旦公钥和私钥被泄露，其它系统很容易伪造令牌环，因此请妥善保管好。
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				登录名关键字
			</td><td width=85%>
				<input name="domino.user.key" value="" class="inputsgl" style="width: 320px;"><br>
				<br style="font-size:5px;">
				一般的，Domino会使用形如“CN=yezq/O=Landray”的格式表示当前用户信息，而最容易被各个系统识别的用户信息为登录名。
				因此，需要从Domino的用户名表达式中获取登录名的信息，您可以在上面填写“CN”这个参数，说明从CN对应的值就是登录名。
				您也可以不设置该参数，此时，系统自动会获取到Domino表达式中的第一项值作为用户登录名。也可以设置多个关键字，以;分隔。
			</td>
		</tr>
	</tbody>
</table>
<br>
<input id="BTN_GenKeyDomino" type="button" value="导入" class="btnopt" onclick="genKeyDomino();">&nbsp;&nbsp;
<input type="button" value="提交" class="btnopt" onclick="submitForm();">&nbsp;&nbsp;
<input type="button" value="关闭" class="btnopt" onclick="window.close();">
<textarea name="fdTokenKey" style="display:none;"><c:out value="${fdTokenKey}" /></textarea>
</center>
<br>
</body>
</html>