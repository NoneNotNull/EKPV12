define([ "dojo/_base/declare", "dojo/text!./tmpl/docViewer.jsp",
		"sys/attachment/mobile/viewer/base/BaseViewer",
		"sys/attachment/mobile/viewer/base/_PageViewerMixin" ], function(
		declare, tmpl, BaseViewer, _PageViewerMixin) {

	return declare("sys.attachment.DocViewer",
			[ BaseViewer, _PageViewerMixin ], {
				templateString : tmpl
			});
});
