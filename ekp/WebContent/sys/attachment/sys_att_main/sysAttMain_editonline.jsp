<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<script>Com_IncludeFile("data.js");</script>
	<div id="optBarDiv">
		<table class="tb_noborder">
		<tr><td id="_button_${sysAttMainForm.fdKey}_Attachment_TD"></td>
		</tr>
		</table>
		<input type=button value="<bean:message key="button.update"/>"
				onclick="return Attach_EditOnlineSubmit();"/>
		<script>
		function Attach_EditOnlineSubmit() {
			//提交表单校验
			for(var i=0; i<Com_Parameter.event["submit"].length; i++){
				if(!Com_Parameter.event["submit"][i]()){
					return false;
				}
			}
			//提交表单消息确认
			for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
				if(!Com_Parameter.event["confirm"][i]()){
					return false;
				}
			}
			Com_Parameter.CloseInfo = null;
			Com_CloseWindow();
			return true;
		}
		</script>
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
	<table class="tb_normal" width=100% height="100%" style="margin-top: -10px;">
		<tr>
		<td valign="top">
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_OCX.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${sysAttMainForm.fdKey}" />
			<c:param name="fdAttType" value="office" />
			<c:param name="fdModelId" value="${sysAttMainForm.fdModelId}" />
			<c:param name="fdModelName" value="${sysAttMainForm.fdModelName}" />
			<c:param name="editMode" value="2" />		
			<c:param name="attachmentId" value="${sysAttMainForm.fdId}" />
			<c:param name="fdFileName" value="${sysAttMainForm.fdFileName}" />
			<c:param name="canPrint" value="${canPrint}" />
			<c:param name="attHeight" value="100%" />
			<c:param name="trackRevisions" value="1" />			
		</c:import>			
		</td>		
		</tr>
	</table>
	<script type="text/javascript">
		Com_SetWindowTitle("${param.fdFileName}");
		var attachmentObject_editonline = new  AttachmentObject("${sysAttMainForm.fdKey}","${sysAttMainForm.fdModelName}","${sysAttMainForm.fdModelId}",false,"office");
		Com_AddEventListener(window,"load", function() {
  			attachmentObject_editonline.show();
  		});
  </script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
