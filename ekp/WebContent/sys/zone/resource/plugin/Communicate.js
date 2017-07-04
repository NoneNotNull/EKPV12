
define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	
	var Communicate  = function (config) {
		this.elementId = config.elementId || null;
		this.navs = [];
		this.icons = [];
		this.params = $.extend({}, config);
	};
	Communicate.prototype.push = function(icon,nav){
		 this.icons.push(icon);
		 this.navs.push(nav);
	};
	Communicate.prototype.show = function() {
		var self = this;
		if(self.params.isSelf) {
			return;
		}
		var container = $("<ul class='lui_zone_contact clearfloat'/>");
		$("#" + self.elementId).append(container);
		
		for(var i = 0 ; i < self.navs.length; i++) {
			~function(__i) {
				var __$content = $("<li class='lui_zone_contact_item'><a href='javascript:;" 
												+ "'><img src='" + env.fn.formatUrl(self.icons[__i]) +"'></a></li>");
				container.append(__$content);
				self.navs[__i].onShow(__$content, self.params);
				if(self.navs[__i].onClick) {
					__$content.on("click", function() {
						self.navs[__i].onClick(__$content, self.params);
					});
				}
			}(i);
		}
	};
	
	
	module.exports = Communicate;
});