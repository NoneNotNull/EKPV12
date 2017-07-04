//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(categoryId) {
		dialog.simpleCategoryForNewFile(
				'com.landray.kmss.sys.news.model.SysNewsTemplate',
				'/sys/news/sys_news_main/sysNewsMain.do?method=add&fdTemplateId=!{id}',false,null,null,categoryId);
	}
	exports.addDoc = addDoc;
});