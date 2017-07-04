define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	require("theme!dialog");
	var $ = require("lui/jquery");
	var layout = require("lui/view/layout");
	var base = require("lui/base");
	var env = require("lui/util/env");
	var overlay = require("lui/overlay");
	var actor = require("lui/dialog/actor");
	var trigger = require("lui/dialog/trigger");
	var content = require("lui/dialog/content");
	var strutil = require('lui/util/str');
	var dragdrop = require('lui/dragdrop');
	var upperFirst = strutil.upperFirst;

	// 父窗口弹框
	var topDialog;
	var topBase;
	var win = top;
	try {
		typeof (win['seajs']);// 跨域错误判断
	} catch (e) {
		win = window;
	}
	if (win != window && typeof (win['seajs']) != 'undefined') {
		win['seajs'].use([ 'lui/dialog', 'lui/base' ], function(dialog, base) {
			topDialog = dialog.Dialog;
			topBase = base;
		});
	}

	// 弹出框
	var Dialog = base.Component
			.extend({

				initialize : function($super, config) {
					$super(config);
					this.startup();
				},
				initProps : function(_config) {
					this.config = _config.config;
					// 是否缓存
					this.cache = this.config.cache || false;
					// 是否锁屏
					this.lock = this.config.lock ? true
							: (this.config.lock == false ? false : true);
					this.width = this.config.width || $(window).width() / 2;
					this.height = this.config.height || $(window).height() / 2;
					this.top = this.config.top;
					this.left = this.config.left;
					this.titleConfig = this.config.title;
					this.elem = this.config.elem;
					this.close = this.config.close != null ? this.config.close
							: true;
					this.layoutConfig = this.config.layout
							|| 'sys/ui/extend/dialog/dialog.tmpl';

					this.triggerConfig = $.extend({
						dialog : this
					}, _config.trigger);    
					this.triggerType = this.triggerConfig
							&& this.triggerConfig.type ? upperFirst(this.triggerConfig.type)
							: "Default";

					this.actorConfig = $.extend({
						'dialog' : this,
						'lock' : this.lock,
						'cache' : this.cache,
						'elem' : this.elem
					}, _config.actor);
					this.actorType = this.actorConfig && this.actorConfig.type ? upperFirst(this.actorConfig.type)
							: 'Default';

					this.contentConfig = this.config.content;
					this.contentType = upperFirst(this.contentConfig.type);

					this.positionConfig = _config.position;

					this.callback = _config.callback || new Function();
				},

				getPosition : function() {
					if (this.top || this.left) {
						this.position = new overlay.CustomPosition({
							top : this.top,
							left : this.left
						});
					} else if (this.positionConfig) {
						this.position = new overlay[upperFirst(this.positionConfig.type)](
								{
									elem : this.elem
								});
					} else {
						this.position = new overlay.DefaultPosition()
					}
					return this.position;
				},

				startup : function() {
					this.addChild();
					this.overlay = new overlay.Overlay({
						"trigger" : new trigger[this.triggerType](
								this.triggerConfig),
						"position" : this.getPosition(),
						"content" : this.content,
						"actor" : new actor[this.actorType](this.actorConfig)
					});
				},

				addChild : function() {
					if (this.layoutConfig) {
						this.layout = new layout.Template({
							datas : [],
							src : (require.resolve(this.layoutConfig + '#')),
							parent : this
						});
						this.children.push(this.layout);
						this.layout.startup();
					}
					if (this.contentConfig) {
						this.content = new content[this.contentType]($.extend({
							parent : this
						}, this.contentConfig));
					}
				},

				drawFrame : function() {
					if (this.isDrawed) {
						return;
					}
					var self = this;
					this.layout.get(this, function(obj) {
						self.layoutDone(obj);
						self.isDrawed = true;
					});
				},

				layoutDone : function(obj) {
					var self = this;
					this.element.hide();
					$(document.body).prepend(this.element);
					this.element.css({
						'width' : this.width
					});

					this.frame = $(obj);
					// dialog头部
					this.head = this.frame
							.find('[data-lui-mark="dialog.nav.head"]');

					if (this.head.length > 0) {
						this.title = this.head
								.find("[data-lui-mark='dialog.nav.title']");
						this.title.append(this.titleConfig);
					}
					this.element.append(this.frame);

					this.frame.find('[data-lui-mark="dialog.content.frame"]')
							.append(this.content.element);

					// 关闭事件
					if (this.close) {
						this.element.find('[data-lui-mark="dialog.nav.close"]')
								.click(function() {
									self.hide(null);
								});
					} else {
						this.element.find('[data-lui-mark="dialog.nav.close"]')
								.remove();
					}

					this.content.drawFrame();
					this.emit('layoutDone');
				},

				callback : function(value, dialog, ctx) {
					this.callback.call(ctx || window, value, dialog);
				},

				show : function() {
					this.drawFrame();
					this.overlay.show();
					return this;
				},

				hide : function(value) {
					var self = this;
					// ie9下在异步回调函数中调用hide函数jquery对象被提前销毁报错
					setTimeout(function() {
						self.content.hide();
						self.overlay.hide();
						self.callback(value, self);
					}, 1);
				}
			});

	function build(_config) {
		_config.config.cache = _config.id ? true && _config.config.cache
				: false;

		// 控制弹出层对应window对象--loading需要使用
		var win = _config.config.win ? _config.config.win : top;
		if (win == window || !topDialog) {
			topDialog = Dialog;
			topBase = base;
		}
		if (top != window && typeof (win['seajs']) != 'undefined') {
			win['seajs'].use([ 'lui/dialog', 'lui/base' ], function(dialog,
					base) {
				topDialog = dialog.Dialog;
				topBase = base;
			});
		}
		if (_config.config.cache) {
			var dialog = topBase.byId(_config.id) ? topBase.byId(_config.id)
					: new topDialog(_config);
		} else {
			dialog = new topDialog(_config);
		}
		return dialog;
	}

	function dialogAlert(html, callback, iconType, buttons, autoClose) {
		var data = {
			config : {
				width : 436,
				lock : true,
				cahce : false,
				title : lang['ui.dialog.operation.title'],
				content : {
					type : "common",
					html : html,
					iconType : iconType || 'warn',// warn,question,success,failure
					buttons : buttons && buttons.length > 0 ? buttons : [ {
						name : lang['ui.dialog.button.ok'],
						value : true,
						focus : true,
						fn : function(value, dialog) {
							dialog.hide(value);
						}
					} ]
				}
			},
			callback : callback
		}

		// 是否自动关闭
		if (autoClose) {
			data['actor'] = {
				type : "Slide"
			};
			data['trigger'] = {
				type : "AutoClose",
				timeout : 3
			};
		}
		return build(data).show();
	}

	/**
	 * config包括width.height和buttons
	 */
	function dialogIframe(url, title, _callback, _config) {
		var data = {
			config : {
				lock : true,
				cache : false,
				width : _config.width,
				height : _config.height,
				top : _config.top,
				left : _config.left,
				title : title || '',
				win : _config.topWin ? _config.topWin : top,
				content : {
					id : 'dialog_iframe',
					scroll : true,
					type : "iframe",
					url : url,
					buttons : _config.buttons || [],
					params : _config.params || ''
				}
			},
			callback : _callback || new Function()
		};

		var dia = build(data).show();
		dia.on('layoutDone', function() {
			new dragdrop.Draggable({
				handle : dia.head,
				element : dia.element,
				isDrop : false,
				isClone : false
			});
		});
		return dia;
	}

	function dialogFailure(html, elem, callback, iconType, buttons) {
		var data = {
			config : {
				width : 'auto',
				lock : true,
				cache : false,
				elem : elem,
				layout : 'sys/ui/extend/dialog/dialog_tip.tmpl',
				content : {
					type : "tip",
					html : html,
					iconType : iconType || 'failure',// warn,question,success,failure
					buttons : buttons
				}
			},
			callback : callback,
			actor : {
				type : "Slide"
			},
			trigger : {
				type : "AutoClose",
				timeout : 2
			},
			position : {
				type : 'ElementPosition'
			}
		}
		return build(data).show();
	}

	function dialogSuccess(html, elem, callback, iconType, buttons) {

		var data = {
			config : {
				width : 'auto',
				lock : true,
				cache : false,
				elem : elem,
				layout : 'sys/ui/extend/dialog/dialog_tip.tmpl',
				content : {
					type : "tip",
					html : html,
					iconType : iconType || 'success',// warn,question,success,failure
					buttons : buttons
				}
			},
			callback : callback,
			actor : {
				type : "Slide"
			},
			trigger : {
				type : "AutoClose",
				timeout : 2
			},
			position : {
				type : 'ElementPosition'
			}
		};
		return build(data).show();
	}

	function dialogConfirm(html, callback, iconType, buttons) {
		var data = {
			config : {
				width : 436,
				lock : true,
				cahce : false,
				title : lang['ui.dialog.operation.title'],
				content : {
					type : "common",
					html : html,
					iconType : iconType || 'question',// warn,question,success,failure
					buttons : buttons && buttons.length > 0 ? buttons : [ {
						name : lang['ui.dialog.button.ok'],
						value : true,
						focus : true,
						fn : function(value, dialog) {
							dialog.hide(value);
						}
					}, {
						name : lang['ui.dialog.button.cancel'],
						value : false,
						styleClass : 'lui_toolbar_btn_gray',
						fn : function(value, dialog) {
							dialog.hide(value);
						}
					} ]
				}
			},
			callback : callback
		}
		return build(data).show();
	}

	function dialogLoading(html, elem, win) {
		var data = {
			config : {
				width : 200,
				lock : true,
				cahce : false,
				elem : elem,
				win : win || window,
				layout : 'sys/ui/extend/dialog/dialog_loading.tmpl',
				content : {
					type : "loading",
					html : html
				}
			},
			actor : {
				type : "Loading"
			},
			position : {
				type : 'ElementPosition'
			}
		}
		return build(data).show();
	}

	function resolveUrl(url, urlParam) {
		if (url.indexOf('?') > 0) {
			url += "&" + urlParam;
		} else {
			url += "?" + urlParam;
		}
		return url;
	}

	function __paramByKey(url, param) {
		var re = new RegExp();
		re.compile("[\\?&]" + param + "=([^&]*)", "i");
		var arr = re.exec(url);
		if (arr == null)
			return null;
		else
			return decodeURIComponent(arr[1]);
	}

	function rtfield(idField, nameField) {
		var idObj, nameObj;
		if (idField != null) {
			if (typeof (idField) == "string")
				idObj = document.getElementsByName(idField)[0];
			else
				idObj = idField;
		}
		if (nameField != null) {
			if (typeof (nameField) == "string")
				nameObj = document.getElementsByName(nameField)[0];
			else
				nameObj = nameField;
		}
		return {
			idObj : idObj,
			nameObj : nameObj
		}
	}

	function dialogSimpleCategory(modelName, idField, nameField, mulSelect,
			action, winTitle, canClose, ___urlParam, notNull) {
		var authType = null, noFavorite = null, url = null;
		if (modelName != null && !Object.isString(modelName)) {
			var _cfg = modelName;
			modelName = _cfg.modelName;
			idField = _cfg.idField;
			nameField = _cfg.nameField;
			mulSelect = _cfg.mulSelect;
			action = _cfg.action;
			winTitle = _cfg.winTitle;
			canClose = _cfg.canClose;
			___urlParam = _cfg.___urlParam;
			authType = _cfg.authType;
			noFavorite = _cfg.noFavorite;
			notNull = _cfg.notNull;
			url = _cfg.url;
		}
		authType = authType || 2;
		var w = 800, h = 480;
		url = url ? url : '/sys/ui/js/category/simple-category.jsp';
		canClose = canClose == false ? false : true;
		mulSelect = mulSelect == true ? true : false;
		notNull = notNull == false ? false : true;
		if (modelName) {
			url = resolveUrl(url, "modelName=" + modelName);
		}
		if (noFavorite) {
			url = resolveUrl(url, "noFavorite=" + noFavorite);
		}
		if (authType != null) {
			url = resolveUrl(url, "authType=" + authType);
		}
		if (mulSelect) {
			h = 510;
		}
		url = resolveUrl(url, "mulSelect=" + mulSelect);

		var fields = rtfield(idField, nameField);

		var idObj = fields.idObj;
		if (idObj && idObj.value)
			url = resolveUrl(url, "currId=" + idObj.value);

		var nameObj = fields.nameObj;

		var buttons = [ {
			name : lang['ui.dialog.button.ok'],
			value : true,
			focus : true,
			fn : function(value, dialog) {
				var params = {};
				var iframe = dialog.element.find('iframe').get(0);
				var urlParams = iframe.contentWindow.urlParams;
				if ((!urlParams || urlParams.length == 0)) {
					if (notNull) {
						dialogAlert(lang['ui.dialog.category.message']);
						return;
					} else
						urlParams = [ '', '' ];
				}
				params = {
					id : urlParams[0],
					name : urlParams[1]
				};
				if (idObj)
					idObj.value = urlParams[0];
				if (nameObj) {
					nameObj.value = urlParams[1];
					// 触发校验事件
					if (nameObj.type != 'hidden') {
						nameObj.focus();
						nameObj.blur();
					}
				}
				dialog.hide(params);
			}
		} ];
		if (canClose)
			buttons.push({
				name : lang['ui.dialog.button.cancel'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					dialog.hide(value);
				}
			});
		if (!notNull)
			buttons.push({
				name : lang['ui.dialog.button.cancelSelect'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					var params = {};
					params = {
						id : '',
						name : ''
					};
					if (idObj)
						idObj.value = '';
					if (nameObj) {
						nameObj.value = '';
					}
					dialog.hide(params);
				}
			});
		var data = {
			config : {
				width : w,
				height : h,
				lock : true,
				cache : false,
				title : winTitle || lang['ui.dialog.category'],
				scroll : true,
				close : canClose,
				content : {
					id : 'dialog_category',
					scroll : true,
					type : "iframe",
					url : url,
					params : ___urlParam,
					buttons : buttons
				}
			},
			callback : action
		}
		var dia = build(data).show();
		dia.on('layoutDone', function() {
			new dragdrop.Draggable({
				handle : dia.head,
				element : dia.element,
				isDrop : false,
				isClone : false
			});
		});
		return dia;
	}

	// 模块名、点击确定跳转路径、是否多选、回调、窗口标题、当前分类id、打开新窗口^、是否允许关闭、扩展字段（字面量）
	function dialogSimpleCategoryForNewFile(modelName, urlParam, mulSelect,
			action, winTitle, idVal, target, canClose, ___urlParam) {
		var authType = null;
		if (modelName != null && !Object.isString(modelName)) {
			var _cfg = modelName;
			modelName = _cfg.modelName;
			mulSelect = _cfg.mulSelect;
			action = _cfg.action;
			winTitle = _cfg.winTitle;
			canClose = _cfg.canClose;
			___urlParam = _cfg.___urlParam;
			authType = _cfg.authType;
			urlParam = _cfg.urlParam;
			__url = _cfg.url;
		}
		authType = authType || 2;
		var w = 800, h = 480;
		var url = typeof __url == "undefined" || __url == null ? '/sys/ui/js/category/simple-category.jsp'
				: __url;
		canClose = canClose == false ? false : true;
		mulSelect = mulSelect == true ? true : false;
		if (modelName) {
			url = resolveUrl(url, "modelName=" + modelName);
		}
		if (idVal) {
			url = resolveUrl(url, "currId=" + idVal);
		}
		if (mulSelect) {
			h = 510;
		}

		url = resolveUrl(url, "mulSelect=" + mulSelect);
		url = resolveUrl(url, "authType=" + authType);

		if (window.console)
			console.log('dialogSimpleCategoryForNewFile:url=' + url);

		var buttons = [ {
			name : lang['ui.dialog.button.ok'],
			value : true,
			focus : true,
			fn : function(value, dialog) {
				var params = {};
				var iframe = dialog.element.find('iframe').get(0);
				var urlParams = iframe.contentWindow.urlParams;
				if (!urlParams || urlParams.length == 0) {
					dialogAlert(lang['ui.dialog.category.message'],'','','',true);
					return;
				}
				params = {
					id : urlParams[0],
					name : urlParams[1]
				}
				if (urlParam) {

					var openUrl = strutil.variableResolver(urlParam, params);
					window.open(env.fn.formatUrl(openUrl),
							target != null ? target : '_blank');
				}
				dialog.hide(params);
			}
		} ];
		if (canClose)
			buttons.push({
				name : lang['ui.dialog.button.cancel'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					dialog.hide(value);
				}
			});
		var data = {
			config : {
				width : w,
				height : h,
				lock : true,
				cache : false,
				title : winTitle || lang['ui.dialog.category'],
				scroll : true,
				close : canClose,
				content : {
					id : 'dialog_category',
					scroll : true,
					type : "iframe",
					url : url,
					params : ___urlParam,
					buttons : buttons
				}
			},
			callback : action
		}
		var dia = build(data).show();
		dia.on('layoutDone', function() {
			new dragdrop.Draggable({
				handle : dia.head,
				element : dia.element,
				isDrop : false,
				isClone : false
			});
		})
		return dia;
	}
	;

	function dialogCategory(modelName, idField, nameField, mulSelect, action,
			winTitle, canClose, isShowTemp, areaId, notNull) {
		var authType = null, noFavorite = null;
		if (modelName != null && !Object.isString(modelName)) {
			var _cfg = modelName;
			modelName = _cfg.modelName;
			idField = _cfg.idField;
			nameField = _cfg.nameField;
			mulSelect = _cfg.mulSelect;
			action = _cfg.action;
			winTitle = _cfg.winTitle;
			canClose = _cfg.canClose;
			isShowTemp = _cfg.isShowTemp;
			areaId = _cfg.areaId;
			authType = _cfg.authType;
			noFavorite = _cfg.noFavorite;
			notNull = _cfg.notNull;
		}
		var w = 800, h = 480;
		var url = '/sys/ui/js/category/category.jsp';
		canClose = canClose == false ? false : true;
		mulSelect = mulSelect == true ? true : false;
		isShowTemp = isShowTemp == false ? 0 : 1;
		notNull = notNull == false ? false : true;
		if (modelName) {
			url = resolveUrl(url, "modelName=" + modelName);
		}
		if (authType != null) {
			url = resolveUrl(url, "authType=" + authType);
		}
		if (noFavorite) {
			url = resolveUrl(url, "noFavorite=" + noFavorite);
		}
		if (mulSelect) {
			h = 510;
		}
		url = resolveUrl(url, "isShowTemp=" + isShowTemp);
		url = resolveUrl(url, "mulSelect=" + mulSelect);
		var fields = rtfield(idField, nameField);
		var idObj = fields.idObj;
		if (idObj && idObj.value)
			url = resolveUrl(url, "currId=" + idObj.value);

		var nameObj = fields.nameObj;
		var buttons = [ {
			name : lang['ui.dialog.button.ok'],
			value : true,
			focus : true,
			fn : function(value, dialog) {
				var params = {};
				var iframe = dialog.element.find('iframe').get(0);
				var urlParams = iframe.contentWindow.urlParams;
				if ((!urlParams || urlParams.length == 0)) {
					if (notNull) {
						dialogAlert(lang['ui.dialog.template.message'],'','','',true);
						return;
					} else
						urlParams = [ '', '' ];
				}
				params = {
					id : urlParams[0],
					name : urlParams[1]
				};
				if (idObj)
					idObj.value = urlParams[0];
				if (nameObj) {
					nameObj.value = urlParams[1];
					// 触发校验事件
					if (nameObj.type != 'hidden') {
						nameObj.focus();
						nameObj.blur();
					}
				}
				dialog.hide(params);
			}
		} ];
		if (canClose)
			buttons.push({
				name : lang['ui.dialog.button.cancel'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					dialog.hide(value);
				}
			});
		if (!notNull)
			buttons.push({
				name : lang['ui.dialog.button.cancelSelect'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					var params = {};
					params = {
						id : '',
						name : ''
					};
					if (idObj)
						idObj.value = '';
					if (nameObj) {
						nameObj.value = '';
					}
					dialog.hide(params);
				}
			});
		var data = {
			config : {
				width : w,
				height : h,
				lock : true,
				cache : false,
				title : winTitle || lang['ui.dialog.template'],
				scroll : true,
				close : canClose,
				content : {
					id : 'dialog_category',
					scroll : true,
					type : "iframe",
					url : url,
					buttons : buttons
				}
			},
			callback : action
		}
		var dia = build(data).show();
		dia.on('layoutDone', function() {
			new dragdrop.Draggable({
				handle : dia.head,
				element : dia.element,
				isDrop : false,
				isClone : false
			});
		})
		return dia;
	}

	function dialogCategoryForNewFile(modelName, urlParam, mulSelect, winTitle,
			action, idVal, target, canClose, isShowTemp, areaId) {
		var w = 800, h = 480;
		var url = '/sys/ui/js/category/category.jsp';
		canClose = canClose == false ? false : true;
		mulSelect = mulSelect == true ? true : false;
		isShowTemp = isShowTemp == false ? 0 : 1;

		if (modelName) {
			url = resolveUrl(url, "modelName=" + modelName);
		}
		if (idVal) {
			url = resolveUrl(url, "currId=" + idVal);
		}
		url = resolveUrl(url, "isShowTemp=" + isShowTemp);

		if (mulSelect) {
			h = 510;
		}
		url = resolveUrl(url, "mulSelect=" + mulSelect);
		url = resolveUrl(url, "authType=2");
		if (window.console) {
			console.log('dialogCategoryForNewFile:url=' + url);
		}

		var buttons = [ {
			name : lang['ui.dialog.button.ok'],
			value : true,
			focus : true,
			fn : function(value, dialog) {
				var params = {};
				if (urlParam) {
					var iframe = dialog.element.find('iframe').get(0);
					var urlParams = iframe.contentWindow.urlParams;
					if (!urlParams || urlParams.length == 0) {
						dialogAlert(lang['ui.dialog.template.message'],'','','',true);
						return;
					}
					params = {
						id : urlParams[0],
						name : urlParams[1]
					}

					var openUrl = strutil.variableResolver(urlParam, params);
					if (window.console) {
						console.log(urlParams);
						console.log(openUrl);
					}
					window.open(env.fn.formatUrl(openUrl),
							target != null ? target : '_blank');
				}
				dialog.hide(params);
			}
		} ];
		if (canClose)
			buttons.push({
				name : lang['ui.dialog.button.cancel'],
				value : false,
				styleClass : 'lui_toolbar_btn_gray',
				fn : function(value, dialog) {
					dialog.hide(value);
				}
			});
		var data = {
			config : {
				width : w,
				height : h,
				lock : true,
				cache : false,
				title : winTitle || lang['ui.dialog.template'],
				scroll : true,
				close : canClose,
				content : {
					id : 'dialog_category',
					scroll : true,
					type : "iframe",
					url : url,
					buttons : buttons
				}
			},
			callback : action
		}

		var dia = build(data).show();
		return dia;
	}
	;

	function dialogResult(data) {
		if (data.status == true) {
			dialogSuccess({
				title : data.title,
				message : data.message
			});
		} else {
			dialogFailure({
				title : data.title,
				message : data.message
			});
		}
	}
	;
	function dialogTree(serviceBean, title, _callback, _config) {
		var dconfig = {
			width : 500,
			height : 500
		};
		var url = "/sys/ui/js/dialog/tree.jsp?service="
				+ encodeURIComponent(serviceBean);
		$.extend(dconfig, _config);
		var data = {
			config : {
				lock : true,
				cache : false,
				width : dconfig.width,
				height : dconfig.height,
				top : dconfig.top,
				left : dconfig.left,
				title : title || '',
				content : {
					id : 'dialog_iframe',
					scroll : true,
					type : "iframe",
					url : url
				}
			},
			callback : _callback || new Function()
		};
		var dia = build(data).show();
		// debugger;
		dia.on('layoutDone', function() {
			new dragdrop.Draggable({
				handle : dia.head,
				element : dia.element,
				isDrop : false,
				isClone : false
			});
		})
		return dia;
	}
	;

	exports.Dialog = Dialog;
	exports.build = build;

	exports.tree = dialogTree;
	exports.alert = dialogAlert;
	exports.result = dialogResult;
	exports.confirm = dialogConfirm;
	exports.success = dialogSuccess;
	exports.failure = dialogFailure;
	exports.loading = dialogLoading;
	exports.iframe = dialogIframe;
	exports.simpleCategoryForNewFile = dialogSimpleCategoryForNewFile;
	exports.simpleCategory = dialogSimpleCategory;
	exports.categoryForNewFile = dialogCategoryForNewFile;
	exports.category = dialogCategory;
});