<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">

function shareToFriend(){
	seajs.use(['lui/dialog', 'lui/jquery'],function(dialog, $){
		$.ajax({
			url: "<c:url value='/kms/common/kms_share/kmsShareMain.do?method=shareToFriend'/>",
			async: false,
			data: {fdId:"${param.fdModelId}", fdModelName: "${param.modelName}", fdUrl: window.location.href},
			dataType: 'json',
			success: function(data){
				var attId = "";
				if(data && data.attId){
					attId = data.attId;
				}
				dialog.iframe("/kms/common/kms_share/kmsShareMain_share_friends.jsp?fdId=${param.fdModelId}&modelName=${param.modelName}&attId=" + attId, 
						"${lfn:message('kms-common:kmsShareMain.friend')}",
						null,  {width:420,height:265}
				); 
			}
		});
	});
}
</script>