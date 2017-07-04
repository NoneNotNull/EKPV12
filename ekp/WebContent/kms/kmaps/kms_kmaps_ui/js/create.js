//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(categoryId) {
		dialog
			.simpleCategoryForNewFile(
				'com.landray.kmss.kms.kmaps.model.KmsKmapsCategory',
				'/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add&categoryId=!{id}',
				false, null, null, categoryId);
	}
	exports.addDoc = addDoc;
});