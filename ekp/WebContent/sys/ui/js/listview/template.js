define(function(require, exports, module) {

	var base = require("lui/base");
	var render = require('lui/view/render');
	var strutil = require('lui/util/str');
	var $ = require('lui/jquery');
	var tmpl = require("lui/view/Template");
	var env = require("lui/util/env");
	var loader = require('lui/util/loader');
	var listview = require('lui/listview/listview');

	var AbstractTemplate = base.Container.extend(loader.ResourceLoadMixin, {
				get : function() {

				}
			});

	var Template = AbstractTemplate.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.code = this.element.children("script[type='text/code']")
					.html();
		},

		addChild : function($super, child) {
			if (child instanceof base.DataRender) {
				this.setRender(child);
				// 避免render自身加载模板
				child._loaded = true;
			}
			$super(child);
		},

		startup : function($super) {
			if (this.render) {
				this.render._parseFormScript(this.render.cfg);
				this.src = this.render.cfg.src;
				this.loadResource(this.getEnv().fn.formatUrl(this.src));
			} else
				this._onLoad(this.code);
			$super();
		},

		initRender : function() {
			this.render._parseFormScript(this.render.cfg);
		},

		setTmpl : function(_tmpl) {
			this.tmpl = _tmpl;
		},

		setRender : function(_render) {
			this.render = _render;
		},

		html : function(data) {
			try {
				if (this.parent && this.parent.emit)
					this.parent.emit("earse", this.parent);
				return (this.tmpl.render({
							"data" : data,
							"template" : this,
							"env" : env,
							"param" : this.param,
							"$" : $,
							"str" : strutil
						}));
			} catch (e) {
				if (window.console)
					console.error("render.Template:error,render.id=" + this.cid
									+ "", e.stack);
				this.emit("error", "render.Template:id="
								+ this.cid
								+ "错误:"
								+ strutil.errorMessage(e.stack, "文件:"
												+ this.src, -2));
			}
		},

		_onLoad : function(html) {
			this.setTmpl(new tmpl(html));
		},

		isShowOtherProp : function(prop) {
			var kv = strutil.toJSON(this.code);
			if (!kv)
				return false;
			if (!kv.showOtherProps) {
				return false;
			}
			var props = kv.showOtherProps.split(/[;,]/);
			if (props.length == 0) {
				return true;
			}
			for (var p in props) {
				if (props[p] === prop) {
					return true;
				}
			}
			return false;
		},

		isFdIdProp : function(key) {
			return 'fdId' === key;
		},

		get : function(data) {
			this.datas = [];
			this._datas = [];
			var datas = data['datas'], columns = data['columns'];
			if (this.render) {
				var kv = strutil.toJSON(this.code);

				for (var i = 0; i < datas.length; i++) {
					var json = {};
					var _json = {};
					for (var j = 0; j < datas[i].length; j++) {

						var flag = false;
						var value = datas[i][j]['value'], key = datas[i][j]['col'];
						if (kv && kv.map) {// 数据转换
							for (var k in kv.map) {
								if (datas[i][j]['col'] == kv.map[k]) {
									key = k;
									break;
								}
							}
						}
						if (columns[j]) {
							json[key] = {
								label : columns[j]['title'],
								text : datas[i][j]['value']
							};
							_json[key] = datas[i][j]['value'];
						}

					}
					var rowId = listview.UniqueId();
					json['rowId'] = rowId;
					_json['rowId'] = rowId;
					this.datas.push(json);
					this._datas.push(_json);
				}

				this.showCheckbox = kv && kv.showCheckbox == false
						? false
						: true;
				this.parent.renderLoaded(this.datas);
			} else {
				for (var i = 0; i < datas.length; i++) {
					var json = {};
					for (var j = 0; j < datas[i].length; j++) {
						json[datas[i][j]['col']] = datas[i][j]['value'];
					}
					json['rowIndex'] = i;
					json['rowId'] = listview.UniqueId();
					this.datas.push(json);
				}
				this.parent.renderLoaded(this.datas, this.customHtml);
			}
		},

		customHtml : function(data, index, key) {
			if (this && this.emit)
				this.emit("earse", this);
			var _rd = {
				"env" : env,
				"$" : $,
				"index" : index,
				"str" : strutil,
				"template" : this
			};
			_rd[key] = data;
			return (this.tmpl.render(_rd));
		},

		fireHtml : function(txt) {
			this.emit('html', txt);
		}
	});

	exports.Template = Template;
	exports.AbstractTemplate = AbstractTemplate;
})