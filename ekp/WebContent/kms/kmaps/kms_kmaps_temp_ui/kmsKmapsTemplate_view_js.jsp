<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript"  
	src="${KMSS_Parameter_ContextPath}kms/kmaps/kms_kmaps_main/kanvas_kplayer/Kanvas.js"></script> 
<script type="text/javascript">
    var kvs = new KPlayer({id: 'demo1', width: '100%', height: '600px'});
	kvs.onReady(function(){
		kvs.setImgDomainServer(window.location.protocol+"//"+window.location.host+"${LUI_ContextPath}");
		kvs.setBase64Data("${kmsKmapsTemplateForm.docContent}");
	});

	//删除模版
	function confirmDelete() {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-kmaps:kmsKmapsMain.deleteMsg')}", function(flag) {
 	 	 		if(flag) {
	 	 	 		Com_OpenWindow(
						'kmsKmapsTemplate.do?method=delete&fdId=${kmsKmapsTemplateForm.fdId}','_self');
				}}
			);
	 	});
	}
	 //分类转移
	 function changeCate(){
		 var cateModelName = "com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory";
		 var modelName = "com.landray.kmss.kms.kmaps.model.KmsKmapsTemplate";
		 var url = "/sys/sc/cateChg.do?method=cateChgEdit&cateModelName="+cateModelName+"&modelName="+modelName+"&categoryId=${kmsKmapsTemplateForm.docCategoryId}&docFkName=docCategory&fdIds=${param.fdId}";
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
</script>
