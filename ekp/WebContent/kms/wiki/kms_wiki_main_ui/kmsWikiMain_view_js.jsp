<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_view_catalog_js.jsp"%>
<script type="text/javascript">	
	seajs.use(['lui/jquery'],function($) {
		$( function() {		
				if('${hasPic}'!='true'){
					CKResize.____ckresize____(true);
				}else{
					var att = attachmentObject_spic_${param.fdId };
					att.on('imgLoaded',function(evt){
						if(evt && evt.target)
							CKResize.extendImage = evt.target;
						CKResize.____ckresize____(true);
					});
				}
			}
		);
	});
	
	
	//打开某个分类的一级页面
	function openCategoryIndex(fdCategoryId){
		if(fdCategoryId) {
			window.open(
					'${LUI_ContextPath}/kms/wiki/?categoryId=' + fdCategoryId,'_blank');
		}
	}
	//恢复
	function confirmRecover() {
		var html =['<div class="lui_knowledge_reason_box">',
						'<div class="lui_knowledge_recover_title">${lfn:message("kms-knowledge:kmsKnowledge.reason.fill")}','</div>',
						'<table class="lui_reason_text"><tr><td>',
							'<textarea rows cols="92" style="height:150px" validate="required maxLength(800)"></textarea>',
						'</tr></td></table>',
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
											url: "${ LUI_ContextPath}/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=recover&fdId=${param.fdId}",
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
							'kmsWikiMain.do?method=recycle&fdId=${param.fdId}','_self');
				}
			} );
		});
	}
 	//删除词条
 	function checkDelete() {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-wiki:kmsWiki.confirmDeleteView')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsWikiMain.do?method=delete&fdId=${kmsWikiMainForm.fdId}','_self');
				}}
			);
	 	});
	}

	//当前标签
	var currentTags="${kmsWikiMainForm.sysTagMainForm.fdTagNames}";

	function reverseTagStr(str) {
		 if(str!=''){
			var arrayStr= str.split(" ") ;
			var returnStr='';
		    for(i=arrayStr.length-1;i>=0;i--){
		    	returnStr=returnStr+arrayStr[i]+" ";
		        }
		  }
		 return returnStr ;
	}
	function addTags(TagsType) {
		var title;
		var contentTitle;
		var value;
		if (TagsType == '2') { // 编辑
			title = "${lfn:message('kms-wiki:kmsWiki.editTag')}";
			contentTitle = "${lfn:message('kms-wiki:kmsWiki.editTagsTips')}";
			value = currentTags;
		} else if (TagsType == '3') { //添加
			title = "${lfn:message('kms-wiki:kmsWiki.addTag')}";
			contentTitle = "${lfn:message('kms-wiki:kmsWiki.addTagsTips')}";
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
								'<div id="tagEdit" class="lui_wiki_tagEdit">',
								'<span id="tagTips">',contentTitle,'</span><br/>',
								'<input type="text" id="wiki_tagInput" style="width:90%" value="',value,'"></input>',
								'<a href="#" onclick="Dialog_TreeList(true,null,null,\' \',\'sysTagCategorTreeService&type=1&fdCategoryId=!{value}\', \'<bean:message key="sysTagTag.tree" bundle="sys-tag"/>\',\'sysTagByCategoryDatabean&type=getTag&fdCategoryId=!{value}\',afterSelectValue, \'sysTagByCategoryDatabean&key=!{keyword}&type=search\')">',
								'<span><bean:message key="dialog.selectOther"/>',
						 		'  </span></a>',
								'</div>'
							   ].join(" "),
					    iconType : "",
						buttons : [ {
							name : "${lfn:message('button.ok')}",
							value : true,
							focus : true,
							fn : function(value,_dialog) {
								var input =  LUI.$('#wiki_tagInput').val();
								_dialog.hide();
								var loading = dialog.loading();
								var updateTagsFlag = updateTags(input, TagsType);
								if( updateTagsFlag != null && updateTagsFlag=='1') {									
									loading.hide();
									if(TagsType == '3')
										dialog.success("${lfn:message('kms-wiki:kmsWiki.addTagsTipsSucccess')}");
									else if(TagsType == '2')
										dialog.success("${lfn:message('kms-wiki:kmsWiki.editTagsTipsSucccess')}");
									setTimeout(function(){
										Com_OpenWindow('kmsWikiMain.do?method=view&fdId=${kmsWikiMainForm.fdId}&id=${kmsWikiMainForm.fdFirstId}','_self');
										}, 1000);
								}
								
							}
						}, {
							name : "${lfn:message('button.cancel')}",
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
	function afterSelectValue(rtnVal){
		if(rtnVal==null)
			return;
		var input =  LUI.$('#wiki_tagInput').val().trim();
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
		LUI.$('#wiki_tagInput').val( input.trim()) ;
	}

	 //更新标签
	function updateTags(tags,type){
		 //ajax 
		var url="kmsWikiMainXMLService&fdId=${kmsWikiMainForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			
		});	  
		return 1; 
	 }

	 //调整属性
	 function editProperty() {
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=editProperty&type=property&fdId=${param.fdId}', 
							"${lfn:message('kms-wiki:kmsWiki.editProperty')}",
							 null, 
							 {	
								width:720,
								height:250,
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
											var proObj = LUI.$('#dialog_iframe').find('iframe')[0].contentDocument.getElementsByName('kmsWikiMainForm')[0];
											var eFlag = editProSubmit(proObj,winObj);
											if(eFlag != null && eFlag=='yes'){
												_dialog.hide();
												loading.hide();
												dialog.success("${lfn:message('kms-wiki:kmsWiki.editPropertySuccess')}");
												setTimeout(function(){window.location.reload();}, 500);												
											} else {
												_dialog.hide();
												loading.hide();
												dialog.success("${lfn:message('kms-wiki:kmsWiki.editPropertyFailure')}");
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
				url: '${ LUI_ContextPath}/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=updateProperty&fdId=${param.fdId}',
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
	//查看历史版本
	function viewAllVersion() {
		var subject = '${kmsWikiMainForm.docSubject}';
		Com_OpenWindow(
				'kmsWikiMain.do?method=listAllVersion&fdId=${param.fdId}&fdFirstId=${kmsWikiMainForm.fdFirstId}&docSubject=' + encodeURIComponent(subject),
				'_blank');
	}

	// 跟上一版本快捷比较
	function compareLastVersion(fdLastId) {
		if (fdLastId) {
			var url = "kmsWikiMain.do?method=compareVersion&secondId=${param.fdId}&firstId="
					+ fdLastId;
			window.open(url, "_blank");
		}
	}

	
	seajs.use(['lui/topic', 'lui/jquery'], function(topic, $){
		topic.channel("new_edi").subscribe("list.loaded",function() {
			window.wikiVersionCheck = [];
			$("#listview_version")
				.find('input[name="List_Selected"]')
					.on("click",function(e){
						var arr = window.wikiVersionCheck,
							obj = {
									target : e.target,
									id : e.target.value
								  };
						if(e.target.checked == false) {
							for(var i = 0; i < arr.length; i++) {
								if(arr[i].id == e.target.value)
									arr.splice(i, 1);
							}
						} 
					    if(e.target.checked == true && arr.unshift(obj) >= 3) {
							arr[arr.length - 1].target.checked = false;
							arr.pop();
						}
						
					});
		});
	});
	
	//版本对比
	function compareVersion() {
		seajs.use(['lui/dialog','lui/jquery'], function(dialog, $) {
			var checkedList = LUI.$("#listview_version").find('input[name="List_Selected"]:checked');
			var rowsize = checkedList.length;
			if (!rowsize) {
				dialog.alert('${lfn:message("kms-wiki:kmsWiki.SelectVer")}');
				return;
			}else if(rowsize != 2){
				dialog.alert('${lfn:message("kms-wiki:kmsWiki.OnlyTwo")}');
				return;
			}
			var firstId = checkedList[1].value;
			var secondId = checkedList[0].value;
			var url="kmsWikiMain.do?method=compareVersion&firstId="+firstId+"&secondId="+secondId;
			Com_OpenWindow(url,"_blank");
			checkList = [];
		});
	}


	//段落点评滑动到段落出
	function evaScroll(_id) {
		var _top;
		if( LUI.$("img[e_id='"+ _id +"']")[0] != null) {
			_top = LUI.$("img[e_id='"+ _id +"']").offset().top;
			LUI.$('html,body').animate({
				scrollTop:_top - 45
			}, 500);
		}
	}

	//词条解锁
	function unlockWiki(){
		seajs.use(['lui/dialog'], function(dialog) {
			dialog.confirm ("${lfn:message('kms-wiki:kmsWiki.UnLockConfirm')}", unlock);
		});
	}
	function unlock (value) {
		if (!value) return;
		seajs.use(['lui/jquery','lui/dialog'], function($, dialog) {
			$.ajax({
				url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=updateUnlock&List_Selected=${kmsWikiMainForm.fdId}',
				cache : false,
				type : 'post',
				success : function(data) {
					if (data && data['flag']) {
						dialog.success("${lfn:message('return.optSuccess')}");
						window.location.reload();
					} else {
						dialog.failure("${lfn:message('return.optFailure')}");
					}
				},
				error : function(error) {
					dialog.failure("${lfn:message('return.optFailure')}");
				}
			});
		});
	}
	
	//置顶
	function setTop(){
		seajs.use(['lui/dialog'],function(dialog){
						dialog.iframe("/kms/wiki/kms_wiki_main_ui/kmsWikiMain_index_setTop.jsp?docIds=${param.fdId}", 
										"${lfn:message('kms-wiki:kmsWiki.setTop')}",
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
				dialog.alert("${lfn:message('kms-wiki:kmsWiki.setTopReason')}");
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
                url: '<c:url value="/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do" />?method=setTop&templateId=${param.templateId}&'+
	 						'docIds=${param.fdId}&fdSetTopLevel='+fdSetTopLevel+'&fdSetTopReason='+fdSetTopReason,
                type: 'post',
                success: function(data){
                	if(data["hasRight"]== true){
	                	var topWinHref =  top.location.href; 
	                	if(topWinHref.indexOf("method=view") < 0){
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	            				dialog.success("${lfn:message('kms-wiki:kmsWiki.executeSucc')}",
											'#listview');
	            			});
	                		setTimeout(function(){window.location.reload();}, 500);	
	                	}else{
	                		_dialog.hide();
	                		seajs.use(['lui/dialog'],function(dialog){
	                			dialog.success("${lfn:message('kms-wiki:kmsWiki.executeSucc')}",
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
			dialog.alert("${lfn:message('kms-wiki:kmsWiki.noRight')}");
		});
	}
	
	//取消置顶
	function cancelTop(){
		seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
				function(dialog, topic, $, env) {
					dialog.confirm("${lfn:message('kms-wiki:kmsWiki.cancelTop')}", function(flag, d) {
						if (flag) {
							var loading = dialog.loading();
							$.post(env.fn.formatUrl('/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=cancelTop&docIds=${param.fdId}'),
									null, function(data, textStatus,
													xhr) {
												if (data["hasRight"]== true) {
													loading.hide();
													dialog.success("${lfn:message('kms-wiki:kmsWiki.executeSucc')}",
															'#listview');
													setTimeout(function(){window.location.reload();}, 500);	
												} else {
													loading.hide();
							                		dialog.alert("${lfn:message('kms-wiki:kmsWiki.noRight')}");
												}
											}, 'json');
						}
					});
				}
		);
	}
 	// 编辑器中词条链接
	function wikiLink(obj) {
		var href;
		LUI.$
				.ajax( {
					url : '<c:url value="/kms/common/resource/jsp/get_json_feed.jsp" />',
					data : {
						"s_bean" : "kmsHomeWikiService",
						"s_method" : "getWikiByName",
						"docSubject" : encodeURIComponent(obj.innerHTML)
					},
					async : false,
					cache : false,
					dataType : "json",
					success : function(data) {
						if (data['fdId']) {
							href = '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=" />'
									+ data['fdId'] + '&id=' + data['id'];
							
						}
					}
				});

		if(href)
			window.open(href, '_blank');
	}

	function changeErrorCorrection(){
		 var url = '<c:url value="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=add&fdModelId=${kmsWikiMainForm.fdId }&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc&fdKnowledgeType=2"/>';		 
		 window.open(url);
	}	

	function openErrorReason(obj){
		var url = '<c:url value="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=viewinfo&fdId="/>'+obj;
		window.open(url); 	 
	}	

	function delErrorCorrection(obj){
		seajs.use(['lui/dialog', 'lui/topic'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-common:kmsCommonDocErrorCorrection.confirmDeleteView')}", function(flag) {
 	 	 		if(flag) {
 	 	 			var url = '<c:url value="/kms/common/kms_common_doc_error_correction/kmsCommonDocErrorCorrection.do?method=delete&fdId="/>'+obj;
 	 	 			LUI.$.ajax( {
 						url : url,
 						success : function(data) {
							seajs.use(['lui/dialog','lui/topic'], function(dialog,topic) {
								dialog.success("${lfn:message('kms-common:kmsCommonDocErrorCorrection.delete')}");
	 	 	 					topic.channel('all_error').publish('list.refresh');
							});
 						}
 					});
				}}
			);
	 	});
		var evt=event||windows.event;
		evt.cancelBubble = true;
		return false;
	}
</script>
	
<script>
	Com_IncludeFile("ckresize.js",Com_Parameter.ContextPath
			+ "resource/ckeditor/", "js", true);
</script>
