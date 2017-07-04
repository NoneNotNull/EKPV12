<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-datainit" key="sysDatainitMain.upload.title"/></div>
<script>
function submitForm(){
	if(document.getElementsByName("initfile")[0].value.length>0){
		document.forms[0].submit();
		$(document.forms[0]).hide();
		$('#loading').show();
		return;
	}
	alert("数据源不能为空");
}
</script>
<html:form action="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=upload" method="post" enctype="multipart/form-data" >
	<center>
		<table class="tb_normal" width=95%>				
			<tr>
				<td class="td_normal_title" width=20%>
					<bean:message bundle="sys-datainit" key="sysDatainitMain.select.upload"/>
				</td><td width=60%>
					<span id="_formFilesSpan">
						<input type="file" class="upload" name="initfile" width=100%>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input class="btnopt" type=button value="<bean:message bundle="sys-datainit" key="sysDatainitMain.upload.button"/>" onclick="submitForm();">
					</span>
				</td>
			</tr>
		</table>
	</center>
</html:form>
<div align="center" style="display: none;" id="loading">
	<img src="../../../resource/style/common/images/loading.gif" border="0" />
	<bean:message bundle="sys-datainit" key="sysDatainitMain.import.loading"/>
</div>
<%@ include file="/resource/jsp/view_down.jsp"%>
