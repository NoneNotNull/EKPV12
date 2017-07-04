
/**
 * 筛选器基础模块
 */
define(function(require, exports, module) {
	var base = require("lui/base");
	
	var cbase = require('lui/criteria/base');
	
	var criteriaGroup = cbase.criteriaGroup;
	var CRITERION_CHANGED = cbase.CRITERION_CHANGED;
	var CRITERION_UPDATE = cbase.CRITERION_UPDATE;
	var CRITERION_HASH_CHANGE = cbase.CRITERION_HASH_CHANGE;
	var criteriaParent = cbase.criteriaParent;
	
	var CriterionSelectedValues = base.Base.extend({
		// 类型值
		valueType: null,
		initProps: function($super, cfg) {
			$super(cfg);
			this.title = cfg.title;
			this.key = cfg.key;
			this.values = cfg.selectedValues ? cfg.selectedValues.selectedValues : [];
			this.model = [];
			this.enable = true;
			this.required = false;
		},
		startup: function() {
			if (this.isStartup) {
				return;
			}
			registerCriteriaValue(this);
			criteriaGroup(this).subscribe(CRITERION_UPDATE, this._onUpdateValues, this);
			this.isStartup = true;
			return this;
		},
		updateModel: function(model) {
			this.model = model;
		},
		findFromModel: function(value) {
			for (var i = 0; i < this.model.length; i ++) {
				if (value == this.model[i].value) {
					return this.model[i];
				}
			}
			return null;
		},
		findAllFromModel: function(values) {
			var rtn = [];
			for (var i = 0; i < values.length; i ++) {
				var val = this.findFromModel(values[i]);
				if (val)
					rtn.push(val);
			}
			return rtn;
		},
		cloneOldVal: function() {
			return [].concat(this.values);
		},
		findFromSelected: function(value) {
			for (var i = 0; i < this.values.length; i ++) {
				if (this.values[i] == value || this.values[i].value == value) {
					return this.values[i];
				}
			}
			return null;
		},
		defaultValueDatas : function(value) {
			if (value) {
				var evt = {
					key : this.key,
					values : [{
								value : value
							}]
				};
				// criteriaGroup(this).publish(CRITERION_HASH_CHANGE, evt);
				criteriaParent(this)._appendDefault(evt);
			}
		},
		isEnable: function() {
			return this.enable;
		},
		isRequired: function() {
			return this.required;
		},
		setEnable: function(enable) {
			if (this.enable === enable) {
				return;
			}
			this.enable = enable;
			if (!this.enable) {
				this.removeAll();
			}
			this.emit('enableChanged', this);
		},
		setRequired: function(required) {
			this.required = required;
			this.emit('requiredChanged', this);
		},
		// ------ api ------
		exclusive: function() {
			return this.parent.exclusive;
		},
		selected: function() {
			return this.values.length > 0;
		},
		add: function(value) {
			var old = this.cloneOldVal();
			value = this.findFromModel(value);
			if (value) {
				if (this.findFromSelected(value) != null)
					return;
				this.values.push(value);
				this.fireChanged(old);
			}
		},
		addAll: function(values) {
			var old = this.cloneOldVal();
			values = this.findAllFromModel(values);
			var add = true;
			for (var i = 0; i < values.length; i ++) {
				var val = values[i];
				if (this.findFromSelected(val) != null)
					continue;
				add = true;
				for (var j = 0; j < this.values.length; j ++) {
					if (this.values[j] == val) {
						add = false;
						break;
					}
				}
				if (add) {
					this.values.push(val);
				}
			}
			this.fireChanged(old);  
		},
		remove: function(value) {
			if (this.isRequired() && this.values.length == 1) {
				return;
			}
			var old = this.cloneOldVal();
			value = this.findFromModel(value);
			for (var i = 0; i < this.values.length; i ++) {
				if (value == this.values[i]) {
					this.values.splice(i, 1);
					break;
				}
			}
			if (old.length == this.values.length)
				return;
			this.fireChanged(old);
		},
		removeAll: function(vals) {
			if (this.isRequired() && this.values.length == 1) {
				return;
			}
			var old = this.cloneOldVal();
			if (vals == null || vals.length == 0) {
				this.values = [];
				if (old == null || old.length == 0)
					return;
				this.fireChanged(old);
				return;
			}
			vals = this.findAllFromModel(vals);
			for (var i = 0; i < this.values.length; i ++) {
				for (var j = 1 ; j < vals.length; j ++) {
					var val = vals[j];
					if (val == this.values[i]) {
						this.values.splice(i, 1);
						i --;
					}
				}
			}
			this.fireChanged(old);
		},
		replace: function(old, value) {
			var old = this.cloneOldVal();
			// TODO 替换实现
		},
		replaceAll: function(values) {
			var old = this.cloneOldVal();
			// TODO 替换实现
		},
		set: function(value) {
			var old = this.cloneOldVal();
			this.values = [];
			value = this.findFromModel(value);
			if (value)
				this.values.push(value);
			this.fireChanged(old);
		},
		setAll: function(values) {
			var old = this.cloneOldVal();
			this.values = [];
			values = this.findAllFromModel(values);
			this.values = this.values.concat(values);
			this.fireChanged(old);
		},
		getFireSelectedValues: function() {
			return this.values;
		},
		fireChanged: function(old) {
			var evt = {trigger: this.parent, src: this, key: this.key, exclusive: this.parent.exclusive,
					title: this.title, values: this.getFireSelectedValues(), oldValues: old};
			this.emit('changed', evt);
			criteriaGroup(this).publish(CRITERION_CHANGED, evt);
		},
		// --------- api event --------
		_onUpdateValues: function(evt) {
			if (evt.key != this.key) {
				return;
			}
			var opt = evt.operation;
			var vals = evt.value;
			this[opt](vals);
		},
		// -----------
		destroy: function($super) {
			unregisterCriteriaValue(this);
			$super();
		}
	});
	
	var NormalSelectedValues = CriterionSelectedValues.extend({
		valueType: "normal"
	});
	
	var HierarchySelectedValues = CriterionSelectedValues.extend({
		valueType: "hierarchy",
		initProps: function($super, cfg) {
			$super(cfg);
			this.model = {parent: null, current: null, datas: null, parents: []};
			this.source = cfg.source;
		},
		setSource: function(source) {
			this.source = source;
		},
		updateModel: function(model) {
			if (Object.isArray(model)) {
				this.model.datas = model;
				return;
			}
			//console.info('update model : ', model);
			this.model.parents = model.parents ? [].concat(model.parents) : [];
			this.model.parent = model.parents ? model.parents[model.parents.length - 1] : null;
			this.model.current = model.current && model.current.value ? model.current : null;
			this.model.datas = model.datas;
		},
		_resetModel: function(currentRealVal) {
			// 根据值，重新计算当前model
			if (currentRealVal == this.model.current)
				return;
			var inParent = this.findFromParents(currentRealVal.value);
			if (inParent) {
				var newParents = [];
				var oldParents = this.model.parents;
				for (var i = 0 ; i < oldParents.length; i ++) {
					if (oldParents[i] == currentRealVal) {
						break;
					}
				}
				this.model.parents = newParents;
			} else {
				if (this.model.current != null)
					this.model.parents.push(this.model.current);
			}
			this.model.current = currentRealVal;
			if (this.model.parents.length > 0)
				this.model.parent = this.model.parents[this.model.parents.length - 1];
		},
		_findFromArray: function(array, val) {
			for (var i = 0; i < array.length; i ++) {
				var row = array[i];
				if (row.value == val) {
					return row;
				}
			}
			return null;
		},
		findFromDatas: function(val) {
			return this._findFromArray(this.model.datas || [], val);
		},
		findFromParents: function(val, fn) {
			return this._findFromArray(this.model.parents || [], val, fn);
		},
		findFromModel: function(value) {
			if (this.model.current && value == this.model.current.value)
				return this.model.current;
			var rtn = this.findFromDatas(value);
			if (rtn)
				return rtn;
			return this.findFromParents(value);
		},
		lookValueDatas : function(val) {
			this._callSource(val || {}, function() {}, true, function(data) {return {value:data, firer: this};});
		},
		_callSource: function(val, fn, all, fmt) {
			if (this.source) {
				if (this.source.resolveUrl) {
					this.source.resolveUrl(val);
					if (all) {
						this.source.url += '&_all=true';
					}
				}
				this.source.get(function(data) {
					this.updateModel(data);
					fn.call(this);
					return fmt(data);
				}, this);
			} else {
				fn.call(this);
			}
		},
		add: function($super, value) {
			var realVal = this.findFromModel(value);
			if (realVal)
				$super(value);
			this._callSource({'value':value}, function() {
				$super(value);
			}, true);
		},
		addAll: function(values) {
			this.add(values[0]);
		},
		replace: function($super, old, value) {
			$super(old, value);
		},
		replaceAll: function($super, values) {
			$super(old, values);
		},
	
		set : function($super, value, firer) {
			var realVal = this.findFromModel(value);
			this._callSource({
						'value' : value
					}, function() {
						if (realVal)
							this._resetModel(realVal);
						$super(value);
					}, realVal == null, function(data) {
						return {
							value : data,
							firer : firer
						}
					});
		},
		setAll: function(values) {
			this.set(values[0]);
		},
		remove: function(value) {
			this.removeAll();
		},
		removeAll : function($super, vals) {
			if (!this.selected()) {
				return;
			}
			this._callSource({}, function() {
						$super(vals);
					}, true, function(data) {
						return {
							value : data,
							firer : this
						}
					});
		},
		getFireSelectedValues: function() {
			//console.info('parents : ', this.model.parents);
			if (!this.model.current)
				return [];
			return (this.model.parents || []).concat([this.model.current]);
		},
		defaultValueDatas : function(value) {
			if (value) {
				var evt = {
					key : this.key,
					values : [{value:value}]
				};
				criteriaGroup(this).publish(CRITERION_HASH_CHANGE, evt);
			}
		},
		
		// 前推一位父对象，用于无子分类的分类操作
		upperParent : function() {
			this.model.parent = this.model.parents.length > 1
					? this.model.parents[this.model.parents.length - 2]
					: null;
		}
	});
	
	var RangeSelectedValues = NormalSelectedValues.extend({
		valueType: "range",
		findFromModel: function($super, value) {
			if (value.text != null)
				return value;
			var val = $super(value);
			if (val)
				return val;
			return {text: value, value: value};
		}
	});
	
	
	function registerCriteriaValue(selectedValue) {
		var p = selectedValue;
		while(p) {
			if (p.registerCriteriaValue) {
				p.registerCriteriaValue(selectedValue);
				return;
			}
			p = p.parent;
		}
	}
	
	function unregisterCriteriaValue(selectedValue) {
		var p = selectedValue;
		while(p) {
			if (p.unregisterCriteriaValue) {
				p.unregisterCriteriaValue(selectedValue);
				return;
			}
			p = p.parent;
		}
	}
	
	exports.CriterionSelectedValues = CriterionSelectedValues;
	exports.NormalSelectedValues = NormalSelectedValues;
	exports.HierarchySelectedValues = HierarchySelectedValues;
	exports.RangeSelectedValues = RangeSelectedValues;
});