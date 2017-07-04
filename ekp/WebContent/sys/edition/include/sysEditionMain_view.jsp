<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEditionForm" value="${requestScope[param.formName].editionForm}" />
<%@ page import="com.landray.kmss.util.StringUtil"%>
<script language="JavaScript">
Com_IncludeFile("optbar.js|dialog.js");
function edition_SelectVersion(){
	var url = '<c:url value="/sys/edition/sys_edition_main/sysEditionMain.do?method=newVersion&mainVersion=${sysEditionForm.mainVersion}&auxiVersion=${sysEditionForm.auxiVersion}&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}" />';
	var version = Dialog_PopupWindow(url, 497, 310);
	if(version != null){
		var href = assemblyHref();
		href =  href + "&version="+version;
		window.location.href = href;
	}
}
function edition_LoadIframe(){
	Doc_LoadFrame('editionContent','<c:url value="/sys/edition/sys_edition_main/sysEditionMain_list.jsp" />?method=list&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}');
}
function assemblyHref(){
	var href = window.location.href;
	var reg = /method=\w*/;
	href = href.replace(reg,"method=newEdition");
	var reg1 = /fdId/;
	href = href.replace(reg1,"originId");
	return href;
}
</script>
<tr LKS_LabelName="<bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />" style="display:none">
	<td>
		<div id="editionBtn" style="display:none;">
			<c:set var="editionQuery"
				value="/sys/edition/sys_edition_main/sysEditionMain.do?method=newVersion&mainVersion=${sysEditionForm.mainVersion}&auxiVersion=${sysEditionForm.auxiVersion}&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}" />
			<c:if test="${sysEditionForm.enabledNewVersion=='true'}">
				<kmss:auth requestURL="${editionQuery}" requestMethod="GET">
					<input type="button" value="<bean:message key="sysEditionMain.button.newedition" bundle="sys-edition"/>" 
						onclick="edition_SelectVersion();">
				</kmss:auth>
			</c:if>
		</div>
		<script>OptBar_AddOptBar("editionBtn");</script>
		<table class="tb_normal" width="100%">
			<tr>
				<td id="editionContent" onresize="edition_LoadIframe();"> 
					<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
		</table>
	</td>
</tr>

