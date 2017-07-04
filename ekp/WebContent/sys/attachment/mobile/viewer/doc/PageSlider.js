define([ "dojo/_base/declare", "dojox/mobile/Slider", "dojo/dom-construct",
		"dojo/topic", "dojo/dom-style",
		"sys/attachment/mobile/viewer/base/BasePage" ], function(declare,
		Slider, domConstruct, topic, domStyle, BasePage) {

	return declare("mui.attachment.PageSlider", [ Slider, BasePage ], {
		baseClass : "mblSlider muiAttViewerPageSlider",

		pageValues : null,

		min : 1,

		_pageChange : function(evt) {
			if (!evt)
				return;
			this.change(evt);
		},

		pageChange : function(obj, evt) {
			if (!evt)
				return;
			this.inherited(arguments);
			this.set('value', evt.pageNum);
		},
		
		_setValueAttr : function(value, priorityChange) {
			// 滑动结束
			if (this.pageValues) {
				if (priorityChange == true)
					this.pageValues.set('pageNum', value, true);
				else
					this._pageChange({
						pageNum : value,
						pageCount : this.pageValues.get('pageCount')
					});
			}
			this.inherited(arguments);
		}
	});
})