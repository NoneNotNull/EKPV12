<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
	<div id="optBarDiv"><input type=button
		value="确定"
		onclick="confirmReason()"> <input
		type="button" value="<bean:message key="button.close"/>"
		onclick="window.close();"></div>

		<table class="tb_normal" width=100% id="reason_table">
			<tr>
				<td class="td_normal_title" width=15%>恢复原因</td>
				<td width=85%>
					<textarea  rows="8" 
							   style="width:90%;height:150px" 
							   name="descript"
							   validate="required maxLength(800)"></textarea>
							   
				</td>
			</tr>
		</table>
		<script>
			function confirmReason() {
				var validator = $KMSSValidation(document.getElementById("reason_table"));
				if(!validator.validate())
					return;
				var reason = document.getElementsByName('descript')[0].value;
				opener.document.getElementsByName('reason')[0].value = reason;
				opener.__submitrecover();
				window.close();
			}
		</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>