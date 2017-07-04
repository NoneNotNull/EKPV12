define([ "dojo/_base/declare", "dojo/topic", "dijit/_WidgetBase" ], function(
		declare, topic, _WidgetBase) {

	return declare("mui.attachment.PageValues", _WidgetBase, {

		pageNum : 1,
		pageCount : 0,

		_setPageNumAttr : function(value, fire) {
			this.pageNum = value;
			topic.publish('/mui/attachment/viewer/pageChange', this, {
				pageNum : this.pageNum,
				pageCount : this.pageCount,
				fire : fire
			});
		},

		_setPageCountAttr : function(value) {
			this.pageCount = value;
		},

		_getPageNumAttr : function() {
			return this.pageNum;
		},

		_getPageCountAttr : function() {
			return this.pageCount;
		}
	});
})