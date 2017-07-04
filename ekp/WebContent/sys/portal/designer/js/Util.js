define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var dialog = require("lui/dialog");
	var dragdrop = require("lui/dragdrop");
	var JSON = require("./JSON");
	var msg = require("lang!sys-portal:desgin.msg");
	var showDialog = function(title,url,cb,w,h){
		w = w || 700;
		h = h || 300;
		return dialog.iframe(url,title,cb,{"width":w,"height":h});
	};
	var addVBox = function(self){
		return {
			"icon":"editMenuIconAddBox",
			"text":""+msg['desgin.msg.addtable'],
			fn:function(){
				var xobj = this;
				require.async(['./VBox','./Container','./Editable'],function(VBox,Container,Editable){
					var param = {};
					//alert(self.element.attr("data-config"))
					if(self instanceof Editable){
						var editableHeight = null;
						if($.trim(self.element.attr("data-config"))==""){
							editableHeight = self.element.outerWidth(true);
							self.element.attr("data-config",escape(JSON.stringify({"columnWidth":editableHeight,"vSpacing":self.config.vSpacing})));
						}else{
							var conf = toJSON(unescape(self.element.attr("data-config")));
							editableHeight = conf.columnWidth;
							if(editableHeight==null){
								editableHeight = self.element.outerWidth(true);
								conf.columnWidth = editableHeight;
								self.element.attr("data-config",escape(JSON.stringify(conf)));
							}
						}
						param.boxWidth = editableHeight;
						param.boxStyle = "";
					}else{
						var conf = toJSON(unescape(self.element.attr("data-config")));
						param.boxWidth = conf.columnWidth;
						param.boxStyle = conf.boxStyle;
					}
					showDialog(xobj.text,'/sys/portal/designer/jsp/addvbox.jsp',function(value){
						if(!value){
							return;
						}
						var xtable = $("<table width='100%' portal-key='"+self.uuid()+"' portal-type='./VBox'></table>");
						xtable.attr("data-config",escape(JSON.stringify({column:value.column,boxWidth:value.boxWidth,boxStyle:value.boxStyle})));
						xtable.attr("width",value.boxWidth);
						self.element.append(xtable);
						
						var xvbox = new VBox({"body":self.body ,"element":xtable});
						xvbox.setParent(self);
						self.addChild(xvbox);
						var xtr = $("<tr></tr>").appendTo(xtable);
						for ( var i = 0; i < value.cols.length; i++) {
							var col = value.cols[i];
							var xtd = $("<td valign='top' portal-key='"+self.uuid()+"' portal-type='./Container'></td>");
							xtd.attr("data-config",escape(JSON.stringify(col)));
							xtd.attr("width",col.columnWidth);
							var c = new Container({"body":self.body ,"element":xtd});
							c.setParent(xvbox);
							xvbox.addChild(c);
							if(i>0){
								var xtdSpacing = $("<td width='"+col.hSpacing+"' class='containerSpacing'></td>");
								xtdSpacing.attr("width",col.hSpacing);
								xtr.append(xtdSpacing);
								xtdSpacing.attr("style","min-width:"+col.hSpacing+"px;");
								c.spacingElement = xtdSpacing;
							}
							xtr.append(xtd);
							c.startup();
						}
						xvbox.startup();
					},750,500).dialogParameter=param;				
				});				
			}
		};
	}; 
	var configVBox = function(self){
		return {
			"icon":"editMenuIconConfig",
			"text":""+msg['desgin.msg.configtable'],
			fn:function(){
				var xobj = this;
				require.async(['./VBox','./Container'],function(VBox,Container){
					var val = toJSON(unescape(self.parent.element.attr("data-config")));
					var param = {};
					param.boxWidth = val.boxWidth;
					param.column = val.column;
					param.boxStyle = val.boxStyle;
					param.cols=[];
					for(var i=0;i<param.column;i++){
						var obj = self.parent.children[i];
						var col = toJSON(unescape(obj.element.attr("data-config"))); 
						param.cols.push(col);
					}
					showDialog(xobj.text,'/sys/portal/designer/jsp/addvbox.jsp',function(value){
						if(!value){
							return;
						}
						self.parent.element.attr("data-config",escape(JSON.stringify({column:value.column,boxWidth:value.boxWidth,boxStyle:value.boxStyle})));
						for(var i=0;i<self.parent.children.length;i++){
							var obj = self.parent.children[i]; 
							if(obj.spacingElement != null){
								obj.spacingElement.attr("width",value.cols[i].hSpacing);
								obj.spacingElement.attr("style","min-width:"+value.cols[i].hSpacing+"px;");
							}
							obj.element.children(".widgetDock").css("height",value.cols[i].vSpacing);
							obj.element.attr("width",value.cols[i].columnWidth);
							obj.config.vSpacing = value.cols[i].vSpacing;
							obj.dropElement.attr("vSpacing",value.cols[i].vSpacing);	
							obj.element.attr("data-config",escape(JSON.stringify(value.cols[i])));
						}
						if(value.cols.length > self.parent.children.length){
							for ( var i = self.parent.children.length; i < value.cols.length; i++) {
								var col = value.cols[i];
								var xtdSpacing = $("<td width='"+col.hSpacing+"' class='containerSpacing'></td>");
								xtdSpacing.attr("width",col.hSpacing);
								xtdSpacing.attr("style","min-width:"+col.hSpacing+"px;");
								var xtd = $("<td valign='top' portal-key='"+self.uuid()+"' portal-type='./Container'></td>");
								xtd.attr("data-config",escape(JSON.stringify(col)));
								xtd.attr("width",col.columnWidth);
								var obj = new Container({"body":self.body ,"element":xtd});
								obj.setParent(self.parent);
								self.parent.addChild(obj);
								self.parent.element.children("tbody").children("tr").append(xtdSpacing);
								obj.spacingElement = xtdSpacing; 	
								self.parent.element.children("tbody").children("tr").append(xtd);
								obj.startup();
							}
						}
						self.parent.alculateWidth();
					},750,500).dialogParameter = param;
				});
			}
		};
	};
	var addWidget = function(self){
		return {
			"icon":"editMenuIconAddWdiget",
			"text":""+msg['desgin.msg.addwidget'],
			fn:function(value){
				var xobj = this;
				require.async(['./Widget'],function(Widget){
					showDialog(xobj.text,'/sys/portal/designer/jsp/addwidget.jsp?scene='+self.getDesigner().scene,function(value){
						if(!value){
							return;
						}
						var temp = $("<div portal-key='"+self.uuid()+"' portal-type='./Widget'><script type='text/config'>"+JSON.stringify(value)+"</script></div>");
						if(value.panelType=="h" || value.panelType=="panel" || value.panelType=="none"){
							if($.trim(value.height) != ""){
								temp.css("height",value.height);
							}
						}else if(value.panelType=="v"){
							temp.css("height","");
						}						
						var w = new Widget({"body":self.body ,"element":temp});
						w.setting = value;
						w.setParent(self);
						self.addChild(w);
						self.element.append(temp);
						w.startup();
					},700,500);
				});
			}
		};
	};
	var configWidget = function(self){
		return {
			"icon":"editMenuIconConfig",
			"text":""+msg['desgin.msg.configwidget'],
			fn:function(value){
				var xobj = this;
				require.async(['./Widget'],function(Widget){
					showDialog(xobj.text,'/sys/portal/designer/jsp/addwidget.jsp?scene='+self.getDesigner().scene,function(value){
						if(!value){
							return;
						}
						//debugger;
						self.element.children("script[type='text/config']").remove();
						self.element.prepend("<script type='text/config'>"+JSON.stringify(value)+"</script>");
						self.setting = value;
						if(value.panelType=="h" || value.panelType=="panel" || value.panelType=="none"){
							if($.trim(value.height) != ""){
								self.element.css("height",value.height);
							}else{
								self.element.css("height","");					
							}
						}else if(value.panelType=="v"){
							self.element.css("height","");
						}
						self.preview.render();
					},700,500).dialogParameter = self.setting;
				});
			}
		};
	};
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
	module.exports.showDialog 	= showDialog;
	module.exports.addVBox 		= addVBox;
	module.exports.configVBox 	= configVBox;
	module.exports.addWidget 	= addWidget;
	module.exports.configWidget = configWidget;
	module.exports.toJSON 		= toJSON;
});