<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<title><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.title'/></title>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<script type="text/javascript"> 
function autoTable() {
	var url = Com_SetUrlParameter(window.location.href,"method","add");
	window.location.href = Com_SetUrlParameter(url,"fdTableType","auto");
}
function manualTable() {
	window.location.href = Com_SetUrlParameter(window.location.href,"method","add");
}
function onekeySubmit() {
	if(window.confirm('<kmss:message key="sys-xform:sysFormDbTable.alert.onkeyConfirm" />')){
		var url = Com_SetUrlParameter(window.location.href,"method","add");
		window.location.href = Com_SetUrlParameter(url,"fdTableType","onekey");
	}
}
function cancelSubmit() { 
	window.close();
} 
</script>
</head>
<body>
<center> 
 <br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=500 border=0 cellspacing=1 cellpadding=0 bgcolor=#c0c0c0>
				<tr> 
					<td height=26 style="font-size: 14px;background-image: url(images/title_bg.gif); text-align: center;font-weight: bold;color: #052e61;"><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.title'/></td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br/>
									<br/>
									<div style="background-image:url(images/but_bg.gif);border: 1px solid #acbeca; width: 100px; height: 22px;line-height: 20px;text-align: center;"><a href="javascript:void(0)" onclick="manualTable()" style="text-decoration: none;color:#000000; "><div><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.map'/></div></a></div>
 									<div class="tb_normal" style="margin-top: 5px;padding: 3px;"><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.mapDescription'/></div>
									
									<br/>
									<br/>
									<div style="background-image:url(images/but_bg.gif);border: 1px solid #acbeca; width: 100px; height: 22px;line-height: 20px;text-align: center;"><a href="javascript:void(0)" onclick="autoTable()" style="text-decoration: none;color:#000000; "><div><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.auto'/></div></a></div>
 									<div class="tb_normal" style="margin-top: 5px;padding: 3px;"><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.autoDescription'/></div>
								 
									<br/>
									<br/>
									<div style="background-image:url(images/but_bg.gif);border: 1px solid #acbeca; width: 100px; height: 22px;line-height: 20px;text-align: center;"><a href="javascript:void(0)" onclick="onekeySubmit()" style="text-decoration: none;color:#000000; "><div><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.onekey'/></div></a></div>
									<div class="tb_normal" style="margin-top: 5px;padding: 3px;"><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.onekeyDescription'/></div>
									
									<br/>
									<br/>
									<div style="text-align: right;">
									<div style="background-image:url(images/but_bg2.gif);border: 1px solid #7ec2f1; width: 100px; height: 22px;line-height: 20px;text-align: center;"><a href="javascript:void(0)" onclick="cancelSubmit()" style="text-decoration: none;color:#000000; "><div><bean:message bundle='sys-xform' key='sysFormTemplate.prompt.button.cancel'/></div></a></div>
									</div>
									
									
									<br/>
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
</center>
</body>
</html>