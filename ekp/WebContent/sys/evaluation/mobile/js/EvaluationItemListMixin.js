define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	dojoConfig.baseUrl + "sys/evaluation/mobile/js/EvaluationItemMixin.js"
	], function(declare, _TemplateItemListMixin, EvaluationItemMixin) {
	
	
	return declare("sys.evaluation.EvaluationItemListMixin", [_TemplateItemListMixin], {
		
		itemRenderer: EvaluationItemMixin
	});
});