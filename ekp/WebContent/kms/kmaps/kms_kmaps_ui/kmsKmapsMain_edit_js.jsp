<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript"  
	src="${KMSS_Parameter_ContextPath}kms/kmaps/kms_kmaps_main/kanvas_kplayer/Kanvas.js"></script>  
<script type="text/javascript">
	var kvs = new Kanvas({id: 'demo', width: '100%', height: '100%'});
	var urlflex = getLocationUrlFlex();
	var url = urlflex + "kms/kmaps/kms_kmaps_main/kmsKmapsAtt.do?method=uploading&fdModelId=${kmsKmapsMainForm.fdId}";
	//按钮
	function getButton(method){
		var customButtonData = "<buttons><button id = '1' label='${ lfn:message('kms-kmaps:kmsKmapsMain.finish')}'"+
			 "tip='${ lfn:message('kms-kmaps:kmsKmapsMain.finish')}' callBack='"+method+"'></button></buttons>";
		 return customButtonData;
	}
	
	kvs.onReady(function(){
		kvs.setCustomButton(getButton('updateMap()'));
		kvs.setImgDomainServer(window.location.protocol+"//"+window.location.host+"${LUI_ContextPath}");
		kvs.setImgUploadServer(url);
		
		var kmapsContent = $("input[name='docContent']").val();
		if(kmapsContent!=''){
			kvs.setBase64Data(kmapsContent);
		}
	});	
	kvs.onLinkBtnClicked(function(e){
		openPropertyToJS(e.data);
		____relationEvent = [];
		____relationEvent.push(function(){
			setLinkInfo(getShapePropertyArr(e.data));
		});
		
	});	
	
	function getData(){
		var data = kvs.getBase64Data();
		return data ;
	};
	
	//打开关联机制  
	function openPropertyToJS(idVal, propertyVal) {
		Relation_editRelation(idVal.toString()); //添加关联机制的信息  
	}
	
	//删除元素,删除关联json
	function deleteShape(fdKey) {
		Relation_deleteRelation(fdKey.toString()); //删除关联机制的信息
	}
	
	//将有关联信息的元素的key组成数组。
	function getShapePropertyArr(index) {
		// 关联数据结构更改为object
		if( typeof(relationMains[index])!='undefined' && !$.isEmptyObject(relationMains[index].relationEntrys)){
			return true ;
		}
		return false;
	}
	
	//设置数据关联
	function setLinkInfo(linkData){
		kvs.setLinkData(linkData);
	};
	
	function getSaveShapePropertyArr() {
		var ids = kvs.getOwnPropertyIDList().split(",");
		var flag = true ;
		for ( var fdKey in relationMains) {
			for(var i=0;i<ids.length;i++){
				if(ids[i] == fdKey.toString()){
					flag = false ; 
					break ;
				}
			}
			if(flag){
				deleteShape(fdKey);
			}
		}
	}
	
	//获取当前url的前缀
	function getLocationUrlFlex() {
		var curUrl = location.href;
		var urlFlex = "";
		if (curUrl.indexOf(":") > -1) {
			urlFlex = window.location.protocol + "\/\/" + location.hostname + ":" + location.port
					+ "${KMSS_Parameter_ContextPath}";
		} else {
			urlFlex = window.location.protocol + "\/\/" + location.hostname
					+ "${KMSS_Parameter_ContextPath}";
		}
		return urlFlex;
	}
	//选择地图模版
	function chooseTemp() {
		$.ajax({
			url : '<c:url value="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do" />',
			data : {
				method : 'getMapTempSum'
			},
			cache : false,
			success : function(data) {
				if(data>0){
					seajs.use(['lui/dialog'],function(dialog){
						dialog.iframe("/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=importTemplate", 
										"${ lfn:message('kms-kmaps:kmsKmapsMain.chooseTemp')}",
										function (value){
											if(value==null){
												return;
											}else{ 
												$.ajax({ 
													url : '<c:url value="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do" />',
													data : {
														method : 'getKmapsContent',
														template :	value
													},
													cache : false,
													success : function(data) {
														var urlflex = getLocationUrlFlex();
														var url = urlflex + "kms/kmaps/kms_kmaps_main/kmsKmapsAtt.do?method=uploading&fdModelId=${kmsKmapsMainForm.fdId}";
														kvs.setImgUploadServer(url);
														kvs.setBase64Data(data);
													},
													error : function(){
													}
													
												});
											}
										},
										 {	
											width:460,
											height:450
										}
						);
					});
				}
				
			},
			error : function(){
			}
			
		});
		
	 }
	/*保存、更新绘图*/
	function updateMap(){
		document.getElementsByName("docContent")[0].value = getData();
		document.getElementsByName("shotCut")[0].value = kvs.getShotCut(380,320);//缩略图
		getSaveShapePropertyArr();
		
		$("#kmsKmapsContent").css("display","block");
		$("#demo").css({"position":"absolute","left":"10000px"});//将Kanvas左移10000px
		$(".kms_kanvas").css("height","0px");
	}

	LUI.ready(function(){
		var editType = "${param.editType}";
		//如果是编辑所有，则进入编辑信息页
		if(editType == "editAll"){
			$("#kmsKmapsContent").css("display","block");
			$("#demo").css({"position":"absolute","left":"10000px"});
			$(".kms_kanvas").css("height","0px");
		}
		$("#demo").css("position","absolute");
		if("${kmsKmapsMainForm.docCategoryId}"==''){//无分类时，自动弹框选择分类
			window.modifyCate(false);
		}else if("${kmsKmapsMainForm.docContent}" == ''){
			chooseTemp();
		}
	});


	/*切换作者类型*/
	function changeAuthorType(value) {
		LUI.$('#innerAuthor').hide();
		LUI.$('#outerAuthor').hide();
		if (value == 1) {
			LUI.$('#outerAuthor input').attr('validate', '').val('');
			LUI.$('#innerAuthor input').attr('validate', 'required');
			LUI.$('#innerAuthor').show();
		}
		if (value == 2) {
			LUI.$('#innerAuthor input').attr('validate', '').val('');
			LUI.$('#outerAuthor input').attr('validate', 'required');
			LUI.$('#outerAuthor').show();
		}
	}
	
	/*根据类型提交*/
	function commitMethod(commitType, saveDraft) {
		var formObj = document.kmsKmapsMainForm;
		var docStatus = document.getElementsByName("docStatus")[0];
		
		if (saveDraft == "true") {
			docStatus.value = "10";
		} else if(saveDraft == "false"){
			docStatus.value = "20";
		}
		Com_Submit(formObj, commitType);
	}

	/*修改分类*/
	function modifyCate(unClose, isModify) {
		seajs.use(['lui/dialog', 'lui/util/env'],function(dialog, env) {
			if(isModify) {
				//修改分类，弹出确认框
				dialog.confirm("${lfn:message('kms-kmaps:kmsKmapsMain.confirmModifyCate')}", 
						function(flag) {
							if(flag)
								dialogForNewFile();
						}
			    );
			} else dialogForNewFile();

				
			function dialogForNewFile() {
				dialog
				   .simpleCategoryForNewFile(
					"com.landray.kmss.kms.kmaps.model.KmsKmapsCategory",
					"/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add&categoryId=!{id}",
					false, function(rtn) {
						// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!unClose && !rtn)
							window.close();
					}, null, LUI.$('input[name=docCategoryId]').val(), "_self",
					true);
			}

	    });
	}
	

	//继续绘图
	function drawMap(){
		//页面校验
		var validateArr = ['docSubject','docAuthorName','outerAuthor','docDeptName'];
		var  S_Valudator = $GetKMSSDefaultValidation(null);
		for(var i=0;i<validateArr.length;i++){
			LUI.$("input[name='"+validateArr[i]+"']").each(function(){
				 S_Valudator.addElements(this);
			 });
		}
		if(!S_Valudator.validate()){
			return ;
		}
		
		$("#kmsKmapsContent").css("display","none");
		$("#demo").css({"position":"fixed","left":"0px"});
		$(".kms_kanvas").css("height","100%");
	}
</script>

