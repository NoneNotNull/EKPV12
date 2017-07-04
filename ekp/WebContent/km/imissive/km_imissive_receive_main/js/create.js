//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(categoryId) {
		dialog.categoryForNewFile(
				'com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate',
				'/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=add&fdTemplateId=!{id}',false,null,null,categoryId,null,null,true);
	}
	exports.addDoc = addDoc;
});