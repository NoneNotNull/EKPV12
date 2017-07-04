<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
	String loadMessage = (String)request.getAttribute("_loadMessageInfo");
	if(loadMessage==null) {
%>
 
 if(typeof Attachment_MessageInfo == "undefined")
	Attachment_MessageInfo = new Array();
 if(Attachment_MessageInfo.length==0) {
 	Attachment_MessageInfo["sysAttMain.fdFileName"]="<bean:message bundle="sys-attachment" key="sysAttMain.fdFileName" />";
 	Attachment_MessageInfo["sysAttMain.fdSize"]="<bean:message bundle="sys-attachment" key="sysAttMain.fdSize"/>";
 	Attachment_MessageInfo["opt.return"]="<bean:message bundle="sys-attachment" key="sysAttMain.opt.return"/>";
	Attachment_MessageInfo["button.saveDraft"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.saveDraft" />";
	Attachment_MessageInfo["button.selectAll"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.selectAll"/>";
	Attachment_MessageInfo["button.fullsize"]="<bean:message bundle="sys-attachment" key="JG.tools.fullsize"/>";
	

	Attachment_MessageInfo["button.upload"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.upload"/>";
	Attachment_MessageInfo["button.textinfo"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.textinfo"/>";
	Attachment_MessageInfo["button.cancelAll"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.cancelAll"/>";
	Attachment_MessageInfo["button.batchdown"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.batchdown"/>";
	Attachment_MessageInfo["button.filesize"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.filesize"/>";
	Attachment_MessageInfo["button.downtimes"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.downtimes"/>";
	Attachment_MessageInfo["button.cancelupload"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.cancelupload"/>";
	Attachment_MessageInfo["button.play"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.play"/>";
	Attachment_MessageInfo["button.confimdelte"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.confimdelte"/>";
	Attachment_MessageInfo["button.progress"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.progress"/>";
	
  	Attachment_MessageInfo["button.create"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.create"/>";
  	Attachment_MessageInfo["button.delete"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.delete" />";
  	Attachment_MessageInfo["button.download"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.download" />";
  	Attachment_MessageInfo["button.read"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.read" />";
  	Attachment_MessageInfo["button.open"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.open" />";
  	Attachment_MessageInfo["button.edit"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.edit" />";
  	Attachment_MessageInfo["button.bookmark"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.bookmark" />"; 
  	Attachment_MessageInfo["button.page"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.page" />"; 
  	Attachment_MessageInfo["button.print"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.print" />"; 
  	Attachment_MessageInfo["button.printPreview"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.printPreview" />"; 
  	Attachment_MessageInfo["button.exitPrintPreview"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.exitPrintPreview" />"; 
  	Attachment_MessageInfo["button.activate"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.activate" />"; 
  	Attachment_MessageInfo["button.hideRevisions"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.hideRevisions" />";   	  	  	 	  	  	  	
  	Attachment_MessageInfo["button.showRevisions"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.showRevisions" />";   	  	  	 	  	  	  	
  	Attachment_MessageInfo["button.acceptRevisions"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.acceptRevisions" />";   	  	  	 	  	  	  	
  	Attachment_MessageInfo["button.refuseRevisions"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.refuseRevisions" />";
  	Attachment_MessageInfo["button.openLocal"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.openLocal" />";
  	Attachment_MessageInfo["button.bigAttBtn"]="<bean:message bundle="sys-attachment" key="sysAttMain.button.bigAttBtn" />";
  	Attachment_MessageInfo["msg.downloadSucess"]="<bean:message bundle="sys-attachment" key="sysAttMain.msg.downloadSucess" />";
  	Attachment_MessageInfo["msg.noChoice"]="<bean:message bundle="sys-attachment" key="sysAttMain.msg.noChoice" />";   	
  	Attachment_MessageInfo["msg.deleteNoChoice"]="<kmss:message bundle="sys-attachment" key="sysAttMain.msg.deleteNoChoice"/>"; 
  	Attachment_MessageInfo["msg.uploading"]="<kmss:message bundle="sys-attachment" key="sysAttMain.msg.uploading"/>";
  	Attachment_MessageInfo["msg.uploadSucess"]="<kmss:message bundle="sys-attachment" key="sysAttMain.msg.uploadSucess"/>";
  	Attachment_MessageInfo["msg.uploadFail"]="<kmss:message bundle="sys-attachment" key="sysAttMain.msg.uploadFail"/>";
  	Attachment_MessageInfo["error.exceedMaxSize"]="<bean:message bundle="sys-attachment" key="sysAttMain.error.exceedMaxSize"/>"; 
  	Attachment_MessageInfo["error.exceedSingleMaxSize"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.exceedSingleMaxSize"/>";   	
  	Attachment_MessageInfo["error.enabledFileType"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.enabledFileType"/>";
	Attachment_MessageInfo["error.zeroError"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.zeroError"/>";
	Attachment_MessageInfo["error.other"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.other"/>";
	Attachment_MessageInfo["error.jgsupport"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.jgsupport"/>";
  	Attachment_MessageInfo["info.JG.lang"]="<kmss:message bundle="sys-attachment" key="JG.lang"/>";
  	Attachment_MessageInfo["start.video"]="<kmss:message bundle="sys-attachment" key="start.video"/>";
  	Attachment_MessageInfo["error.exceedImageMaxSize"]="<kmss:message bundle="sys-attachment" key="sysAttMain.error.exceedImageMaxSize"/>";
 }
 
 <%
		request.setAttribute("_loadMessageInfo","1");
	}
 %>