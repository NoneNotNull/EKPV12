define(function(require, exports, module) {
	var lang = require('lang!sys-ui');
	var select_panel = require('lui/criteria/select_panel');
	var render = require('lui/view/render');
	var source = require('lui/data/source');
	var $ = require('lui/jquery');

	var CriterionInputDatas = select_panel.CriterionInputDatas;

	var CriterionCalendarDatas = CriterionInputDatas.extend({

		className : "criterion-calendar",

		initProps : function($super, cfg) {
			this.INPUT_NAME = "data-lui-date-input-name";
			this.VALIDATE_NAME = "data-lui-date-input-validate";
			this.VALIDATE_CONTAINER_CLASS = "lui_criteria_date_validate_container";
			this.INPUT_PLACEHOLDER = "placeholder";
			this.SELECT_CLASS = "lui_criteria_date_select";
			this.LI_CLASS = "lui_criteria_date_li";
			this.BTN_CLASS = "commit-action";
			this.type = "";
			$super(cfg);
		},
		startup : function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.render) {
				this.render = new render.Template({
					src : require
							.resolve('./template/criterion-calendar-cell.jsp#'),
					parent : this
				});
				this.render.startup();
			}
			if (!this.source) {
				// 待修改
				var data = {
					datas : [{
								'name' : ['date', 'from', this.cid].join('-'),
								'placeholder' : lang['ui.criteria.startDate']

							}, {
								'name' : ['date', 'to', this.cid].join('-'),
								'placeholder' : lang['ui.criteria.endDate']
							}],
					parent : this
				};
				this.source = new source.Static(data);
				if (this.source.startup)
					this.source.startup();
			}

			$super();
		},
		doRender : function($super, html) {
			$super(html);
			this.element.find("." + this.BTN_CLASS).hide();
			LUI.placeholder(this.element);
			this.bindValidate();
		},

		sychOkBtnShow : function() {
			var __show = false;
			var btn = this.element.find("." + this.BTN_CLASS);
			var values = this.selectedValues.values;
			var valuesEmpty = values == null || values.length == 0;
			this.element.find('[' + this.INPUT_NAME + ']').each(function(i) {
				if ((valuesEmpty && this.value != '')
						|| (!valuesEmpty && values[i].value != this.value)) {
					__show = true;
					// btn.show();
					return false;
				}
					// btn.hide();
			});
			// 判断是否通过校验
			this.element.find('.' + this.VALIDATE_CONTAINER_CLASS).each(
					function(i) {
						if ($(this).css('display') == 'block') {
							__show = false;
							return false;
						}
					});
			if (__show)
				btn.show()
			else
				btn.hide();
		},
		onSelected : function(evt) {
			var target = evt.target;
			if (target == this.element[0]) {
				return;
			}
			var $target = $(target);

			// 日期选择
			if ($target.hasClass(this.SELECT_CLASS)
					|| $target.attr('type') == 'text') {
				// 待修改
				var parent = $target.parent();
				var $input = parent.children("[" + this.INPUT_NAME + "]");
				var self = this;
				var btn = this.element.find("." + this.BTN_CLASS);
				window[this.type].call(parent
								.find("." + this.SELECT_CLASS + "")[0],
						window.event || evt, $input.attr(this.INPUT_NAME),
						null, function(field) {
							self.validate($target);
							self.sychOkBtnShow();
						});
			}
			// 筛选确定
			else if ($target.hasClass(this.BTN_CLASS)) {
				var inputValues = [];
				this.element.find("[" + this.INPUT_NAME + "]").each(function() {
							inputValues.push(this.value);
						});
				// 选中区域出现时间信息
				this.selectedValues.setAll(inputValues);
			}
		},
		onChanged : function(val) {
			this.element.find('[' + this.INPUT_NAME + ']').each(function(i) {
						if (val.values != null && val.values.length < i + 1) {
							$(this).val('');
						} else {
							if (!val.values[i].text) { // 修正显示信息
								val.values[i].text = val.values[i].value;
							}
							$(this).val(val.values[i].value);
						}
					});
			this.switchAllActionAreaSelected();
			this.sychOkBtnShow();
		},
		clearAll : function($super) {
			var values = this.selectedValues.values;
			if (values == null || values.length == 0) {
				this.onChanged({
							values : []
						});
				this.element.find("." + this.BTN_CLASS).hide();
				this.clearValidate();
			}
			$super();
		},
		// 文本框输入日期格式校验
		bindValidate : function() {
			var self = this;
			var $inputs = this.element.find('[' + this.INPUT_NAME + ']');
			$inputs.bind('blur', function() {
						self.validate(this);
					});
		},
		clearValidate : function() {
			var $container = this.element.find('.'
					+ this.VALIDATE_CONTAINER_CLASS), $validates = this.element
					.find('[' + this.VALIDATE_NAME + ']');
			$container.hide();
			$validates.css('visibility', 'hidden');
		},
		validate : function(target) {
			if (!$(target).val())
				return false;
			var res = this.executeValidate($(target).val()), name = $(target)
					.attr(this.INPUT_NAME), $validate = this.element.find('['
					+ this.VALIDATE_NAME + '="' + name + '"]'), $container = this.element
					.find('.' + this.VALIDATE_CONTAINER_CLASS);
			if (!res) {
				var msg = this.validateMsg();
				$validate.find('.text').html(msg);
				$container.show();
				$validate.css('visibility', 'visible');
			} else
				$validate.css('visibility', 'hidden');

			var __hasVisibility = false;
			this.element.find('[' + this.VALIDATE_NAME + ']').each(function() {
						if ($(this).css('visibility') == 'visible') {
							__hasVisibility = true;
							return false;
						}
					})
			if (!__hasVisibility)
				$container.hide();
			return res;
		},
		// 执行校验
		executeValidate : function(v) {
			return true;
		},
		// 校验失败返回信息
		validateMsg : function() {}
	});

	var CriterionTimeDatas = CriterionCalendarDatas.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.type = "selectTime";
				},
				executeValidate : function(v) {
					var res = false;
					var regTime = /^[0-2][\d]:[0-5][\d]$/;
					if (v) {
						res = regTime.test(v);
					}
					return res;
				},
				validateMsg : function() {
					return lang['ui.criteria.calendar.time.validate'];
				}
			});

	var CriterionDateDatas = CriterionCalendarDatas.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.type = "selectDate";
		},
		executeValidate : function(v) {
			var res = false;
			var regDate = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
			if (Com_Parameter['Lang'] != null
					&& Com_Parameter['Lang'] != 'zh-cn') {
				regDate = /^(((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-9])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})$/;
			}
			if (v) {
				res = regDate.test(v);
			}
			return res;
		},
		validateMsg : function() {
			return lang['ui.criteria.calendar.date.validate'];
		}
	});

	var CriterionDateTimeDatas = CriterionCalendarDatas.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.type = "selectDateTime";
		},
		executeValidate : function(v) {
			var res = false;
			var regDate = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
			if (Com_Parameter['Lang'] != null
					&& Com_Parameter['Lang'] != 'zh-cn') {
				regDate = /^(((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-9])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})$/;
			}
			var regTime = /^[0-2][\d]:[0-5][\d]$/;
			if (v) {
				var dateAry = v.split(/\s+/);
				if (dateAry.length == 2) {
					res = regDate.test(dateAry[0]) && regTime.test(dateAry[1]);
				}
			}
			return res;
		},
		validateMsg : function() {
			return lang['ui.criteria.calendar.datetime.validate'];
		}
	});
	exports.CriterionTimeDatas = CriterionTimeDatas;
	exports.CriterionDateDatas = CriterionDateDatas;
	exports.CriterionDateTimeDatas = CriterionDateTimeDatas;
});