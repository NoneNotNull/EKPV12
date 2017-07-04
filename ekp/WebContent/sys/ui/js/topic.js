

define(function(require, exports, module) {
	var Class = require('lui/Class');
	var base = require('lui/base');
	var Evented = require("lui/Evented");
	
	var Topic = base.Base.extend(Evented, {
		initialize : function($super) {
			$super();
			this._init_signal();
		}
	});
	
	var Group = new Class.create({
		initialize: function() {
			this.topics = new Topic();
		},
		//ln为回调函数，ctx构造回调函数中this
		subscribe: function(name, ln, ctx) {
			this.topics.on(name, ln, ctx);
		},
		//topic构造回调函数中this
		publish: function(name, topic) {
			this.topics.emit(name, topic);
		},
		unsubscribe: function(name, ln) {
			this.topics.off(name, ln);
		}
	});
	
	var groups = {};
	
	var get_group = function(group) {
		if (!group) {
			return defaultGroup;
		}
		if (group instanceof base.Base) {
			var parent = group;
			while(parent) {
				if (parent.channel) {
					return get_group(parent.channel);
				}
				parent = parent.parent;
			}
			return defaultGroup;
		}
		var g = groups[group];
		if (g == null) {
			g = new Group();
			groups[group] = g;
		}
		return g;
	};
	
	var defaultGroup = new Group();
	
	Object.extend(module.exports, defaultGroup);
	module.exports.group = get_group;
	module.exports.channel = get_group;
	
});