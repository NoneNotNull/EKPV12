<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/sys/config/resource/jsperror.jsp" %>
<%@ include file="/sys/config/resource/htmlhead.jsp"%>
<link href="${KMSS_Parameter_StylePath}promptBox/prompt.css" rel="stylesheet" type="text/css" />
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("docutil.js");

</script>
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
								<td width="20" class="PromptTD_Left Prompt_error"><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td class="PromptTD_Center">
									<br><bean:message key="return.title"/><br>
									<br style="font-size:10px" class="">
									<span class="errortitle">
										<bean:message bundle="sys-follow" key="sysFollowDoc.failure"/>
									</span>
									<br style="font-size:10px">
									<span class="errorlist">
										<bean:message bundle="sys-follow" key="sysFollowDoc.reason"/>
									</span>
									<div align=center>
									
									</div>
									<br style="font-size:10px">
								</td>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
							</tr>
							<TR><TD colSpan=3>
							<DIV align=center><INPUT onclick=Com_CloseWindow(); class=btnmsg type=button value=关闭> </DIV><BR></TD></TR>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
	</tr>
</table>
<br><br>
</BODY>
</html>