define(function(require, exports, module) {
	require('theme!step')
	var base = require("lui/base");
	var panel = require("lui/panel");
	var layout = require("lui/view/layout");
	var topic = require('lui/topic');
	var str = require('lui/util/str');
	var $ = require("lui/jquery");

	var Step = base.Container.extend({

		initProps : function($super, cfg) {
			$super(cfg);
			this.contents = [];
			this._contents = [];
			this._titles = [];
			this.__index = this.config.index || 0;
			this.__range = this.config.range || 0;

			this.vars = {};
			if (this.config.vars)
				this.vars = this.config.vars;
		},

		addChild : function($super, obj) {
			if (obj instanceof layout.AbstractLayout)
				this.layout = obj;
			else if (obj instanceof panel.AbstractContent)
				this.contents.push(obj);
			$super(obj);
		},

		startup : function($super) {
			$super();
		},

		doLayout : function($super, obj) {
			this.frame = $(obj);
			this.element.append(this.frame);
			this.element.show();
			this.parseContentMark(this.frame);
			this.initFirstContent();
			this.buildTemp();
			$super(obj);
			this.bindEvent();
		},

		buildTemp : function() {
			this.__submit = this.element.find('[data-lui-mark="step.submit"]');
			this.__next = this.element.find('[data-lui-mark="step.next"]');
			this.__pre = this.element.find('[data-lui-mark="step.pre"]');
		},

		parseContentMark : function(frame) {
			var contentNodes = frame.find("[data-lui-mark='step.contents']");
			for (var i = 0; i < this.contents.length; i++) {
				var dom = $("<div data-lui-content-index='" + i + "'></div>");
				dom.append(this.contents[i].element).hide();
				contentNodes.append(dom);
				this._contents.push(dom);
			}
		},

		initFirstContent : function() {
			if (this._contents.length === 0)
				return;
			this.contents[0].load();
			this._contents[0].show();
		},

		__hideContents : function() {
			for (var j = 0; j < this.contents.length; j++) {
				this._contents[j].hide();
			}
		},

		_refreshContent : function(i) {
			if (!this.vars.unHide)
				this.__hideContents();
			this._contents[i].show();
			this.contents[i].load();
		},

		_refreshButton : function() {
			if (this.hasPre()) {
				this.__submit.hide();
				this.__pre.show();
			} else
				this.__pre.hide();
			if (this.hasNext()) {
				this.__submit.hide();
				this.__next.show();
				this.__next.removeClass('btn_step_nor');
			} else if (!this.hasSubmit())
				this.__next.addClass('btn_step_nor');
			else
				this.__next.hide();
			if (this.hasSubmit()) {
				this.__next.hide();
				this.__submit.show();
			}
		},

		_refreshTitle : function(i) {
			var self = this;
			if (this._titles.length === 0)
				this.element.find('[data-lui-mark="step.title"] li').each(
						function() {
							self._titles.push($(this));
						});
			for (var j = 0; j < self._titles.length; j++) {
				self._titles[j].removeClass('current');

			}
			self._titles[i].addClass('current');
		},

		fireEvent : function(type, evt) {
			topic.channel(this).publish(
					[type.toLocaleUpperCase(), 'STEP'].join('.'), evt);
		},

		refresh : function(index) {
			this._refreshContent(index);
			this._refreshTitle(index);
			this._refreshButton();
		},

		pre : function() {
			if (!this.hasPre())
				return;
			var evt = {
				// type : 'pre',
				'last' : this.__index,
				'cur' : this.__index - 1
			};
			this.fireEvent('jump', evt);
			if (evt.cancel)
				return;
			this.__index--;
			this.refresh(this.__index);
		},

		next : function() {
			if (!this.hasNext())
				return;
			var evt = {
				// type : 'next',
				'last' : this.__index,
				'cur' : this.__index + 1
			};
			this.fireEvent('jump', evt);
			if (evt.cancel)
				return;
			this.__index++;
			this.refresh(this.__index);
			this._refreshTitled(this.__index);
			this.resetRange();
		},

		// 重置当前可点击范围
		resetRange : function() {
			if (this.__index > this.__range)
				this.__range = this.__index;
		},

		_refreshTitled : function(i) {
			var self = this;
			if (this._titles.length === 0)
				this.element.find('[data-lui-mark="step.title"] li').each(
						function() {
							self._titles.push($(this));
						});
			if (!self._titles[i].hasClass('fulfill')) {

				for (; i < self._titles.length && i >= 0; i--) {
					self._titles[i].addClass('fulfill');
				}
			}
		},

		submit : function() {
			var evt = {
				type : 'submit',
				index : (this.__index)
			};
			new Function(this.config.onSubmit)();
			this.fireEvent('submit', evt);
		},

		// 强制跳转
		fireJump : function(index) {
			var i = parseInt(index);
			var evt = {
				'last' : this.__index,
				'cur' : i
			};
			this.fireEvent('firejump', evt);
			if (evt.cancel)
				return;
			this.__index = parseInt(index);
			this.resetRange();
			this._refreshTitled(this.__index);
			this.refresh(this.__index);
		},

		jump : function(index) {
			var i = parseInt(index);
			if (i > this.__range)
				return;
			var evt = {
				'last' : this.__index,
				'cur' : i
			};
			this.fireEvent('jump', evt);
			if (evt.cancel)
				return;
			this.__index = parseInt(index);
			this.refresh(this.__index);
		},

		hasPre : function() {
			return !this.vars.unPre && this.__index > 0;
		},

		hasNext : function() {
			return this.__index < this.contents.length - 1;
		},

		hasSubmit : function() {
			return this.config.onSubmit
					&& this.__index === this.contents.length - 1;
		},

		// 绑定向前向后提交按钮
		bindEvent : function() {
			var self = this;
			this.element.bind('click', function(evt) {
						var $parent = $(evt.target);
						while ($parent.length > 0) {
							if ($parent.attr('data-lui-mark') == 'step.pre') {
								self.pre();
								break;
							}
							if ($parent.attr('data-lui-mark') == 'step.next') {
								self.next();
								break;
							}
							if ($parent.attr('data-lui-mark') == 'step.submit') {
								self.submit();
								break;
							}
							if (!self.vars.unPre)

								if ($parent.attr('data-lui-index')) {
									self.jump($parent.attr('data-lui-index'));
								}
							$parent = $parent.parent();
						}
					});
		}
	});

	exports.Step = Step;
})