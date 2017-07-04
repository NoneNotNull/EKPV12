<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("docutil.js|calendar.js|dialog.js|doclist.js|optbar.js");
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
//页面数据过多，显示加载中
function load(){
	var loadOver = document.getElementById("loadOver").value;
	if(loadOver.length==0){
		document.getElementById("loading").innerHTML = "<bean:message bundle="tib-sap-sync" key="tibSapSyncCategory.loading"/>";
		setTimeout("load()",10);
	}else{
		document.getElementById("loading").innerHTML = "";
	}
}
//返回跳转
function historyTo(){
		window.history.go(-1);
}
</script>
<center>
<table  width="95%" width=400 border=0 cellspacing=1 cellpadding=0>
	<tr cellspacing="0" cellpadding="0">
		<td align="center" colspan="3" height="20"  class="barmsg"><bean:message bundle="tib-sap-sync" key="docCategory.delete.confirm"/></td>
	</tr>
	<tr cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
		<td colspan="3" height="40">
				<center><bean:message bundle="tib-sap-sync" key="docCategory.delete.confirm.message"/></center>
				<br>
		</td>
	</tr>
</table>
<table  width="95%" width=400 border=0 cellspacing=1 cellpadding=0>
	<tr cellspacing="0" cellpadding="0">
		<td colspan="3">
			   <center></center>
		</td>
	</tr>
</table>
<br>
	<div align=center>
		<input type="button" class="btnmsg" value="<bean:message key='button.back'/>" onclick="historyTo();"/>									
	</div>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>