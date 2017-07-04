define(function(require, exports, module) {	
	var $ = require("lui/jquery");
	var dialog = require("lui/dialog");
	var Base = require("./Base");
	var Util = require("./Util");
	var msg = require("lang!sys-portal:desgin.msg");
	var Footer = Base.extend({
		initialize : function($super,config) {
			$super(config);
		},
		startup:function(){
			var self = this;
			this.footerEditor = (function(){
				if(self.element.children(".footerEditor").length >0){					 
					return self.element.children(".footerEditor"); 
				}else{
					var x = $("<div class='footerEditor'></div>");
					self.element.append(x);
					return x;
				}
			})();
			this.footerPreview =  (function(){
				if(self.footerEditor.children(".footerPreview").length >0){					 
					return self.footerEditor.children(".footerPreview"); 
				}else{
					var x = $("<div class='footerPreview'>"+msg['desgin.msg.deffooter']+"</div>");
					self.footerEditor.append(x);
					return x;
				}
			})();
			this.fdFooter = (function(){
				if(self.element.children("[name='fdFooter']").length >0){					 
					return self.element.children("[name='fdFooter']"); 
				}else{
					var x = $("<input type='hidden' name='fdFooter' value='footer.default' />");
					self.element.append(x);
					return x;
				}
			})();
			this.fdFooterVars = (function(){
				if(self.element.children("[name='fdFooterVars']").length >0){					 
					return self.element.children("[name='fdFooterVars']"); 
				}else{
					var x = $("<input type='hidden' name='fdFooterVars' />");
					self.element.append(x);
					return x;
				}
			})();
			this.edit = (function(){
				if(self.footerEditor.children(".editFooter").length >0){					 
					return self.footerEditor.children(".editFooter"); 
				}else{
					var x = $("<div class='editFooter'>"+msg['desgin.msg.setting']+"</div>");
					self.footerEditor.append(x);
					return x;
				}
			})(); 
			this.edit.click(function(){
				var param = {};
				param.fdFooter = $(self.fdFooter).val();
				param.fdFooterVars = $(self.fdFooterVars).val();
				Util.showDialog(""+msg['desgin.msg.configf']+"","/sys/portal/designer/jsp/configfooter.jsp?scene="+self.getDesigner().scene,function(value){
					if(value==null)
						return;
					
					$(self.fdFooter).val(value.fdFooter);
					$(self.footerPreview).html(value.fdFooterName);
					$(self.fdFooterVars).val(value.fdFooterVars);
				},700,400).dialogParameter = param;
			});
		},
		destroy : function($super){ 
			$super();
		}
	});
	module.exports = Footer;
});