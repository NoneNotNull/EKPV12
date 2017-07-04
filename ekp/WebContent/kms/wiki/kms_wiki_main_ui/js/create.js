//新建分类选择框，给门户或二级页面调用
define( function(require, exports, module) {
	var dialog = require('lui/dialog');
	// 参数为默认选中的分类
	function addDoc(categoryId) {
		if (categoryId) {
			var ids = categoryId.split(";");
			if (ids && ids.length != 1) {
				categoryId = "";
			}
		}
		dialog
				.simpleCategoryForNewFile(
						'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
						'/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=!{id}',
						false, null, null, categoryId, null, null, {
							'fdTemplateType' : '2,3'
						});
	}
	exports.addDoc = addDoc;
});