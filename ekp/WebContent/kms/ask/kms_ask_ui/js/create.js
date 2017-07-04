//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(currentId) {
		dialog
			.simpleCategoryForNewFile(
				'com.landray.kmss.kms.ask.model.KmsAskCategory',
				'/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add&fdCategoryId=!{id}',
				false,null,null,currentId);
	}
	exports.addDoc = addDoc;
});