
/**
 * 筛选器基础模块
 */
define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	var base = require("lui/base");
	var layout = require('lui/view/layout');
	var render = require('lui/view/render');
	var $ = require('lui/jquery');
	
	var cbase = require('./base');
	var criteriaGroup = cbase.criteriaGroup;
	var CRITERION_CHANGED = cbase.CRITERION_CHANGED;
	var CRITERION_UPDATE = cbase.CRITERION_UPDATE;
	
	var CriteriaSelected = base.Container.extend({
		className: 'criteria-selected',
		doLayout: function(html) {
			this.element.html(html);
			this.element.addClass('criterion');
			this.selectedArea = this.element.find('.criterion-expand');
			this.multiOption = this.element.find('.multi-option');
			
			var self = this;
			this.selectedArea.bind('click', function(evt) {
				self.onCancel(evt);
			});
			
			var selectedArea = this.selectedArea;
			var multiOption = this.multiOption;
			multiOption.bind('click', function(evt) {
				if (multiOption.hasClass('selected')) {
					self.parent.setMultiAll(false);
				} else {
					self.parent.setMultiAll(true);
				}
			});
			multiOption.text(lang['ui.criteria.multi']);
			multiOption.attr('title', lang['ui.criteria.multi']);
			
			var self = this;
			selectedArea.find('.commit-action').bind('click', function() {
					self.parent.fireCriteriaChanged();
					$(this).hide();
			});
			this.showMultiOption();
		},
		showMultiOption: function() {
			if (this.multiOption == null)
				return;
			if (this.parent.isSupportMulti() && this.parent.canMulti && this.parent.expand) {
				this.multiOption.show();
			} else {
				this.multiOption.hide();
			}
		},
		_onMultiChanged: function(multi) {
			var multiOption = this.multiOption;
			if (multi) {
				multiOption.addClass('selected');
				multiOption.text(lang['ui.criteria.single']);
				multiOption.attr('title', lang['ui.criteria.single']);
			} else {
				multiOption.removeClass('selected');
				multiOption.text(lang['ui.criteria.multi']);
				multiOption.attr('title', lang['ui.criteria.multi']);
				this.selectedArea.find('.commit-action').hide();
			}
			this.showCommitAction = multi;
		},
		onCancel: function(evt) {
			var target = $(evt.target);
			if (target.hasClass('cancel')) {
				var ps = target.parents('[data-criterion-key]');
				var dataCriterion = $(ps[0]);
				var evtData = {
					operation: 'removeAll',
					key: dataCriterion.attr('data-criterion-key'),
					value: null
				};
				criteriaGroup(this).publish(CRITERION_UPDATE, evtData);
			}
		},
		onSelectedChanged: function(val) {
			if (this.showCommitAction) {
				this.selectedArea.find('.commit-action').show();
			}
			if (val.trigger) {
				var fire = val.trigger.criteria_selected == false
						? false
						: true;
				if (!fire)
					return;
			}
			var cellRender = val.render || this.cellRender;
			var key = val.key;
			var empty = (val.values.length == 0);
			var oldKey = this.selectedArea.find('[data-criterion-key="'+key+'"]');
			var selectedArea = this.selectedArea;
			if (oldKey.length == 0 && !empty) {
				cellRender.get(val, function(html) {
					selectedArea.find('.criterion-other').before(html);
				});
			}
			else {
				if (empty) {
					oldKey.remove();
				} else {
					cellRender.get(val, function(html) {
						oldKey.before(html);
						oldKey.remove();
					});
				}
			}
		},
		startup: function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.layout) {
				this.layout = new layout.Template({src:require.resolve('./template/criterion-selected.jsp#'), parent:this});
				this.layout.startup();
			}
			if (!this.cellRender) {
				this.cellRender = new render.Template({src:require.resolve('./template/criterion-selected-cell.html#'), parent:this});
				this.cellRender.startup();
			}
			$super();
			this.showCommitAction = this.parent.multi;
			this.parent.on('multiChanged', this._onMultiChanged, this);
			criteriaGroup(this).subscribe(CRITERION_CHANGED, this.onSelectedChanged, this);
			this.isStartup = true;
		}
	});
	
	exports.CriteriaSelected = CriteriaSelected;
});