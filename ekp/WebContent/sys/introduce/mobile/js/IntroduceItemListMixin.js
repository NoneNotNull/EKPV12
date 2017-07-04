define(	[
				"dojo/_base/declare",
				"mui/list/_TemplateItemListMixin",
				dojoConfig.baseUrl
						+ "sys/introduce/mobile/js/IntroduceItemMixin.js"],
		function(declare, _TemplateItemListMixin, IntroduceItemMixin) {

			return declare("sys.introduce.IntroduceItemListMixin",
					[_TemplateItemListMixin], {

						itemRenderer : IntroduceItemMixin
					});
		});