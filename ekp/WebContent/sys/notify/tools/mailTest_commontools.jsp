<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js|popdialog.js|jquery.js");            
</script>
<script type="text/javascript">
	function doTest() {
		var fdOrgPersonIds = $('input[name=fdOrgPersonIds]').val();
		var fdEmailTestTitle = $('input[name=fdEmailTestTitle]').val();
		var fdEmailTestContent = $('textarea[name=fdEmailTestContent]').val();
		if (fdOrgPersonIds == "") {
			alert("请选择邮件接收用户");
			return;
		}
		if (fdEmailTestTitle == "") {
			alert("请填写邮件标题");
			return;
		}
		if(fdEmailTestTitle!=null && fdEmailTestTitle.length > 300){
			alert("邮件标题不能大于300字符");
			return;
		}
		if (fdEmailTestContent == "") {
			alert("请填写邮件内容");
			return;
		}
		 
		if(fdEmailTestContent!=null && fdEmailTestContent.length > 8000){
			alert("邮件内容不能大于8000字符");
			return;
		}
		var url = Com_Parameter.ContextPath
				+ "sys/notify/sys_notify_main/sysNotifyMailTest.do?method=sendMailTest";
		var params = {
			fdOrgPersonIds : fdOrgPersonIds,
			fdEmailTestTitle : fdEmailTestTitle,
			fdEmailTestContent : fdEmailTestContent
		};
		var loadingDialog = new PopDialog({
			content:"数据处理中，请稍后...",
			width:400,
			buttons: {
				 
			}
		});
		$.post(url, params, function(data) {
			loadingDialog.close();
			if (data != null && data.length > 0) {
				showResult("发送失败！<br/>"+data);
			} else {
				showResult("发送成功！");
			}
		});
	}
	function showResult(content){
		var dialog = new PopDialog({
			content:content,
			width:400,
			buttons: {
				'<bean:message key="button.close" />': function(){dialog.close();}
			}
		});
	}
	function resetForm() {
		$('input[name=fdOrgPersonIds]').val('');
		$('textarea[name=fdOrgPersonNames]').val('');
		$('input[name=fdEmailTestTitle]').val('');
		$('textarea[name=fdEmailTestContent]').val('');
	}
</script>

<div id="optBarDiv">
	<input type="button" value="执行" onclick="doTest();">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<p class="txttitle"><bean:message key="sysNotify.config.emailtest" bundle="sys-notify"/></p>
<table class="tb_normal" width=85%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="sysNotify.config.emailtest.org" bundle="sys-notify"/>
		</td>
		<td width="85%">
			<input type="hidden" name="fdOrgPersonIds">
			<textarea name="fdOrgPersonNames" style="width:85%" readonly></textarea>
			<a href="#" class="com_btn_link" onclick="Dialog_Address(true, 'fdOrgPersonIds','fdOrgPersonNames', ';', ORG_TYPE_PERSON);">
			<bean:message key="dialog.selectOrg" /></a><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="sysNotify.config.emailtest.title" bundle="sys-notify"/>
		</td>
		<td width="85%">
			<input type="text" name="fdEmailTestTitle"  class="inputsgl" style="width:85%;" value="<bean:message key="sysNotify.config.emailtest.title.defaultContent" bundle="sys-notify"/>"/><span class="txtstrong">*</span>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="sysNotify.config.emailtest.content" bundle="sys-notify"/>
		</td>
		<td width="85%">
			<textarea name="fdEmailTestContent" style="width: 85%; height: 90px" ><bean:message key="sysNotify.config.emailtest.content.defaultContent" bundle="sys-notify"/></textarea><span class="txtstrong">*</span>
		</td>
	</tr>	
</table>
<div id="resultTab"></div>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>