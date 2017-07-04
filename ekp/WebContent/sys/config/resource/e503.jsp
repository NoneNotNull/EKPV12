<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/htmlhead.jsp"%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("docutil.js");
</script>
<title><bean:message key="return.systemInfo"/></title>
</head>
<BODY style="margin-left:10px">
<br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=400 border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg><bean:message key="return.systemInfo"/></td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br><bean:message key="return.title"/><br>
									<br style="font-size:10px">
									<font color="red">
										<strong><bean:message key="global.service.unavalable"/></strong>
									</font>
									<br><br style="font-size:10px"><br style="font-size:10px">
								</td>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
	</tr>
</table>
</body>
</html>