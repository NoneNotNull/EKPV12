
/**
 * 筛选器基础模块
 */
define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	var base = require("lui/base");
	var layout = require('lui/view/layout');
	var $ = require('lui/jquery');
	var topic = require('lui/topic');
	
	var CRITERIA_UPDATE = 'criteria.update'; 
	// {operation: 'add|set|remove|clear', data:[{key: 'key', value: 'value'}]}
	
	var CRITERIA_CHANGED = 'criteria.changed';
	var CRITERION_CHANGED = 'criteria.criterion.changed';
	var CRITERION_UPDATE = "criteria.criterion.update";
	var CRITERION_HASH_CHANGE = 'criteria.criterion.hash.change';
	// {operation: 'add|addAll|remove|removeAll|replace|replaceAll', key: 'key', value: 'value'}
	
	var Criteria = base.Container.extend({
		className: 'criteria',
		initProps: function($super, cfg) {
			$super(cfg);
			this.criterions = [];
			this.expand = cfg.expand || false;
			this.multi = cfg.multi || false;
			this.canMulti = cfg.canMulti == false ? false : true;
			this.criteriaValues = [];
			this.immediateFire = !this.multi;
			this.fireCount = 0;
		},
		registerCriteriaValue: function(cv) {
			this.criteriaValues.push(cv);
		},
		serLayHashInit:function(lazy){
			this.lazyHashInit = lazy;
		},
		getCriteriaValues: function() {
			var rtn = [];
			for (var i = 0; i < this.criteriaValues.length; i ++) {
				var c = this.criteriaValues[i];
				if (c.isEnable())
					rtn.push(c);
			}
			return rtn;
		},
		unregisterCriteriaValue: function(cv) {
			for (var i = 0; i < this.criteriaValues.length; i ++) {
				if (cv == this.criteriaValues[i]) {
					this.criteriaValues.splice(i, 1);
					break;
				}
			}
		},
		addChild: function($super, child, attr) {
			if (child.className == 'criterion' || attr == 'criterions') {
				this.criterions.push(child);
				return;
			}
			$super(child, attr);
		},
		
		removeCriterion:function(ct){
			for (var i = 0; i < this.criterions.length; i ++) {
				if (ct == this.criterions[i]) {
					this.criterions.splice(i, 1);
					break;
				}
			}
		},
		
		// 判断是否有支持展开收缩功能
		isAllExpand : function() {
			var _allExpand = true;
			$.each(this.criterions, function() {
				if (this.expand == false
						|| this.expand == 'false') {
					_allExpand = false;
				}
			});
			return _allExpand;
		},
		_drawAll: function() {
			if (this._criterions_draw === false) {
				this._criterions_draw = true;
				$.each(this.criterions, function(i, criterion) {
					criterion.draw();
				});
			}
		},
		expandCriterions: function(expand, animate) {
			if (expand) { // 延迟绘制
				this._drawAll();
			}
			animate = animate == false ? animate : true;
			$.each(this.criterions, function() {
				if (this.expand == false) {
					this.show(expand ,animate);
				}
			});
			if (expand) {
				this.moreAction.addClass('expand');
				this.moreAction.find('.text').text(lang['ui.criteria.^allCondition']);
				this.moreAction.attr('title', lang['ui.criteria.^allCondition']);
			} else {
				this.moreAction.removeClass('expand');
				this.moreAction.find('.text').text(lang['ui.criteria.allCondition']);
				this.moreAction.attr('title', lang['ui.criteria.allCondition']);
			}
			this.expand = expand;
			this.criteriaSelected.showMultiOption();
		},
		isSupportMulti: function() {
			for (var i = 0; i < this.criterions.length; i ++) {
				if (this.criterions[i].supportMulti()) {
					return true;
				}
			}
			return false;
		},
		setMultiAll: function(multi) {
			if (multi === this.multi)
				return;
			this.multi = multi;
			if (this.clearCriterionValue)
				this.clearCriterionValue();
			$.each(this.criterions, function() {
				if (this.supportMulti()) {
					this.setMulti(multi);
				}
			});
			this.immediateFire = !this.multi;
			this.emit('multiChanged', multi);
		},
		doLayout: function(html) {
			var self = this;
			this.element.append(html);
			this.selectedArea = this.element.find('.criteria-selected-wapper');
			this.criterionsArea = this.element.find('.criterions-wapper');
			this.popupArea = this.element.find('.criteria-popup-wapper');
			this.moreAction = this.element.find('.criteria-extra-more');
			this.criteriaSelected.setParentNode(this.selectedArea);
			this.criteriaSelected.draw();
			
			var criterionsArea = this.criterionsArea[0];
			
			$.each(this.criterions, function(i, criterion) {
				criterion.setParentNode(criterionsArea);
			});
			this._criterions_draw = false; // 延迟绘制，draw调用移动到expandCriterions中
			$.each(this.criterions, function() {
				if (this.immediately == true || this.expand) {
					this.draw();
				}
			});
			this.expandCriterions(this.expand, false);
			var moreAction = this.moreAction;
			if (this.isAllExpand())
				moreAction.hide();
			else
				moreAction.bind('click', function() {
					if (moreAction.hasClass('expand')) {
						self.expandCriterions(false);
					} else {
						self.expandCriterions(true);
					}
				});
			this.element.show();
		},
		startup: function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.layout) {
				this.layout = new layout.Template({src:require.resolve('./template/criteria.jsp#'), parent: this});
				this.layout.startup();
			}
			if (!this.criteriaSelected) {
				this.criteriaSelected = new CriteriaSelected({parent:this});
				this._startupChild(this.criteriaSelected);
			}
			$super();
			return this;
		},
		destroy: function($super) {
			this._destroyAll(this.criterions);
			this.criterionsArea.off();
			this.criterionsArea = null;
			this.selectedArea.off();
			this.selectedArea = null;
			this.popupArea.off();
			this.popupArea = null;
			this.moreAction.off();
			this.moreAction = null;
			$super();
		},
		draw: function($super) {
			if(this.isDrawed)
				return;
			$super();
		}
	});
	
	var criteriaParent = function(component) {
		var criteria = component;
		while (criteria) {
			if (criteria instanceof Criteria) {
				return criteria;
			}
			criteria = criteria.parent;
		}
		return null;
	};
	
	var criteriaGroup = function(component) {
		return topic.channel(criteriaGroupName(component));
	};
	
	var criteriaGroupName = function(component) {
		var criteria = component;
		while (criteria) {
			if (criteria instanceof Criteria) {
				return criteria.channel;
			}
			criteria = criteria.parent;
		}
		return null;
	};
	
	var criterionContainer = function(component) {
		var criterion = component;
		while (criterion) {
			if (criterion.className == 'criterion' || criterion._isCriterionProxy) {
				return criterion;
			}
			criterion = criterion.parent;
		}
		return null;
	};
	
	var criterionIsMulti = function(component) {
		var criterion = criterionContainer(component);
		if (criterion)
			return criterion.multi;
		return false;
	};
	
	exports.criteriaParent = criteriaParent;
	exports.criteriaGroupName = criteriaGroupName;
	exports.criteriaGroup = criteriaGroup;
	exports._Criteria = Criteria;
	//exports.Criterion = Criterion;
	exports.criterionIsMulti = criterionIsMulti;
	exports.criterionContainer = criterionContainer;
	exports.CRITERIA_UPDATE = CRITERIA_UPDATE;
	exports.CRITERIA_CHANGED = CRITERIA_CHANGED;
	exports.CRITERION_CHANGED = CRITERION_CHANGED;
	exports.CRITERION_UPDATE = CRITERION_UPDATE;
	exports.CRITERION_HASH_CHANGE = CRITERION_HASH_CHANGE;
});