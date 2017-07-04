define( function(require, exports, module) {
	var lang = require('lang!kms-knowledge');
	var langUi = require('lang!sys-ui');
	var $ = require("lui/jquery");
	var dialog = require('lui/dialog');
	var env = require('lui/util/env');
	var strutil = require('lui/util/str');
	function addDoc(categoryId) {
		var defaultId = "";
		if (categoryId) {
			var ids = categoryId.split(";");
			if (ids && ids.length != 1) {
				categoryId = "";
			}
		}
		if (categoryId)
			defaultId = categoryId;
		dialog.simpleCategoryForNewFile(
				'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
				"", false, selectTemplate,
				lang['kmsKnowledge.selectKnowledgeCategory'], defaultId, null,
				true);
	}
	//模版选择
	function selectTemplate(params) {
		if (!params || !params.id) {
			return;
		}
		var that = this;
		dialog
				.build(
						{
							config : {
								width : 600,
								height : 300,
								lock : true,
								cache : false,
								title : lang['kmsKnowledge.selectKnowledgeTemplate'],
								content : {
									id : 'dialog_iframe',
									scroll : true,
									type : "iframe",
									url : '/kms/knowledge/kms_knowledge_ui/template_select.jsp',
									params : params,
									// url|element|html:"",
									iconType : "",
									buttons : [
											{
												name : langUi['ui.dialog.button.ok'],
												value : true,
												focus : true,
												fn : function(value, _dialog) {
													var iframe = _dialog.element
															.find('iframe')
															.get(0);
													var selectId = iframe.contentWindow.selectId;
													var urlParam = getUrl(selectId);
													if (!urlParam) {
														dialog
																.alert(lang['kmsKnowledgeCategory.selectKnowledgeTemplate']);
														return;
													}
													var openUrl = strutil
															.variableResolver(
																	urlParam,
																	params);
													window
															.open(
																	env.fn
																			.formatUrl(openUrl),
																	'_blank');
													_dialog.hide();
												}
											},
											{
												name : langUi['ui.dialog.button.cancel'],
												value : false,
												fn : function(value, _dialog) {
													_dialog.hide();
												}
											} ]
								}
							},
							callback : function(value, dialog) {
							},
							actor : {
								type : "default"
							},
							trigger : {
								type : "default"
							}
						}).show();
	}

	function getUrl(type) {
		var url;
		if (type == '1') {
			//文档库新建链接
			url = "/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=!{id}";
		} else if (type == '2') {
			//维基新建链接
			url = "/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=!{id}";
		}
		return url;
	}

	exports.addDoc = addDoc;
});