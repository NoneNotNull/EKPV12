<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
	function circulationLog_LoadIframe(){
		var iframe = document.getElementById("circulationLogContent").getElementsByTagName("IFRAME")[0];
		if(iframe.getAttribute("src")=="")
			iframe.src = '<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=listCirculation&fdId=${param.fdId}';
	}
</script>
<tr LKS_LabelName="<bean:message bundle="km-smissive" key="kmSmissiveMain.label.circulation" />" style="display:none"><td>
<table class="tb_noborder" width="100%" ${param.styleValue}>
	<tr>
		<td id="circulationLogContent" onresize="circulationLog_LoadIframe();" valign="top">
			<iframe src="" width=100% height=100% frameborder=0 scrolling=no>
			</iframe>
		</td>
	</tr>
</table>
</td></tr>