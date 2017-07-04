//新建分类选择框，给门户或二级页面调用
define(function(require, exports, module) {
	var dialog = require('lui/dialog');
	//参数为默认选中的分类
	function addDoc(categoryId) {
		dialog.simpleCategoryForNewFile(
				'com.landray.kmss.work.cases.model.WorkCasesCategory',
				'/work/cases/work_cases_main/workCasesMain.do?method=add&docCategoryId=!{id}',false,null,null,categoryId);
	}
	exports.addDoc = addDoc;
});