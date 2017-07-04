<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript"  
	src="${KMSS_Parameter_ContextPath}kms/kmaps/kms_kmaps_main/kanvas_kplayer/Kanvas.js"></script>  
<script type="text/javascript">
	//按钮
	function getButton(method){
		var customButtonData = "<buttons><button id = '1' label='${ lfn:message('kms-kmaps:kmsKmapsMain.finish')}'"+
			 	 			"tip='${ lfn:message('kms-kmaps:kmsKmapsMain.finish')}' callBack='"+method+"'></button>"+
		 					 "<button id = '1' label='${ lfn:message('kms-kmaps:kmsKmapsMain.close')}'"+
		 					 "tip='${ lfn:message('kms-kmaps:kmsKmapsMain.close')}' callBack='Com_CloseWindow'></button></buttons>";
		 return customButtonData;
	}
	
	var kvs = new Kanvas({id: 'demo', width: '100%', height: '100%'}); 
	var urlflex = getLocationUrlFlex();
	var url = urlflex + "kms/kmaps/kms_kmaps_main/kmsKmapsAtt.do?method=uploading&fdModelId=${kmsKmapsTemplateForm.fdId}"; 
	kvs.onReady(function(){
		kvs.setCustomButton(getButton('updateTemp'));
		
		kvs.setImgUploadServer(url);
		if("${kmsKmapsTemplateForm.docContent}" != ''){
			kvs.setImgDomainServer(window.location.protocol+"//"+window.location.host+"${LUI_ContextPath}");
			kvs.setBase64Data("${kmsKmapsTemplateForm.docContent}");
		}
	});	
	
	function getData(){
		var data = kvs.getBase64Data();
		return data ;
	};
	
	//获取当前url的前缀
	function getLocationUrlFlex() {
		var curUrl = location.href;
		var urlFlex = "";
		if (curUrl.indexOf(":") > -1) {
			urlFlex = window.location.protocol+"\/\/" + location.hostname + ":" + location.port
					+ "${KMSS_Parameter_ContextPath}";
		} else {
			urlFlex = window.location.protocol+"\/\/" + location.hostname
					+ "${KMSS_Parameter_ContextPath}";
		}
		return urlFlex;
	}
	
	function updateTemp(){
		document.getElementsByName("docContent")[0].value = getData();
		$("#kmapsTemplateContent").css("display","block");
		$("#demo").css({"position":"absolute","left":"10000px"});//将Kanvas左移10000px
		$(".kms_kanvas").css("height","0px");
	}
	LUI.ready(function(){
		var editType = "${param.editType}";
		//如果是编辑所有，则进入编辑信息页
		if(editType == "editAll"){
			$("#kmapsTemplateContent").css("display","block");
			$("#demo").css({"position":"absolute","left":"10000px"});
			$(".kms_kanvas").css("height","0px");
		}
		$("#demo").css("position","absolute");
		if("${kmsKmapsTemplateForm.docCategoryId}"==''){//无分类时，自动弹框选择分类
			window.modifyCate(false);
		}
	});

	//继续绘图
	function drawTemp(){
		//页面校验
		var validateArr = ['fdName'];
		var  S_Valudator = $GetKMSSDefaultValidation(null);
		for(var i=0;i<validateArr.length;i++){
			LUI.$("input[name='"+validateArr[i]+"']").each(function(){
				 S_Valudator.addElements(this);
			 });
		}
		if(!S_Valudator.validate()){
			return ;
		}
		
		$("#kmapsTemplateContent").css("display","none");
		$("#demo").css({"position":"fixed","left":"0px"});
		$(".kms_kanvas").css("height","100%");
	}


	/*修改模版分类*/
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
					"com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory",
					"/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=add&categoryId=!{id}",
					false, function(rtn) {
						// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!unClose && !rtn)
							window.close();
					}, null, LUI.$('input[name=docCategoryId]').val(), "_self",
					true);
			}

	    });
	}
</script>
