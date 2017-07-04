define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dijit/_WidgetBase",
				"mui/util", "mui/dialog/Tip", "dojo/html",
				"dojo/text!./intr.html", "dojo/query", "dojo/_base/lang",
				"dojo/dom", "dojo/_base/array", "dojo/request", "dojo/topic",
				"dijit/registry", "dojo/window" ],
		function(declare, domConstruct, domClass, domStyle, domAttr,
				widgetBase, util, tip, html, tmpl, query, lang, dom, array,
				request, topic, registry, win, msg) {

			return declare(
					'sys.introduce.Intr',
					[ widgetBase ],
					{

						mask : null,

						// 限制字数，默认140
						limitNum : 140,

						value : 3,

						lock : false,

						submitEnableClass : 'muiIntrSubmitEnable',

						tips : {
							'intr_tip_1' : '值得一看',
							'intr_tip_2' : '重点推荐',
							'intr_tip_3' : '强力推荐'
						},

						buildRendering : function() {
							this.domNode = this.containerNode;
							this.inherited(arguments);
						},

						startup : function() {
							this.inherited(arguments);
							this.connect(this.domNode, "onclick", 'intrClick');
							topic.publish('/sys/introduce/loaded', [ this ]);

						},

						// 伪输入框点击事件
						intrClick : function(evt) {
							this.defer(this.showMask, 350);
						},

						bindInput : function() {
							var input = this.inputNode[0];
							this.connect(input, "onfocus", 'doFocus');
							this.connect(input, "onblur", 'doBlur');
							this.connect(input, "onkeyup", 'doKeyup');
							this.connect(input, "oninput", 'doInput');
						},

						bindSubmit : function() {
							this.submitHandle = this.connect(
									this.submitNode[0], "onclick", 'doSubmit');
						},

						bindHideMask : function() {
							this.hideMaskNode.on('click', lang.hitch(this,
									this.hideMask));
						},

						buildMask : function() {

							if (this.container) {
								this._showMask();
								return;
							}

							var dhs = new html._ContentSetter({
								parseContent : true,
								onBegin : function() {
									this.content = this.content
											.replace('!{starklass}',
													'mui/rating/Rating');
									this.inherited("onBegin", arguments);
								}
							});
							this.container = domConstruct.create('div', {
								'className' : 'muiIntrMask'
							}, document.body, 'last');

							dhs.node = this.container;
							dhs.set(tmpl);
							dhs.tearDown();
							var self = this;
							setTimeout(function() {
								self.ulContainer = query('ul', self.container);
								self._showMask();
							}, 1);
							// 提交按钮
							this.submitNode = query('.muiIntrSubmit',
									this.container);
							this.bindSubmit();
							// 绑定输入框相关事件
							this.inputNode = query('.muiIntrMaskText',
									this.container);
							this.bindInput();
							this.setInputValue(this.value);

							// 绑定收起按钮
							this.hideMaskNode = query('.muiIntrHideMask',
									this.container);
							this.bindHideMask();

							// 监听星星改变事件
							this.subscribe("/mui/rating/ratingSelected", lang
									.hitch(this, this.scoreSelected));
							// 组织架构选择框值发生改变
							this.subscribe("/mui/Category/valueChange", lang
									.hitch(this, this.addressChange));
						},

						setInputValue : function(value) {
							var tip = this.tips['intr_tip_' + value];
							this.inputNode[0].value = tip;
							this.validate();
						},

						addressChange : function(evt) {
							this.validate();
						},

						scoreSelected : function(evt) {

							if (evt != null) {
								var val = evt.value;
								// 设置隐藏域分数值
								query('[name="fdIntroduceGrade"]')[0].value = 3 - parseInt(val);
								// 填写默认点评回复
								var inputV = this.inputNode[0].value.trim(), isdefault = this
										.isDefualt(inputV);
								if (inputV && !isdefault)
									return;
								this.setInputValue(val);
							}
						},

						// 判断是否为默认点评内容
						isDefualt : function(val) {
							var isDefault = false;
							for ( var key in this.tips) {
								if (val == this.tips[key]) {
									isDefault = true;
									break;
								}
							}
							return isDefault;
						},

						_showMask : function() {
							domStyle.set(this.container, {
								'display' : 'block',
								'opacity' : 1
							});
							this
									.defer(
											function() {
												domStyle.set(this.domNode, {
													'display' : 'none'
												});
												this.ulContainer
														.style({
															'-webkit-transform' : 'translate3d(0px, 0px, 0px)',
															'opacity' : 1
														});
											}, 200);
						},

						_hideMask : function(fire) {
							this.ulContainer
									.style({
										'-webkit-transform' : 'translate3d(0px, 400%, 0px)',
										'opacity' : 0
									});
							this.defer(function() {
								domStyle.set(this.container, {
									'opacity' : 0
								});
								domStyle.set(this.domNode, {
									'display' : 'block'
								});
								if (!fire) {
									this.setInputValue(this.value);
									// 重置相关表单值
									this.resetForm();
									registry.byId('intr_praise_opt').set(
											'value', this.value);
								}
							}, 500);
							this.defer(function() {
								domStyle.set(this.container, {
									'display' : 'none'
								});
							}, 700);
						},

						// 重置相关表单
						resetForm : function() {
							query('input[name="fdIntroduceGoalNames"]',
									this.container)[0].value = '';
							query('input[name="fdIntroduceGoalIds"]',
									this.container)[0].value = '';
							query('input[name="fdIntroduceGrade"]',
									this.container)[0].value = 3 - parseInt(this.value);

						},

						destroyMask : function(fire) {
							if (!this.ulContainer)
								return;
							this._hideMask(fire);
						},

						// 显示遮罩
						showMask : function() {
							if (this.lock == true)
								return;
							this.set('lock', true);
							this.defer(function() {
								this.buildMask();
							}, 350);

						},

						// 隐藏遮罩
						hideMask : function(fire) {
							this.defer(function() {
								this.destroyMask(fire);
								this.set('lock', false);
							}, 350);
						},

						doFocus : function() {
							if (this.isDefualt(this.inputNode[0].value.trim()))
								this.inputNode[0].value = '';
							this.validate();
						},

						doBlur : function() {
							this.validate();
						},

						doKeyup : function() {
							this.validate();
						},

						doInput : function() {
							this.validate();
						},

						validate : function() {
							if (this._validate()) {
								this.submitNode
										.addClass(this.submitEnableClass);
							} else {
								this.submitNode
										.removeClass(this.submitEnableClass);
							}
						},

						// 隐藏域，提交会对其进行封装
						hideInput : [ 'fdIntroduceToPerson',
								'fdIntroduceToEssence', 'fdIntroduceGoalNames',
								'fdIntroduceGoalIds', 'fdIntroduceGrade' ],

						// 推荐提交
						doSubmit : function(evt) {

							if (!this._validate())
								return;
							var fromData = {};
							var self = this;
							// 封装隐藏域数据
							array
									.forEach(
											query("#intr_formData input"),
											function(domNode) {
												fromData[domAttr.get(domNode,
														"name")] = domNode.value;
											});

							fromData['fdIntroduceReason'] = this.inputNode[0].value;

							array.forEach(this.hideInput, function(item) {
								fromData[item] = query('input[name="' + item
										+ '"]', this.container)[0].value;
							});

							var promise = request
									.post(
											util
													.formatUrl("/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=save"),
											{
												data : fromData,
												timeout : 30000
											}).response
									.then(function(data) {
										if (data.status == 200
												&& data.getHeader("lui-status") == "true") {
											tip.success({
												text : '推荐成功'
											});
											self
													.defer(
															function() {
																topic
																		.publish(
																				"/mui/list/onPull",
																				registry
																						.byId('intr_scollView'));
																topic
																		.publish(
																				"/mui/category/clear",
																				{
																					key : 'fdIntroduceGoalIds'
																				});
															}, 300);

										} else
											tip.fail({
												text : '推荐失败'
											});

									});
							this.hideMask();
						},

						// 校验
						_validate : function() {
							var proto = this.constructor.prototype;
							var flag = true;
							for (name in proto) {
								if (/^_validate[A-Z](.*)$/.test(name)) {
									flag = proto[name].call(this);
									if (!flag)
										return false;
								}
							}
							return flag;
						},

						_validateInput : function() {
							var flag = false;
							var val = this.inputNode[0].value.trim();
							var leng = val.length;
							var l = 0;
							for (var i = 0; i < leng; i++) {
								if (val[i].charCodeAt(0) < 299)
									l++;
								else
									l += 2;
							}
							if (l <= 2 * this.limitNum && l > 0)
								flag = true;
							return flag;
						},

						_validateAddress : function() {
							var val = query('[name="fdIntroduceGoalIds"]')[0].value
									.trim();
							if (val)
								return true;
							else
								return false;
						}

					})
		});