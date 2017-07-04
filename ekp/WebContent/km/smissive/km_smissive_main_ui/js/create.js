//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(categoryId) {
		dialog.simpleCategoryForNewFile(
				'com.landray.kmss.km.smissive.model.KmSmissiveTemplate',
				'/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=!{id}',false,null,null,categoryId);
	}
	exports.addDoc = addDoc;
});