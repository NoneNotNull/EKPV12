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
	<table class="tb_normal" width=95%>
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
			<td><input type='text' id='control_width' class='inputsgl' style="width:80%" storage="true" value="95%"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>高度(百分比或像素,如80%或200px)</td>
			<td><input type='text' id='control_height' class='inputsgl' style="width:80%" storage="true" value="80px"/></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=40%>内容长度限制(0或空不限制)</td>
			<td><input type='text' id='control_content' class='inputsgl' style="width:80%" storage="true"/></td>
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
	var control_height=$("#control_height").val();
	if(control_height&&!/^\d+%$|^\d+px$/g.test(control_height)){
		alert('高度百分比或像素格式不正确');
		return false;
	}
	var control_content=$("#control_content").val();
	if(control_content&&!/^\d+$/g.test(control_content)){
		alert('内容长度限制必须为数字');
		return false;
	}
	return true;
}
</script>
