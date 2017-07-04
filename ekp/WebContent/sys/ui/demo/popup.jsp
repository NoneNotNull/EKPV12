<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/ekp/resource/js/sea.js"
	data-config="/ekp/resource/js/seaconfig.jsp#"></script>
<script type="text/javascript">
	seajs.use([ 'sys/ui/js/parser', 'lui/jquery', 'sys/ui/js/popup/popup' ],
			function(parser, $) {
				window.$ = $;
				$(document).ready(function() {
					parser.parse();
				});

			});
</script>  
<title>ss</title>
</head>
<body style="margin: 0px; padding: 0px;">
<div style="height: 2000px;"></div>
<div style="padding-left: 500px; margin: 60px;position: relative;">a&gt;&gt; <span>
<div id="abcd" style="display: inline-block;">文字<span id="sssss">&#9660;</span></div>
<ui:popup  triggerObject="#sssss" triggerEvent="click" align="top-right" borderWidth="5" positionObject="#abcd">

	<div style="width: 150px; height: 150px;" class="aaa_popup">abc</div>

</ui:popup>
</div>
 
 
<table width="100%">
	<tr><td style="height: 30px;">
	 
		  
	</td><td> </td></tr>
	<tr>
		<td width="50%">
		 
		</td>
		<td width="50%" valign="top">
	 
		 <div>a</div> 
			<button onclick="startPopup()">开始</button>
		   <div id="ptest" style="display: inline-block;">aaaaa</div>
		   <div id="ptestBox" style="background-color: white;">asdfasdf</div>
		</td>
	</tr>
</table>
<script>
function startPopup(){
	seajs.use(['sys/ui/js/popup/popup','lui/jquery'], function(popup, $) {
		popup.build("#ptest", "#ptestBox");
	});
}
</script> 
</body>
</html>
