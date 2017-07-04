define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var Class = require("lui/Class");
	var Evented = require('lui/Evented');
	var msg = require("lang!sys-portal:desgin.msg");
	var Util = require("./Util");
	var Toolbar = new Class.create(Evented, {
		initialize : function(config) {
			var self = this;
			this.element = config.element;
			this.desginer = config.desginer;
			this.element.css({"background":"white","height":"30px","line-height":"30px"});
			
			//显示源码
			var getV =  $("<div style='display: inline-block;cursor:pointer;'><span class='lui_icon_s lui_icon_s_icon_value' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.editorMode']+"</span></div>");
			getV.click(function(){				 
				if(self.desginer.showSource != null && self.desginer.showSource===true){
					self.desginer.source.hide();
					self.desginer.destroy();
					self.desginer.setValue(self.desginer.source.val());		
					self.desginer.showSource = false;
					$(this).html("<span class='lui_icon_s lui_icon_s_icon_value' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.editorMode']+"</span>");			
				}else{
					var os = self.desginer.editor.offset();
					self.desginer.source
						.css({"position":"absolute","left":os.left,"top":os.top,"z-index":200})
						.width(self.desginer.editor.width())
						.height(self.desginer.editor.height())
						.show();
					self.desginer.source.val(self.desginer.getValue());
					self.desginer.showSource = true;
					$(this).html("<span class='lui_icon_s lui_icon_s_icon_edit' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.designMode']+"</span>");
				}
			});
			this.element.append(getV);
			/*
			//显示设计界面			
			this.element.append("<div style='display: inline-block;'>&nbsp;|&nbsp;</div>");
			var showE = $("<div style='display: inline-block;'>编辑</div>");
			showE.click(function(){
				
			});
			this.element.append(showE);
			*/
			this.element.append("<div style='display: inline-block;padding-right:10px;padding-left:10px;'>&nbsp;|&nbsp;</div>");

			//修改模版
			var showT = $("<div style='display: inline-block;cursor:pointer;'><span class='lui_icon_s lui_icon_s_icon_template' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.selectTemplate']+"</span></div>");
			showT.click(function(){
				if(self.desginer.showSource == null || self.desginer.showSource===false){
					Util.showDialog(msg['desgin.msg.selectTemplate'],"/sys/portal/designer/jsp/selecttemplate.jsp?scene="+self.desginer.scene,function(value){
						if(value==null){
							return ;
						}
						self.desginer.setTemplate(value);
					},750,550);
				}
			});
			this.element.append(showT);
			
			//页面属性
			this.element.append("<div style='display: inline-block;padding-right:10px;padding-left:10px;'>&nbsp;|&nbsp;</div>");
			var showP = $("<div style='display: inline-block;cursor:pointer;'><span class='lui_icon_s lui_icon_s_icon_template' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.pageProperties']+"</span></div>");
			showP.click(function(){
				if(self.desginer.showSource == null || self.desginer.showSource===false){
					Util.showDialog(msg['desgin.msg.pageProperties'],"/sys/portal/designer/jsp/pageproperties.jsp?scene="+self.desginer.scene,function(value){
						if(value==null){
							return ;
						}
						self.desginer.setPageProperties(value);
					},550,350).dialogParameter=self.desginer.getPageProperties();
				}
			});
			this.element.append(showP);
			/**
			//选择布局
			this.element.append("<div style='display: inline-block;'>&nbsp;|&nbsp;</div>");
			var showL = $("<div style='display: inline-block;'>选择布局</div>");
			showL.click(function(){
				Util.showDialog("选择模版","/sys/portal/designer/jsp/selecttemplate.jsp",function(value){
					if(value==null){
						return ;
					}
					self.desginer.setTemplate(value);
				},750,550);
			});
			this.element.append(showL);
			**/

			this.element.append("<div style='display: inline-block;padding-right:10px;padding-left:10px;'>&nbsp;|&nbsp;</div>");
			var showM = $("<div style='display: inline-block;cursor:pointer;'><span class='lui_icon_s lui_icon_s_icon_fullscreen' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.fullscreen']+"</span></div>");
			showM.click(function(){
				if(self.desginer.showSource != null && self.desginer.showSource===true){
					self.desginer.source.hide();
					self.desginer.destroy();
					self.desginer.setValue(self.desginer.source.val());		
					self.desginer.showSource = false;
					$(this).html("<span class='lui_icon_s lui_icon_s_icon_value' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.editorMode']+"</span>");			
				}
				if(!$(this).data("isMax")){
					self.desginer.element.css({
						"position": "absolute",
						"z-index": 10,
						"top": "0px",
						"right": "0px",
						"left": "0px",
						"bottom": "0px"
					});
					self.desginer.editor.height(self.desginer.element.outerHeight(true)-self.element.outerHeight(true)-5);
					$(this).html("<span class='lui_icon_s lui_icon_s_icon_miniscreen' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.restore']+"</span>");
					$(this).data("isMax",true);
				}else{
					self.desginer.element.css({
						"position": ""
					});
					$(this).html("<span class='lui_icon_s lui_icon_s_icon_fullscreen' style='vertical-align:middle;'></span><span class='com_btn_link_light' style='vertical-align:middle;margin-left:3px;'>"+msg['desgin.msg.fullscreen']+"</span>");
					$(this).data("isMax",false);
				}				 
			});
			this.element.append(showM);
			
		}
	});
	module.exports = Toolbar;
});