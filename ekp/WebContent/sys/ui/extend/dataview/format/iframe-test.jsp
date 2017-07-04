<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
.button_resize{
	font-size:10px; width:20px; height:20px;
}
.input_resize{
	color: #0066FF; border: 1px solid #999999; width:50px; height:18px;
}
</style>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js"
	data-config="${LUI_ContextPath}/resource/js/seaconfig.jsp#"></script>
<script type="text/javascript">
	seajs.use([ 'lui/parser', 'lui/jquery','lui/LUI','theme!common','theme!icon' ], function(parser, $,LUI) {
		window.$ = $;
		$(document).ready(function() {
			parser.parse();
		});
		window.clickMe = function(obj){
			$(obj).after("<br/>这是一行信息");
			setTimeout(function(){
				var id = "${param.LUIElementId}";
				if(id==""){
					return;
				}
				LUI.fire({
					"type":"event",
					"name":"resize",
					"target":id,
					"data":{
						"width":$(document.body).width(),
						"height":$(document.body).height()
					}
				}, parent);
				}, 100);
		};
	});	
	
</script>
<title>我的测试样例</title>
</head>
<body>
		<table width="100%" cellpadding="5" cellspacing="5" border="0" align="top">
			<tr>
				<td>
					<input type="button" value="点击我，增加一行" onclick="clickMe(this);"/>
				</td>
			</tr>
		</table>
</body>
</html>
