define( [ "dojo/_base/declare", 'dojo/topic', 'dojo/dom-style',
		"dojo/_base/lang" ], function(declare, topic, domStyle, lang) {

	return declare("mui.list._TopListMixin", null, {

		adjustDestination : '/mui/list/adjustDestination',

		listTop : '/mui/list/toTop',

		toTop : function(evt) {
			topic.publish(this.listTop , this);
		},

		connectToggle : function() {
			// 监听列表进行显示与隐藏
		this.subscribe(this.adjustDestination, lang.hitch( function(srcObj, to, pos, dim) {
			// 当前位置+惯性，当前位置，容器高宽等
			this.defer(function() {
				var beShow = to.y < -5 && ((dim!=null && dim.c.h >= dim.d.h) || dim==null);
				if (beShow && !this._show)
					this.show();

				if (!beShow && this._show)
					this.hide();
			}, 0);
				
			}));

	}
	});
});