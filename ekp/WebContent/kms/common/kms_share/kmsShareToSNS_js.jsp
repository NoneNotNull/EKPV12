<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">

function shareToSNS(){
	seajs.use(['lui/dialog'],
			function(dialog) {
				LUI.$.ajax({
					type : "POST",
					url :  "<c:url value='/kms/common/kms_share/kmsShareMain.do?method=shareToSNS'/>",
					data: {fdId: '${param.fdId}'}',
						fdModelName:'${param.modelName}',categoryModelName:'${param.categoryModelName}'},
					dataType : 'json',
					async: false,
					success : function(data) { 
							
						var _snsurl = data['snsUrl'] + "title=" + 
										encodeURIComponent(data['title']) + "&url=" + encodeURIComponent(data['docUrl']) +
										"&callback_url=" + encodeURIComponent(data['callBackUrl']);
						window.open(_snsurl);
						
					},
					error: function() {
						
					}		
				});
			}
	);
}
function shareToSNS2(){
	
}
</script>