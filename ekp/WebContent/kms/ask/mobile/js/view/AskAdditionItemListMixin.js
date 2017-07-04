define([ "dojo/_base/declare", "mui/list/_TemplateItemListMixin",
		"kms/ask/mobile/js/view/item/AskAdditionItemMixin", "dojo/query",
		"dijit/registry" ], function(declare, _TemplateItemListMixin,
		AskAdditionItemMixin, query, registry) {

	return declare("kms.ask.AskAdditionItemListMixin",
			[ _TemplateItemListMixin ], {
				itemRenderer : AskAdditionItemMixin,
				onComplete : function(items) {
					this.inherited(arguments);
					if (items.length == 0)
						query('.muiAskAddition').style('display', 'none');
				}
			});
});