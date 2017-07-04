define(function(require, exports, module) {	
	var $ = require("lui/jquery");
	var dialog = require("lui/dialog");
	var Base = require("./Base");
	var Util = require("./Util");
	var msg = require("lang!sys-portal:desgin.msg");
	var Header = Base.extend({
		initialize : function($super,config) {
			$super(config);
		},
		startup:function(){
			var self = this;
			this.headerEditor = (function(){
				if(self.element.children(".headerEditor").length >0){					 
					return self.element.children(".headerEditor"); 
				}else{
					var x = $("<div class='headerEditor'></div>");
					self.element.append(x);
					return x;
				}
			})();
			this.headerPreview =  (function(){
				if(self.headerEditor.find(".headerPreview").length >0){					 
					return self.headerEditor.find(".headerPreview"); 
				}else{
					var x = $("<div class='headerPreview'>"+msg['desgin.msg.defheader']+"</div>");
					self.headerEditor.append(x);
					return x;
				}
			})();
			this.fdHeader = (function(){
				if(self.element.children("[name='fdHeader']").length >0){					 
					return self.element.children("[name='fdHeader']"); 
				}else{
					var x = $("<input type='hidden' name='fdHeader' value='header.default' />");
					self.element.append(x);
					return x;
				}
			})();
			this.fdHeaderVars = (function(){
				if(self.element.children("[name='fdHeaderVars']").length >0){					 
					return self.element.children("[name='fdHeaderVars']"); 
				}else{
					var x = $("<input type='hidden' name='fdHeaderVars' />");
					self.element.append(x);
					return x;
				}
			})();
			this.fdLogo = (function(){
				if(self.element.children("[name='fdLogo']").length >0){					 
					return self.element.children("[name='fdLogo']"); 
				}else{
					var x = $("<input type='hidden' name='fdLogo' />");
					self.element.append(x);
					return x;
				}
			})();

			this.logoEditor = (function(){
				if(self.element.children(".logoDiv").length >0){					 
					return self.element.children(".logoDiv"); 
				}else{
					var x = $("<div class='logoDiv'></div>");
					self.element.append(x);
					return x;
				}
			})();
			
			this.logoImg = (function(){
				if(self.logoEditor.children(".logoImg").length >0){					 
					return self.logoEditor.children(".logoImg"); 
				}else{
					var x = $("<img class='logoImg' src='"+self.parent.contextPath+"/resource/images/logo.png' />");
					self.logoEditor.append(x);
					return x;
				}
			})();
			this.logoEdit = (function(){
				if(self.logoEditor.children(".logoEdit").length >0){					 
					return self.logoEditor.children(".logoEdit"); 
				}else{
					var x = $("<div class='logoEdit'>"+msg['desgin.msg.select']+"LOGO</div>");
					self.logoEditor.append(x);
					return x;
				}
			})();
			this.edit = (function(){
				if(self.headerEditor.find(".editHeader").length >0){					 
					return self.headerEditor.find(".editHeader"); 
				}else{
					var x = $("<div class='editHeader'>"+msg['desgin.msg.setting']+"</div>");
					self.headerEditor.append(x);
					return x;
				}
			})();
			this.logoEdit.click(function(){
				Util.showDialog(""+msg['desgin.msg.select']+"Logo","/sys/ui/jsp/logo.jsp",function(value){
					if(value==null)
						return;
					$(self.fdLogo).val(value);
					$(self.logoImg).attr("src",self.parent.contextPath+value);
				},500,400);
			});
			this.edit.click(function(){
				var param = {};
				param.fdHeader = $(self.fdHeader).val();
				param.fdHeaderVars = $(self.fdHeaderVars).val();
				Util.showDialog(""+msg['desgin.msg.configh']+"","/sys/portal/designer/jsp/configheader.jsp?scene="+self.getDesigner().scene,function(value){
					if(value==null)
						return;

					$(self.fdHeader).val(value.fdHeader);
					$(self.headerPreview).html(value.fdHeaderName);
					$(self.fdHeaderVars).val(value.fdHeaderVars);
				},700,400).dialogParameter = param;
			});
		},
		destroy : function($super){ 
			$super();
		}
	});
	module.exports = Header;
});