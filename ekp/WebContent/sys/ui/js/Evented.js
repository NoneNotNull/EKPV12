
define(function(require, exports, module) {
	require('lui/Class');
	var Evented = {
			_init_signal: function() {
				this._signals = {};
			},
			_add_singal: function(type, fn, ctx, one) {
				var signal = this._signals[type];
				if (signal == null) {
					signal = [];
					this._signals[type] = signal;
				}
				signal.push({fn: fn, ctx: ctx, one: one});
				return this;
			},
			on: function(type, fn, ctx) {
				return this._add_singal(type, fn, ctx, false);
			},
			one: function(type, fn, ctx) {
				return this._add_singal(type, fn, ctx, true);
			},
			emit: function() {
				var signal = this._signals[arguments[0]];
				if (signal) {
					var args = [];
					for (i = 1, len = arguments.length; i < len; i++) {
						args[i - 1] = arguments[i];
					}
					var destroyeds = [];
					for (var i = 0; i < signal.length; i ++) {
						try {
							var _signal = signal[i];
							if (_signal.ctx != null && this._destroyed) {
								destroyeds.push(_signal);
								continue;
							}
							_signal.fn.apply(_signal.ctx || this, args);
							if (_signal.one) {
								destroyeds.push(_signal);
							}
						} catch (e) {
							if (window.console)
								console.error("Evented.emit:id="+this.id, e.stack);
						}
					}
					for (var i = 0; i < destroyeds.length; i ++) {
						this.off(arguments[0], destroyeds[i].fn, destroyeds[i].ctx);
					}
				} else {
//					if (window.console)
						//console.debug("Evented.emit: no signal '" + arguments[0] + "' listener!");
				}
				return this;
			},
			off: function() {
				if (arguments.length == 0) {
					this._signals = {};
					return;
				}
				if (arguments.length == 1) {
					this._signals[arguments[0]] = [];
					return;
				}
				var signal = this._signals[arguments[0]];
				if(signal==null)
					return;
				var fn = arguments[1];
				//var ctx = arguments.length > 2 ? arguments[2] : null;
				for (var i = 0; i < signal.length; i ++) {
					if (signal[i].fn == fn) {
						signal.splice(i, 1);
						return this;
					}
				}
				return this;
			},
			fire: function(evt) {
				if (!evt.source) {
					evt.source = this;
				}
				var caller = this;
				while (caller) {
					caller.emit(evt.name, evt);
					if (evt.stopType && caller instanceof evt.stopType) {
						break;
					}
					if (evt.stop == true) {
						break;
					}
					caller = caller.parent;
				}
			}
	};
	module.exports = Evented;
});