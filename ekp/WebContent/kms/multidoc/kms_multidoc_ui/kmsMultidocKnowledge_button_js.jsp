<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	//新建
	function addDoc() {
		seajs.use(['kms/multidoc/kms_multidoc_ui/js/create'], function(create) { 
			create.addDoc("${param.categoryId}");
		});
	}
	//删除 参数为true则是删除草稿
	function delDoc(draft) {
		var url = '/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&categoryId=${param.categoryId}';
		if(draft === true) 
			url += "&status=10";
		kms_delDoc(url,{"successForward":"lui-source", "failureForward":"lui-failure"});
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
					dialog.iframe("/kms/multidoc/kms_multidoc_ui/kms_multidoc_index_setTop.jsp?templateId=${param.categoryId}&docIds="+values, 
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
                url: '<c:url value="/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do" />?method=setTop&'+
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


	//回收
	function recycleDoc() {
		kms_recycleDoc('/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=recycleall&categoryId=${param.categoryId}');
	}
</script>