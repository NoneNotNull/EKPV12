define(
		[ "dojo/_base/declare", "mui/rtf/_ImageResizeMixin", "dojo/_base/array" ],
		function(declare, _ImageResizeMixin, array) {

			return declare("mui.rtf._ImageGlobalResizeMixin",
					_ImageResizeMixin, {
						initSrcList : function() {
							var w = window;
							if (!w.RtfImages)
								w.RtfImages = {};
							if (!w.RtfImages[this.channel]) {
								w.RtfImages[this.channel] = [];
							}
							this.srcs = [];
						},

						addSrcList : function(src) {
							this.srcs.push(src);
							window.RtfImages[this.channel].push(src);
						},

						getSrcList : function() {
							return window.RtfImages[this.channel];
						},

						emptySrcList : function() {
							array.forEach(this.srcs, function(src, index) {
								window.RtfImages[this.channel] = array.filter(
										window.RtfImages[this.channel],
										function(i) {
											return i != src
										});
							}, this);
							this.srcs.length = 0;
						}
					});

		});