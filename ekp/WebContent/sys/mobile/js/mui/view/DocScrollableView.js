define([ "dojo/_base/declare", "dojox/mobile/ScrollableView",
		"mui/list/_ViewScrollEventPublisherMixin", "dojo/dom-attr" ], function(
		declare, ScrollableView, _ViewScrollEventPublisherMixin, domAttr) {

	return declare("mui.view.DocScrollableView", [ ScrollableView,
			_ViewScrollEventPublisherMixin ], {
		scrollBar : false,
		isFormElement : function(/* DOMNode */node) {
			if (node && node.nodeType !== 1) {
				node = node.parentNode;
			}
			if (!node || node.nodeType !== 1) {
				return false;
			}
			var t = node.tagName;
			// 兼容编辑器，避免编辑器无法获取焦点
			return (t === "SELECT" || (t === "INPUT")
					|| t === "TEXTAREA" || t === "BUTTON" || domAttr.get(node,
					'contenteditable') == 'true');
		}
	});
});