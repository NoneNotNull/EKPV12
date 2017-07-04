<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	//全选、取消全选
	function selectAll(){
		var txtSpan = $(".kms_opeGroup").find("span");
		var checkList = $('#att_doc_attachment :checkbox');
		if($(".kms_opeGroup").find(":checkbox").is(":checked")){
			txtSpan.html("${ lfn:message('kms-kmtopic:kmsKmtopicMain.cancel') }");
			checkList.prop("checked",true);
		}else{	
			txtSpan.html("${ lfn:message('kms-kmtopic:kmsKmtopicMain.chooseAll') }");
			checkList.prop("checked",false);
		}
	}
	//批量下载
	function batchDown(){
		var _dialog;
		seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
			_dialog = dialog;
		});
		
		var docIds = "";
		var checkBox =  document.getElementsByName("List_Selected");
		if(checkBox!=null) { 
			for(var i=0;i<checkBox.length;i++) {
				if(checkBox[i].checked){
					docIds += ";" + checkBox[i].value;
				}
			} 
		}
		docIds = docIds.substring(1, docIds.length);
		if(docIds.length <= 0){
			_dialog.alert("${ lfn:message('kms-kmtopic:kmsKmtopicMain.downLoad.attTip') }");
		}else{
			$.ajax({
				type : "POST",
				dataType: 'json',
				url :  "<c:url value='/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=getAttIdsByDocIds'/>",
				data : {docIds:docIds},
				success : function(result) {
					if(result['noAttachment']){
						_dialog.alert("${lfn:message('kms-kmtopic:kmsKmtopicMain.batchDown.noAttachment')}");
					}else{
						 if(result['checkDown']){
							 var unAuthModelNames = result['unAuthModelNames'];
							 var attIds = result['attIds'];
	
							 if(attIds == ""){
								 _dialog.alert("${lfn:message('kms-kmtopic:kmsKmtopicMain.attDown.noRight')}");
							 }else{
								 if(unAuthModelNames != "" && attIds != ""){
									 confirmDown(attIds,unAuthModelNames);
								 }else{
									 var url = getUrl("download", attIds);
									 window.open(url, "_blank");
								 }
							 }
						 }else{
							 _dialog.alert("${lfn:message('kms-kmtopic:kmsKmtopicMain.att.countLimit')}"+result['attSize']);
						 }
					}
					
					 
				}				
			});
		}
	};

	//存在没有权限下载的附件，是否继续下载有权限的附件
	function confirmDown(attIds , unAuthModelNames){
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe("/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_confirm_batchDown.jsp?attIds="+attIds+"&unAuthModelNames="
							+encodeURIComponent(unAuthModelNames), 
							"${ lfn:message('kms-kmtopic:kmsKmtopicMain.addLink') }",
							 null, 
							 {	
								width:700,
								height:210
							}
			); 
		});
	}

	/****************************************
	 * 获取域名
	 ***************************************/
	function getHost(){
		var host = location.protocol.toLowerCase()+"//" + location.hostname;
		if(location.port!='' && location.port!='80'){
			host = host+ ":" + location.port;
		}
		return host;
	}

	/****************************************
	 * 功能函数，获取URL地址，传入参数method和文档fdId
	 ***************************************/
	function getUrl(method, docId) {
		return getHost() + Com_Parameter.ContextPath
				+ "sys/attachment/sys_att_main/sysAttMain.do?method=" + method
				+ "&fdId=" + docId;
	};

	//调整属性
	 function editProperty() {
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('kmsKmtopicMain.do?method=editProperty&type=property&fdId=${param.fdId}', 
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
											var eFlag = editProSubmit(proObj,winObj);
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
	//调整属性异步处理
	 function editProSubmit(_obj) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=updateProperty&fdId=${param.fdId}',
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
	var currentTags="${kmsKmtopicMainForm.sysTagMainForm.fdTagNames}";
	//添加标签
	function addTags(TagsType) {
		var title;
		var contentTitle;
		var value;
		if (TagsType == '2') { // 编辑
			title = "${lfn:message('kms-kmtopic:kmsKmtopicMain.button.editTag')}";
			contentTitle = "${lfn:message('kms-kmtopic:kmsKmtopicMain.editTagsTips')}";
			value = currentTags;
		} else if (TagsType == '3') { //添加
			title = "${lfn:message('kms-kmtopic:kmsKmtopicMain.button.addTag')}";
			contentTitle = "${lfn:message('kms-kmtopic:kmsKmtopicMain.editTagsTips')}";
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
								'<div id="tagEdit" class="lui_kmtopic_tagEdit">',
								'<span id="tagTips">',contentTitle,'</span>',
								'<input type="text" id="kmtopic_tagInput" value="',value,'" style="width:90%"></input>',
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
								var input =  LUI.$('#kmtopic_tagInput').val();
								_dialog.hide();
								var loading = dialog.loading();
								var updateTagsFlag = updateTags(input, TagsType);
								if( updateTagsFlag != null && updateTagsFlag=='1') {									
									loading.hide();
									if(TagsType == '3')
										dialog.success("${lfn:message('kms-kmtopic:kmsKmtopicMain.addTagsTipsSucccess')}");
									else if(TagsType == '2')
										dialog.success("${lfn:message('kms-kmtopic:kmsKmtopicMain.editTagsTipsSucccess')}");
									setTimeout(function(){
										Com_OpenWindow('kmsKmtopicMain.do?method=view&fdId=${param.fdId}','_self');
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
		var url="kmsKmtopicMainXMLService&fdId=${kmsKmtopicMainForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			
		});	
		return 1;    
	 }

	//删除
	function confirmDelete() {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-kmtopic:kmsKmtopicMain.datagrid.deleteMsg')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsKmtopicMain.do?method=delete&fdId=${param.fdId}','_self');
				}}
			);
	 	});
	}
	//目录展开与收起
	function slideLogContent(catelog){
		var catelogContent = $($(catelog).parent()[0])[0].nextElementSibling;
		if($(catelogContent).is(":hidden")){
			$(catelogContent).slideDown('slow');
			$($(catelog)[0].children[0]).html('${lfn:message('kms-kmtopic:kmsKmtopicMain.slideUp')}');
	    }else{
	    	$(catelogContent).slideUp("slow");
	    	$($(catelog)[0].children[0]).html('${lfn:message('kms-kmtopic:kmsKmtopicMain.open')}');
	    }
	}

	//打开具体文档，当文档不存在，则弹框提示
	function openFile(docId,docUrl,fdContentType){
		if(fdContentType == 2){// 2代表是外部链接
			window.open(docUrl,'_blank');
		}else{
			LUI.$.ajax({
				type : "POST",
				dataType: 'json',
				url :  "<c:url value='/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=isFileExist'/>",
				data : {docId:docId},
				success : function(result) {
					if(result['isExist']){
						docUrl = getHost() + Com_Parameter.ContextPath + docUrl;
						window.open(docUrl,'_blank');
					}else{
						seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
							dialog.alert("${ lfn:message('kms-kmtopic:kmsKmtopicMain.file.notExist') }");
						});
					}
				}				
			});
		}
	}
</script>