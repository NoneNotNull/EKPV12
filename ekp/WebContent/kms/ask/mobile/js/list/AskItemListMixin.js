define([ "dojo/_base/declare", "mui/list/_TemplateItemListMixin",
		"kms/ask/mobile/js/list/item/AskItemMixin" ], function(declare,
		_TemplateItemListMixin, AskItemMixin) {

	return declare("kms.ask.AskItemListMixin", [ _TemplateItemListMixin ], {

		itemRenderer : AskItemMixin
	});
});