<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="sysAttMain_OCX.jsp"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("jg_attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<script type="text/javascript">
var jg_attachmentObject_${param.fdKey} = new JG_AttachmentObject("${attachmentId}", "${param.fdKey}", "${param.fdModelName}", "${param.fdModelId}", "${param.fdAttType}", "view");
jg_attachmentObject_${param.fdKey}.userName = "<%=com.landray.kmss.util.UserUtil.getUser().getFdName()%>";
<c:if test="${not empty param.isTemplate && param.isTemplate == 'true'}">
	jg_attachmentObject_${param.fdKey}.isTemplate = true;
</c:if>
<c:if test="${not empty param.editMode}">
	jg_attachmentObject_${param.fdKey}.editMode = "${param.editMode}";
</c:if>
<c:if test="${not empty param.buttonDiv}">
	jg_attachmentObject_${param.fdKey}.buttonDiv = "${param.buttonDiv}";
</c:if>
<c:if test="${not empty param.bookMarks}">
	jg_attachmentObject_${param.fdKey}.bookMarks = "${param.bookMarks}";
</c:if>
//得到文档状态，用于控制留痕按钮在发布状态中不显示
<c:if test="${_docStatus=='30'}">
	jg_attachmentObject_${param.fdKey}.hiddenRevisions=false;
</c:if>
<c:if test="${not empty attachmentId}">
<kmss:auth
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=print&fdId=${attachmentId}"
	requestMethod="GET">
	jg_attachmentObject_${param.fdKey}.canPrint=true;
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${attachmentId}"
			requestMethod="GET">
	jg_attachmentObject_${param.fdKey}.canDownload=true;		
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=read&fdId=${attachmentId}"
			requestMethod="GET">
	jg_attachmentObject_${param.fdKey}.canRead=true;		
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=copy&fdId=${attachmentId}"
			requestMethod="GET">
	jg_attachmentObject_${param.fdKey}.canCopy=true;	
</kmss:auth>
<kmss:auth	
	requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=edit&fdId=${attachmentId}"
			requestMethod="GET">
	jg_attachmentObject_${param.fdKey}.canEdit=true;
</kmss:auth>
</c:if>
function OnToolsClick(vIndex,vCaption){
	if(vIndex=='-1'&&vCaption=='全屏_BEGIN'){
        if(jg_attachmentObject_${param.fdKey}.canCopy){
      	  jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "1";
      	  jg_attachmentObject_${param.fdKey}.ocxObj.ShowToolBar = 2;
      	  jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "4,1";
  	  }else{
  		  jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "0";
  		  jg_attachmentObject_${param.fdKey}.ocxObj.ShowToolBar = 2;
  		  jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "0,1";
        }
    }
}
Com_AddEventListener(window, "unload", function() {
	jg_attachmentObject_${param.fdKey}.unLoad();
});
</script>
<%
    boolean isExpand = "true".equals(request.getParameter("isExpand"));
if(isExpand){
%>
<script>
   if(jg_attachmentObject_${param.fdKey}){
			setTimeout(function(){
			jg_attachmentObject_${param.fdKey}.load(encodeURIComponent("${fdFileName}"), "");
			jg_attachmentObject_${param.fdKey}.show();
			if(!jg_attachmentObject_${param.fdKey}.canCopy){
				jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "0";
				jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "0,1";
			}else{
				jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "1";
				jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "4,1";
			}
			if(Com_Parameter.IE)
				jg_attachmentObject_${param.fdKey}.ocxObj.setAttribute("OnToolsClick","OnToolsClick(vIndex,vCaption);");
			else
				jg_attachmentObject_${param.fdKey}.ocxObj.setAttribute("event_OnToolsClick","OnToolsClick");
			},100);
	}
</script>
<%}else{ %>
<ui:event event="show">
		if(jg_attachmentObject_${param.fdKey}){
			setTimeout(function(){
			jg_attachmentObject_${param.fdKey}.load(encodeURIComponent("${fdFileName}"), "");
			jg_attachmentObject_${param.fdKey}.show();
			if(!jg_attachmentObject_${param.fdKey}.canCopy){
				jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "0";
				jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "0,1";
			}else{
				jg_attachmentObject_${param.fdKey}.ocxObj.CopyType = "1";
				jg_attachmentObject_${param.fdKey}.ocxObj.EditType = "4,1";
			}
			if(Com_Parameter.IE)
				jg_attachmentObject_${param.fdKey}.ocxObj.setAttribute("OnToolsClick","OnToolsClick(vIndex,vCaption);");
			else
				jg_attachmentObject_${param.fdKey}.ocxObj.setAttribute("event_OnToolsClick","OnToolsClick");
			},100);
		}
</ui:event>
<%}%>