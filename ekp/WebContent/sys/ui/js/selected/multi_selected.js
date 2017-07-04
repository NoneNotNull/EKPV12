
/**
 * 筛选器对外保利API模块
 */
define(function(require, exports, module) {

	//require("theme!criteria");
	
	//var topic = require('lui/topic');
	var Class = require("lui/Class");
	var base = require('lui/base');
	var $ = require('lui/jquery');
	var Evented = require('lui/Evented');
	var render = require('lui/view/render');
	
	function eqById(expt, val) {
		if (expt == val)
			return true;
		var v1 = Object.isString(expt) || Object.isNumber(expt) ? expt : expt.id;
		var v2 = Object.isString(val) || Object.isNumber(val) ? val : val.id;
		return v1 == v2;
	}
	
	var SelectedModel = new Class.create(Evented, {
			initialize : function(cfg) {
				cfg = cfg || {};
				this._init_signal();
				this.config = cfg;
				this.parent = cfg.parent;
				this.values = cfg.values || [];
				this.eqFun = cfg.eqFun || eqById;
				this._startuped = false;
			},
			setParent: function(parent) {
				this.parent = parent;
			},
			startup: function() {
				if (this._startuped) {
					return;
				}
				this._emitValue('startup', this.values);
				this._startuped = true;
			},
			_old: function() {
				return [].concat(this.values);
			},
			_emitValue: function(name, old) {
				this.emit(name, {curr: this.values, old: old});
				this.emit("changed", {curr: this.values, old: old});
			},
			has: function(val) {
				for (var i = 0 ; i < this.values.length; i ++) {
					if (this.eqFun(this.values[i], val)) {
						return true;
					}
				}
				return false;
			},
			addAll: function(vals) {
				var old = this._old();
				for (var i = 0; i < vals.length; i ++) {
					if (!this.has(vals[i])) {
						this.values.push(vals[i]);
					}
				}
				this._emitValue('addAll', old);
			},
			add: function(val) {
				if (this.has(val)) {
					return;
				}
				var old = this._old();
				this.values.push(val);
				this._emitValue('add', old);
			},
			remove: function(val) {
				if (!this.has(val)) {
					return;
				}
				var old = this._old();
				for (var i = 0 ; i < this.values.length; i ++) {
					if (this.eqFun(this.values[i], val)) {
						this.values.splice(i, 1);
						break;
					}
				}
				this._emitValue('remove', old);
			},
			set: function() {
				
			},
			removeAll: function() {
				var old = this.values;
				this.values = [];
				this._emitValue('removeAll', old);
			}
	});
	
	var Selected = base.Component.extend({
			className: "lui-selected",
			initProps: function($super, cfg) {
				$super(cfg);
				this.render = null;
				this.model = null;
			},
			addChild: function(child) {
				if (child instanceof base.DataRender){
					this.setRender(child);
				}
				if (child instanceof SelectedModel) {
					this.setModel(child);
				}
			},
			setRender: function(render) {
				this.render = render;
			},
			setModel: function(model) {
				this.model = model;
			},
			doRender: function(html) {
				this.element.html(html);
			},
			bindEvent: function() {
				var self = this;
				this.element.delegate('[data-id]', 'click', function() {
					self.model.remove(this.getAttribute('data-id'));
				});
				this.element.delegate('.selected_removeall', 'click', function() {
					self.model.removeAll();
				});
				
				this.model.on('changed', function(evt) {
					self.emit('changed', evt);
				});
			},
			modelChanged: function(evt) {
				this.render.get(evt.curr);
			},
			startup: function($super) {
				$super();
				if (this.render == null) {
					this.render = new render.Template({src:require.resolve('sys/ui/extend/selected/multi_selected.tpl.jsp#'), parent: this});
				}
				if (this.model == null) {
					this.model = new SelectedModel({parent: this, values: this.config.values});
				}
				this.model.on('changed', this.modelChanged, this);
				this.render.on('html', this.doRender, this);
				this.bindEvent();
				return this;
			},
			draw: function($super) {
				$super();
				this.model.startup();
				this.emit('ready');
			},
			// api
			addVal: function(val) {
				this.model.add(val);
			},
			addValAll: function(vals) {
				this.model.addAll(vals);
			},
			removeVal: function(val) {
				this.model.remove(val);
			},
			removeValAll: function() {
				this.model.removeAll();
			},
			getValues: function() {
				return this.model.values;
			},
			hasVal: function(val) {
				return this.model.has(val);
			}
	});
	
	exports.Selected = Selected;
	exports.SelectedModel = SelectedModel;
});