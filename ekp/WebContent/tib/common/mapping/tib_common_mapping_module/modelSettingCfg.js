/**
 * 模块注册默认modelName-模块中文描述 mainModel-主文档className com.kmss.landray...
 * tempModel-分类名className cateType-分类类型 1-全局分类 / 2-简单分类
 * 
 * just for tibCommonMappingModule_edit.jsp
 */

var cacheModuelInfo = [{
			modelName : TibCommon_lang.examineFlow,
			mainModel : 'com.landray.kmss.km.review.model.KmReviewMain',
			tempModel : 'com.landray.kmss.km.review.model.KmReviewTemplate',
			cateType : '1',
			fdTemCateFieldName : 'docCategory',
			fdTemNameFieldName : 'fdName',
			fdModelTemFieldName : 'fdTemplate',
			fdFormTemFieldName : 'fdTemplateId'

		}, {
			modelName : TibCommon_lang.newModule,
			mainModel : 'com.landray.kmss.sys.news.model.SysNewsMain',
			tempModel : 'com.landray.kmss.sys.news.model.SysNewsTemplate',
			cateType : '0',
			fdTemCateFieldName : '',
			fdTemNameFieldName : '',
			fdModelTemFieldName : 'fdTemplate',
			fdFormTemFieldName : 'fdTemplateId'
		}
//		, {
//			modelName : "测试定制明细表",
//			mainModel : 'com.landray.kmss.km.sample.model.KmSampleMain',
//			tempModel : 'com.landray.kmss.km.sample.model.KmSampleTemplate',
//			cateType : '1',
//			fdTemCateFieldName : 'docCategory',
//			fdTemNameFieldName : 'fdName',
//			fdModelTemFieldName : 'fdTemplate',
//			fdFormTemFieldName : 'fdTemplateId'
//		}
		];

// ============================================
// 联动 fdModuleName
function changeOther(elem) {
	var elemVal = elem.value;
	// 联动element
	var model = document.getElementsByName('fdModuleName')[0];
	model.value = elem.value;
	var mainModel = document.getElementsByName('fdMainModelName')[0];
	var tempModel = document.getElementsByName('fdTemplateName')[0];

	var fdTemCateFieldName = document.getElementsByName('fdTemCateFieldName')[0];
	var fdTemNameFieldName = document.getElementsByName('fdTemNameFieldName')[0];

	var fdModelTemFieldName = document.getElementsByName('fdModelTemFieldName')[0];
	var fdFormTemFieldName = document.getElementsByName('fdFormTemFieldName')[0];
	var fdCate = document.getElementsByName('fdCate');

	var defObject = null;
	if (!elemVal) {
		mainModel.value = '';
		tempModel.value = '';
		fdTemCateFieldName.value = '';
		fdTemNameFieldName.value = '';
		fdModelTemFieldName.value = '';
		fdFormTemFieldName.value = '';
		var cate = fdCate[0].value == '1' ? fdCate[0] : fdCate[1];
		cate.checked = true;
		changeAllConfig(cate);
		return;
	}

	for (var i = 0, len = cacheModuelInfo.length; i < len; i++) {
		if (cacheModuelInfo[i].modelName == elemVal) {
			defObject = cacheModuelInfo[i];
		}
	}
	if (defObject) {
		mainModel.value = defObject["mainModel"];
		tempModel.value = defObject["tempModel"];
		fdTemCateFieldName.value = defObject["fdTemCateFieldName"];
		fdTemNameFieldName.value = defObject["fdTemNameFieldName"];
		fdModelTemFieldName.value = defObject["fdModelTemFieldName"];
		fdFormTemFieldName.value = defObject["fdFormTemFieldName"];

		if (defObject["cateType"] == '1') {
			var cate = fdCate[0].value == '1' ? fdCate[0] : fdCate[1];
			cate.checked = true;
			changeAllConfig(cate);
		} else {
			var cate = fdCate[0].value == '0' ? fdCate[0] : fdCate[1];
			cate.checked = true;
			changeAllConfig(cate);
		}
	}
}

function emptyElement() {
	//var model = document.getElementsByName('fdModuleName')[0];
	var mainModel = document.getElementsByName('fdMainModelName')[0];
	var tempModel = document.getElementsByName('fdTemplateName')[0];

	var fdTemCateFieldName = document.getElementsByName('fdTemCateFieldName')[0];
	var fdTemNameFieldName = document.getElementsByName('fdTemNameFieldName')[0];

	var fdModelTemFieldName = document.getElementsByName('fdModelTemFieldName')[0];
	var fdFormTemFieldName = document.getElementsByName('fdFormTemFieldName')[0];
	var fdCate = document.getElementsByName('fdCate');
	mainModel.value = '';
	tempModel.value = '';
	fdTemCateFieldName.value = '';
	fdTemNameFieldName.value = '';
	fdModelTemFieldName.value = '';
	fdFormTemFieldName.value = '';
	var cate = fdCate[0].value == '1' ? fdCate[0] : fdCate[1];
	cate.checked = true;
	changeAllConfig(cate);

}

function refresh(elem) {
	var select = document.getElementsByName(elem.name + "_select")[0];
	if (elem.value) {
		for (var i = 0, len = select.options.length; i < len; i++) {
			var tmp = null;
			if (select.options[i].value == '') {
				tmp = select.options[i];
			}
			if (select.options[i].value == elem.value) {
				select.options[i].selected = true;
				changeOther(select);
				return;
			}
			if (tmp) {
				tmp.selected = true;
			}
			emptyElement();
		}
	}
}

/**
 * Com_Submit 方法前校验fdModuleName非空
 * 
 * @param {}
 *            form
 * @param {}
 *            method
 * @return {Boolean}
 * 
 * function Com_Submit_withModel(form, method) { var select =
 * document.getElementsByName("fdModuleName")[0];
 * document.getElementById("advice-fdModuleName").style.display = "none"; if
 * (!select.value) {
 * document.getElementById("advice-fdModuleName").style.display = ""; return
 * false; } Com_Submit(form, method); }
 */
