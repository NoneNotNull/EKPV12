define(function(require, exports, module) {
			var lang = require('lang!sys-ui');
			var select_panel = require('lui/criteria/select_panel');
			var render = require('lui/view/render');
			var source = require('lui/data/source');
			var $ = require('lui/jquery');
			
			var CriterionInputDatas = select_panel.CriterionInputDatas;
			
			var TextInput = CriterionInputDatas.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.placeholder = cfg.placeholder || lang['ui.criteria.insert'];
				},
				supportMulti: function() {
					return false;
				},
				startup : function($super) {
					if (this.isStartup) {
						return;
					}
					if (!this.render) {
						this.setRender(new render.Template({
									src : require
											.resolve('./template/criterion-textinput-cell.jsp#'),
									parent : this
								}));
						this.render.startup();
					}
					if (!this.source) {
						this.setSource(new source.Static({
									datas : [{
												'placeholder' : this.placeholder
											}],
									parent : this
								}));
						if(this.source.startup)
							this.source.startup();
					}
					$super();
				},
				doRender : function($super, html) {
					$super(html);
					var self = this;
					this.element.find('.commit-action').bind('click', function(evt) {
						self.onClicked(evt);
					}).hide();
					this.element.find(':text').bind({
						'keyup' : function(evt) {
							self.onKeyup(evt);
						},
						// 解决鼠标右键粘贴不触发事件的问题
						'paste':function(evt){
							self.onPaste(evt);
						}
					});
					LUI.placeholder(this.element);
				},
				onClicked: function(evt) {
					this.addValue();
				},
				onKeyup : function(evt) {
					if (evt.keyCode != 13 && this.element.find(':text').val() != '') {
						this.element.find('.commit-action').show();
					}
					if (evt.keyCode == 13) {
						this.addValue();
					}
				},
				
				onPaste : function(evt) {
					this.element.find('.commit-action').show();
				},
				
				addValue: function() {
					var text = this.element.find(':text');
					var value = text.val();
					if (value == '') {
						this.selectedValues.removeAll();
						return;
					}
					this.selectedValues.set(value);
				},
				onChanged: function(val) {
					var sv = this.selectedValues.values;
					var text = this.element.find(':text');
					if (sv == null || sv.length == 0) {
						text.val('');
						this.element.find('.commit-action').hide();
						return;
					}
					if (text.val() != sv[0].value) {
						text.val(sv[0].value);
					}
					if (!sv[0].text) { // 修补文本
						sv[0].text = sv[0].value;
					}
					this.element.find('.commit-action').hide();
				}
			});
			
			var NumberInput = CriterionInputDatas.extend({
				supportMulti: function() {
					return false;
				},
				startup : function($super) {
					if (this.isStartup) {
						return;
					}
					if (!this.render) {
						this.setRender(new render.Template({
									src : require
											.resolve('./template/criterion-numberinput-cell.jsp#'),
									parent : this
								}));
						this.render.startup();
					}
					if (!this.source) {
						this.setSource(new source.Static({
									datas : [{min: 'MIN', max: 'MAX'}],
									parent : this
								}));
						if(this.source.startup)
							this.source.startup();
					}
					$super();
				},
				onChanged: function(val) {
					var sv = this.selectedValues.values;
					
					var min = this.element.find('[name="lui-critertion-min"]');
					var max = this.element.find('[name="lui-critertion-max"]');
					if (sv == null || sv.length == 0) {
						min.val('');
						max.val('');
						this.element.find('[data-critertion-number-min]').each(function() {
							$(this).find('a').removeClass('selected');
						});
						return;
					}
					var hasSelected = false;
					this.element.find('[data-critertion-number-min]').each(function() {
						var valElem = $(this);
						var aElem = valElem.find('a');
						if (valElem.attr('data-critertion-number-min') == sv[0].value
								&& valElem.attr('data-critertion-number-max') == sv[1].value) {
							if (!aElem.hasClass('selected')) {
								aElem.addClass('selected');
							}
							hasSelected = true;
						} else {
							aElem.removeClass('selected');
						}
						if (!sv[0].text) { // 修复选项文本
							sv[0].text = aElem.attr('title');
							sv[1].text = aElem.attr('title');
						}
					});
					if (!hasSelected) {
						min.val(sv[0].value);
						max.val(sv[1].value);
						if (!sv[0].text) { // 修复选项文本
							sv[0].text = sv[0].value;
							sv[1].text = sv[1].value;
						}
					} else {
						min.val('');
						max.val('');
					}
				},
				onSelected: function(evt) {
					var target = evt.target;
					if (target == this.element[0]) {
						return;
					}
					var self = this;
					self._withElement(target, 'data-critertion-number-min', function(valElem) {
						if (valElem.attr('data-critertion-number-min') == 'MIN'
							&& valElem.attr('data-critertion-number-max') == 'MAX') {
							return;
						}
						var aElem = valElem.find('a');
						if (!aElem.hasClass('selected')) {
							self.selectedValues.setAll([
							     {text: aElem.attr('title'), value: valElem.attr('data-critertion-number-min')},
							     {text: aElem.attr('title'), value: valElem.attr('data-critertion-number-max')}
							]);
						} else {
							self.selectedValues.removeAll();
						}
					});
				},
				doRender : function($super, html) {
					$super(html);
					var self = this;
					this.element.find('.commit-action').bind('click', function(evt) {
						self.onClicked(evt);
					}).hide();
					this.element.find('[name="lui-critertion-min"], [name="lui-critertion-max"]').bind('keyup', function(evt) {
						self.onKeyup(evt);
					});
				},
				onClicked: function(evt) {
					this.addValue();
				},
				onKeyup : function(evt) {
					if (evt.keyCode == 13) {
						this.addValue();
					} else {
						var min = this.element.find('[name="lui-critertion-min"]');
						var max = this.element.find('[name="lui-critertion-max"]');
						if (min.val() == '' || max.val() == '') {
							this.element.find('.commit-action').hide();
							return;
						}
						this.element.find('.commit-action').show();
					}
				},
				addValue: function() {
					this.element.find('.commit-action').hide();
					var min = this.element.find('[name="lui-critertion-min"]');
					var max = this.element.find('[name="lui-critertion-max"]');
					if (min.val() == '' || max.val() == '') {
						this.selectedValues.removeAll();
						return;
					}
					this.selectedValues.setAll([
					     min.val(),
					     max.val()
					]);
				}
			});
			
			exports.TextInput = TextInput;
			exports.NumberInput = NumberInput;
});