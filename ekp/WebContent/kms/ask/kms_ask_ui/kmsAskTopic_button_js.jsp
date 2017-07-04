<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	//提问
	function addAsk() {
		seajs.use(['kms/ask/kms_ask_ui/js/create'], function(create) {
			create.addDoc('${param.categoryId}');
		});
	}
	//删除提问
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
								$.post(env.fn.formatUrl('/kms/ask/kms_ask_topic/kmsAskTopic.do?method=deleteall&categoryId=${param.categoryId}'),
										$.param({"List_Selected":values},true), function(data, textStatus,
														xhr) {
													if (data.status) {
														loading.hide();
														dialog.success("${lfn:message('kms-ask:kmsAskTopic.delete.success')}",
																'#listview');
														topic.publish('list.refresh');
													} else {
														dialog.failure("${lfn:message('kms-ask:kmsAskTopic.delete.fail')}",
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
	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
		LUI.ready(function(){
			if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(false);}
		});
		topic.subscribe('criteria.changed',function(evt){
			if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(false);}
			for(var i=0;i<evt['criterions'].length;i++){
				if(evt['criterions'][i].key=="intro"){
					if(evt['criterions'][i].value[0]=='introduce'||evt['criterions'][i].value[1]=='introduce'){
						if(LUI('cancelIntroduce')){LUI('cancelIntroduce').setVisible(true);}
					}
				}
			}
		});
	});
	//取消推荐操作
	function introduce_cancelIntroduce(){
		var values="";
		var selected;
		var select = document.getElementsByName("List_Selected");
		for(var i=0;i<select.length;i++) {
			if(select[i].checked){
				values+=select[i].value;
				values+=",";
				selected=true;
			}
		}
		if(selected) {
			values = values.substring(0,values.length-1);
			if(selected) {
				seajs.use(['lui/dialog'],function(dialog){
					dialog.confirm("${lfn:message('kms-ask:kmsAsk.cancel.confirm')}",function(val,dia){
						if(val){
							window.del_load = dialog.loading();
							var xurl = "<c:url value="/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=cancelIntro" />";
							var xdata = {};
							xdata.List_Selected = LUI.$("[name='List_Selected']").val();
							LUI.$.post(xurl,xdata,function(json){
								if(window.del_load!=null)
									window.del_load.hide();
								if(json.status){
									dialog.success("${lfn:message('return.optSuccess')}");
								}else{
									dialog.failure("${lfn:message('return.optFailure')}");									
								}
							},'json');
						}
					});
				});
				 
			}
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
					dialog.iframe("/kms/ask/kms_ask_ui/kmsAskTopic_index_setTop.jsp?templateId=${param.categoryId}&docIds="+values, 
									"${lfn:message('kms-ask:kmsAskTopic.setTop')}",
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
				dialog.alert("${lfn:message('kms-ask:kmsAskTopic.setTopReason')}");
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
                url: '<c:url value="/kms/ask/kms_ask_index/kmsAskTopicIndex.do" />?method=setTop&'+
	 						'docIds='+values+'&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
                type: 'post',
                success: function(data){
                	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 

	                	seajs.use(['lui/dialog', 'lui/topic'],function(dialog,topic){
	                		var loading = dialog.loading();
	                		_dialog.hide();
	                		loading.hide();
							dialog.success("${lfn:message('kms-ask:kmsAskTopic.executeSucc')}",
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
			dialog.alert("${lfn:message('kms-ask:kmsAskTopic.noRight')}");
		});
	}
	
</script>