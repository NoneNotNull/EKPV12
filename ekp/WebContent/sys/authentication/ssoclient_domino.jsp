<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<script>
Com_IncludeFile("data.js");
<%-- 提交表单 --%>
function submitForm(){
	var fields = document.getElementById("TB_Main").getElementsByTagName("INPUT");
	var rtnVal = {};
	for(var i=0; i<fields.length; i++){
		var value = Com_Trim(fields[i].value);
		if(value == ""){
			alert("请完整填写所有必填项，再执行提交操作！");
			return;
		}
		rtnVal[fields[i].name] = value;
	}
	var data = new KMSSData();
	data.AddHashMap(rtnVal);
	data.SendToUrl(Com_Parameter.ContextPath+"sys/authentication/ssoclient.do?method=genKeyDomino", function(http){
		var result = eval("("+http.responseText+")");
		if(result.error!=null){
			alert(result.error);
			return;
		}
		top.returnValue = result;
		window.close();
	});
}

<%-- window onload事件，初始化所有值 --%>
window.onload = function(){
	for(var fieldName in dialogArguments){
		setFieldValue(fieldName, dialogArguments[fieldName]);
	}
};

<%-- 设置某个字段的值 --%>
function setFieldValue(fieldName, fieldValue){
	if(fieldValue==null)
		return;
	var fields = document.getElementsByName(fieldName);
	if(fields.length==0)
		return;
	fields[0].value = fieldValue;
}
</script>
<center>
请输入Domino服务器相关参数<br><br>
<table class="tb_normal" width=95% id="TB_Main">
	<tr>
		<td class="td_normal_title" width=20%>
			DIIOP地址
		</td><td width=85%>
			<input name="dominoDiiopServer" value="" class="inputsgl" style="width: 320px;">
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			管理员账号
		</td><td width=85%>
			<input name="dominoLoginName" value="" class="inputsgl" style="width: 320px;">
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			管理员密码
		</td><td width=85%>
			<input type="password" name="dominoPassword" value="" class="inputsgl" style="width: 320px;">
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			SSO文档配置名称
		</td><td width=85%>
			<input name="dominoTokenName" value="LtpaToken" class="inputsgl" style="width: 320px;">
			<span class="txtstrong">*</span>
		</td>
	</tr>
</table>
<br>
<input type="button" value="确定" class="btnopt" onclick="submitForm();">&nbsp;&nbsp;
<input type="button" value="取消" class="btnopt" onclick="window.close();">
</center>
<br>
</body>
</html>