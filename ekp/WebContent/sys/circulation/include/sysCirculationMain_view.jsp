<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysCirculationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysCirculationForm.circulationForm.fdIsShow=='true'}">
	<c:set var="circulationUrl"
		value="/sys/circulation/sys_circulation_main/sysCirculationMain.do?method=add&fdModelName=${sysCirculationForm.circulationForm.fdModelName}&fdModelId=${sysCirculationForm.circulationForm.fdModelId}&fdIsNewVersion=${sysCirculationForm.circulationForm.fdIsNewVersion}" />
	<div id="circulationBtn" style="display:none;">
		<kmss:auth requestURL="${circulationUrl}" requestMethod="GET">
			<input type="button" value="<bean:message key="sysCirculationMain.button.circulation" bundle="sys-circulation"/>"
				onclick="Com_OpenWindow('<c:url value="${circulationUrl}" />','_blank');">
		</kmss:auth>
	</div>
	<script language="JavaScript">
		Com_IncludeFile("optbar.js");
		OptBar_AddOptBar("circulationBtn");
		function circulation_LoadIframe(){
			Doc_LoadFrame("circulationContent", '<c:url value="/sys/circulation/sys_circulation_main/sysCirculationMain.do" />?method=list&fdModelId=${sysCirculationForm.circulationForm.fdModelId}&fdModelName=${sysCirculationForm.circulationForm.fdModelName}');
		}
	</script>
	<tr LKS_LabelName="<bean:message bundle="sys-circulation" key="sysCirculationMain.tab.circulation.label" />${sysCirculationForm.circulationForm.fdCirculationCount}" style="display:none">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td id="circulationContent" onresize="circulation_LoadIframe();">
						<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</c:if>
