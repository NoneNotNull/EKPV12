<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
</script>
</head>
<body style="margin-left:10px">
<br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=500 border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=19 class=barmsg>
						<bean:message bundle="sys-admin" key="sysAdminCheckHealth.confirm.title" />
					</td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br>
									<table class="tb_noborder" width="100%">
										<tr>
											<td>
											<div style="color:red">
												<bean:message bundle="sys-admin" key="sysAdminCheckHealth.confirm.desc" />
											</div>
											</td>
										</tr>
									</table>
									<br style="font-size:10px" />
									<div align=center>
										<input type=button class=btnmsg style="cursor:pointer" value="<bean:message bundle="sys-admin" key="sysAdminCheckHealth.confirm.btn" />"
											onclick="Com_OpenWindow('<c:url value="/sys/admin/checkhealth/sysAdminCheckHealth.jsp" />', '_self');">
									</div>
									<br style="font-size:10px" />
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
<br><br>
</body>
</html>