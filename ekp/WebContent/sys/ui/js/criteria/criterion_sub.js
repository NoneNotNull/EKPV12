/**
 * 子属性
 */
define(function(require, exports, module) {
	var select_panel = require('lui/criteria/select_panel');
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var criterion = require('lui/criteria/criterion');
	var select_panel = require('lui/criteria/select_panel');
	var source = require('lui/data/source');
	var render = require("lui/view/render");
	var cbase = require('lui/criteria/base');
	var criteriaGroup = cbase.criteriaGroup;
	var criterionIsMulti = cbase.criterionIsMulti;
	var CRITERION_CHANGED = cbase.CRITERION_CHANGED;

	var SubSelectedValues = select_panel.CriterionSelectDatas.extend({
		className : "sub",

		initProps : function($super, cfg) {
			$super(cfg);
			this.__subUrl = this.config.subUrl || '';
		},

		startup : function($super) {
			$super();
			var self = this;
			criteriaGroup(this).subscribe(CRITERION_CHANGED,
					this.onSelectedChanged, this);
			this.onErase(function() {
						criteriaGroup(self).unsubscribe(CRITERION_CHANGED,
								self.onSelectedChanged, self);
					});
		},

		onSelectedChanged : function($super, evt) {
			if (evt && evt.values && evt.values.length === 0) {
				this.clearSub();
			}
		},

		onChanged : function(evt) {
			this.synchSelected();
			this.buildSub(evt);
		},

		clearAll : function() {
			this.selectedValues.removeAll();
			this.clearSub();
		},

		serializeParams : function(p) {
			var array = [this.__subUrl];
			for (var j = 0; j < p.values.length; j++) {
				array.push("q." + encodeURIComponent(p.key) + '='
						+ encodeURIComponent(p.values[j].value));
			}
			array.push('__time=' + new Date().getTime());
			this.request(array.join('&'));
		},

		clearSub : function() {
			var __criterion = this.parent.parent;
			if (__criterion.subCriterion) {
				var __sub = __criterion.subCriterion;
				__criterion.parent.removeCriterion(__sub);
				__sub.selectBox.criterionSelectElement.clearAll();
				__sub.destroy();
			}
		},

		// 构建子属性对象
		buildSub : function(p) {
			this.serializeParams(p);
		},

		request : function(url) {
			if (window.console)
				console.log('subUrl:' + url);
			var self = this;
			self.clearSub();
			$.ajax({
						url : env.fn.formatUrl(url),
						dataType : 'json',
						success : function(data, textStatus) {
							self.buildKlass(data);
						},
						error : function(request, textStatus, errorThrown) {
						}
					});
		},

		_buildCriterion : function(key, title, __criteria) {
			var _criterion = new criterion.Criterion({
						key : key,
						expand : false,
						title : title,
						parent : __criteria
					});
			if (__criteria && __criteria.criterions) {
				__criteria.criterions.push(_criterion);
			}
			return _criterion;
		},

		_buildTitleBox : function(title, _criterion) {
			var _titleBox = new criterion.CriterionTitleBox({
						title : title,
						parent : _criterion
					});
			this._addChildren(_titleBox.parent, _titleBox);
			_criterion.titleBox = _titleBox;
			return _titleBox;
		},

		_buildSelectBox : function(_criterion) {
			var _selectBox = new criterion.CriterionSelectBox({
						parent : _criterion
					});
			this._addChildren(_selectBox.parent, _selectBox);
			_criterion.selectBox = _selectBox;
			return _selectBox;
		},

		_buildPanel : function(_selectBox) {
			var _panel = new SubSelectedValues({
						parent : _selectBox
					});
			this._addChildren(_panel.parent, _panel);
			_selectBox.criterionSelectElement = _panel;
			return _panel;
		},

		_bulidSource : function(option, _panel) {
			var _source = new source.Static({
						datas : option,
						parent : _panel
					});
			_panel.setSource(_source);
			this._addChildren(_source.parent, _source);
			return _source;
		},

		_buildRender : function(_panel) {
			var _render = new render.Template({
						src : require.resolve('./template/criterion-cell.jsp#'),
						parent : _panel
					});
			_panel.setRender(_render);
			this._addChildren(_render.parent, _render);
			_render.startup();
			return _render;
		},

		_buildSelectedValues : function(_panel) {
			var _selectedValues = criterionIsMulti(_panel);
			_panel.buildSelectedValues(_selectedValues);
			this._addChildren(_panel.selectedValues.parent,
					_panel.selectedValues);
		},

		buildKlass : function(data) {
			var option = data.option;
			if (!option || option.length == 0)
				return;
			var key = data.key, title = data.title;
			var __criterion = this.parent.parent;
			var __critaria = __criterion.parent;
			var _criterion = this._buildCriterion(key, title, __critaria);
			var _titleBox = this._buildTitleBox(title, _criterion)
			var _selectBox = this._buildSelectBox(_criterion);
			var _panel = this._buildPanel(_selectBox);
			var _source = this._bulidSource(option, _panel);
			if(_source.startup)
					_source.startup();
			this._buildRender(_panel);
			this._buildSelectedValues(_panel);
			_source.startup();
			_criterion.startup();
			_titleBox.startup();
			_selectBox.startup();
			_criterion.draw();
			__criterion.subCriterion = _criterion;
			_criterion.element.insertAfter(__criterion.element);

			// 设置单选多选
			var __criteriaSelected = __critaria.criteriaSelected;
			if (!__criteriaSelected.multiOption.hasClass('selected'))
				return;
			if (_criterion.supportMulti()) {
				_criterion.setMulti(true);
			}
		},

		_addChildren : function(parent, child) {
			parent.children.push(child);
		}

	});

	exports.SubSelectedValues = SubSelectedValues;
});
