<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysIntroduceForm" value="${requestScope[param.formName]}"/>
<c:if test="${sysIntroduceForm.introduceForm.fdIsShow=='true'}">
	<tr LKS_LabelName="<bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" />${sysIntroduceForm.introduceForm.fdIntroduceCount}" 
		style="display:none" >
		<td>
			<div id="introduceBtn" sytle="display:none;">
				<kmss:auth requestURL="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}" requestMethod="GET">
					<input type="button" value="<bean:message key="sysIntroduceMain.button.introduce" bundle="sys-introduce"/>"
						onclick="openIntroduceWindows();">
				</kmss:auth>
			</div>
			<script language="JavaScript">
				Com_IncludeFile("optbar.js");
			</script>
			<script>
				OptBar_AddOptBar("introduceBtn");
				function openIntroduceWindows(){
					var url = encodeURIComponent('<c:url value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add" />&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdIsNewVersion=${sysIntroduceForm.introduceForm.fdIsNewVersion}&toEssence=${param.toEssence}&toNews=${param.toNews}&docSubject=${param.docSubject}&docCreatorName=${param.docCreatorName}');
					var width = 640;
					var height = 500;
					var winStyle = "resizable:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;";
					url = '<c:url value="/resource/jsp/frame.jsp?url=" />' + url;
					return showModalDialog(url, null, winStyle);
				}
				function introduce_LoadIframe(){
					Doc_LoadFrame("introduceContent",'<c:url value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do" />?method=viewAll&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}');
				}
			</script>
			<table class="tb_normal" width="100%">
				<tr>
					<td id="introduceContent" onresize="introduce_LoadIframe()">
						<iframe src="" width=100% height=100% frameborder=0 scrolling=no style="min-height: 100px;">
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</c:if>

