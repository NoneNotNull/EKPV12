<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">

function shareToPerson(){
	seajs.use(['lui/dialog'],function(dialog){
		dialog.iframe("/kms/common/kms_share/kmsShareMain_share_person.jsp?fdId=${param.fdId}&modelName=${param.modelName}", 
						"${lfn:message('kms-common:kmsShareMain.share')}",
						null, 
						 {	
							width:820,
							height:250
						}
		); 
	});

}
</script>