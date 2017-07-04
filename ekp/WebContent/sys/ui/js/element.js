define(function(require, exports, module) {
	var Class = require("lui/Class");
	var base = require("lui/base");
  
	var AbstractSource = base.DataSource;
	
	var AbstractRender = base.DataRender;
	 
	var Text = base.Component.extend({
		initProps : function(_config){
			this.config = _config;
			if (this.config.style)
				this.element.attr("style",this.config.style);
			if(this.config.text)
				this.element.html(this.config.text);
		},
		draw :function(){
			this.element.show();
		}
	}); 
	exports.Text = Text;
	exports.AbstractSource = AbstractSource;
	exports.AbstractRender = AbstractRender;
});