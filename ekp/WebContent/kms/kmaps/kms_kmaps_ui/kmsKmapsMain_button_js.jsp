<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	//新建地图
	function addMaps() {
		seajs.use(['kms/kmaps/kms_kmaps_ui/js/create'], function(create) {
			create.addDoc('${param.categoryId}');
		});
	}


	//删除地图
	function delDoc(draft) {
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
								$.post(env.fn.formatUrl('/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall&categoryId=${param.categoryId}' 
											+ (true === draft ? "&status=10" : "")),
										$.param({"List_Selected":values},true), function(data, textStatus,
														xhr) {
													if (data.status) {
														loading.hide();
														dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.delete.success')}",
																'#listview');
														topic.publish('list.refresh');
													} else {
														dialog.failure("${lfn:message('kms-kmaps:kmsKmapsMain.delete.fail')}",
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

	seajs.use(['lui/jquery', 'lui/topic','lui/toolbar' ], function($, topic, toolbar) {
		LUI.ready(function(){
					var delete_btn_id = "delete_btn_draft";
					if(!LUI("deleteall")) {
						topic.subscribe('criteria.changed',function(evt) {
							function isCDraft () {
								for(var i = 0; i < evt['criterions'].length; i ++){
									if(evt['criterions'][i].key=="docStatus" 
										&& evt['criterions'][i].value.length==1 
											&& evt['criterions'][i].value[0]=='10') { 
										return true;
									}
								}
							 	return false;
							}
							
							var delBtn = LUI(delete_btn_id);
							if(delBtn) delBtn.setVisible(false);
							if (isCDraft() == true) {
								if(delBtn) delBtn.setVisible(true);
								else {
									var delButton = new toolbar.Button({
															 id:delete_btn_id,
															 click: "delDoc(true)",
															 text:"${lfn:message('button.delete')}",
															 order: 5
												 	});
									delButton.startup();
									LUI("kmaps_toolbar").addButton(delButton);
								}
							}
						});
					}
				});
	});
	
	//控制取消推荐按钮出现与否 
	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
		LUI.ready(function(){
			if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(false);}
		});
		topic.subscribe('criteria.changed',function(evt){
			if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(false);}
			for(var i=0;i<evt['criterions'].length;i++){
				if(evt['criterions'][i].key=="introduce"){
					if(evt['criterions'][i].value[0]=='intro'||evt['criterions'][i].value[1]=='intro'){
						if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(true);}
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
				dialog.iframe("/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=editProperty&fdId="+docIds, 
								"${lfn:message('kms-kmaps:kmsKmapsMain.button.editProperty')}",
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
												var proObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('kmsKmapsMainForm')[0];
												var eFlag = editProSubmit(proObj,docIds,winObj);
												if(eFlag != null && eFlag=='yes'){
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.editPropertySuccess')}");
													setTimeout(function(){window.location.reload();}, 500);												
												} else {
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.editPropertyFailure')}");
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
						dialog.alert("${lfn:message('kms-kmaps:kmsKmapsMain.chooseSameCate')}");
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

	//调整属性异步处理
	 function editProSubmit(_obj,docIds) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=updateProperty&fdId='+docIds,
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
	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.kmaps.model.KmsKmapsMain";
</script>
