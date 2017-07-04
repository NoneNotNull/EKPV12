<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	//新建专辑
	function addTopic() {
		seajs.use(['kms/kmtopic/kms_kmtopic_main/js/create'], function(create) {
			create.addDoc('${param.categoryId}');
		});
	}

	//删除专辑
	function delDoc() {
		var values = [];
		var selected;
		var select = document.getElementsByName("List_Selected");
		for (var i = 0; i < select.length; i++) {
			if (select[i].checked) {
				values.push(select[i].value);
				selected = true;
			}
		}
		if (selected) {
			seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
					function(dialog, topic, $, env) {
						dialog.confirm("${lfn:message('page.comfirmDelete')}", function(flag, d) {
							if (flag) {
								var loading = dialog.loading();
								$.post(env.fn.formatUrl('/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=deleteall&categoryId=${param.categoryId}'),
										$.param({"List_Selected":values},true), function(data, textStatus,
														xhr) {
													if (data.status) {
														loading.hide();
														dialog.success("${lfn:message('kms-kmtopic:kmsKmtopicMain.delete.success')}",
																'#listview');
														topic.publish('list.refresh');
													} else {
														dialog.failure("${lfn:message('kms-kmtopic:kmsKmtopicMain.delete.fail')}",
																'#listview');
													}
												}, 'json');
							}
						});
					});
		} else {
			seajs.use(['lui/dialog'], function(dialog) {
						dialog.alert("${lfn:message('page.noSelect')}");
					});
		}
	}

	//控制取消推荐按钮出现与否 
	seajs.use(['lui/topic'], function(topic) {
		LUI.ready(function(){
			if(LUI('cancelIntroduce')) {
				LUI('cancelIntroduce').setVisible(false);
			}
		});
		topic.subscribe('criteria.changed',function(evt){
			if(evt['criterions'].length==0 && LUI('cancelIntroduce')){
				LUI('cancelIntroduce').setVisible(false);
			}
			for(var i=0;i<evt['criterions'].length;i++){
				if(evt['criterions'][i].key=="docIsIntroduced" && 
						(evt['criterions'][i].value[0]==1||evt['criterions'][i].value[1]==1)){
						if(LUI('cancelIntroduce')) {
							LUI('cancelIntroduce').setVisible(true);
						}
				}else{
					if(LUI('cancelIntroduce')){
						LUI('cancelIntroduce').setVisible(false);
					}
				} 
			}
		});
	});

	//属性修改
	function editProperty(){
		var docIds = findSelectId();
		if(docIds){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.iframe("/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=editProperty&fdId="+docIds, 
								"${lfn:message('kms-kmtopic:kmsKmtopicMain.button.editProperty')}",
								 null, 
								 {	
									width:720,
									height:230,
									buttons:[
										{
											name : "${lfn:message('button.ok')}",
											value : true,
											focus : true,
											fn : function(value,_dialog) {
												//获取弹出窗口的window对象
												var winObj = LUI.$('#dialog_iframe').find('iframe')[0].contentWindow; 
												//验证
												if(!editProValidate(winObj)) {
													return;
												}
												var loading = dialog.loading();
												//获取弹出窗口的document对象里面的form
												var proObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('kmsKmtopicMainForm')[0];
												var eFlag = editProSubmit(proObj,docIds,winObj);
												if(eFlag != null && eFlag=='yes'){
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-kmtopic:kmsKmtopicMain.editPropertySuccess')}");
													setTimeout(function(){window.location.reload();}, 500);												
												} else {
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-kmtopic:kmsKmtopicMain.editPropertyFailure')}");
												}
											}
										}, {
											name : "${lfn:message('button.cancel')}",
											value : false,
											fn : function(value, _dialog) {
												_dialog.hide();
											}
										} 
									]
								}
				);
			});
		}
	}

	//调整属性验证
	function editProValidate(_winObj) {
		//验证必填项
	 	if(_winObj != null  && !_winObj.Com_Parameter.event["submit"][0]()) {
	 		return false;
	 	}
	 	else return true;
	}

	//调整属性异步处理
	 function editProSubmit(_obj,docIds) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=updateProperty&fdId='+docIds,
				type: 'POST',
				dataType: 'json',
				async: false,
				data: LUI.$(_obj).serialize(),
				success: function(data, textStatus, xhr) {
					if (data && data['flag'] === true) {
						//调整成功
						editFlag = 'yes';
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					//调整失败
					editFlag = 'no';
				}
			});
			if(editFlag != null) 
				return editFlag;
	}

	 function findSelectId(){
			var values = [];
			var selected,template;
			var select = document.getElementsByName("List_Selected");
			for (var i = 0; i < select.length; i++) {
				if (select[i].checked) {
					values.push(select[i].value);
					selected = true;
					if(template && template!=LUI('listview').table.kvData[i].docCategoryId){
						seajs.use(['lui/dialog'],function(dialog){
							dialog.alert("${lfn:message('kms-kmtopic:kmsKmtopicMain.chooseSameCate')}");
						});
						return null;
					}
					if(!template){
						template = LUI('listview').table.kvData[i].docCategoryId
					}
				}
			}
			if(selected){
				return values;
			}else{
				seajs.use(['lui/dialog'],function(dialog){
					dialog.alert("${lfn:message('page.noSelect')}");
				});
			}
			
		}
</script>