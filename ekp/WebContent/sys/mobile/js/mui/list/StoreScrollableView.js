define([
    "dojo/_base/declare",
	"dojox/mobile/ScrollableView",
	"./_ViewPullReloadMixin",
	"./_ViewPushAppendMixin",
	"./_ViewScrollEventPublisherMixin"
	], function(declare, ScrollableView, _ViewPullReloadMixin, _ViewPushAppendMixin, _ViewScrollEventPublisherMixin) {
	
	
	return declare("mui.list.StoreScrollableView", [ScrollableView, _ViewPullReloadMixin, _ViewPushAppendMixin, _ViewScrollEventPublisherMixin], {
		
		scrollBar : false,
		
		threshold : 50,
		
		hideTopBottom: true
	});
});