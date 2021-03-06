<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
</script>
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="expires" content="0">
</head>
<body>
	<form>
	<table class="tb_normal"  width=95%>
		<tr>
			<td align="center" colspan="2">
				<b>设置参数</b>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>必填(针对数据库非必填字段生效)</td>
			<td>
				<input type="checkbox" name="control_required" value="true" storage='true'/>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>默认值</td>
			<td><input type='text' id='defaultValue' class='inputsgl' style="width:80%" storage="true"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>宽度(百分比或像素,如80%或200px)</td>
			<td><input type='text' id='control_width' class='inputsgl' style="width:80%" storage="true"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>数据类型</td>
			<td><select id='dataType' storage='true'>
					<option value="Double">数字</option>
					<option value="BigDecimal">数字(BigDecimal)</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>校验</td>
			<td>小数位数<input type='text' id='scale' class='inputsgl' style="width:40px" storage="true" value='0'/>,<br/>
				介于<input type='text' id='beginNum' class='inputsgl' style="width:40px" storage="true"/>到
					<input type='text' id='endNum' class='inputsgl' style="width:40px" storage="true"/>之间
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
			   <%@ include file="/sys/xform/designer/fieldlayout/default_layout/common_param.jsp"%>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
<script>
function checkOK(){
	var control_width=$("#control_width").val();
	if(control_width&&!/^\d+%$|^\d+px$/g.test(control_width)){
		alert('宽度百分比或像素格式不正确');
		return false;
	}
	var scale=$("#scale").val();
	if(scale&&!/^\d+$/g.test(scale)){
		alert('小数位数必须为数字');
		return false;
	}
	var beginNum=$("#beginNum").val();
	if(beginNum&&!/^\d+$/g.test(beginNum)){
		alert('限制范围必须为数字');
		return false;
	}
	var endNum=$("#endNum").val();
	if(endNum&&!/^\d+$/g.test(endNum)){
		alert('限制范围必须为数字');
		return false;
	}
	return true;
}
</script>
