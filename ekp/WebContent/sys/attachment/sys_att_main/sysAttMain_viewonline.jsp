<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<div id="optBarDiv">
	<table class="tb_noborder">
	<tr><td id="_button_${sysAttMainForm.fdKey}_Attachment_TD"></td>
	</tr>
	</table>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_Parameter.CloseInfo=null;Com_CloseWindow();">
</div>
	<c:set var="canPrint" value=""/>
	<c:set var="canCopy" value=""/>
<kmss:auth
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=print&fdId=${sysAttMainForm.fdId}"
	requestMethod="GET">
	<c:set var="canPrint" value="1"/>			
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=copy&fdId=${sysAttMainForm.fdId}"
			requestMethod="GET">
	<c:set var="canCopy" value="1"/>
</kmss:auth>
	<table class="tb_normal" width=100% height="100%" style="margin-top: -10px;">
		<tr>
		<td>
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_OCX.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${sysAttMainForm.fdKey}" />
			<c:param name="fdAttType" value="office" />
			<c:param name="fdModelId" value="${sysAttMainForm.fdModelId}" />
			<c:param name="fdModelName" value="${sysAttMainForm.fdModelName}" />
			<c:param name="editMode" value="3" />		
			<c:param name="attachmentId" value="${sysAttMainForm.fdId}" />
			<c:param name="fdFileName" value="${sysAttMainForm.fdFileName}" />
			<c:param name="canPrint" value="${canPrint}" />
			<c:param name="canCopy" value="${canCopy}" />
			<c:param name="attHeight" value="100%" />			
		</c:import>		
		</td>
		</tr>
	</table>
	<script type="text/javascript">
		Com_SetWindowTitle("${sysAttMainForm.fdFileName}");
		var attachmentObject_editonline = new  AttachmentObject("${sysAttMainForm.fdKey}","${sysAttMainForm.fdModelName}","${sysAttMainForm.fdModelId}",false,"office");
		<c:if test="${canPrint=='1'}">
			attachmentObject_editonline.canPrint=true;
		</c:if>
		<c:if test="${canCopy=='1'}">
			attachmentObject_editonline.canCopy=true;	
		</c:if>
		Com_AddEventListener(window,"load", function() {
			attachmentObject_editonline.show();
		});
	</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
