define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var base = require("lui/base");
	var overlay = require("lui/overlay");

	var Default = base.Component.extend({
		initProps : function(_config) {
		},
		startup : function() {

		}
	});
	var AutoClose = base.Component.extend({
		initProps : function(_config) {
			this.dialog = _config.dialog;
			this.timeout = _config.timeout;
		},

		// 定时关闭
		time : function(second) {
			var self = this, timer = self.timer;
			eventTimer = self.eventTimer;
			timer && clearTimeout(timer);
			if (second) {
				self.timer = setTimeout(function() {
					self.dialog.hide();
				}, 1000 * second);
				this.onErase(function() {
					clearTimeout(self.timer);
				});

				this.onErase(function() {
					clearTimeout(self.eventTimer);
				});
			}
			return self;
		},

		startup : function() {
			var self = this;
			this.overlay.content.on('layoutDone', function() {
				self.time(self.timeout);
			})

		}
	});

	exports.Default = Default;
	exports.AutoClose = AutoClose;
});