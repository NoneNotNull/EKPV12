<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
	$(function(){
		//var showJson = window.dialogArguments;
		var myIframe = document.getElementById("myListControlIframe");
		//if (myIframe.src == "") {
			myIframe.src = "tibSapMappingListControlMain.do?method=include"+
				"&isMulti=${param.isMulti }&fdKey="+ encodeURIComponent("${param.fdKey }")+"&rfcName="+ encodeURIComponent("${param.rfcName }");
		//}
	});

</script>
<iframe id="myListControlIframe" width="100%" height="520" frameborder="0" scrolling="yes" 
		src="" >
</iframe>
<textarea style="display: none;" id="tempShowJson">${param.showJson }</textarea>
<%@ include file="/resource/jsp/list_down.jsp"%>