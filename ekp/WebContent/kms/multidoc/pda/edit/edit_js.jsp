<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/multidoc/pda/css/edit.css" />
<script>
	function updateCategory(data) {
		if (data) {
			var url = '${LUI_ContextPath }/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId='
					+ data.id;
			window.open(url, '_self');
		}
	}

	function selectCategory() {
		var currId = $("input[name=docCategoryId]").val(), currName = $(
				"input[name=docCategoryName]").val()
		canClose = currId ? true : false;
		var params = {
			'fdTemplateType' : '1,3'
		};
		Pda
				.simpleCategoryForNewFile({
					modelName : "com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
					action : updateCategory,
					currId : '',
					currName : '',
					canClose : canClose,
					params : params
				});
	}

	function save() {
		pre_nextValidate(document.kmsMultidocKnowledgeForm, function(result,
				form, first) {
			if (!result) {
				var $step = $(first).parents('.step'), index = $step
						.attr('data-lui-index');
				jumpIndex = index;
				Pda.Topic.emit({
					'type' : 'jump',
					'index' : jumpIndex,
					'step' : $step,
					'_step' : $step
				});
			}
		});
		document.getElementsByName('docStatus')[0].value = '20';
		Com_Submit(document.forms[0], 'save');
	}
	
	// 隐藏“附件区域”面板
	Pda.Topic.on('upload_change',function(){
		$('.lui-attachment-area').hide();
	});
</script>