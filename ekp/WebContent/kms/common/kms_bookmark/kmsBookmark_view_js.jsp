<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
function changeBM(fdModelId,fdModelName){
	//var fdDocName="${lfn:escapeJs(param.docSubject)}";
	var BMBtnParent = $("#BMBtn_"+fdModelId).parents("#bookmarkDiv");
	var fdDocName=BMBtnParent.find("input[id='mark_docSubject']").val();
	seajs.use(['lui/jquery'],function($){
		$.ajax({
			type : "get",
			url :  "${LUI_ContextPath}/kms/common/kms_bookmark/KmsBookmarkMain.do?method=buildLog",
			dataType: 'json',
			data: {fdModelId: fdModelId,
				   fdModelName: fdModelName,
				   docSubject:fdDocName},
			success: function(data, textStatus, xhr){
						var isMarked=BMBtnParent.find("input[id='isMarked']").val();
						BMBtnParent.find("span[id='bmIcon']")[0].innerHTML=" "+data.fdNum+" ";
						if(isMarked=='true'){
								BMBtnParent.find("input[id='isMarked']").val("false");
								BMBtnParent.find("span[id='starItem']").attr("class","bml0");
								$("#BMBtn_"+fdModelId).attr("title","${lfn:message('kms-common:kmsBookMarkMain.todo')}");
								//document.getElementById("bmIcon").innerHTML=" "+data.fdNum+" ";
								//document.getElementById("isMarked").value=false;
								//document.getElementById("starItem").className="bml0";
								//document.getElementById("BMBtn").title="${lfn:message('kms-common:kmsBookMarkMain.todo')}";
						}else if(isMarked=='false'){
								BMBtnParent.find("input[id='isMarked']").val("true");
								BMBtnParent.find("span[id='starItem']").attr("class","bml");
								$("#BMBtn_"+fdModelId).attr("title","${lfn:message('kms-common:kmsBookMarkMain.del')}");
								//document.getElementById("bmIcon").innerHTML=" "+data.fdNum+" ";
								//document.getElementById("isMarked").value=true; 
								//document.getElementById("starItem").className="bml";
								//document.getElementById("BMBtn").title="${lfn:message('kms-common:kmsBookMarkMain.del')}";
						}
			} ,
			error: function(xhr, textStatus, errorThrown) {
							}
				   
		});
		
		});
}

//对已收藏过的换用“已收藏”图标
function updateMarkedStatus(modelIds,fdModelName){
	var fdModelIds = modelIds.join(",");
	LUI.$.ajax({
		type : "POST",
		url :  "${LUI_ContextPath}/kms/common/kms_bookmark/KmsBookmarkMain.do?method=checkMarkedByIds",
		data: {fdModelIds: fdModelIds,
			   fdModelName: fdModelName},
		dataType : 'json',
		async: false,
		success : function(data) {
				for(var i=0;i<data["markedIds"].length;i++){
					var markedModelId = data["markedIds"][i];
					var BMBtnParent = $("#BMBtn_"+markedModelId).parents("#bookmarkDiv");
					BMBtnParent.find("input[id='isMarked']").val("true");
					BMBtnParent.find("span[id='starItem']").attr("class","bml");
					$("#BMBtn_"+markedModelId).attr("title","${lfn:message('kms-common:kmsBookMarkMain.del')}");
				}
		},
		error: function() {
			
		}	
	});
}
</script>