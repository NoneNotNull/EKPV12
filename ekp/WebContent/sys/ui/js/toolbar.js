define(function(require, exports, module) {
	require("theme!toolbar");
	var Class = require("lui/Class");
	var base = require("lui/base");
	var element = require("lui/element");
	var layout = require("lui/view/layout");
	var env = require("lui/util/env");
	var topic = require("lui/topic");
	var $ = require("lui/jquery");

	var AbstractButton = new Class.create(base.Container, {
		initProps : function($super, _config) {
			this.config = _config;
			this.textContent = null;
			this.iconContent = null;
			this.layoutDom = null;
			this.visible = true;
			this.disabled = _config.disabled||false;
			this.parentId = this.element.attr("data-lui-parentid");
			this.order = this.config.order == null
					? 3
					: this.config.order;
			if (this.order > 5) {
				this.order = 5;
			} else if (this.order < 1) {
				this.order = 1;
			}
			if (this.parentId != null && this.parentId != '') {
				this.weight = 10 * (6 - this.order);
			} else {
				this.weight = 11 * (6 - this.order);
			}
			$super(_config);
		},
		addChild : function($super, obj) {
			if (obj instanceof element.Text) {
				this.textContent = obj.element;
			}
			$super(obj);
		},
		startup : function($super) {
			if (this.config.text != null && this.textContent == null) {
				var textVar = new element.Text({
							'text' : $.trim(this.config.text)
						});
				if (textVar.startup)
					textVar.startup();
				this.onErase(function() {
							textVar.destroy();
						});
				this.textContent = textVar.element;
			}
			if (this.config.icon != null && this.config.icon != '') {
				this.iconContent = $('<div/>')
						.addClass('lui_widget_btn_icon')
						.append($('<div/>').attr("class",
								this.config.icon)
								.addClass("lui_icon_s"));
			}
			if (this.textContent != null)
				this.textContent.addClass("lui_widget_btn_txt");

			var _self = this;
			this.element.show();
			if (this.config.title != null) {
				this.element.attr('title', this.config.title);
			} else {
				this.element.attr('title', this.config.text);
			}
			this.element.addClass('lui_widget_btn');
			this.element.attr('style', this.config.style);
			// 让按钮可以设置焦点
			this.element.attr('tabindex', 0);
			this.element.click(function() {
						_self.onClick();
					});
			this.element.mouseover(function() {
						_self.onMouseOver();
					});
			this.element.mouseout(function() {
						_self.onMouseOut();
					});
			$super();
		},
		setLayout:function(domObj) {
			this.isDrawed = false;
			this.layoutDom = domObj;
		},
		onMouseOver : function() {
			if (this.layoutDom != null) {
				var swhClass = this.layoutDom.attr('data-lui-on-class');
				this.layoutDom.addClass(swhClass);
			}
			this.element.addClass('lui_icon_on');
			this.emit("mouseover");
		},
		onMouseOut : function() {
			if (this.layoutDom != null) {
				var swhClass = this.layoutDom.attr('data-lui-on-class');
				this.layoutDom.removeClass(swhClass);
			}
			this.element.removeClass('lui_icon_on');
			this.emit("mouseout");
		},
		onClick : function() {

		},
		refreshSatus : function() {
			var _self = this;
			var domObj = this.element;
			if(this.layoutDom!=null && $.contains($(document),this.layoutDom)){
				domObj = this.layoutDom;
			}
			if (!this.visible) {
				domObj.hide();
			} else{
				domObj.show();
			}
			this.element.unbind('click');
			this.element.unbind('mouseover');
			this.element.unbind('mouseout');
			if (this.disabled) {
				this.onMouseOut();
				this.element.removeAttr('tabindex');
				domObj.addClass("lui_widget_btn_disabled");
			}else{
				this.element.click(function() {
					_self.onClick();
				});
				this.element.mouseover(function() {
					_self.onMouseOver();
				});
				this.element.mouseout(function() {
					_self.onMouseOut();
				});
				domObj.removeClass("lui_widget_btn_disabled");
			}
		},
		//设置可见
		setVisible : function(isShow) {
			this.visible = isShow;
			this.refreshSatus();
			if(this.parent)
				this.parent.emit("redrawButton");
		},
		//设置是否不可用
		setDisabled : function(isDisabled) {
			this.disabled = isDisabled;
			this.refreshSatus();
		}
	});

	var ToolBar = new Class.create(base.Container, {
			initProps : function($super, _config) {
				this.config = _config;
				this.buttons = new Array();
				this.count = this.config.count == null
						? 3
						: this.config.count;
				if (this.count <= 0)
					this.count = 3;

				this.scribed = false;
				this.vars = {};
				if (this.config.vars)
					this.vars = this.config.vars;
				$super(_config);
			},
			addChild : function($super, obj) {
				if (obj instanceof AbstractButton) {
					this.buttons.push(obj);
				}
				if (obj instanceof layout.AbstractLayout) {
					this.layout = obj;
				}
				$super(obj);
			},
			startup : function($super) {
				if (this.config.buttons != null
						&& this.config.buttons.length > 0) {
					for (var i = 0; i < this.config.buttons.length; i++) {
						this.addChild(this.config.buttons[i]);
					}
				}
				this.buttons = this._buttonSort(this.buttons);
				if (this.config.layout != null) {
					var tmpConfig = this.config.layout;
					this.layout = new layout[tmpConfig['type']](Object
							.extend({
										"kind" : "toolbar",
										"parent" : this
									}, tmpConfig));
					this.layout.startup();
				}
				$super();
			},
			doLayout : function(obj) {
				var _self = this;
				var layourDom = $(obj);
				this.element.show();
				this.element.append(layourDom);
				if (!this.scribed) {
					topic.group(this.config.channel).subscribe("btn_add",
							function(evt) {
								_self.addButton(evt.data.target);
							});
					topic.group(this.config.channel).subscribe("btn_disabled",
							function(evt) {
								_self.setDisabled(evt.data);
							});
					this.scribed = true;
				}
				// 导入按钮初始化
				this.____dataInit();
			},
			
			_buttonSort:function(buttons){
				$.each(buttons,function(idx , button){
						button._indexNum = buttons.length - idx; 
					});
				return this.buttons.sort(function(oneBtn, twoBtn){
					return (twoBtn.weight - oneBtn.weight)||(twoBtn._indexNum - oneBtn._indexNum);
				});
			},
			____dataInit : function() {
				var mark = this.____getCookie();
				if (mark && mark == 'open') {
					require.async('sys/datainit/import/datainit', function(
									datainit) {
								if (datainit.getIsDrawed())
									return;
								datainit.setIsDrawed(true);
								var btn = new Button(datainit.getCfg());
								datainit.surroundBtn(btn);
							});
				}
			},
			____getCookie : function() {
				var arr, reg = new RegExp("(^| )isopen=([^;]*)(;|$)");
				if (arr = document.cookie.match(reg))
					return unescape(arr[2]);
				else
					return null;
			},
			refresh : function() {
				this.erase();
				this.draw();
			},
			destroy : function($super) {
				this.buttons = null;
				this.layout = null;
				$super();
			},
			//设置toolbar是否可用
			setDisabled : function(isDisabled) {
				for (var i = 0; i < this.buttons.length; i++) {
					this.buttons[i].setDisabled(isDisabled);
				}
			},
			//增加单个按钮
			addButton : function(obj) {
				if (obj instanceof AbstractButton) {
					this.addChild(obj);
					this.buttons = this._buttonSort(this.buttons);
					this.emit("redrawButton");
				}
			},
			//批量添加按钮
			addButtons : function(buttons) {
				for (var j = 0; j < buttons.length; j++) {
					if (buttons[j] instanceof AbstractButton) {
						this.addChild(buttons[j]);
						this.buttons = this._buttonSort(this.buttons);
					}
				}
				this.emit("redrawButton");
			},
			//删除某个按钮
			removeButton : function(obj) {
				if(obj!=null){
					if (obj instanceof AbstractButton) {
						for (var i = 0; i < this.buttons.length; i++) {
							if (this.buttons[i] == obj) {
								this.buttons.splice(i, 1);
								break;
							}
						}
						this.buttons = this._buttonSort(this.buttons);
						this.emit("redrawButton");
						obj.erase();
						// this.emit("removeButton",obj);
					}
				}else{
					for (var i = 0; i < this.buttons.length; i++) {
						this.buttons[i].erase();
					}
					this.buttons = new Array();
					this.emit("redrawButton");
				}
			}
		});

	var Toggle = new Class.create(AbstractButton, {
		initProps : function($super, _config) {
			this.config = _config;
			this.selected = _config.selected || false;
			this.group = _config.group;
			this.value = _config.value;
			var self = this;
			topic.subscribe('toggle.change', function(data) {
						self._subscribeEvent(data);
					});
			$super(_config);
		},

		startup : function($super) {
			$super();
			if (this.isSelected() && this.config.click) {// 初始化点击事件在startup触发，解决列表重复加载
				new Function(this.config.click).apply(this);
			}
		},

		_subscribeEvent : function(data) {
			var arguGroup = null;
			var arguId = null;
			if (data != null) {
				arguGroup = data.group;
				arguId = data.cid;
				if (arguGroup != null) {
					if (this.group == arguGroup) {
						if (this.cid == arguId && data.cid != null) {
							this.selected = true;
						} else {
							this.selected = false;
						}
						this._refreshToggle();
					}
				} else {
					if (this.cid == data.cid && data.cid != null) {
						this.selected = true;
					}
					this._refreshToggle();
				}
			}
		},
		_refreshToggle : function() {
			if (this.selected) {
				if (this.layoutDom != null) {
					var swhClass = this.layoutDom.attr('data-lui-status-class');
					this.layoutDom.addClass(swhClass);
				}
				this.element.addClass("lui_icon_on");

			} else {
				if (this.layoutDom != null) {
					var swhClass = this.layoutDom.attr('data-lui-status-class');
					this.layoutDom.removeClass(swhClass);
				}
				this.element.removeClass("lui_icon_on");
			}
		},
		draw : function() {
			if (!this.isDrawed) {
				var contentElement = this.element;
				if (this.layoutDom != null) {
					contentElement = this.layoutDom
							.find('div[data-lui-mark="toolbar_button_content"]');
				}
				contentElement.append(this.iconContent);
				if (this.textContent != null)
					contentElement.append(this.textContent);

				var tmpContent = this.element
						.find('div[data-lui-mark="toolbar_button_inner"]');
				if (tmpContent.length > 0) {
					tmpContent.remove();
				}
				this.element.append(this.layoutDom.children());
				if (this.layoutDom != null) {
					this.layoutDom.append(this.element);
				}
				this.initEvent();
			}
			this.isDrawed = true;
		},

		fireEvent : function() {
			// 保存用户行为
			this.setLocalStorage(this.value);
			topic.publish('toggle.change', {
						"group" : this.group,
						"cid" : this.cid
					});
			// 新增发布channel事件
			topic.channel(this).publish('toggle.change.channel', {
						'channel' : this.channel,
						'cid' : this.cids,
						'toggle' : this
					});
		},

		initEvent : function() {
			if (this.isSelected()) {
				this.fireEvent();
			}
		},
		onMouseOut : function($super) {
			$super();
			this._refreshToggle();
		},
		onClick : function() {
			var scriptCode = "";
			if (this.config.click) {
				scriptCode = this.config.click;

			} else if (this.config.href) {
				scriptCode = ["window.open('",
						env.fn.formatUrl(this.config.href), ",'",
						this.config.target ? this.config.target : '_self', "')"]
						.join('');
			}
			if($.trim(scriptCode)!='')
				new Function(scriptCode).apply(this);
			this.fireEvent();
		},
		setSelected : function(selected) {
			this.selected = selected;
			if (this.isSelected()) {
				this.fireEvent(this.element);
			} else {
				this._refreshToggle();
			}
		},
		
		isSelected : function() {
			var id = this.getLocalStorage();
			if (id)
				return id === this.value;
			return this.selected;
		},

		// 获取当前页面url标志
		getUrlPrefix : function() {
			if (this.urlPrefix)
				return this.urlPrefix;
			var path = location.pathname;
			if (path.lastIndexOf('/') > 0)
				path = path.substring(0, path.lastIndexOf('/'));
			this.urlPrefix = path;
			return path;
		},

		setLocalStorage : function(value) {
			if (value != localStorage.getItem("toggle.change"))
				localStorage.setItem("toggle.change", value);
		},

		getLocalStorage : function() {
			return localStorage.getItem("toggle.change");
		}
	});

	var Button = new Class.create(AbstractButton, {
		initProps : function($super, _config) {
			this.config = _config;
			this.styleClass = 'lui_toolbar_btn_def';
			if(this.config.styleClass!=null)
				this.styleClass = this.config.styleClass;
			this.defaultLayout = "<div>"
					+ "<div class='lui_toolbar_btn_l' data-lui-mark='toolbar_button_inner'>"
					+ "<div class='lui_toolbar_btn_r'>"
					+ "<div class='lui_toolbar_btn_c' data-lui-mark='toolbar_button_content'></div></div></div></div>";
			$super(_config);
		},
		draw:function($super){
			if(this.isDrawed)
				return this;
			this._btnDraw();
		},
		_btnDraw : function() {
			var contentElement = this.element;
			var tmpLayout = this.layoutDom;
			if (tmpLayout == null) {
				this.nonexistLayout = true;
				tmpLayout = $(this.defaultLayout);
			}
			if (tmpLayout != null && this.nonexistLayout) {
				this.element.addClass(this.styleClass);
			}
			contentElement = tmpLayout.find('div[data-lui-mark="toolbar_button_content"]');

			contentElement.append(this.iconContent);
			if (this.textContent != null) {
				contentElement.append(this.textContent);
			}
			var tmpContent = this.element
					.find('div[data-lui-mark="toolbar_button_inner"]');
			if (tmpContent.length > 0) {
				tmpContent.remove();
			}

			this.element.append(tmpLayout.children());
			
			if (this.nonexistLayout != true) {
				tmpLayout.append(this.element);
			}

			if (this.children.length > 0) {
				for (var i = 0; i < this.children.length; i++) {
					if (this.children[i].draw)
						this.children[i].draw();
				}
			}
			
			if (this.disabled) {
				this.setDisabled(true);
			}
			this.isDrawed = true;
		},
		setLayout:function($super,domObj) {
			this.nonexistLayout = false;
			this.isDrawed = false;
			this.layoutDom = domObj;
		},
		onClick : function() {
			var clickStr = "";
			if (this.config.click != null) {
				clickStr += this.config.click;
			} else if (this.config.href != null) {
				var target = "_blank";
				if (this.config.target != null)
					target = this.config.target;
				clickStr += "window.open('"
						+ env.fn.formatUrl(this.config.href) + "','" + target
						+ "');";
			}
			var _self = this;
			if($.trim(clickStr)!='')
				new Function(clickStr).apply(this.element.get(0));
			// 新增发布channel事件
			topic.channel(this).publish('toggle.change.channel', {
						'channel' : this.channel,
						'cid' : this.cids,
						'button' : this
					});
		}
	});
	var ToggleGroup = new Class.create(AbstractButton, {
		initProps : function($super,_config) {
			$super(_config);
			this.buttons = new Array();
		},
		addChild : function($super, obj) {
			if (obj instanceof AbstractButton) {
				this.buttons.push(obj);
			}
			if (obj instanceof layout.AbstractLayout) {
				this.__setLayout(obj);
			}
			// $super(obj);
		},
		startup : function($super) {
			$super();
			var self = this;
			this.parent.layout.on('html', function() {
				self.parentLayoutLoaded = true;
			});
		},
		draw : function($super) {
			if (!this.isDrawed) {
				var tmpLayout = this.layoutDom;
				if (this.layoutDom == null) {
					tmpLayout = $(this.defaultLayout);
					this.element.addClass("lui_toolbar_btn_def");
				} else {
					this.element.removeClass("lui_toolbar_btn_def");
				}
				tmpLayout.children().remove();
				if (this.layoutDom != null) {
					tmpLayout.addClass("lui_toolbar_toggleGroup_btn");
					tmpLayout.append(this.element);
				}else{
					this.element.addClass("lui_toolbar_toggleGroup_btn");
				}
			}
			$super();
		},
		__setLayout : function(layout) {
			this.layout = layout;
		},
		doLayout : function(obj) {
			var _self = this;
			var layourDom = $(obj);
			this.element.show();
			this.element.append(layourDom);
		},
		onMouseOver : function() {
		},
		onMouseOut : function() {
		}
	});

	var buildButton = function(_cfg) {
		var rtnBtn = new Button(_cfg);
		rtnBtn.startup();
		return rtnBtn;
	};
	var buildToolBar = function(buttons, layout, cfg) {
		var _cfg = {
			"buttons" : buttons,
			"layout" : layout
		};
		_cfg = Object.extend(_cfg, cfg);
		var toolBar = new ToolBar(_cfg);
		toolBar.startup();
		return toolBar;
	};
	exports.ToolBar = ToolBar;
	exports.Toggle = Toggle;
	exports.Button = Button;
	exports.buildButton = buildButton;
	exports.buildToolBar = buildToolBar;
	exports.AbstractButton = AbstractButton;
	exports.ToggleGroup = ToggleGroup;
});