<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	// flash滚轮事件
	function mouseWheel(evt) {
		evt = window.event || evt;
		try {
			document.getElementById("att_swf_viewer").mouseWheelScroll(
					evt.wheelDelta);
		} catch (e) {
		}
		if (evt.preventDefault) {
			evt.preventDefault();
		} else {
			evt.returnValue = false;
		}
	}

	LUI.ready( function() {

		function slide(evt) {
			var $parent = LUI.$(evt.target);
			while ($parent.length > 0) {
				if ($parent.attr('data-emit')) {
					var emit = $parent.attr('data-emit');
					if ($parent.hasClass('lui_multidoc_slideDown')) {
						$parent.removeClass('lui_multidoc_slideDown');
						$parent.addClass('lui_multidoc_slideUp');
						$parent.parent().next('[data-on=' + emit + ']').each(
								function() {
									LUI.$(this).slideDown('slow');
								});
						$('#detail_span').html('${lfn:message('kms-multidoc:kmsMultidoc.slideUp')}');
						break;
					}
					if ($parent.hasClass('lui_multidoc_slideUp')) {
						$parent.removeClass('lui_multidoc_slideUp');
						$parent.addClass('lui_multidoc_slideDown');
						$parent.parent().next('[data-on=' + emit + ']').each(
								function() {
									LUI.$(this).slideUp('slow');
								});
						$('#detail_span').html('${lfn:message('kms-multidoc:kmsMultidoc.slideDown')}');
						break;
					}
				}
				$parent = $parent.parent();
			}
		}
		LUI.$(window).click( function(evt) {
			slide(evt);
		});
		
	
		
	});
	//恢复
	function confirmRecover() {
		var html =['<div class="lui_knowledge_reason_box">',
						'<div class="lui_knowledge_recover_title">${lfn:message("kms-knowledge:kmsKnowledge.reason.fill")}</div>',
						'<table class="lui_reason_text"><tr><td>',
							'<textarea rows cols="92" style="height:150px" validate="required maxLength(800)"></textarea>',
						'</td></tr></table>',
					'</div>'].join(" ");
		seajs.use(['lui/dialog','lui/jquery'],function(dialog, $) {
			dialog.build(
				{
					id:'recoverDialog',
					config: {
						height: 300,
						width: 600,
						lock: true,
						title: "${lfn:message('kms-knowledge:kmsKnowledge.dialog.recover')}",
						content: {
							type: "html",
							html: html,
							buttons :  [{
								name : "${lfn:message('sys-ui:ui.dialog.button.ok')}",
								value : true,
								focus : true,
								fn : function(value, _dialog) {
									var validator = $KMSSValidation($('.lui_reason_text')[0]);
									if(!validator.validate())
										return;
									var reason = $('.lui_reason_text textarea').val(),
										loading = dialog.loading();
									_dialog.hide(value);
									$.ajax(
										{
										    type: 'post',
											url: "${ LUI_ContextPath}/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=recover&fdId=${param.fdId}",
											data: {description: reason} ,
											async : false,
											success: function(data) {
												loading.hide();
												if(data.flag) {
													dialog.success("${lfn:message('return.optSuccess')}");
													setTimeout(function(){window.location.reload();}, 500);
												}
												else 	dialog.failure("${lfn:message('return.optFailure')}");
											}
										}
									);
								}
							}, {
								name : "${lfn:message('sys-ui:ui.dialog.button.cancel')}",
								value : false,
								styleClass : 'lui_toolbar_btn_gray',
								fn : function(value, dialog) {
									dialog.hide(value);
								}
							}]
						}
					},
					callback:function() {
						
					}
				}
			).show();
		});
	} 
	//回收
	function confirmRecycle(msg, url, target) {
		seajs.use(['lui/dialog'],function(dialog) {
			dialog.confirm("${lfn:message('kms-knowledge:kmsKnowledge.confirm.recycle')}", function(flag){
				if(flag) {
					Com_OpenWindow(
							'kmsMultidocKnowledge.do?method=recycle&fdId=${param.fdId}','_self');
				}
			} );
		});
	}
	
	//删除
	function confirmDelete() {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-multidoc:kmsMultidoc.datagrid.deleteMsg')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsMultidocKnowledge.do?method=delete&fdId=${param.fdId}','_self');
				}}
			);
	 	});
	}
	//调整属性
	 function editProperty() {
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('kmsMultidocKnowledge.do?method=editProperty&type=property&fdId=${param.fdId}', 
							"${lfn:message('kms-multidoc:kmsMultidoc.button.editProperty')}",
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
											var proObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('kmsMultidocKnowledgeForm')[0];
											var eFlag = editProSubmit(proObj,winObj);
											if(eFlag != null && eFlag=='yes'){
												_dialog.hide();
												loading.hide();
												dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.editPropertySuccess')}");
												setTimeout(function(){window.location.reload();}, 500);												
											} else {
												_dialog.hide();
												loading.hide();
												dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.editPropertyFailure')}");
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
	//调整属性异步处理
	 function editProSubmit(_obj) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=updateProperty&fdId=${param.fdId}',
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
	//调整属性验证
	function editProValidate(_winObj) {
		//验证必填项
	 	if(_winObj != null  && !_winObj.Com_Parameter.event["submit"][0]()) {
	 		return false;
	 	}
	 	else return true;
	}

	//显示标签
	var currentTags="${kmsMultidocKnowledgeForm.sysTagMainForm.fdTagNames}";
	//添加标签
	function addTags(TagsType) {
		var title;
		var contentTitle;
		var value;
		if (TagsType == '2') { // 编辑
			title = "${lfn:message('kms-multidoc:kmsMultidoc.button.editTag')}";
			contentTitle = "${lfn:message('kms-multidoc:kmsMultidoc.editTagsTips')}";
			value = currentTags;
		} else if (TagsType == '3') { //添加
			title = "${lfn:message('kms-multidoc:kmsMultidoc.button.addTag')}";
			contentTitle = "${lfn:message('kms-multidoc:kmsMultidoc.addTagsTips')}";
			value = "";
		}
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			dialog.build( {
				id : 'addTags',
				config : {
					height: 50,
					width:  420,
					lock : true,
					cache : false,
					title : title,
					content : {
						type : "html",
						html : [
								'<div id="tagEdit" class="lui_multidoc_tagEdit">',
								'<span id="tagTips">',contentTitle,'</span>',
								'<input type="text" id="multidoc_tagInput" value="',value,'" style="width:90%"></input>',
								'<a href="#" onclick="Dialog_TreeList(true,null,null,\' \',\'sysTagCategorTreeService&type=1&fdCategoryId=!{value}\', \'<bean:message key="sysTagTag.tree" bundle="sys-tag"/>\',\'sysTagByCategoryDatabean&type=getTag&fdCategoryId=!{value}\',afterSelectValue, \'sysTagByCategoryDatabean&key=!{keyword}&type=search\')">',
								 '<span><bean:message key="dialog.selectOther"/>',
						 		  '</span></a>',
								'</div>'
							   ].join(" "),
					    iconType : "",
						buttons : [ {
							name : "${lfn:message('button.ok')}",
							value : true,
							focus : true,
							fn : function(value,_dialog) {
								var input =  LUI.$('#multidoc_tagInput').val();
								_dialog.hide();
								var loading = dialog.loading();
								var updateTagsFlag = updateTags(input, TagsType);
								if( updateTagsFlag != null && updateTagsFlag=='1') {									
									loading.hide();
									if(TagsType == '3')
										dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.addTagsTipsSucccess')}");
									else if(TagsType == '2')
										dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.editTagsTipsSucccess')}");
									setTimeout(function(){
										Com_OpenWindow('kmsMultidocKnowledge.do?method=view&fdId=${param.fdId}','_self');
										}, 1000);
								}
								
							}
						}, {
							name : "${lfn:message('button.cancel')}",
							styleClass:"lui_toolbar_btn_gray",
							value : false,
							fn : function(value, dialog) {
								dialog.hide();
							}
						} ]
					}
				},

				callback : function(value, dialog) {

				},
				actor : {
					type : "default"
				},
				trigger : {
					type : "default"
				}

			}).show(); 
		});
	}
	 //更新标签
	function updateTags(tags,type){
		 //ajax 
		var url="kmsMultidocKnowledgeXMLService&fdId=${kmsMultidocKnowledgeForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			
		});	
		return 1;    
	 }

	function afterSelectValue(rtnVal){
		if(rtnVal==null)
			return;
		var input =  LUI.$('#multidoc_tagInput').val().trim();
		var nameStr=input.split(" ");
		var name='';
		for(var i=0;i<rtnVal.GetHashMapArray().length;i++){
			var newName=rtnVal.GetHashMapArray()[i]['name'];
					var isExist=1;
					for(var j=0;j<nameStr.length;j++){
						var oldName=nameStr[j];
						if(newName==oldName){
							isExist=0;
						}
					}
					if(isExist==1){
						input = input+" "+ newName;
					}
		}
		LUI.$('#multidoc_tagInput').val( input.trim()) ;
	}


	//置顶
	function setTop(){
		seajs.use(['lui/dialog'],function(dialog){
						dialog.iframe("/kms/multidoc/kms_multidoc_ui/kms_multidoc_index_setTop.jsp?docIds=${param.fdId}", 
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
																commitForm(_dialog);
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
	}

	function commitForm(_dialog){
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
	 						'docIds=${param.fdId}&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
                type: 'post',
                success: function(data){
                	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 
	                	if(topWinHref.indexOf("method=view") < 0){
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	            				dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.executeSucc')}",
											'#listview');
	            			});
	                		setTimeout(function(){window.location.reload();}, 500);	
	                	}else{
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	                			dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.executeSucc')}",
											'#listview');
	            			});
	                		setTimeout(function(){window.location.reload();}, 500);	
	                	}
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
	
	//取消置顶
	function cancelTop(){
		seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
				function(dialog, topic, $, env) {
					dialog.confirm("${lfn:message('kms-multidoc:kmsMultidoc.cancelTop')}", function(flag, d) {
						if (flag) {
							var loading = dialog.loading();
							$.post(env.fn.formatUrl('/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=cancelTop&templateId=${param.categoryId}&docIds=${param.fdId}'),
									null, function(data, textStatus,
													xhr) {
												if (data["hasRight"]== true) {
													loading.hide();
													dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.executeSucc')}",
															'#listview');
													setTimeout(function(){window.location.reload();}, 500);	
												} else {
													loading.hide();
							                		dialog.alert("${lfn:message('kms-multidoc:kmsMultidoc.noRight')}");
												}
											}, 'json');
						}
					});
				}
		);
	}
	
</script>
