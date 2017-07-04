define([ "dojo/_base/declare", "dojo/dom", "mui/rtf/_ImageGlobalResizeMixin",
		"mui/rtf/_TableResizeMixin" ], function(declare, dom,
		_ImageGlobalResizeMixin, _TableResizeMixin) {

	var claz = declare("mui.rtf.RtfResizeUtil", [ _ImageGlobalResizeMixin,
			_TableResizeMixin ], {
		constructor : function(options) {
			if (options) {
				this.name = options.name;
				this.channel = options.channel || 'default';
				this.formatContent(options.containerNode);
			}
		},

		destroy : function() {
			this.emptySrcList();
		}
	});
	return claz;
});