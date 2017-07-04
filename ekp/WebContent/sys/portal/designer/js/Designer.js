define(function(require, exports, module) {	
	//require('sys/portal/designer/css/design.css');
	var $ = require("lui/jquery");
	var Class = require("lui/Class");
	var Evented = require('lui/Evented');
	var HtmlFormat = require('./HtmlFormat');
	var Toolbar = require('./Toolbar');
	var JSON = require("./JSON");

	 
	if(window.LDESIGNER==null){
		window.LDESIGNER={};
	}
	 

	var Desginer = new Class.create(Evented, {
		initialize : function(config) {
			var self = this;
			this.scene = config.scene;
			this.contextPath = config.contextPath;
			this.ref = config.ref;
			this.pageProperties = {};
			this.source = $(document.getElementById(config.element));
			if($(this.source.val()).is("div[portal-type='Template']")){
				var tObj = $(this.source.val());
				this.ref = tObj.attr("ref");
				var tconfig = tObj.attr("data-config");
				if($.trim(tconfig)!=""){
					$.extend(this.pageProperties, toJSON(unescape(tconfig)));
				}
			}
			this.element = $("<div></div>"); 
			this.source.after(this.element);
			this.toolbar  = new Toolbar({"element":$("<div style='text-align: left;'></div>"),"desginer":this});
			//this.source.hide();
			this.editor = $("<iframe style='width:100%;height:500px;background-color: white;' frameborder='0'></iframe>");
			if(config.style){
				this.editor.attr("style",this.editor.attr("style") + config.style);
				//this.editor.attr("style",config.style);
			}
			this.element.append(this.toolbar.element);
			this.element.append(this.editor);
			
			this.children = [];
			this.instances = null;
			this.editWindow = null;
			this.editDocument = null;

			Com_Parameter.event["submit"].unshift(function() {
				//debugger;
				self.source.val(self.getValue());
				return true;
			});
		},
		addChild : function(obj){
			this.children.push(obj);
		},
		start : function(){
			var self = this;
			this.editor.off().bind("load",function(){
				self.editWindow = this.contentWindow;
				self.editDocument = null;
				self.editDocument = $(self.editWindow.document);
				/*
				self.onResize();
				$(self.editWindow).resize(function(){
					self.onResize();
				});
				*/
				//self.editDocument.find("body").prepend("<link rel='stylesheet' href='"+self.contextPath+"/sys/portal/designer/css/design.css'/>");
				self.editDocument.find("head").append("<link rel='stylesheet' href='"+self.contextPath+"/sys/portal/designer/css/design.css'/>");
				//加载完模板后初始可编辑区域
				self.instances = null;
				//alert("aaaaaaaaaaaa")
				self.setValue($.trim(self.source.val()));				
			});
			this.editor.attr("src",""+self.contextPath+"/sys/portal/designer/jsp/template.jsp?ref="+encodeURIComponent(this.ref)+"&v=427");
			return this;
		},
		onResize : function(){
			this.editDocument = $(this.editWindow.document);
			var h = this.editDocument.height();
			var w = this.editDocument.width();
			this.editor.height(h).width(w);
		},
		destroy : function(){
			for(var i=this.children.length-1;i>=0;i--){
				this.children[i].destroy();				
			}
		},
		setValue : function(val){
			var self = this; 
			this.children = [];
			var body = self.editDocument.find("body");
			var temp = $("<div>"+val+"</div>");
			body.append(temp.hide());
			//可编辑区域
			try{
				body.find("div[data-lui-mark='template:block']").each(function(){
					var block = $(this);
					var key = block.attr("key");
					var keyValue = temp.find("div[portal-type='./Editable'][portal-key='"+key+"']");
					if(keyValue != null && keyValue.length > 0){
						block.append(keyValue);
					}else{
						block.append("<div portal-key='"+key+"' portal-type='./Editable'></div>");
					}
				});
				body.find("div[data-lui-mark='template:header']").each(function(){
					var header = $(this);
					var key = header.attr("key");
					var keyValue = temp.find("div[portal-type='./Header'][portal-key='"+key+"']");
					if(keyValue != null && keyValue.length > 0){
						header.append(keyValue);
					}else{
						header.append("<div portal-key='"+key+"' portal-type='./Header'></div>");
					}
				});
				body.find("div[data-lui-mark='template:footer']").each(function(){
					var footer = $(this);
					var key = footer.attr("key");
					var keyValue = temp.find("div[portal-type='./Footer'][portal-key='"+key+"']");
					if(keyValue != null && keyValue.length > 0){
						footer.append(keyValue);
					}else{
						footer.append("<div portal-key='"+key+"' portal-type='./Footer'></div>");
					}
				});
			}catch (e) {
				if(window.console)
					console.log(e);
			}
			temp.remove();
			delete temp;
			self.parser();
		},
		setTemplate : function(tmpl){			
			this.source.val(this.getValue());
			this.ref = tmpl.ref;
			if(this.children != null){
				for(var i=this.children.length-1;i>=0;i--){
					this.children[i].destroy();
				}
			}
			this.start();
		},
		getPageProperties : function(){
			return this.pageProperties;
		},
		setPageProperties : function(data){
			this.pageProperties = data;
		},
		setTheme : function(theme){
			
		},
		parser : function(){
			var self = this;
			var modules = [];
			var elements = [];
			var body = this.editDocument.find("body");
			body.find("[portal-type]").each(function() {
				elements.push(this);
				modules.push($(this).attr('portal-type'));
			});
			if (modules.length) {
				require.async(modules, function() {
					self.instances = {};
					for (var i = 0; i < arguments.length; i++) {
						var clz = arguments[i];
						var instance = new clz({"body":body, "element": elements[i]});
						self.instances[instance.key] = instance;
					}
					
					var key = "";
					for (key in self.instances)   {
						try {
							var instance = self.instances[key];
							var parentElement = instance.element.parents("[portal-type]");
							if (parentElement.length < 1) { 
								instance.setParent(self);
								self.addChild(instance);
							}else{
								var parentElement = $(parentElement[0]);
								var parent = self.instances[parentElement.attr('portal-key')];		
								instance.setParent(parent);
								parent.addChild(instance);
							}
						} catch(e) {
							if (window.console)
								console.error(e.stack);
						}
					}
					for (key in self.instances)   {
						var instance = self.instances[key];
						if(instance.startup)
							instance.startup();
					}
					
					delete modules;
					delete elements;			
				});
			}
		},
		getValue : function(){
			var val = [];
			for(var i=0;i<this.children.length;i++){				
				val.push(this.getOuterHTML(this.children[i].element.get(0)));
			}
			val = val.join('\r\n');
			//debugger;
			var template = "ref='"+this.ref+"'";
			val = "<div portal-type='Template' "+template+" data-config=\"" + escape(JSON.stringify(this.getPageProperties())) + "\">"+val+"</div>";
			val = val.replace(/jquery([0-9])+\=\"([0-9])+\"/ig,'');
			return HtmlFormat(val.replace(/^\s+/, ''), 4, ' ', 80);
		},
		getOuterHTML : function(el){
			if(document.documentMode){
				return el.outerHTML;
			}else{
				var div = document.createElement("div");
				div.appendChild(el.cloneNode(true));
				var contents = div.innerHTML;
				div = null;
				delete div;
				return contents;
			}
		}
	});
	
	var toJSON = function(str){
		try{
			return eval("("+str+")");
			//return JSON.parse(str);
			//return (new Function("return (" + str + ");"))();
		}catch(e){
			alert(str);
			alert(e);
		}
	};
	module.exports = Desginer;
});