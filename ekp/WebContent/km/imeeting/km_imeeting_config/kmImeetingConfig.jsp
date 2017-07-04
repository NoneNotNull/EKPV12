<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	window.onload = function(){
		var unShow=document.getElementsByName("unShow")[0];
		var unShowValue=document.getElementsByName("value(unShow)")[0];
		if(unShowValue.value=="false"){
			unShow.checked=false;
		}else{
			unShow.checked=true;
		}
	};
	function changeValue(thisObj){
		var unShow=document.getElementsByName("unShow")[0];
		var unShowValue=document.getElementsByName("value(unShow)")[0];
		if(unShow.checked){
			unShowValue.value="true";
		}else{
			unShowValue.value="false";
		}
	}
</script>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgConfig"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.conflict.configMethod"/>
		</td>
		<td colspan="3">
			<html:hidden property="value(unShow)" />
			<input name="unShow" type="checkbox" onclick="changeValue(this);"/>
			<bean:message bundle="km-imeeting" key="kmImeetingRes.config.unShow"/>
		</td>		
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
