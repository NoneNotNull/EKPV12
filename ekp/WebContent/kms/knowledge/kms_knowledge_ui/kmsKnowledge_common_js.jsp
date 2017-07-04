<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	/*
	 * 二级页面批量操作公用代码
	 */

	//发布状态下才有删除（回收按钮），回收按钮ID必须为recycleall,草稿状态下可以删除文档
	seajs.use(['lui/topic','lui/toolbar'], function(topic, toolbar) {
		var luiRecycle,
			 delete_btn_id = "delete_btn_draft";//在草稿状态下添加的彻底删除ID，与原有的不同
		LUI.ready(
			function(){
				if(luiRecycle = LUI('recycleall')){
					luiRecycle.setVisible(false);
				}
			}
		);
		topic.subscribe('criteria.changed',function(evt){
				if(luiRecycle) luiRecycle.setVisible(false);
				if(LUI(delete_btn_id)) LUI(delete_btn_id).setVisible(false);
				for(var i=0; i<evt['criterions'].length; i++){
					if(evt['criterions'][i].key=="docStatus" && evt['criterions'][i].value.length==1) {
						if(	evt['criterions'][i].value[0]=='30') {
							//文档状态栏只选了发布状态
							if(luiRecycle) luiRecycle.setVisible(true);
						} else if(evt['criterions'][i].value[0]=='10') {
							//草稿状态
							if(!LUI("deleteall")) {
								if(LUI(delete_btn_id)) {
									LUI(delete_btn_id).setVisible(true);
								}
								else {
									var delButton = new toolbar.Button(
											{
												 id:delete_btn_id,
												 click: "delDoc(true)",
												 text:"${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}",
												 order: 5
											 }
										 );
									delButton.startup();
									LUI("knowledge_toolbar").addButton(delButton);
								}
							}
						}
					}
				}
		});
	});

	//控制取消推荐按钮出现与否 
	seajs.use(['lui/topic'], function(topic) {
		LUI.ready(function(){
			var cancelIntro = LUI('cancelIntroduce');
			if(cancelIntro) {
				cancelIntro.setVisible(false);

				topic.subscribe('criteria.changed',function(evt){
					if(evt['criterions'].length==0){
						cancelIntro.setVisible(false);
					}
					for(var i=0;i<evt['criterions'].length;i++){
						if(evt['criterions'][i].key=="docIsIntroduced" && 
								(evt['criterions'][i].value[0]==1||evt['criterions'][i].value[1]==1)){
							cancelIntro
									.setVisible(true);
								
						}else{
							cancelIntro.setVisible(false);
						} 
					}
				});
			}
		});
		
	});

	//控制置顶按钮出现与否 
	seajs.use(['lui/topic'], function(topic) {
		LUI.ready(function(){
			var setTop = LUI('setTop');
			if(setTop) {
				setTop.setVisible(true);

				topic.subscribe('criteria.changed',function(evt){
					if(evt['criterions'].length==0){
						setTop.setVisible(true);
					}
					for(var i=0;i<evt['criterions'].length;i++){
						if(evt['criterions'][i].key=="docStatus" && 
								(evt['criterions'][i].value[0]==10||evt['criterions'][i].value[1]==10)){
							setTop
									.setVisible(false);
								
						}else{
							setTop.setVisible(true);
						} 
					}
				});
			}
		});
		
	});
		
    /*
    * 批量回收操作 参数：回收操作路径
    */
	function kms_recycleDoc(url) {
		if(!url)
			return;
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
						dialog.confirm("${lfn:message('kms-knowledge:kmsKnowledge.confirm.recycleAll')}", function(flag, d) {
							if (flag) {
								var loading = dialog.loading();
								$.ajax({
										url : env.fn.formatUrl(url),
										cache : false,
										data : $.param({"List_Selected":values},true),
										type : 'post',
										dataType :'json',
										success : function(data) {
											if (data.flag) {
												loading.hide();
												if(data.errorMessage) {//新版本锁定
													dialog.failure(
															data.errorMessage ,'#listview');
												}
												else {//删除成功
													dialog.success("${lfn:message('kms-knowledge:kmsKnowledge.delete.success')}",
															'#listview');
													topic.publish('list.refresh');
												}
											} else {
												loading.hide();	
											}
										},
										error : function(error) {//删除失败
											loading.hide();	
											dialog.failure(
													"${lfn:message('kms-knowledge:kmsKnowledge.delete.fail')}",
														'#listview');
										}
									}
								);
							}
						});
					});
		} else {
			seajs.use(['lui/dialog'], function(dialog) {
						dialog.alert("${lfn:message('page.noSelect')}");
					});
		}
	}

	/**
	* 批量彻底删除操作 参数
	*  url:操作路径 
	*  data:附加参数 对象类型
	*/
	function kms_delDoc(url , data) {
		if(!url || typeof url != "string")
			return;
		var values = [],
		     selected,
		     select = document.getElementsByName("List_Selected");
		for (var i = 0; i < select.length; i++) {
			if (select[i].checked) {
				values.push(select[i].value);
				selected = true;
			}
		}
		if (selected) {
			seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
					function(dialog, topic, $, env) {
						var dataObj = $.extend({},data,{"List_Selected":values});
						dialog.confirm("${lfn:message('kms-knowledge:kmsKnowledge.confirm.deleteall')}", function(flag, d) {
							if (flag) {
								var loading = dialog.loading();
								$.ajax({
										url : env.fn.formatUrl(url),
										cache : false,
										data : $.param(dataObj,true),
										type : 'post',
										dataType :'json',
										success : function(data) {
											if (data.flag) {
												loading.hide();
												if(data.errorMessage) {//新版本锁定
													dialog.failure(
															data.errorMessage ,'#listview');
												}
												else {//删除成功
													dialog.success("${lfn:message('kms-knowledge:kmsKnowledge.delete.success')}",
															'#listview');
													topic.publish('list.refresh');
												}
											} else {
												loading.hide();	
											}
										},
										error : function(error) {//删除失败
											loading.hide();	
											dialog.failure(
													"${lfn:message('kms-knowledge:kmsKnowledge.delete.fail')}",
														'#listview');
										}
									}
								);
							}
						});
					});
		} else {
			seajs.use(['lui/dialog'], function(dialog) {
						dialog.alert("${lfn:message('page.noSelect')}");
					});
		}
	}

	/*************批量修改属性********* 
	*/
	//属性修改
	function editProperty(){
		var docIds = findSelectId();
		if(docIds){
			seajs.use(['lui/dialog','lui/topic'],function(dialog, topic) {
				dialog.iframe("/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=editProperty&templateId=${param.categoryId}&fdId="+docIds, 
								"${lfn:message('kms-knowledge:kmsKnowledge.button.editProperty')}",
								 null, 
								 {	
									width:750,
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
												var proObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('kmsKnowledgeBaseDocForm')[0];
												var eFlag = editProSubmit(proObj,winObj);
												if(eFlag != null && eFlag=='yes'){
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-knowledge:kmsKnowledge.editPropertySuccess')}");
													topic.publish('list.refresh');											
												} else {
													_dialog.hide();
													loading.hide();
													dialog.success("${lfn:message('kms-knowledge:kmsKnowledge.editPropertyFailure')}");
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
	 function editProSubmit(_obj) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=updateProperty&templateId=${param.categoryId}',
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
						dialog.alert("${lfn:message('kms-knowledge:kmsKnowledge.chooseSameCate')}");
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
	/********调整属性结束**** */
</script>
