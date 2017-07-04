<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>
	 function closeWin(){
	   if(jg_attachmentObject_editonline.ocxObj.WebClose()){
		 Com_CloseWindow();
		}
	}
</script>
<script>Com_IncludeFile("jg_attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<div id="optBarDiv">
	<table class="tb_noborder">
	<tr><td id="_button_${sysAttMainForm.fdKey}_JG_Attachment_TD"></td>
	</tr>
	</table>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_Parameter.CloseInfo=null;closeWin();">
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
		<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_OCX.jsp" charEncoding="UTF-8">
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
	var url = window.location.href;
	var fdId = Com_GetUrlParameter(url,"fdId");
	var fdKey ="${sysAttMainForm.fdKey}";
	var jg_attachmentObject_editonline = new JG_AttachmentObject(fdId,fdKey, "", "", "office", "view");
	jg_attachmentObject_editonline.userName = "<%=com.landray.kmss.util.UserUtil.getUser().getFdName()%>";
	<c:if test="${canPrint=='1'}">
	jg_attachmentObject_editonline.canPrint = true;
	</c:if>
	<c:if test="${canCopy=='1'}">
	jg_attachmentObject_editonline.canCopy = true;	
	</c:if>	
	Com_AddEventListener(window, "load", function() {
		jg_attachmentObject_editonline.load(encodeURIComponent("${sysAttMainForm.fdFileName}"));
		jg_attachmentObject_editonline.show();
		<c:if test="${isPrint}">
		jg_attachmentObject_editonline.ocxObj.WebOpenPrint();
		</c:if>
		if(!jg_attachmentObject_editonline.canCopy){
			jg_attachmentObject_editonline.ocxObj.CopyType = "0";
			jg_attachmentObject_editonline.ocxObj.EditType = "0,1";
		}else{
			jg_attachmentObject_editonline.ocxObj.CopyType = "1";
			jg_attachmentObject_editonline.ocxObj.EditType = "4,1";
		}
		if(Com_Parameter.IE)
			jg_attachmentObject_editonline.ocxObj.setAttribute("OnToolsClick","OnToolsClick(vIndex,vCaption);");
		else
			jg_attachmentObject_editonline.ocxObj.setAttribute("event_OnToolsClick","OnToolsClick");
	});
	function OnToolsClick(vIndex,vCaption){
		 if(vIndex=='-1'&&vCaption=='全屏_BEGIN'){
             if(jg_attachmentObject_editonline.canCopy){
           	  jg_attachmentObject_editonline.ocxObj.CopyType = "1";
           	  jg_attachmentObject_editonline.ocxObj.ShowToolBar = 2;
           	  jg_attachmentObject_editonline.ocxObj.EditType = "4,1";
       	  }else{
       		  jg_attachmentObject_editonline.ocxObj.CopyType = "0";
           	  jg_attachmentObject_editonline.ocxObj.ShowToolBar = 2;
           	  jg_attachmentObject_editonline.ocxObj.EditType = "0,1";
             }
         }
	}
	Com_AddEventListener(window, "unload", function() {
		jg_attachmentObject_editonline.unLoad();
	});
	</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
