<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<title>修改log4j级别</title>
<script>
	function openDebug(){
		var calssName = document.getElementsByName("className")[0].value;
		var level = document.getElementsByName("level")[0].value;
		if(calssName == ""){
			alert("请填写类名!");
			return;
		}
		if(level == ""){
			alert("请选择级别!");
			return;
		}
		calssName = Com_Trim(calssName);
		Com_OpenWindow(Com_Parameter.ContextPath+'sys/common/config.do?method=chgLog&class='+calssName+'&level='+level,'_self');
	}
	function resetForm(){
		var calssName = document.getElementsByName("className")[0];
		var level = document.getElementsByName("level")[0];
		calssName.value = '';
		level.value = '';
	}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">修改log4j级别</p>
<center>
<table class="tb_normal" width=85%>
	<tr>
		<td class="td_normal_title" width=15%>
			类名（全路径）
		</td><td width="85%">
			<input type="text" name="className" style="width:90%" class="inputsgl"/>
			<span class="txtstrong">*</span><br>
			<span class="message">
					例：com.landray.kmss.km.review.service.spring.KmReviewMainServiceImp
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			级别
		</td><td width="85%">
			<select name="level">
				<option value="">==请选择==</option>
				<option value="DEBUG">DEBUG</option>
				<option value="ERROR">ERROR</option>
				<option value="INFO">INFO</option>
				<option value="WARN">WARN</option>
			</select>
		</td>
	</tr>	
</table>
<br/>
<table class="tb_nobrder" width=85%>
	<tr>
		<td align="center">
			<input type=button class="btnopt" value="执行" onclick="openDebug();">
			&nbsp;&nbsp;&nbsp;
			<input type=button class="btnopt" value="重置" onclick="resetForm();">
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>