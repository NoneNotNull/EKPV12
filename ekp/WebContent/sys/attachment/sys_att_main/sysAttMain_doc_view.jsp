<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<script>
//说明：docView可以用linkview取代
function Attachment_ShowList(attObj) {
	if(attObj.attType!="office") {
		document.getElementById(attObj.renderId).innerHTML = getAttHTML(attObj);
	}
}
function getAttHTML(attachmentObject){
	var attHTML = '<ul class="attUl">';
	attHTML += '<li class="attTitle">';
	attHTML += '<bean:message bundle="sys-attachment" key="table.sysAttMain" />：';
	attHTML += '</li>';
	for(var i=0;i<attachmentObject.fileList.length;i++) {
		var doc = attachmentObject.fileList[i];
		var fileExt = doc.fileName.substring(doc.fileName.lastIndexOf("."));	
		var _method = "";
		if(attachmentObject.fileList[i].fileStatus > -1) {
			attHTML += '<li>';
			attHTML += getImgHTML(doc.fileName);
			attHTML += doc.fileName;
			if(attachmentObject.canDownload){
				attHTML += '&nbsp;&nbsp;';
				attHTML += '<a href="javascript:download(\''+doc.fdId+'\');">';
				attHTML += '<bean:message bundle="sys-attachment" key="sysAttMain.button.download" />';
				attHTML += '</a>';
			}
			if(attachmentObject.canRead){
				if(File_EXT_READ.indexOf(fileExt.toLowerCase())>-1)
					_method = "view";
				else 
					_method = "readDownload";
				attHTML += "&nbsp&nbsp";
				attHTML += '<a target="_blank" href="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do" />?method='+_method+'&fdId='+doc.fdId+'&fdFileName='+doc.fileName+'&fdKey='+'${param.fdKey}'+'">';
				attHTML += '<bean:message bundle="sys-attachment" key="sysAttMain.button.open" />';
				attHTML += '</a>';
			}
			attHTML += '</li>';
		}
	}
	attHTML += '</ul>';
	return attHTML;
}
function download(id){
	Attachment_ObjectInfo['${param.fdKey}'].downDoc(id);
}
function getImgHTML(filename){
	iconName = GetIconNameByFileName(filename);
	var imgHTML = '<img src="${KMSS_Parameter_ResPath}style/common/fileIcon/'+iconName+'" height="16" width="16" border="0" align="absmiddle" style="margin-right:3px;" />';
	return imgHTML;
}
</script>
<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
	<c:param name="drawFunction" value="Attachment_ShowList" />
	<c:param name="formBeanName" value="${ param.formBeanName }" />	
	<c:param name="fdModelName" value="${ param.fdModelName }" />
	<c:param name="fdModelId" value="${ param.fdModelId }" />
	<c:param name="fdMulti" value="${ param.fdMulti }" />
	<c:param name="fdAttType" value="${ param.fdAttType }" />
	<c:param name="fdImgHtmlProperty" value="${ param.fdImgHtmlProperty }" />
	<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
	<c:param name="showDefault" value="${ param.showDefault }" />
	<c:param name="buttonDiv" value="${ param.buttonDiv }" />
	<c:param name="isTemplate" value="${ param.isTemplate }" />
	<c:param name="fdKey" value="${ param.fdKey }" />
</c:import>