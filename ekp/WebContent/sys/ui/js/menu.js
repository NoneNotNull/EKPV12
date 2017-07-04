define(function(require, exports, module) {
	require("theme!menu");
	var base = require("lui/base");
	var source = require("lui/data/source");
	var layout = require("lui/view/layout");
	var env = require("lui/util/env");
	var str = require("lui/util/str");
	var $ = require("lui/jquery");
	var popup = require("lui/popup");
	
	var AbstractMenuItem = base.Container.extend({
		initProps : function($super,_config){
			$super(_config);
			this.config = _config;			
			this.icon = this.config.icon;
			this.href =  env.fn.formatUrl(this.config.href);
			this.target = this.config.target || "_self";
		},
		startup :function(){
			var self = this;
			if(this.href){
				this.element.click(function(){				
					self.onClick(self.href,self.target);
				});
				// 手型更换为只有链接时候才出现
				this.element.css('cursor','pointer');
			} 
			this.element.addClass("lui_item");
		},
		onClick :function(_href,_target){
			window.open(_href,_target);
		},
		insert: function(newItem , isBefore){
		},
		before: function(newItem){
			this.insert(newItem, true);
		},
		after: function(newItem){
			this.insert(newItem, false);
		},
		refreshEvent:function(){
			this.element.mouseover(function(){
				$(this).addClass("lui_icon_on");
			});
			
			this.element.mouseout(function(){
				$(this).removeClass("lui_icon_on");
			});
			this.element.addClass("lui_icon_on");
		}
	});
	var AbstractMenuSource = AbstractMenuItem.extend({
		
	});
	var MenuItem = AbstractMenuItem.extend({
		initProps : function($super,_config){
			$super(_config);
			this.text =	env.fn.formatText( this.config.text);
			this.title =  env.fn.formatText(this.config.title);
			this.selected =	this.config.selected;
		},
		startup:function($super){
			if(this.title){
				this.element.attr("title",this.title);
			}
			$super();
		},
		buildItemChildByData:function(item , data){
			if(data.children){
				for(var j=0;j<data.children.length;j++){
					var tmpVar = data.children[j];
					var newItem = buildItem(tmpVar);
					item.addChild(newItem);
					this.buildItemChildByData(newItem , tmpVar);
				}
			}
		},
		draw: function($super){
			if(!this.selected){
				this.element.mouseover(function(){
					$(this).addClass("lui_icon_on");
				});
				this.element.mouseout(function(){
					$(this).removeClass("lui_icon_on");
				});
			}
			this.element.show();
		},
		erase: function() {
			if(this.parent){
				this.parent.removeChild(this);
			}
			if(this.children){
				for (var i = 0; i < this.children.length; i ++) {
					if (this.children[i].erase) {
						this.children[i].erase();
					}
				}
			}
			this.emit("erase", this);
			this.off("erase");
			if(this.element)
				this.element.empty();		
			this.isDrawed = false;
		},
		destroy:function(){
			if (this._destroyed) {
				return;
			}
			this.erase();
			
			if (this.element) {
				this.element.off();
				this.element.remove();
				this.element = null;
			}
			this.children = null;
			this.off();
			this.config = null;
			this._destroyed = true;
			delete this;
		},
		insert: function(newItem , isBefore){
			var parent = this.parent;
			if(parent!=null){
				newItem.setParent(parent);
				if(newItem instanceof AbstractMenuSource){
					newItem.draw(this,isBefore);
				}else if(newItem instanceof AbstractMenuItem){
					parent.addItem(newItem,this,isBefore);
				}
			}
		}
	});
	/************************
	 * 数据模型：
	 * [
		 	{
		 		“text”:
				“icon”:
				“href”:
				“target”:
				“title”:
				"autofetch":
				"selected"
				“children”：[]  //直接返回下一级数据
				“childrenSource”: { //数据另外的数据源获取
						href,
						target,
						type,
						config {},
						autofetch
				}  	
			}
			...
			处理逻辑
			当menusource的autoFetch与返回的数据中的autoFetch关系是：menusource中的提供默认值，实际生效以返回数据中的为准。
			当autoFetch为true时，childrenSource无效，
					如果返回值中有children则取该数组为下一级的数据，如没有则重组source的请求url，获取下一级数据。
			autoFetch为false时，如果返回值中有children则取该数组为下一级的数据,并且追加childrenSource定义的数据源。
			
		]
	 ************************/
	var MenuSource =  AbstractMenuSource.extend({
		initProps : function($super,_config){
			$super(_config);
			this.config = _config;
			this.href = this.config.href;
			this.target = this.config.target || "_self";
			this.icon = this.config.icon;
			this.autoFetch = this.config.autoFetch==null ? false : this.config.autoFetch;
			this.params = this.config.params;
		},
		addChild: function($super,obj) {
			if(obj instanceof source.BaseSource){
				this.source = obj;
			}
			$super(obj);
		},
		startup:function($super){
			if(this.config.source!=null){
				this.source = this.config.source;
			}
			$super();
		},
		draw: function(arguItem,isBefore){
			if(this.source && this.parent!=null){
				var self = this;
				if(this.source.resolveUrl){
					if(this.params == null)
						this.source.resolveUrl();
					else
						this.source.resolveUrl(this.params);
				}
				this.source.get(function(data){
					if(data.length>0){
						var beforeItem = null;
						for(var i=0;i<data.length;i++){
							if($.trim(data[i].icon) == "" && self.icon!=null){
								data[i].icon = self.icon;
							}
							if($.trim(data[i].href) == "" && self.href!=null){
								data[i].href = str.variableResolver(self.href, data[i]);
							}
							if($.trim(data[i].target) == ""){
								data[i].target = self.target;
							}
							var tmpAutoFetch = data[i].autoFetch==null ? self.autoFetch : data[i].autoFetch;
							tmpAutoFetch = (tmpAutoFetch==true || tmpAutoFetch=="true")?true:false;
							var item = buildItem(data[i]);
							if(tmpAutoFetch){//自动获取
								if(data[i].children!=null && data[i].children.length>0){
									item.buildItemChildByData(item,data[i]);
								}else{
									if(self.source.resolveUrl){
										var tmpSource = buildSource(self.source,data[i],
												{"href":self.href,"target":self.target,"icon":self.icon,"autoFetch":self.autoFetch});
										if(tmpSource!=null)
											item.addChild(tmpSource);
									}
								}
							}else{
								if(data[i].children!=null && data[i].children.length>0){
									item.buildItemChildByData(item,data[i]);
								}
								if(data[i].childrenSource!=null ){
									var sourceConfig = data[i].childrenSource;
									if($.trim(sourceConfig.href) == "" && self.href!=null){
										sourceConfig.href = self.href;
									}
									if($.trim(sourceConfig.icon) == ""  && self.icon!=null){
										sourceConfig.icon = self.icon;
									}
									if($.trim(sourceConfig.target) == ""){
										sourceConfig.target = self.target;
									}
									if(sourceConfig.autoFetch == null){
										sourceConfig.autoFetch = self.autoFetch;
									}
									if(sourceConfig.type!=null){
										var tmpSource = new source[sourceConfig.type](sourceConfig);
										buildSource(tmpSource,data[i],sourceConfig);
										if(tmpSource!=null)
											item.addChild(tmpSource);
									}
								}
							}
							if(i==0){
								if(arguItem!=null){
									self.parent.addItem(item,arguItem,isBefore,data.length,i);
								}else{
									self.parent.redrawItem(item,self,data.length,i);
								}
							}else{
								self.parent.addItem(item,beforeItem,null,data.length,i);
							}
							self.addChild(item);
							beforeItem = item;
						}
						self.parent.emit("popupShow");
					}else{
						self.parent.removeChild(self);
					}
				});
			}
			this.isDrawed = true;
		},
		insert: function(newItem,isBefore){
			var parent = this.parent;
			if(parent!=null){
				newItem.setParent(parent);
				if(newItem instanceof AbstractMenuSource){
					if(this.isDrawed == true){
						if(this.children.length>1){//第一个是source
							var index = this.children.length - 1;
							if(isBefore)
								index = 1;
							newItem.draw(this.children[index],isBefore);
						}else{
							newItem.draw(this,isBefore);
						}
					}else{
						parent.addChild(newItem);
					}
				}else if(newItem instanceof AbstractMenuItem){
					if(this.isDrawed == true){
						if(this.children.length>1){
							var index = this.children.length - 1;
							if(isBefore)
								index = 1;
							parent.addItem(newItem,this.children[index],isBefore);
						}else{
							parent.addItem(newItem,null,isBefore);
						}
					}else{
						parent.addItem(newItem,this,isBefore);
					}
				}
			}
		}
	});
	
	var MenuPopup = AbstractMenuItem.extend({
		initProps: function($super,_config){
			$super(_config); 
			this.text =	env.fn.formatText( this.config.text);
			this.title =  env.fn.formatText(this.config.title);
			this.align = this.config.align;
			this.borderWidth  = this.config.borderWidth;
			this.triggerEvent = this.config.triggerEvent;
			if(this.config.triggerObject!=null)
				this.triggerObject = $(this.config.triggerObject);
			this.popCfg = {};
			this.popCfg.align = this.align;
			this.popCfg.borderWidth = this.borderWidth;
			this.popCfg.triggerEvent = this.triggerEvent;
		},
		startup:function($super){
			if(this.title){
				this.element.attr("title",this.title);
			}
			this.popContainer =  $("<div class='lui_menu_popup'/>").append(this.element.children()).hide();
			$super();
		},
		draw: function(){
			if(!this.isDrawed){
				if(this.parent.popup != null){
					this.popCfg.parent = this.parent.popup;
				}
				this.popCfg.channel = this.channel;
				var trigger = this.element;
				if(this.triggerObject!=null){
					trigger = this.triggerObject;
				}
				var tmpPop = popup.build(trigger,this.popContainer,this.popCfg);
				for(var i=0;i<this.children.length;i++){
					this.children[i].popup = this.parent.popup;
					tmpPop.addChild(this.children[i]);
				}
				this.onErase(function(){tmpPop.destroy();});
				this.isDrawed = true;
			}
			this.element.show();
			if(this.triggerObject!=null){
				this.triggerObject.show();
			}
		},
		insert: function(newItem , isBefore){
			var parent = this.parent;
			if(parent!=null){
				newItem.setParent(parent);
				if(newItem instanceof AbstractMenuSource){
					newItem.draw(this,isBefore);
				}else if(newItem instanceof AbstractMenuItem){
					parent.addItem(newItem,this,isBefore);
				}
			}
		}
	}); 
	
	var Menu = base.Container.extend({
		initProps : function($super,_config){
			$super(_config);
			this.config = _config;
			this.menuSouce = new Array();
			this.element.show();
			this.loading = $("<img src='"+env.fn.formatUrl('/sys/ui/js/ajax.gif')+"' />");
			this.element.append(this.loading);
		},
		addChild: function($super,obj) {
			if(obj instanceof layout.AbstractLayout){
				this.layout = obj;
			}else if(obj instanceof AbstractMenuSource){
				this.menuSouce.push(obj);
			}
			if(obj.setParent)
				obj.setParent(this);
			$super(obj);
		},
		startup: function(){
			if(this.config.layout!=null){
				var _cfg = Object.extend({"parent":this,"kind":"menu"},this.config.layout);
				this.layout = new layout[this.config.layout.type](_cfg);
				this.layout.startup();
			}
			if(this.config.items!=null){
				for(var i=0;i<this.config.items.length;i++){
					this.addChild(this.config.items[i]);
				}
			}
			if(this.parent instanceof popup.Popup){
				this.popup = this.parent;
			}
			var self = this;
			this.on("popupShow",function(){
				if(self.popup)
					self.popup.overlay.actor.show();
			});
			this.on("popupHide",function(){
				if(self.popup){
					self.popup.overlay.hide();
					self.popup.destroy();
				}
			});
		},
		doLayout: function($super,obj){
			if(!this.layouted){
				this.element.append($(obj));
				for(var i=0;i<this.menuSouce.length;i++){
					this.menuSouce[i].draw();
				}
				for ( var i=0; i<this.children.length; i++) {
					if(this.children[i].draw && !this.children[i].isDrawed){
						this.children[i].draw();
					}
				}
				this.loading.remove();
				this.emit("popupShow");
				this.layouted = true;
			}
		},
		//参数对象仅为item
		addItem: function(item , posItem , isBefore, len, i){
			if(item instanceof AbstractMenuItem){
				if(posItem==null){
					this.addChild(item);
				}else{
					var index = $.inArray(posItem,this.children);
					if(index!=-1){
						this.children.splice(index,0,item);
						if(item.setParent)
							item.setParent(this);
					}else{
						this.addChild(item);
					}
				}
				item.draw();
				var evt = {
							"item" : item,
							"posItem" : posItem,
							"isBefore" : isBefore
						};
				if (typeof(len) != 'undefined'
									&& typeof(i) != 'undefined') {
					evt.len = len;
					evt.index = i;
				}
				this.emit("addItem", evt);
			}
		},
		redrawItem: function(item,posItem,len,i){
			if(item instanceof AbstractMenuItem){
				if(posItem!=null){
					var index = $.inArray(posItem,this.children);
					if(index!=-1){
						this.children.splice(index,1,item);
						if(item.setParent)
							item.setParent(this);
						item.draw();
						var evt = {
							"item" : item,
							"posItem" : posItem
						}
						if (typeof(len) != 'undefined'
										&& typeof(i) != 'undefined') {
							evt.len = len;
							evt.index = i;
						}
						this.emit("redrawItem",evt);
					}else{
						this.addItem(item);
					}
				}
			}
		},
		//参数对象为item，source，popup
		insertBefore: function(newChild , target){
			target.before(newChild);
		},
		insertAfter: function(newChild , target){
			target.after(newChild);
		},
		removeChild: function(child){
			if(child instanceof AbstractMenuItem){
				var index = $.inArray(child,this.children);
				if(index!=-1){
					this.children.splice(index,1);
				}
				if((child instanceof AbstractMenuSource)){
					var index = $.inArray(child,this.menuSouce);
					if(index!=-1){
						this.menuSouce.splice(index,1);
					}
					this.emit("removeItem",{"item":child});
					if(child.isDrawed){
						child.destroy();
					}
				}else{
					this.emit("removeItem",{"item":child});
				}
			}
			this.refreshMenu();
		},
		refreshMenu: function(){
			if(this.children.length<=0){
				if(this.popup!=null){
					var item = this.popup.positionObject;
					item = base.byId(item.attr("id"));
					this.emit("popupHide");
					item.parent.emit("popupItemHide",{"popupItem":item});
					item.refreshEvent();
				}
			}
		}
	});
	var buildItem = function(_cfg){
		var item = new MenuItem(_cfg);
		item.startup();
		return item;
	};
	var buildMenu = function(items,layout){
		var _cfg = {
				"items" : items ,
				"layout": layout
			};
		var menu = new Menu(_cfg);
		menu.startup();
		return menu;
	};
	var buildSource = function(sourceArgu,params,cfg){
		if(!(sourceArgu instanceof source.BaseSource)){
				return null;
		}
		var _cfg = {
				"source":sourceArgu,
				"params":params
			};
		_cfg = Object.extend(_cfg,cfg);
		var menuSource = new MenuSource(_cfg);
		menuSource.startup();
		return menuSource;
	};
	exports.AbstractMenuItem = AbstractMenuItem;
	exports.MenuItem = MenuItem;
	exports.MenuPopup = MenuPopup;
	exports.MenuSource = MenuSource;
	exports.Menu = Menu;
	exports.buildItem = buildItem;
	exports.buildSource = buildSource;
	exports.buildMenu = buildMenu;
});