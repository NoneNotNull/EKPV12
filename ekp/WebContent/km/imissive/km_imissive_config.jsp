<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message key="setting.read.default.type" bundle="km-imissive" /></p>
<center>
<table class="tb_normal" width=70%>
	<tr>
	    <!-- 默认启用阅读加速模式  -->
		<td class="td_normal_title" width=20%>
			<bean:message bundle="km-imissive" key="setting.read.default.type"/>：
		</td>
		<td>
		    <!-- 不启用 -->
			<input name="value(showImgDoc)" type="radio" value="1" checked="checked"/>
			<bean:message bundle="km-imissive" key="setting.read.default.type.off"/>
			<!-- 仅发布后-->
			<input  name="value(showImgDoc)" type="radio" value="2"/>
			<bean:message bundle="km-imissive" key="setting.read.default.type.on"/>
			<br>
				<bean:message bundle="km-imissive" key="setting.read.default.typeInfo0"/><br>
				<bean:message bundle="km-imissive" key="setting.read.default.typeInfo1"/><br>
				<bean:message bundle="km-imissive" key="setting.read.default.typeInfo2"/><br>
				<bean:message bundle="km-imissive" key="setting.read.default.typeInfo3"/>
		</td>
	</tr>
	<html:hidden property="value(showImgDoc)"/>
</table>
</center>
</html:form> 
<script>
Com_IncludeFile("jquery.js");
</script>
<script>
$(document).ready(function (){
	init();
});
/****
 * 初始化
*/
function init(){
	var showImgDoc = $('input[name="value(showImgDoc)"][type="hidden"]');
	var radio = 'input[name="value(showImgDoc)"][type="radio"][value='+showImgDoc.val()+']';
	$(radio).attr("checked","checked");
	$('input[name="value(showImgDoc)"][type="radio"]').each( function() {
			$(this).bind('click', function() {
				showImgDoc.val(this.value);
			});
		});
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>