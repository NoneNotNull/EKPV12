<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("data.js");
function refreshInfo(){
	//Com_Parameter.XMLDebug = true;
	var statusInfo = new Array(
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.stoped"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.error"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.finish"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.ready"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.starting"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.running"/>",
		"<bean:message bundle="sys-datainit" key="sysDatainitMain.status.stopping"/>"
	);
	var blockCount = 40;
	
	var data = new KMSSData();
	data.UseCache = false;
	data.AddBeanData("sysDatainitXMLDataBean");
	var rtnInfo = data.GetHashMapArray()[0];
	//currentTime,startTime,endTime,status,processCount,successCount,ignoreCount,failureCount,errorFile
	var status = parseInt(rtnInfo.status);
	rtnInfo.processCount = parseInt(rtnInfo.processCount);
	rtnInfo.successCount = parseInt(rtnInfo.successCount);
	rtnInfo.ignoreCount = parseInt(rtnInfo.ignoreCount);
	rtnInfo.failureCount = parseInt(rtnInfo.failureCount);
	var handleCount = 0;
	if(rtnInfo.processCount>0){
		handleCount = rtnInfo.successCount+rtnInfo.ignoreCount+rtnInfo.failureCount;
		rtnInfo.process = Math.round(handleCount*100/rtnInfo.processCount)+"% &nbsp;("+handleCount+"/"+rtnInfo.processCount+")";
		handleCount = Math.round(handleCount*blockCount/rtnInfo.processCount);
	}else{
		rtnInfo.process = "N/A";
	}
	rtnInfo.processbar = "";
	for(var i=0; i<handleCount; i++)
		rtnInfo.processbar += "■";
	for(; i<blockCount; i++)
		rtnInfo.processbar += "□";
	rtnInfo.status = statusInfo[status+3];
	for(var o in rtnInfo){
		var obj = document.getElementById("div_"+o);
		if(obj!=null)
			obj.innerHTML = rtnInfo[o];
	}
	document.getElementById("btn_showImport").style.display=(status>0)?"none":"";
	document.getElementById("btn_stopImport").style.display=(status>0)?"":"none";
	if(status>0){
		setTimeout("refreshInfo()", 2000);
	}
}
function showMoreErrInfo(srcImg){
	var obj = document.getElementById("div_errorFile");
	if(obj.style.display=="none"){
		obj.style.display="block";
		srcImg.src = Com_Parameter.StylePath + "msg/minus.gif";
	}else{
		obj.style.display="none";
		srcImg.src = Com_Parameter.StylePath + "msg/plus.gif";
	}
}
function doAction(method){
	location.href = "<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method="/>"+method+"&type=${param.type}";
}
window.onload = refreshInfo;
</script>
</head>
<BODY style="margin-left:10px">
<br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=500 border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg>
						<bean:message bundle="sys-datainit" key="sysDatainitMain.status.title"/>
					</td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br>
									<bean:message bundle="sys-datainit" key="sysDatainitMain.status.info"/>
									<span id="div_currentTime"></span>
									<br><br style="font-size:10px">
									<table class="tb_noborder" width="100%">
										<tr height="25px">
											<td colspan="2" id="div_processbar" class="msgtitle" style="font-size:16px"></td>
										</tr>
										<tr>
											<td class="msgtitle" width="50%">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.status"/>
												<span id="div_status"></span>
											</td>
											<td class="msgtitle" width="50%">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.process"/>
												<span id="div_process"></span>
											</td>
										</tr>
										<tr height="25px">
											<td class="msglist">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.startTime"/>
												<span id="div_startTime"></span>
											</td>
											<td class="msglist">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.endTime"/>
												<span id="div_endTime"></span>
											</td>
										</tr>
										<tr height="25px">
											<td class="msglist">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.successCount"/>
												<span id="div_successCount"></span>
											</td>
											<td class="msglist">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.ignoreCount"/>
												<span id="div_ignoreCount"></span>
											</td>
										</tr>
										<tr height="25px">
											<td class="msglist" colspan="2">
												<image src='${KMSS_Parameter_StylePath}msg/plus.gif' onclick='showMoreErrInfo(this);' style='cursor:pointer'>
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.failureCount"/>
												<span id="div_failureCount"></span><br>
												<div id="div_errorFile" style="display:none"></div>
											</td>
										</tr>
										<tr>
											<td class="msglist" colspan="2">
												<br style="font-size:10px">
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.help"/><br><br style="font-size:5px"><li>
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.help.click"/></li><br><br style="font-size:5px">	<li>
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.help.specific"/></li><br><br style="font-size:5px"><li>
												<bean:message bundle="sys-datainit" key="sysDatainitMain.status.help.not"/></li>
											</td>
										</tr>
									</table>
									<br style="font-size:10px">
									<div align=center>
										<input type=button class=btnmsg value="<bean:message bundle="sys-datainit" key="sysDatainitMain.status.btnImport"/>"
											onclick="doAction('showImport');" id="btn_showImport" style="display:none">
										<input type=button class=btnmsg value="<bean:message bundle="sys-datainit" key="sysDatainitMain.status.btnStop"/>"
											onclick="doAction('stopImport');" id="btn_stopImport" style="display:none">
									</div>
									<br style="font-size:10px">
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
</BODY>
</html>