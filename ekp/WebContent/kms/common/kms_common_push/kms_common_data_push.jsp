<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.List"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
	<div style="float:right;margin-right:20px;">
	<ui:dataview >
		<ui:source type="AjaxJson">
			{url:'${url}'}
		</ui:source>
		<ui:render type="Template">
			<c:import url="/kms/common/kms_common_push/kms-common-datapush.html" charEncoding="UTF-8">
			</c:import>
		</ui:render>
	</ui:dataview>
	</div>
<script>
var _dialog;
seajs.use(['lui/dialog'], function(dialog) {
	_dialog = dialog;
});

function datapush(modelName,fdId,cateModelName){
	if("com.landray.kmss.kms.wiki.model.KmsWikiMain" == modelName){
		var kmsCommonPushAction = encodeURIComponent('${kmsCommonPushAction}');
		url = '/kms/common/kms_common_push/kms_common_push_wiki.jsp?fdModelId='+fdId+'&modelName='+modelName +"&kmsCommonPushAction="+kmsCommonPushAction;
		seajs.use(
				[ 'lui/dialog' ],
				function(dialog) {
					dialog.iframe(
							url,
							"${lfn:message('kms-common:kmsCommonDataPush.title')}",
							function() {
							}, {
								"width" : 700,
								"height" : 500
							});
		});

	}else if("com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" == modelName){
		seajs.use(['sys/ui/js/dialog'], function(dialog) {
			var create_url = '${kmsCommonPushAction}&fdTemplateId=!{id}&fdCategoryId=!{id}&modelName='+modelName+'&fdModelId='+fdId;
			dialog.simpleCategoryForNewFile(
				cateModelName,
				create_url,
				false,
				function(rtn) {
					// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
					if (!true && !rtn)
						window.close();
				},
				null,
				LUI.$('input[name=docCategoryId]').val(),
				"_black", 
				true, {
					'fdTemplateType': '1,3'
				}
			);
		});
	}else{
		var url = '${kmsCommonPushAction}&fdId='+fdId+'&modelName='+modelName ;
		seajs.use(
				[ 'lui/dialog' ],
				function(dialog) {
					dialog.iframe(
							url,
							"${lfn:message('kms-common:kmsCommonDataPush.title')}",
							function() {
							}, {
								"width" : 700,
								"height" : 500
							});
		});
	}
	
}

</script>