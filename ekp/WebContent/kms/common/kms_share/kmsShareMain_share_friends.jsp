<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript" src="${ LUI_ContextPath}/kms/common/resource/js/lib/jquery.qrcode.min.js"></script>


<script type="text/javascript">
	var stopIntervalNum = null;
	LUI.ready(function(){
		stopIntervalNum = setInterval("showQRCode()",100);
	});

	function showQRCode(){
		var isHidden = $("#shareModule1").is(":hidden");
		var _QRCode = $("#share_friends_QRCode")[0].innerHTML;
		if(!isHidden && $.trim(_QRCode) == ""){
			var mode = !!document.createElement('canvas').getContext ? 'canvas' : 'table';
			jQuery('#share_friends_QRCode').qrcode({render:mode,text:parent.window.location.href,width:150,height:150});
			
			if(stopIntervalNum != null){
				clearInterval(stopIntervalNum);
			}
		}
	}
</script>
	
<div style="padding:20px 25px 0px;">
	<table class="share_friends_tbl">
		<tr>
			<!-- 二维码 -->
			<td  class="share_friends_QRCode">
				<div id="share_friends_QRCode"></div>
			</td>
			<td class="share_friends_tip">
				<div>${lfn:message('kms-common:kmsShareMain.shareTo.friends.scan') } </div>
				<div>${lfn:message('kms-common:kmsShareMain.shareTo.friends.scan2') }</div>
			</td>
		</tr>
	</table>
</div>
