<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="kmCollaborateMainForm" value="${requestScope[param.formName]}" />
	<c:set var="communicateUrl"
		value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add&fdModelName=${kmCollaborateMainForm.modelClass.name}&fdModelId=${kmCollaborateMainForm.fdId}&key=${param.key}" />
	<div id="communicateBtn" style="display:none;">
		<kmss:auth requestURL="${communicateUrl}" requestMethod="GET">
			<input type="button" value="<c:if test="${empty param.commuTitle}"><bean:message key="table.kmCollaborateMainTitle" bundle="km-collaborate"/></c:if><c:if test="${not empty param.commuTitle}">${param.commuTitle}</c:if>"
				onclick="Com_OpenWindow('<c:url value="${communicateUrl}" />','_blank');">
		</kmss:auth>
	</div>
	<script language="JavaScript">
		Com_IncludeFile("optbar.js");
		OptBar_AddOptBar("communicateBtn");
		function communicate_LoadIframe(){
			Doc_LoadFrame('communicateContent','<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do"/>?method=list&forward=listInclude&fdModelId=${kmCollaborateMainForm.fdId}&fdModelName=${kmCollaborateMainForm.modelClass.name}&include=enter');
			}
	</script>

	<tr LKS_LabelName="<c:if test="${empty param.commuTitle}"><bean:message bundle="km-collaborate" key="kmCollaborateMain.tab.communicate.label" /></c:if><c:if test="${not empty param.commuTitle}">${param.commuTitle}</c:if>" style="display:none">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td id="communicateContent" onresize="communicate_LoadIframe();">
						<iframe src="" width="100%" height="auto" frameborder="0" scrolling="auto"  style="height: 40px; min-height: 100px">
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>

