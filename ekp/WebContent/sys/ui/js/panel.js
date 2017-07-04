// JavaScript Document
define(function(require, exports, module) {
	require("theme!panel");
	var $ = require("lui/jquery");
	var base = require("lui/base");
	var env = require("lui/util/env");
	var layout = require("lui/view/layout");
	var topic = require("lui/topic");
	 
	
	var AbstractContent = base.Container.extend({
		initProps : function(_config){
			this.isShow = false;	
			this.config = _config;	
			this.isLoad = false;
			this.title = _config.title; 
			this.element.show();
			this.vars = {};
			if(this.config.vars)
				this.vars = this.config.vars;
			if(this.config.toggle!=null)
				this.toggle = this.config.toggle;
			if(this.config.expand!=null)
				this.expand = this.config.expand;
			//debugger;
			if(_config.style)
				this.element.attr("style",(this.element.attr("style") ? this.element.attr("style") + ";" : "" ) + _config.style);
		},
		getSize : function(){
			return this.parent.getSize();
		}
	}); 
	var AbstractPanel = base.Container.extend({
		initProps : function($super,_config){
			this.config = _config;
			this.contents = [];	 
			this.vars = {};
			this.navs = [];
			if(_config.style)
				this.element.attr("style",(this.element.attr("style") ? this.element.attr("style") + ";" : "" ) + _config.style);
			$.extend(this.vars,_config.vars);
		},	
		getPanelSize : function() {
			return {width : this.frameWidth ,height : this.frameHeight};
		},
		getSize : function($super){
			var size = $super();
			size.width = size.width - this.getPanelSize().width;
			size.height = size.height - this.getPanelSize().height;
			return size;
		},	
		erase :	function($super,includeChild){
			if(this.isDrawed){
				if(includeChild==null || includeChild){
					$super(includeChild);
				}else{
					this.tempFrame = $("<div data-lui-mark='temp'/>");
					this.element.append(this.tempFrame);
					for(var i=0;i<this.contents.length;i++){
						this.tempFrame.append(this.contents[i].getRootElement());
					}
					var cd = this.element.children();
					for(var i=cd.length-1;i>=0;i--){
						if((cd[i].getAttribute("data-lui-mark")||"")!="temp"){
							cd.remove();
						}
					}
					for(var i=0;i<this.contents.length;i++){					
						this.element.append(this.contents[i].getRootElement());
					}
					this.tempFrame.remove();
				}
			}
			this.isDrawed = false;
		}, 
		parseToggleMark : function(dom) {			
			//切换按钮
			var self = this;
			var headNodes = dom.find("[data-lui-mark='panel.nav.head']");
			headNodes.each(function(index, domEle) {
				var headNode = $(domEle);
				self.headersNode.push(headNode);
				var toggleNode = headNode.find('[data-lui-mark="panel.nav.toggle"]')
				var len = self.togglesNode.length;
				self.togglesNode.push(toggleNode);
				if(self.contents[len].getToggle()){
					headNode.css('cursor','pointer');
					headNode.click(function(evt){	
						self.onToggle(len,null,null,evt);						 
					});
				}else{
					toggleNode.hide();
				}
			});
		},
		parseTextMark : function(dom){	
			var self = this;		
			var titleNodes = dom.find("[data-lui-mark='panel.nav.title']");
			titleNodes.each(function(index, domEle) {
				//标题文字
				var titleNode = $(domEle);
				self.titlesNode.push(titleNode);
				titleNode.append(self.contents[index].title);
			});
		},
		parseContentMark : function(dom){
			var self = this;
			var contentNodes = dom.find("[data-lui-mark='panel.contents']");
			if(contentNodes.length > 0){
				for(var i=0;i<this.contents.length;i++){
					contentNodes.append("<div data-lui-mark='panel.content'></div>");
				}
				dom.find("[data-lui-mark='panel.content']").map(function(){
					self.contentsNode.push($(this)); 
				});
			}else{
				dom.find("[data-lui-mark='panel.content']").map(function(){
					self.contentsNode.push($(this)); 
				});
			}
		},
		doLayout:function($super,obj){
			var self = this;
			  
			this.frame = $(obj);
			this.titlesNode = [];
			this.togglesNode = [];
			this.contentsNode = [];
			this.headersNode = [];
			
			
			this.titlesFrame = this.frame.find("[data-lui-mark='panel.nav.frame']");
			//获取标题的mark;
			this.parseTextMark(this.frame);
			//解析toggle的mark
			this.parseToggleMark(this.frame);
			//解析content的mark
			this.parseContentMark(this.frame);
			
			 
			this.element.append(this.frame);
			this.element.show();
			 
			//处理高度
			//获取frame的高度
			this.frameHeight = this.frame.height();
			this.frameWidth = this.frame.width();
			
			if(this.contentsNode.length > 0){
				//将所有子元素的Dom元素移动到指定位置
				for(var i=0;i<this.contents.length;i++){
					var obj = this.contents[i].getRootElement();
					this.contentsNode[i].hide().append(obj);
					this.markContent(obj,this.contents[i]);
				}
			}
			//window.console.log("panel.doLayout");
			$super(obj);
			
		},
		markContent : function(dom,content){
			if(content.config.extClass!=null){
				$(dom).addClass(content.config.extClass);
			}
		},
		addChild: function($super,obj) {
			if(obj instanceof layout.AbstractLayout){
				this.layout = obj;
			}else if(obj instanceof AbstractContent){
				this.contents.push(obj);
			}
			$super(obj);
		},
		resize : function(){
			for(var i=0;i<this.contents.length;i++){
				this.contents[i].resize();
			}
		}
	});
	 
	
	/**
	 * 多标签面板的定义
	 */
	var TabPanel = AbstractPanel.extend({	
		initProps : function($super,_config){
			$super(_config);
			this.selectedIndex = 0;
			if(_config.selectedIndex != null)
				this.selectedIndex = _config.selectedIndex;
		},
		doLayout:function($super,obj){
			$super(obj);
			var self = this;
			//处理切换
			this.navs = [];
			this.titlesFrame.each(function(index,domEle){
				var navFrame = $(domEle);
				var navTitle = null;
				var navSwitch = null;
				navFrame.click(function(){
					self.setSelectedIndex(index);
				});
				navSwitch = navFrame.attr("data-lui-switch-class");
				if(navFrame.find("[data-lui-mark='panel.nav.title']").length>0){
					navTitle = navFrame.find("[data-lui-mark='panel.nav.title']").get(0);
				}
				self.navs.push({"navFrame":navFrame,"navTitle":navTitle,"navSwitch":navSwitch});
			});	 
			//
			this.on("selectChange",function(data){
				this.setSelectedIndex(data.index);
			});
			this.emit("layoutDone");
			this.emit("selectChange",{"index":this.selectedIndex});
		},	
		
		setSelectedIndex:function(i){
			var evt = {	
				index : { before : this.selectedIndex ,after : i},
				panel : this,
				cancel : false
			};
			this.emit("indexChanged",evt);
			if(!evt.cancel){
				for(var j=0;j<this.contents.length;j++){
					this.contentsNode[j].hide();  
					if(this.navs[j].navFrame && this.navs[j].navSwitch){
						this.navs[j].navFrame.removeClass(this.navs[j].navSwitch);
					}
				}
				this.contentsNode[i].show();
				this.contents[i].load();
				if(this.navs[i].navFrame && this.navs[i].navSwitch){
					this.navs[i].navFrame.addClass(this.navs[i].navSwitch);
				}
				this.selectedIndex=i;
			}
		}
	});  
	var Panel = AbstractPanel.extend({
		initProps : function($super,cfg){
			$super(cfg);
			this.memoryExpand = cfg.memoryExpand ? ("Panel.mExp-" + Com_Parameter.CurrentUserId + "-" + cfg.memoryExpand) : false;
			this._memoryExpandObj = [];
		},
		isMemoryExpand: function(index) {
			if (this._memoryExpandObj.length) {
				if (this._memoryExpandObj.length > index) {
					return this._memoryExpandObj[index];
				}
			}
			else if (this.memoryExpand && window.localStorage && window.JSON) {
				var mData = localStorage.getItem(this.memoryExpand);
				if (mData != null && mData.length > 0) {
					var mObj = JSON.parse(mData);
					this._memoryExpandObj = mObj;
					if (mObj.length) {
						if (mObj.length > index) {
							return mObj[index];
						}
					}
				}
			}
			return this.contents[index].getExpand();
		},
		writeMemoryExpand: function(index, expand) {
			if (this.memoryExpand && window.localStorage && window.JSON) {
				var mData = localStorage.getItem(this.memoryExpand);
				var mObj = (mData != null && mData.length > 0) ? JSON.parse(mData) : [];
				mObj[index] = expand;
				localStorage.setItem(this.memoryExpand, JSON.stringify(mObj));
				this._memoryExpandObj = mObj;
			}
		},
		writeMemoryExpands: function(expandArray) {
			if (this.memoryExpand && window.localStorage && window.JSON) {
				localStorage.setItem(this.memoryExpand, JSON.stringify(expandArray));
			}
		},
		doLayout:function($super,obj){
			$super(obj);
			var expandArray = [];
			for ( var j = 0; j < this.contents.length; j++) {
				if(this.contents[j].getToggle()){
					if(this.isMemoryExpand(j)){
						expandArray.push(true);
						this.onToggle(j,true);
					}else{
						expandArray.push(false);
						this.onToggle(j,true,true);
					}
				}else{
					expandArray.push(true);
					this.onToggle(j,true);
				}
			}
			this.writeMemoryExpands(expandArray);
			this.emit("layoutDone");
		},
		onToggle : function(i,isInit,isShow,evt) {
			var self = this;
			var content = this.contentsNode[i];
			var toggle = this.togglesNode[i];
			var evt = {
				index : i,
				panel : this,
				cancel : false,
				init : isInit,
				content : content,		
				visible : isShow || this.contents[i].isShow
			};
			self.emit("toggleBefore", evt);
			if (!evt.cancel) {
				if(evt.visible){
					if(evt.init)
						content.hide();
					else
						content.slideUp(300);
					if(toggle){
						toggle.addClass(toggle.attr("data-lui-switch-class"));
					} 
				}else{
					if(evt.init){
						content.show();
						this.contents[i].load();
					}else
						content.slideDown(300,function(){
							self.contents[i].load();
						});
					
					if(toggle){		
						toggle.removeClass(toggle.attr("data-lui-switch-class"));
					} 
				}
			}
			if(evt.visible){
				this.contents[i].isShow = false;					
			}else{
				this.contents[i].isShow = true;					
			} 
			if (!evt.init) {
				this.writeMemoryExpand(i, !evt.visible);
			}
			self.emit("toggleAfter", evt);
		}
	});
	var NonePanel = Panel.extend({
		 
	});
	var AccordionPanel = Panel.extend({	
		/*
		doLayout:function($super,obj){
			$super();
		},
		onToggle : function(i,isInit){
			var evt = {
				index : i,
				panel : this,
				init : isInit
			};
			this.layout.emit("toggle",evt);
		},
		* **/
		startup:function($super){
			var self = this;
			$super();
			topic.group(this.config.channel).subscribe("addContent",function(evt){
				self.addContent(evt.data);
			},self);
			topic.group(this.config.channel).subscribe("removeContent",function(evt){
				if(evt.data!=null){
					if(evt.data.target.id!=null){
						self.removeContentById(evt.data.target.id);
					}else if(evt.data.target.index!=null){
						self.removeContentByIndex(evt.data.target.index);
					}
				}
			},self);
		},
		removeContentByIndex:function(i){
			if(this.contents[i]!=null){
				this.layout.emit("removeContent",this.contents[i]);
				this.contents.splice(i,1);
				this.titlesNode.splice(i,1);
				this.togglesNode.splice(i,1);
				this.contentsNode.splice(i,1);
				this.headersNode.splice(i,1);
				if(this.contents.length<=0){
					this.element.hide();
				}
				this.resetEvent();
			}
		},
		removeContentById:function(id){
			var content = base.byId(id);
			this.layout.emit("removeContent",content);
			for(var i=0;i<this.contents.length;i++){
				if(this.contents[i]==content){
					this.contents.splice(i,1);
					this.titlesNode.splice(i,1);
					this.togglesNode.splice(i,1);
					this.contentsNode.splice(i,1);
					this.headersNode.splice(i,1);
				}
			}
			if(this.contents.length<=0){
				this.element.hide();
			}
			this.resetEvent();
		},
		addContent:function(config){
			this.element.show();
			var obj = new Content(config); 
			obj.setParent(this);
			obj.startup();
			obj.draw();
			var ni = this.contents.length;
			this.addChild(obj);
			this.layout.emit("addContent",obj);
			if(this.contents.length<=0){
				this.element.show();
			}
		},
		expandContent:function(arguContent){
			var contentObj = null;
			var expandIndex = -1;
			if(typeof(arguContent) == "string"){
				contentObj = base.byId(arguContent);
			}else if(typeof(arguContent) == "number"){
				contentObj = this.contentsNode[arguContent]
				expandIndex = arguContent;
			}else if(typeof(arguContent) == "object"){
				contentObj = arguContent;
			}
			if(expandIndex==-1){
				for(var i=0;i<this.contents.length;i++){
					if(this.contents[i] == contentObj){
						expandIndex = i;
						break;
					}
				}
			}
			if(!contentObj.isShow){
				this.onToggle(expandIndex);
			}
		},
		// 重置toggle绑定事件
		resetEvent : function() {
			var self = this;
			for (var jj = 0; jj < this.headersNode.length; jj++) {
				var headNode = this.headersNode[jj];
				var toggleNode = headNode
						.find('[data-lui-mark="panel.nav.toggle"]')
				if (self.contents[jj].getToggle()) {
					headNode.unbind('click');
					~~function(jj) {
						return function() {
							headNode.click(function(evt) {
										self.onToggle(jj, null, null, evt);
									});
						}();
					}(jj);
				}
			}
		}
	});
	var TabPage = AccordionPanel.extend({
		
	});
	var Content = AbstractContent.extend({
		initProps : function($super,_config){
			this.element.attr("data-lui-type",'lui/panel!Content');
			$super(_config);
		},
		startup : function(){
			if(this.layout == null){
				var config = {
					"kind":"content",
					"src":"/sys/ui/extend/panel/content.tmpl"
				};
				if(this.config.layout)
					$.extend(config,this.config.layout);
				this.layout = new layout.Template(config);
				this.layout.startup();
			}
			if(this.config.child!=null){
				for(var i=0;i<this.config.child.length;i++){
					var childVar = this.config.child[i];
					this.addChild(childVar);
					if(childVar.setParent)
						childVar.setParent(this);
					this.element.append(childVar.element);
				}
			}
		},
		getToggle : function(){			
			if(this.toggle==null){
				if(this.parent.config.toggle != null)
					return this.parent.config.toggle;
				else
					return true;
			}else{
				return this.toggle;
			}
		},
		getExpand : function(){
			if(this.expand==null){
				if(this.parent.config.expand != null)
					return this.parent.config.expand;
				else
					return true;
			}else{
				return this.expand;
			}
		},
		load:function(){
			var self = this;
			if(this.isLoad){
				return;
			}
			if(this.isLayout==null||this.isLayout==false){
				setTimeout(function(){
					self.load();
				},20);
			}else{
				this.resetHeight();
				for ( var i = 0; i < this.children.length; i++) {
					if(this.children[i].draw)
						this.children[i].draw();
				}
				this.isLoad = true; 
				if(this.config.refresh!=null){
					window.setInterval(function(){
						self.refresh();
					}, parseInt(this.config.refresh)*1000);
				}
				this.emit("show");
			}
		},
		refresh : function(){
			var isCurrent = false;
			for(var i=0;i<this.parent.contents.length;i++){
				if(i==this.parent.selectedIndex && this.parent.contents[i]==this){
					isCurrent = true;
				}
			}
			//当前Content是否显示。
			if(isCurrent){
				for ( var i = 0; i < this.children.length; i++) {
					if(this.children[i].refresh)
						this.children[i].refresh();
				}
			}
		},
		resize : function(){
			for ( var i = 0; i < this.children.length; i++) {
				if(this.children[i].resize)
					this.children[i].resize();
			}
		},
		doLayout:function(obj){
			var self = this;
			if(this.config.outerHeight==null && this.parent.config.height!=null){
				this.config.outerHeight = this.parent.config.height - this.parent.element.height();
			}
			if(this.config.scroll==null){
				this.config.scroll = (String(this.parent.config.scroll)=="true");
			}else{
				this.config.scroll = (String(this.config.scroll)=="true");
			}
			this.frame = $(obj);
			this.contentInside = this.frame.find("[data-lui-mark='panel.content.inside']");
			this.element.after(this.frame);
			this.contentInside.append(this.element);
			this.isLayout = true;
			this.elementSpace = this.element.outerHeight(true)-this.element.height();
			//$super,不用调用$super,$super会将所有子元素的draw调用一次，改调用会在load里面实现
		},
		getRootElement : function(){
			if(this.frame)
				return this.frame;
			else
				return this.element;
		},
		resetHeight : function(){
			//debugger;
			//设置内容高度
			if(this.config.outerHeight){
				this.contentInside.css({"height":1, "min-height":"", "overflow":"hidden"});
				var height = this.config.outerHeight - this.frame.outerHeight(true) + 1;
				if(this.config.scroll){
					this.contentInside.css({"height":height, "min-height":"", "overflow":"auto"});
				}else{
					this.contentInside.css({"height":"", "min-height":height, "overflow":""});
				}
				this.element.css({"min-height":height - this.elementSpace});
			}else{
				this.contentInside.css({"height":"", "min-height":"", "overflow":""});
				this.element.css({"min-height":""});
			}
		} 
	});

  
	exports.AbstractPanel = AbstractPanel;
	exports.AbstractContent = AbstractContent;
	exports.Content = Content; 
	exports.NonePanel = NonePanel; 
	exports.Panel = Panel; 
	exports.TabPanel = TabPanel; 
	exports.TabPage = TabPage;
	exports.AccordionPanel = AccordionPanel; 
});