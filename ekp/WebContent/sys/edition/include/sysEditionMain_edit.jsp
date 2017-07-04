<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEditionForm" value="${requestScope[param.formName].editionForm}" />
<tr LKS_LabelName="<bean:message bundle="sys-edition" key="sysEditionMain.tab.label" />" style="display:none">
	<td>
		<html:hidden property="editionForm.fdModelId" />
		<html:hidden property="editionForm.fdModelName" />
		<html:hidden property="editionForm.mainVersion" />
		<html:hidden property="editionForm.auxiVersion" />
		<html:hidden property="editionForm.isNewVersion" />
		<script>
			function edition_LoadIframe(){
				Doc_LoadFrame('editionContent','<c:url value="/sys/edition/sys_edition_main/sysEditionMain.do"/>?method=list&fdModelName=${sysEditionForm.fdModelName}&fdModelId=${sysEditionForm.fdModelId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}');
			}
		</script>
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

