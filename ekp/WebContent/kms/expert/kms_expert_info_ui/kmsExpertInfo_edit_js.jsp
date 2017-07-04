<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
   Com_IncludeFile("treeview.js");
</script>
<script type="text/javascript">
	/**
	 *个人信息的异步填充
	 */
	 function getPersonInfo(rtnVal) {
		 seajs.use(['lui/jquery','lui/dialog'], function($, dialog) {
						    if(rtnVal==null)
						      return;
						    var fdPerId = rtnVal[0];
						    var flag = true ;
						    $.ajax({
								url : '<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />',
								data: {
									method : 'checkFdPerId',
									fdPerId : fdPerId
								},
								cache: false,
								async: false, 
								success: function(data){
									if(data=='true'){
										flag = false ;
										dialog.alert("${lfn:message('kms-expert:error.kmsExpertInfo.fdName.repeat')}");
										document.getElementsByName("kmsExpertInfoForm")[0].reset();
									}
									//若不存在此专家,初始化个人信息
									if(flag) {
										$.ajax({
											url : '<c:url value="/kms/expert/kms_expert_index/kmsExpertIndex.do" />',
											data: {
												method : 'getPerInfo',
												fdPerId : fdPerId
											},
											cache: false,
											async: false,
											success: function(data){
												if(data.department)
													document.getElementsByName("fdDeptName")[0].value=data.department;
												if(data.position)
													document.getElementsByName("fdPostNames")[0].value=data.position;
												if(data.mobileNo)
													document.getElementsByName("fdMobileNo")[0].value=data.mobileNo;
												if(data.workPhone)
													document.getElementsByName("fdWorkPhone")[0].value=data.workPhone;
												//document.getElementsByName("fdRtxNo")[0].value=data.RTX;
												if(data.Email)
													document.getElementsByName("fdEmail")[0].value=data.Email;
												if(data.fdSex) {
													$("input[name='fdSex'][value=" + data.fdSex + "]")
														.attr("checked", "checked");
												}									
											},
											error: function(){} 
										});

									} 
								},
								error: function(){}
						  });
					}
		);
	}



	/*
	*修改分类
	*/
	function modifyCate(canClose) {
		seajs.use(['lui/dialog','lui/jquery'], function(dialog, $) {
			dialog.simpleCategory(
					'com.landray.kmss.kms.expert.model.KmsExpertType',
					'kmsExpertTypeId',
					null,
					false,
					function(param) {
						if (param && param.id) {
							$.ajax({
								url : '<c:url value="/kms/expert/kms_expert_index/kmsExpertIndex.do" />',
								data: {
									method : 'getExpertType',
									fdCateId : param.id
								},
								cache: false,
								async: false,
								success: function(data){
									document.getElementsByName("kmsExpertTypeId")[0].value = param.id;
									document.getElementsByName("kmsExpertTypeName")[0].value = data.allTypeName;										
								},
								error: function(){} 
							});
						}
					}, null, canClose);	
		});
	}


	seajs.use(['lui/jquery'],function($) {
		$(function() {
			if($('input[name=kmsExpertTypeId]').val() == "") {
				modifyCate(false);
			}
		});

		$('#detailsBtn').click(detailsToggle);
	});
	
	function detailsToggle() {
		LUI.$('#details').toggle();
	}
</script>