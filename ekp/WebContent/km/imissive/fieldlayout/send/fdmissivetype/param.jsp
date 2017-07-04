<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/" + Com_Parameter.Style + "/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
	Com_IncludeFile('dialog.js');
</script>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
</head>
<body>
	<form>
	<table class="tb_normal"  width=95%>
		<%@ include file="/km/imissive/fieldlayout/common/param_top.jsp"%>
		<tr>
			<td class="td_normal_title" width=40%>默认值</td>
			<td>
			  <input type="radio" name="fdMissiveType" value="0" storage="true" checked="checked">不限</input> 
	          <input type="radio" name="fdMissiveType" value="1" storage="true">分发件</input> 
	          <input type="radio" name="fdMissiveType" value="2" storage="true">上报件</input>
			</td>
		</tr>
	 <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
	</table>
	</form>
</body>
</html>
