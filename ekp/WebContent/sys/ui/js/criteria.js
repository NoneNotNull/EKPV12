
/**
 * 筛选器对外保利API模块
 */
define(function(require, exports, module) {

	require("theme!criteria");
	
	var topic = require('lui/topic');
	var base = require('lui/base');
	var $ = require('lui/jquery');
	
	var cbase = require('lui/criteria/base');
	var selected = require('lui/criteria/criteria_selected');
	var criterion = require('lui/criteria/criterion');
	var selected_values = require('lui/criteria/selected_values');
	var select_panel = require('lui/criteria/select_panel');
	var criterion_popup = require('lui/criteria/criterion_popup');
	
	var criteriaGroup = cbase.criteriaGroup;
	var CRITERIA_UPDATE = cbase.CRITERIA_UPDATE;
	var CRITERIA_CHANGED = cbase.CRITERIA_CHANGED;
	var CRITERION_CHANGED = cbase.CRITERION_CHANGED;
	var CRITERION_HASH_CHANGE = cbase.CRITERION_HASH_CHANGE;
	
	function drawParent(c) {
		while(c.parent && !c.parent.isDrawed) {
			c = c.parent;
		}
		if (!c.isDrawed && c.draw) {
			c.draw();
		}
	}
	
	var Criteria = cbase._Criteria.extend({
		initProps: function($super, cfg) {
			$super(cfg);
			this.oldImmediateFire = [];
			this.changedLock = false;
		},
		startup: function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.criteriaSelected) {
				this.criteriaSelected = new selected.CriteriaSelected({parent:this});
				this._startupChild(this.criteriaSelected);
			}
			$super();
			criteriaGroup(this).subscribe(CRITERIA_UPDATE, this._onCriteriaUpdate, this);
			criteriaGroup(this).subscribe(CRITERION_CHANGED, this._onCriterionChanged, this);
			criteriaGroup(this).subscribe(CRITERION_HASH_CHANGE, this._onCriterionHashChanged, this);
			if (this.hasHash()) {// 附带hash默认值的由筛选器初始化列表，防止列表重复初始化
				criteriaGroup(this).publish('criteria.init');
			}
			return this;
		},
		
		// 筛选项默认值重构hash
		_onCriterionHashChanged : function(evt) {
			var keys = [this._hashMultiKey(), this._hashCriterionKey()];
			var hashMap = this._getFromHash(keys);
			var criMap = {};
			if (hashMap[keys[1]] != null) {
				var hashStr = hashMap[keys[1]];
				var hashArray = hashStr.split(';');
				for (var i = 0; i < hashArray.length; i++) {
					var p = hashArray[i].split(':');
					var val = criMap[p[0]];
					if (val == null) {
						val = [];
						criMap[p[0]] = val;
					}
					val.push(p[1]);
				}
			}
			if (evt.key) {
				var __values = [];
				for (var jj = 0; jj < evt.values.length; jj++) {
					__values.push(evt.values[jj].value);
				}
				criMap[evt.key] = __values;
			}
			var ___hashArray = [];
			for (var kk in criMap) {
				var vals = criMap[kk];
				var key = encodeURIComponent(kk);
				for (var i = 0; i < vals.length; i++) {
					___hashArray.push(key + ":"
							+ encodeURIComponent(vals[i]));
				}
			}
			var hashStr = ___hashArray.join(';');
			hashMap[keys[1]] = hashStr;
			this._setToHash(hashMap);
		},
		
		hasHash : function() {
			if(this.lazyHashInit)
				return true;
			if (location.hash) {
				var keys = [this._hashCriterionKey()];
				var hashMap = this._getFromHash(keys);
				if (hashMap[keys[0]] != null) {
					return true;
				}
			}
			return false;
		},
		
		beforeBatch: function() {
			this.oldImmediateFire.push(this.immediateFire);
			this.immediateFire = false;
		},
		afterBatch: function(fire) {
			fire = fire === false ? false : true;
			this.immediateFire = true;
			if (fire)
				this.fireCriteriaChanged();
			this.immediateFire = this.oldImmediateFire.pop();
		},
		_onCriteriaUpdate: function(evt) {
			var method = evt.operation + "CriterionValue";
			this[method]({key: evt.key, value: evt.value});
		},
		_onCriterionChanged: function(evt) {
			// 增加锁，避免循环onchange
			if (this.changedLock)
				return;
			try {
				this.fireCount ++;
				var criteriaValues = this.getCriteriaValues();
				// 处理独占联动问题
				if (evt.exclusive && evt.values.length > 0) {
					this.changedLock = true;
					this.beforeBatch();
					for (var i = 0; i < criteriaValues.length; i ++) {
						if (evt.key == criteriaValues[i].key) {
							continue;
						}
						criteriaValues[i].removeAll();
					}
					this.afterBatch(false);
					this.changedLock = false;
				} else if (evt.values.length > 0) {
					this.changedLock = true;
					this.beforeBatch();
					for (var i = 0; i < criteriaValues.length; i ++) {
						var cri = criteriaValues[i];
						if (evt.key != cri.key && cri.exclusive() && cri.selected()) {
							criteriaValues[i].removeAll();
						}
					}
					this.afterBatch(false);
					this.changedLock = false;
				}
				if (this.immediateFire) {
					this.fireCriteriaChanged();
				}
			} catch (e) {
				this.changedLock = false;
			}
		},
		findSelectedValuesByKey: function(key) {
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				var crv = criteriaValues[i];
				if (crv.key == key) {
					return crv;
				}
			}
			return null;
		},
		_buildCriteriaSelectedValues : function() {
			var array = [];
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i++) {
				var crv = criteriaValues[i];
				if (crv.values != null && crv.values.length > 0) {
					var vals = [];
					var valus = {};
					for (var j = 0; j < crv.values.length; j++) {
						vals.push(crv.values[j].value);
						if (crv.values[j].nodeType) {
							valus.nodeType = crv.values[j].nodeType;
						}
					}
					valus.key = crv.key;
					valus.value = vals;
					array.push(valus);
				}
			}
			return array;
		},
		
		fireCriteriaChanged: function() {
			if (this.fireCount == 0) {
				if(window.console)
					console.info("Criteria: 无条件变化，不分发事件!");
				return;
			}
			// 条件拼装
			var criterions = this._buildCriteriaSelectedValues();
			var evt = {criteria: this.id, criterions: criterions};
			if(window.console)
				console.info("Criteria: 发布条件变化事件:", evt);
			criteriaGroup(this).publish(CRITERIA_CHANGED, evt);
			this.fireCount = 0;
			
			this._buildHashUrl(criterions);
		},
		_hashCriterionKey: function() {
			if (this.channel == null) {
				return "cri.q";
			}
			return "cri." + this.channel + ".q";
		},
		_hashMultiKey: function() {
			if (this.channel == null) {
				return "cri.m";
			}
			return "cri." + this.channel + ".m";
		},
		// ----- hash操作 -------
		_buildHashUrl: function(criterions) {
			// 查询条件
			criterions = criterions || this._buildCriteriaSelectedValues();
			var hashArray = [];
			$.each(criterions, function() {
				var vals = this.value;
				var key = encodeURIComponent(this.key);
				for (var i = 0; i < vals.length; i ++) {
					hashArray.push(key + ":" + encodeURIComponent(vals[i]));
				}
			});
			var hashStr = hashArray.join(';');
			
			// 多选
			var multi = this.multi;
			if (multi === this.config.multi) {
				multi = '';
			} else if (this.config.multi == null && multi == false) {
				multi = '';
			}
			
			// 设置hash
			var hashMap = {};
			hashMap[this._hashCriterionKey()] = hashStr;
			hashMap[this._hashMultiKey()] = multi;
			this._setToHash(hashMap);
		},
		_parseHashUrl: function() {
			var keys  = [this._hashMultiKey(), this._hashCriterionKey()];
			var hashMap = this._getFromHash(keys);
			if (hashMap[keys[0]] != null) {
				this.setMultiAll(hashMap[keys[0]] == 'true');
			}
			var criterions = [], criMap = {};
			if (hashMap[keys[1]] != null) {
				var hashStr = hashMap[keys[1]];
				var hashArray = hashStr.split(';');
				for (var i = 0; i < hashArray.length; i ++) {
					var p = hashArray[i].split(':');
					var val = criMap[p[0]];
					if (val == null) {
						val = [];
						criMap[p[0]] = val;
					}
					val.push(p[1]);
				}
			}
			for (var k in criMap) {
				criterions.push({'key': k, 'value': criMap[k]});
			}
			if (criterions.length == 0 && this._all_default) {
				for (var i = 0; i < this._all_default.length; i++) {
					var val = [], dval = this._all_default[i];
					for (var j = 0; j < dval.values.length; j ++) {
						val.push(dval.values[j].value);
					}
					criterions.push({'key': dval.key, 'value': val});
				}
			}
			if (criterions.length > 0) {
				this.setAllCriterionValue(criterions);
			}
		},
		_getFromHash: function(keys) {
			var localHash = location.hash;
			var re = new RegExp();
			var hashMap = {};
			for (var i = 0; i < keys.length; i ++) {
				var key = encodeURIComponent(keys[i]);
				re.compile("[\\#&]"+key+"=([^&]*)", "i");
				var value = re.exec(localHash);
				if (value != null){
					hashMap[key] = decodeURIComponent(value[1]);
				}
			}
			return hashMap;
		},
		_setToHash: function(hashMap) {
			var localHash = location.hash;
			var re = new RegExp();
			for (var key in hashMap) {
				var value = hashMap[key];
				re.compile("([\\#&]" + key + "=)[^&]*", "i");
				if (re.test(localHash)) {
					if (value == '') {
						localHash = localHash.replace(re, "");
					} else {
						localHash = localHash.replace(re, "$1" + value);
					}
				} else {
					if (value != '') {
						if (localHash.length > 0) {
							localHash += "&" + key + "=" + value;
						} else {
							localHash = key + "=" + value;
						}
					}
				}
			}
			// 解决ie下页面跳动的问题
			var scrollTop =  $(document).scrollTop();
			location.hash = localHash;
			$(document).scrollTop(scrollTop);
		},
		
		draw: function($super) {
			if(this.isDrawed)
				return;
			$super();
			var self = this;
			if (self.criterionCount > 0) {
				this.on('selectDatasload', function() {
							self.criterionCounted++;
							if (self.criterionCounted == self.criterionCount)
								setTimeout(function() {
											self._parseHashUrl();
										}, 1);
						});
				return;
			}
			$(function() { // TODO 状态值重构,需要有dojo组件中的组件ready
				setTimeout(function() {self._parseHashUrl();}, 600);
			});
		},
		_appendDefault: function(evt) {
			this._all_default = this._all_default || [];
			this._all_default.push(evt);
		},
		
		criterionCount: 0,
		
		criterionCounted: 0,
		
		// 用于统计初始化筛选项数量
		_appendCriterionCount : function() {
			this.criterionCount++;
		},
		
		// -- 对外 api --
		addCriterionValue: function(evt) {
			this.beforeBatch();
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				var crv = criteriaValues[i];
				if (crv.key == evt.key) {
					drawParent(crv);
					crv.set(evt.value);
				}
			}
			this.afterBatch();
		},
		setAllCriterionValue: function(evt) {
			this.beforeBatch();
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				var crv = criteriaValues[i];
				var isSeted = false;
				for (var j = 0; j < evt.length; j ++) {
					var p = evt[j];
					if (crv.key == p.key) {
						drawParent(crv);
						crv.setAll(p.value);
						isSeted = true;
						break;
					}
				}
				if (!isSeted) {
					crv.removeAll();
				}
			}
			this.afterBatch();
		},
		setCriterionValue: function(evt) {
			this.beforeBatch();
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				var crv = criteriaValues[i];
				if (crv.key == evt.key) {
					drawParent(crv);
					crv.set(evt.value);
				} else {
					crv.removeAll();
				}
			}
			this.afterBatch();
		},
		removeCriterionValue: function(evt) {
			this.beforeBatch();
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				var crv = criteriaValues[i];
				if (crv.key == evt.key) {
					crv.removeAll();
				}
			}
			this.afterBatch();
		},
		clearCriterionValue: function(evt) {
			this.beforeBatch();
			var criteriaValues = this.getCriteriaValues();
			for (var i = 0; i < criteriaValues.length; i ++) {
				if (evt && evt.exclude == criteriaValues[i].key) {
					continue;
				}
				this.criteriaValues[i].removeAll();
			}
			this.afterBatch();
		},
		addValue:function(key,value){
			this.addCriterionValue({'key': key, 'value': value});
		},
		setValue:function(key,value){
			this.setCriterionValue({'key': key, 'value': value});
		},
		removeValue:function(key,value){
			this.removeCriterionValue({'key': key, 'value': value});
		},
		clearValue:function(key,value){
			this.fireCount = 1;// 强制刷新数据
			this.clearCriterionValue({'key': key, 'value': value});
		}
	});
	
	var titlePopupItemClick = function(channel, key, value) {
		addCriterionValueByChannel(channel, key, value);
	};
	var setCriterionValueByChannel = function(channel, key, value) {
		topic.channel(channel).publish(CRITERIA_UPDATE, {'operation': 'set', 'key': key, 'value': value});
	};
	var addCriterionValueByChannel = function(channel, key, value) {
		topic.channel(channel).publish(CRITERIA_UPDATE, {'operation': 'add', 'key': key, 'value': value});
	};
	var removeCriterionValueByChannel = function(channel, key, value) {
		topic.channel(channel).publish(CRITERIA_UPDATE, {'operation': 'remove', 'key': key, 'value': value});
	};
	var clearCriterionValueByChannel = function(channel, key, value) {
		topic.channel(channel).publish(CRITERIA_UPDATE, {'operation': 'clear', 'key': key, 'value': value});
	};
	var setCriterionValueById = function(id, key, value) {
		base.byId(id).setCriterionValue({'key': key, 'value': value});
	};
	var addCriterionValueById = function(id, key, value) {
		base.byId(id).addCriterionValue({'key': key, 'value': value});
	};
	var removeCriterionValueById = function(id, key, value) {
		base.byId(id).removeCriterionValue({'key': key, 'value': value});
	};
	var clearCriterionValueById = function(id, key, value) {
		base.byId(id).clearCriterionValue({'key': key, 'value': value});
	};
	
	// 全局绑定
	window.luiCriteriaTitlePopupItemClick = titlePopupItemClick;
	window.luiSetCriterionValueByChannel = setCriterionValueByChannel;
	window.luiAddCriterionValueByChannel = addCriterionValueByChannel;
	window.luiRemoveCriterionValueByChannel = removeCriterionValueByChannel;
	window.luiClearCriterionValueByChannel = clearCriterionValueByChannel;
	window.luiSetCriterionValueById = setCriterionValueById;
	window.luiAddCriterionValueById = addCriterionValueById;
	window.luiRemoveCriterionValueById = removeCriterionValueById;
	window.luiClearCriterionValueById = clearCriterionValueById;
	
	// 模块绑定
	exports.luiCriteriaTitlePopupItemClick = titlePopupItemClick;
	exports.luiSetCriterionValueByChannel = setCriterionValueByChannel;
	exports.luiAddCriterionValueByChannel = addCriterionValueByChannel;
	exports.luiRemoveCriterionValueByChannel = removeCriterionValueByChannel;
	exports.luiClearCriterionValueByChannel = clearCriterionValueByChannel;
	exports.luiSetCriterionValueById = setCriterionValueById;
	exports.luiAddCriterionValueById = addCriterionValueById;
	exports.luiRemoveCriterionValueById = removeCriterionValueById;
	exports.luiClearCriterionValueById = clearCriterionValueById;
	
	// 模块对外暴露
	Object.extend(exports, cbase);
	Object.extend(exports, selected);
	Object.extend(exports, criterion);
	Object.extend(exports, selected_values);
	Object.extend(exports, select_panel);
	Object.extend(exports, criterion_popup);
	
	exports.Criteria = Criteria;
});