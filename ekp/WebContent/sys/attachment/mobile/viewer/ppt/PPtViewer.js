define([ "dojo/_base/declare", "dojo/text!./tmpl/pptViewer.jsp",
		"sys/attachment/mobile/viewer/base/BaseViewer",
		"sys/attachment/mobile/viewer/base/_PageViewerMixin" ], function(
		declare, tmpl, BaseViewer, _PageViewerMixin) {

	return declare("sys.attachment.PPtViewer",
			[ BaseViewer, _PageViewerMixin ], {

				templateString : tmpl,

				onScroll : function(evt) {
					if (!this._height)
						return;
					var target = document.body;
					var scrollTop = target.scrollTop;
					this.pageValues.set('pageNum', Math.round(scrollTop
							/ this._height) + 2);
				},

				setH_W : function(target) {
					var _body = target.contentDocument.body;
					this.getNodeSize(_body);
				}

			});
});
