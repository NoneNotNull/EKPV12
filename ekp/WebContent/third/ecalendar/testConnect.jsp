<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile("doclist.js|dialog.js|data.js");
function testConnect(){
	var data = new KMSSData();
	var webServiceUrl = Com_GetUrlParameter(window.location.href, "webServiceUrl");
	var domain = Com_GetUrlParameter(window.location.href, "domain");
	var version = Com_GetUrlParameter(window.location.href, "version");
	var account = document.getElementsByName("account")[0].value;
	var password = document.getElementsByName("password")[0].value;
	var url = "ecalendar.do?method=testConnect"+"&domain="+domain+"&account="+account+"&password="+password+"&version="+version+"&webServiceUrl="+webServiceUrl;
	//alert(url);
	data.SendToUrl(url, exchangeProcessRequest);
}

function exchangeProcessRequest(request){
	var result = Com_GetUrlParameter(request.responseText, "result");
	if(result=="true"){
		alert("连接成功！");
	}else{
		alert("连接失败！错误信息："+result);
    }
}
</script>

<table class="tb_normal" width=100% id="calendar.integrate.ecalendar">
	
		
	<tr>
		<td class="td_normal_title" width="110px;">exchange账号</td>
		<td>
			<input type="text" name="account" ></input>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="110px;">密码</td>
		<td>
			<input type="password" name="password" ></input>
		</td>
	</tr>
	
	<tr>
		<td colspan="2" align="center">
			<input type="button" class="btnopt" value="测试连接" onclick="testConnect();">
		</td>
		
	</tr>
	
</table> 