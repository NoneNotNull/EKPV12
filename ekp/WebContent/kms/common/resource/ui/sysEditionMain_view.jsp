<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEditionForm" value="${requestScope[param.formName].editionForm}" />
<%@ page import="com.landray.kmss.util.StringUtil"%>
<script language="JavaScript">
Com_IncludeFile("optbar.js|dialog.js");
function edition_SelectVersion(){
	var url = "<c:url value='/kms/common/resource/ui/kmsSysEditionMain.do?method=newVersion&mainVersion=${sysEditionForm.mainVersion}&auxiVersion=${sysEditionForm.auxiVersion}&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}' />";
	var version = Dialog_PopupWindow(url, 497, 310);
	if(version != null){
		var href = assemblyHref();
		href =  href + "&version="+version;
		window.location.href = href;
	}
}
function edition_LoadIframe(){
	var iframe_0 = document.getElementById("editionContentIframe") ;
		iframe_0.src = "<c:url value='/kms/common/resource/ui/kmsSysEditionMain.do' />?method=list&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}";
}
function assemblyHref(){
	var href = window.location.href;
	var reg = /method=\w*/;
	href = href.replace(reg,"method=newEdition");
	var reg1 = /fdId/;
	href = href.replace(reg1,"originId");
	return href;
}
function setNewEditonButton(){
	 var a=document.getElementById("newEdtionButton");
	 var url = "<c:url value='/kms/common/resource/ui/kmsSysEditionMain.do?method=newVersion&mainVersion=${sysEditionForm.mainVersion}&auxiVersion=${sysEditionForm.auxiVersion}&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}' />";
     if(a!=null)
		 a.rev=url;
}
function hiddenNewEditonButton(){
	 var a=document.getElementById("newEdtionButtonDiv");
	 if(a)
	 a.style.display="none";
}
$(document).ready(function() {
	var enabledNewVersion='${sysEditionForm.enabledNewVersion}';
	 
	if(enabledNewVersion=='true'){
		setNewEditonButton();	 
	}else{
		hiddenNewEditonButton(); 
	 }
	 
});
</script>
<tr LKS_LabelName="<bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />" SHOW_NUM="false" style="display:none">
  
	<td>
		<div id="editionBtn" style="display:none;">
			<c:set var="editionQuery"
				value="/kms/common/resource/ui/kmsSysEditionMain.do?method=newVersion&mainVersion=${sysEditionForm.mainVersion}&auxiVersion=${sysEditionForm.auxiVersion}&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}" />
			<c:if test="${sysEditionForm.enabledNewVersion=='true'}">
				<kmss:auth requestURL="${editionQuery}" requestMethod="GET">
					<input type="button" value="<bean:message key="sysEditionMain.button.newedition" bundle="sys-edition"/>" 
						onclick="edition_SelectVersion();">
				</kmss:auth>
			</c:if>
		</div>
	 
		<table border="0" cellspacing="0" width="100%" cellpadding="0" >
			<tr>
				<td id="editionContent" onresize="edition_LoadIframe();"> 
				 	<iframe id="editionContentIframe" src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
		</table>
	</td>
</tr>

