<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript"
	src="${KMSS_Parameter_ContextPath}kms/kmaps/kms_kmaps_main/kanvas_kplayer/Kanvas.js"></script>
<script type="text/javascript">
	//标签
	window.onload = function() {
		var href = Com_Parameter.ContextPath + "sys/ftsearch/searchBuilder.do?method=search&searchFields=tag&newLUI=true"+
					"&modelName=com.landray.kmss.kms.kmaps.model.KmsKmapsMain";
		var tags = "${kmsKmapsMainForm.sysTagMainForm.fdTagNames}".split(" ");
		var container = $("td.tag_content");
		$.each(tags,function(key,value){
			if(value!=""){
				var tagDom = $("<span/>");
				tagDom.addClass("tag_tagSign");
				tagDom.text(value);
				tagDom.click(function(){
					window.open(href + "&queryString=" + encodeURIComponent(value),"_blank");
				});
				container.append(tagDom);
			}
		});
	};

    var kvs = new KPlayer({id: 'demo1', width: '100%', height: '600px'});
	kvs.onReady(function(){
		kvs.setImgDomainServer(window.location.protocol+"//"+window.location.host+"${LUI_ContextPath}");
		kvs.setBase64Data("${kmsKmapsMainForm.docContent}"); 
	});
	//弹出属性面板
	kvs.onLinkClicked(function(e){
		a = e.data ;
		downShape(e.data);
	}); 
	kvs.onUnselected(function(e){
		$(".destroy").stop(true).animate({'margin-right':'-110px','opacity':'0'},800);
	}); 
	//点击元素，查询搜索
	function downShape(fdKey) {
		if (!Relation_checkHasRelation(fdKey)) {// 判断没有关联信息不弹出层 ---add by miaogr
			return false;
		}
		var rentry = relationMains[fdKey].relationEntrys;
		var length = rentry.length;
		var flag = false;//false：从右侧弹出DIV层，显示搜索结果；true：直接打开新页面
		if (length == 0) {
			return false;
		} else if (length == 1) {
			//如果只有一项关联项
			var _rentryFdId = rentry[0].fdId;
			var staticLength = 0;
			for(var index in rentry[0].staticInfos[_rentryFdId]){
				staticLength++;
			}
			if(staticLength == 1){
				flag = true;
			}
			//var otherUrl = rentry[0].fdOtherUrl;
			//var type = rentry[0].fdType;
			//if (type == 4 && otherUrl != "" && otherUrl.indexOf("<br>") == -1) {
			//	flag = true;
			//}
		}
		if (flag) {
			var fdUrl = rentry[0].staticInfos[_rentryFdId][0].fdRelatedUrl;
			//兼容旧数据
			if(fdUrl==""){
				var otherUrl = rentry[0].fdOtherUrl;
				var type = rentry[0].fdType;
				if (type == 4 && otherUrl != "" && otherUrl.indexOf("<br>") == -1) {
					var fdUrls = otherUrl.split('|'), fdUrl;
					if (fdUrls.length > 1 && fdUrls[1]) {
						fdUrl = fdUrls[1];
					} else {
						fdUrl = fdUrls[0];
					}
				}
			}
			//兼容旧数据--end
			Com_OpenWindow(fdUrl, "_blank");
		}else {
			clickBtn();
			//有多个关联项或者有多个静态链接
			var relationIframe = document.getElementById("relationIframe");
			var relationId = relationMains[fdKey].fdId;//关联项Id
			var modelId = relationMains[fdKey].fdModelId;//modelId
			var modelName = relationMains[fdKey].fdModelName;
			var src = "<c:url value='/sys/relation/sys_relation_main/sysRelationMain.do' />?method=view&forward=docView&fdId="
				+ relationId
				+ "&currModelId="
				+ modelId
				+ "&currModelName="
				+ modelName
				+ "&fdKey="
				+ fdKey
				+ "&showCreateInfo=true&frameName=sysRelationContent";
			if(relationIframe.getAttribute("src") && relationIframe.getAttribute("src") === src) 
				return;
			relationIframe.src = src;
		}
	}
	seajs.use(['lui/dialog'],function(dialog) {
		LUI.$(document).ready(function(){
			// 关联机制弹出框关闭
			LUI.$('.lui_icon_s_icon_remove').click(function(){
				LUI.$(".relationContainer").stop(true).animate({'right':'-310px','opacity':'0'},400);
			});
		
		});
	});
	function clickBtn(){
		$(".relationContainer").stop(true).animate({'right':'0','opacity':'1'},400);
	}

	//删除
	function confirmDelete() {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-kmaps:kmsKmapsMain.deleteMsg')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsKmapsMain.do?method=delete&fdId=${param.fdId}','_self');
				}}
			);
	 	});
	}

	//调整属性
	 function editProperty() {
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('kmsKmapsMain.do?method=editProperty&type=property&fdId=${param.fdId}', 
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
											var eFlag = editProSubmit(proObj,winObj);
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
	//调整属性异步处理
	 function editProSubmit(_obj) {
		 	var editFlag;
		 	LUI.$.ajax({
				url: '${ LUI_ContextPath}/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=updateProperty&fdId=${param.fdId}',
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

	 //分类转移
	 function changeCate(){
		 var cateModelName = "com.landray.kmss.kms.kmaps.model.KmsKmapsCategory";
		 var modelName = "com.landray.kmss.kms.kmaps.model.KmsKmapsMain";
		 var url = "/sys/sc/cateChg.do?method=cateChgEdit&cateModelName="+cateModelName+"&modelName="+modelName+"&categoryId=${kmsKmapsMainForm.docCategoryId}&docFkName=docCategory&fdIds=${param.fdId}";
			seajs
					.use(
							[ 'lui/dialog' ],
							function(dialog) {
								dialog
										.iframe(
												url,
												"${ lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }",
												function() {
												}, {
													"width" : 600,
													"height" : 300
												});
							});
	}
	//显示标签
	var currentTags="${kmsKmapsMainForm.sysTagMainForm.fdTagNames}";
	//添加标签
	function addTags(TagsType) {
		var title;
		var contentTitle;
		var value;
		if (TagsType == '2') { // 编辑
			title = "${lfn:message('kms-kmaps:kmsKmapsMain.button.editTag')}";
			contentTitle = "${lfn:message('kms-kmaps:kmsKmapsMain.editTagsTips')}";
			value = currentTags;
		} else if (TagsType == '3') { //添加
			title = "${lfn:message('kms-kmaps:kmsKmapsMain.button.addTag')}";
			contentTitle = "${lfn:message('kms-kmaps:kmsKmapsMain.addTagsTips')}";
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
								'<div id="tagEdit" class="lui_kmapmain_tagEdit">',
								'<span id="tagTips">',contentTitle,'</span>',
								'<input type="text" id="kmapmain_tagInput" value="',value,'"></input>',
								'</div>'
							   ].join(" "),
					    iconType : "",
						buttons : [ {
							name : "${lfn:message('button.ok')}",
							value : true,
							focus : true,
							fn : function(value,_dialog) {
								var input =  LUI.$('#kmapmain_tagInput').val();
								_dialog.hide();
								var loading = dialog.loading();
								var updateTagsFlag = updateTags(input, TagsType);
								if( updateTagsFlag != null && updateTagsFlag=='1') {									
									loading.hide();
									if(TagsType == '3')
										dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.addTagsTipsSucccess')}");
									else if(TagsType == '2')
										dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.editTagsTipsSucccess')}");
									setTimeout(function(){
										Com_OpenWindow('kmsKmapsMain.do?method=view&fdId=${param.fdId}','_self');
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
		var url="kmsKmapsMainXMLService&fdId=${kmsKmapsMainForm.fdId}&type="+type+"&tags="+encodeURIComponent(tags);
		var data = new KMSSData(); 
		data.SendToBean(url,function defaultFun(rtnData){ 
			
		});	
		return 1;    
	 }
	//保存模版
	function saveTemplate() {

			seajs.use(['lui/dialog'],function(dialog){
				dialog.iframe("kmsKmapsMain.do?method=getMapForm&fdId=${kmsKmapsMainForm.fdId}", 
								"${lfn:message('kms-kmaps:kmsKmapsMain.chooseTemp')}",
								function (value){
									if(value==null){
										return;
									}else{
										dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.saveTempTip')}",
										'#listview');
									}
								},
								 {	
									width:500,
									height:480
								}
				);
			});
	}
	
</script>

