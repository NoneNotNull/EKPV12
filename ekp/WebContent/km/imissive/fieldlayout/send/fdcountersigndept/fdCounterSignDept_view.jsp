<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<span id="names">${kmImissiveSendMainForm.fdCounterSignDeptNames}</span>
<c:if test="${isSignEnd!=true}">
    <!-- 会签管理角色|发文的文书 -->
	<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=counterSign&fdId=${param.fdId}" requestMethod="GET">
		<input type="hidden" id="fdCounterSignDeptIds" name="fdCounterSignDeptIds" value="${kmImissiveSendMainForm.fdCounterSignDeptIds}"/>
		<input type="hidden" id="fdCounterSignDeptNames" name="fdCounterSignDeptNames" value="${kmImissiveSendMainForm.fdCounterSignDeptNames}"/>
		<input type="hidden" id="selectIds" name="selectIds" value="${kmImissiveSendMainForm.fdCounterSignDeptIds}"/>
		<input type="hidden" id="selectNames" name="selectNames" value="${kmImissiveSendMainForm.fdCounterSignDeptNames}"/>
		<ui:button text="${lfn:message('km-imissive:robot.fdCounterSign.operation')}" id="sign" onclick="Dialog_TreeList(true, 
		                            'selectIds',
		                            'selectNames', ';', 
		                            'kmImissiveUnitCategoryTreeService', 
				                    '${ lfn:message(\'km-imissive:kmImissiveSendMain.fdCounterSignDept\') }',
				                    'kmImissiveUnitListService&parentId=!{value}',updateSendMain);"></ui:button>
				                    
		<script type="text/javascript">
	seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
		//更新主文档
		window.updateSendMain = function(){
			var oldIds = $("#fdCounterSignDeptIds").val();
			var oldNames = $("#fdCounterSignDeptNames").val();
			
			var newIds = $("#selectIds").val();
			var newNames = $("#selectNames").val();
			//不能为空
			if(newIds == ""){
                dialog.alert('<bean:message bundle="km-imissive" key="robot.fdCounterSign.operation.notNull" />');
                $("#selectIds").val(oldIds);
                $("#selectNames").val(oldNames);
                return;
			}
			
			if(oldIds == newIds){
				return;
			}
			var addIds = "";
			var deleteIds = "";
			idsArr = newIds.split(";");
			//增加的ids
			for ( var i=0 ; i < idsArr.length ; i++ ) {
				if(oldIds.indexOf(idsArr[i])<0){
					addIds += ";" + idsArr[i];
				}
			};
			//减少的ids
			idsArr = oldIds.split(";");
			for ( var j=0 ; j < idsArr.length ; j++ ) {
				if(newIds.indexOf(idsArr[j])<0){
					deleteIds += ";" + idsArr[j];
				}
			};
			if(addIds.indexOf(";")==0){
				addIds = addIds.substring(1, addIds.length);
			}
			if(deleteIds.indexOf(";")==0){
				deleteIds = deleteIds.substring(1, deleteIds.length);
			}
			var fdId = "${kmImissiveSendMainForm.fdId}";
			var url = "${LUI_ContextPath}/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=updateSigner";
			var data ={fdId:fdId,addIds:addIds,deleteIds:deleteIds};
			   $.ajax({
						url :url,
						type : 'POST',
						dataType : 'json',
						data : data,
						success : function(data, textStatus, xhr) {
							if (data.result == true) {
								//更新页面
								$("#fdCounterSignDeptIds").val(newIds);
								$("#fdCounterSignDeptNames").val(newNames);
								$("#names").text(newNames);
								if(data.isSignEnd == true){
									$("#sign").hide();
							    }
								dialog.success('<bean:message key="return.optSuccess" />');
							} else {
								dialog.faiture('<bean:message key="return.optFailure" />');
							}
					}
				}); 
	    	};      
	 	 });
		</script>	
	</kmss:auth>
</c:if>	 
