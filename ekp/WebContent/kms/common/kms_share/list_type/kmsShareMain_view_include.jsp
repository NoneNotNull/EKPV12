<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_share/style/share_view.css" />
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
function shareAction(thisObj){
	$("body").attr("style","overFlow-y:hidden;");//父窗口禁掉滚动条
	var fdModelId = $(thisObj).attr("share-data-modelid");
	var fdModelName = $(thisObj).attr("share-data-modelname");
	seajs.use(['lui/dialog'],function(dialog){
		dialog.iframe('/kms/common/kms_share/kmsShareMain.do?method=listShareModules&'+
				'fdModelId='+fdModelId+'&fdModelName='+fdModelName, 
						"分享",
						function(){
							$("body").attr("style","overFlow-y:auto;");
						}, 
						 {	
							width:710,
							height:570
						}
		);
	});
}
</script>