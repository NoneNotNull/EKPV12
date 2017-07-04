<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="tibSysSapRfcSettingForm" value="${requestScope[param.formName]}" />
<%@ page import="com.landray.kmss.util.StringUtil"%>
<script language="JavaScript">
Com_IncludeFile("optbar.js|dialog.js");
Com_IncludeFile("jquery.js");
function rfc_history_LoadIframe(){
	var iframe = document.getElementById("rfc_history").getElementsByTagName("IFRAME")[0];
	//if(iframe.src==""){
	//	iframe.src = "<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do" />?method=list&rfcSettingId=${tibSysSapRfcSettingForm.fdId}";
	//}

	if($(iframe).attr("src").length<1){
		 var srcValue="<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do" />?method=list&rfcSettingId=${tibSysSapRfcSettingForm.fdId}";
		$(iframe).attr("src",srcValue);
	}
};
function setWinHeight(obj){
	/*var win=obj;
	if (document.getElementById){
		if (win && !window.opera){
			if (win.contentDocument && win.contentDocument.body.offsetHeight)  
				win.height = win.contentDocument.body.offsetHeight;   
			else if(win.Document && win.Document.body.scrollHeight)
				win.height = win.Document.body.scrollHeight;
		}
	}*/

	 var bodyHeight;
	 var isChrome = navigator.userAgent.toLowerCase().match(/chrome/) != null;
   if (!!window.ActiveXObject || "ActiveXObject" in window ||isChrome) {
       bodyHeight = window.frames["_ifameName"].document.body.scrollHeight;
   } else {
       bodyHeight = thisFrame.contentWindow.document.documentElement.scrollHeight;
   }
   
   $(obj).height(bodyHeight+20);
}

</script>
<tr LKS_LabelName="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.rfcSearch.history"/>" style="display:none">
	<td>
		<table class="tb_normal" width="100%">
			<tr>
				<td id="rfc_history" onresize="rfc_history_LoadIframe();">
					<iframe src="" name="_ifameName" width=100% height=150px frameborder=0 onload="setWinHeight(this)">
					</iframe>
				</td>
			</tr>
		</table>
	</td>
</tr>

