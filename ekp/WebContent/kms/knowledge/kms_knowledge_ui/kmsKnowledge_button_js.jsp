<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	function addDoc() {
		seajs.use(['kms/knowledge/kms_knowledge_ui/js/create'],function(create) {
			create.addDoc('${param.categoryId}');
		});
	}
	//回收
	function recycleDoc() {
		kms_recycleDoc('/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=recycleall&categoryId=${param.categoryId}');
	}

	function delDoc(draft) {
		var url = '/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=deleteall&categoryId=${param.categoryId}';
		if(draft === true) 
			url += "&status=10";
		kms_delDoc(url,{"successForward":"lui-source", "failureForward":"lui-failure"});
	}

	//属性修改
	function editProperty(){
		var docIds = findSelectId();
		if(docIds){
			seajs.use(['lui/dialog'],function(dialog){
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
													//setTimeout(function(){window.location.reload();}, 500);												
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


	//置顶
	function setTopSelection(){
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
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe("/kms/knowledge/kms_knowledge_ui/kmsKnowledge_index_setTop.jsp?templateId=${param.categoryId}&docIds="+values, 
									"${lfn:message('kms-multidoc:kmsMultidoc.setTop')}",
									 null, 
									 {	
										width:720,
										height:370,
										buttons:[
													{
														name : "${lfn:message('button.ok')}",
														value : true,
														focus : true,
														fn : function(value,_dialog) {
															commitForm(_dialog,values);
														}
													}, {
														name : "${lfn:message('button.cancel')}",
														styleClass:"lui_toolbar_btn_gray",
														value : false,
														fn : function(value, _dialog) {
															_dialog.hide();
														}
													} 
												]
									}
					); 
				});
			} else {
				seajs.use(['lui/dialog'], function(dialog) {
							dialog.alert("${lfn:message('page.noSelect')}");
						});
			}
	} 
	
	function commitForm(_dialog,values){
		var fdSetTopReason = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopReason')[0].value;
		if (fdSetTopReason == "") {
			seajs.use(['lui/dialog'],function(dialog){
				dialog.alert("${lfn:message('kms-multidoc:kmsMultidoc.setTopReason')}");
			});
	 		return false;
	 	}
		var fdSetTopLevel = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('fdSetTopLevel');
		for(var i = 0; i < fdSetTopLevel.length; i++){
			if(fdSetTopLevel[i].checked){
				fdSetTopLevel=fdSetTopLevel[i].value;
				break;
			}
		}
	 	fdSetTopReason = encodeURIComponent(fdSetTopReason);
	 	LUI.$.ajax({
	            url: '<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do" />?method=setTop&'+
	 						'docIds='+values+'&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
	            type: 'post',
	            success: function(data){
	            	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 
	
	                	seajs.use(['lui/dialog', 'lui/topic'],function(dialog,topic){
	                		var loading = dialog.loading();
	                		_dialog.hide();
	                		loading.hide();
							dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.executeSucc')}",
									'#listview');
							topic.publish('list.refresh');
	        			});
	            		
	            	}else{
	            		setTopFail(_dialog);
	            	} 
	            }
			 }); 
	}
	
	function setTopFail(_dialog){
		_dialog.hide();
		seajs.use(['lui/dialog'],function(dialog){
			dialog.alert("${lfn:message('kms-multidoc:kmsMultidoc.noRight')}");
		});
	}
</script>