define(
		[ "dojo/_base/declare", "dojo/dom-construct", "./emoji",
				"dojo/dom-style", "dojo/_base/lang", "dojo/dom-attr",
				"dojo/dom-class", "dojo/text!../tmpl/panelV.html", "dojo/html",
				"mui/util", "dojo/topic",
				"mui/form/editor/plugins/EditorPluginBaseMixin" ],
		function(declare, domConstruct, emoji, domStyle, lang, domAttr,
				domClass, tmpl, html, util, topic, EditorPluginBaseMixin) {

			function map(array, fn) {
				var length = array.length;
				var result = [];
				while (length--) {
					result[length] = fn(array[length]);
				}
				return result;
			}

			function ucs2decode(string) {
				var output = [], counter = 0, length = string.length, value, extra;
				while (counter < length) {
					value = string.charCodeAt(counter++);
					if (value >= 0xD800 && value <= 0xDBFF && counter < length) {
						extra = string.charCodeAt(counter++);
						if ((extra & 0xFC00) == 0xDC00) {
							output.push(((value & 0x3FF) << 10)
									+ (extra & 0x3FF) + 0x10000);
						} else {
							output.push(value);
							counter--;
						}
					} else {
						output.push(value);
					}
				}
				return output;
			}

			function ucs2encode(array) {
				return map(
						array,
						function(value) {
							var output = '';
							if (value > 0xFFFF) {
								value -= 0x10000;
								output += String
										.fromCharCode(value >>> 10 & 0x3FF | 0xD800);
								value = 0xDC00 | value & 0x3FF;
							}
							output += String.fromCharCode(value);
							return output;
						}).join('');
			}

			return declare(
					"mui.form.editor.plugins.face.Plugin",
					[ EditorPluginBaseMixin ],
					{

						type : 'face',

						icon : 'mui-editor-face',

						event : function(evt) {
							this._faceShow(evt)
						},

						_faceIsInit : false,

						constructor : function(options) {
							this.inherited(arguments);
						},

						startup : function() {
							this.editor.formatContent.push(this._faceFormat);
						},

						// 格式化表情，将输入法表情置换为图片
						_faceFormat : function(html) {
							if (!html)
								return "";
							var str = html;
							var unicodes = ucs2decode(str);
							var unicodeString = '';
							var kinds = emoji.getEmojiList();

							var hasEmoji = false;
							for (var now = 0; now < unicodes.length;) {
								var unicode = unicodes[now];
								var isEmoji = false;
								var isEmojiUnicode = false;
								if (unicode >= 0xE000 && unicode < 0xE538) {
									unicodeString = unicode.toString(16);
									isEmoji = true;
								} else if ((unicode >= 0x2196 && unicode <= 0x2199)
										|| (unicode == 0x25C0 || unicode == 0x25B6)
										|| (unicode == 0x23EA || unicode == 0x23E9)
										|| (unicode >= 0x2600 && unicode <= 0x3299)
										|| (unicode >= 0x1f000 && unicode <= 0x1f700)) {
									unicodeString = unicode.toString(16);
									isEmoji = true;
									isEmojiUnicode = true;
								} else {
									if (unicode == 0x20e3) {
										if (now > 0) {
											var preCode = unicodes[now - 1];
											if (preCode == 0x23
													|| preCode >= 0x30
													&& preCode <= 0x39) {
												isEmoji = true;
												isEmojiUnicode = true;
												--now;
												unicode = preCode;
											}
										}
									}
								}

								if (isEmoji) {
									hasEmoji = true;
									for (var i = 0; i < kinds.length; ++i) {
										var kind = kinds[i];
										for (var j = 0; j < kind.length; ++j) {
											var emo = kind[j];
											var foundCount = 0;
											var unicodeEmoji = emo[1];
											if (isEmojiUnicode) {
												var isArray = (typeof unicodeEmoji != 'string');
												if (isArray
														&& now
																+ unicodeEmoji.length
																- 1 < unicodes.length) {
													for (var uindex = 0; uindex < unicodeEmoji.length; uindex++) {
														var unString = unicodes[now
																+ uindex]
																.toString(16);
														if (unString != unicodeEmoji[uindex]) {
															foundCount = 0;
															break;
														} else {
															foundCount++;
														}
													}
												} else if (!isArray
														&& emo[1] == unicodeString) {
													foundCount = 1;
												}
											} else if (!isEmojiUnicode
													&& emo[0] == unicodeString) {
												foundCount = 1;
											}

											if (foundCount > 0) {
												var data = 'data:image/png;base64,'
														+ emo[2];
												var html = '<img src="' + data
														+ '"/>';
												var puny = ucs2decode(html);
												unicodes
														.splice(now, foundCount);
												for (var curr = 0; curr < puny.length; ++curr) {
													unicodes.splice(now, 0,
															puny[curr]);
													++now;
												}
												--now;
												break;
											}
										}
									}
								}
								++now;
							}
							if (hasEmoji) {
								return ucs2encode(unicodes);
							}
							return html;
						},

						// 构建表情选择面板
						_faceBuildPanel : function() {
							var facePanel = '';
							var emojis = emoji.getEmojiList();
							for (var i = 0; i < emojis.length; i++) {
								var _emoji = emojis[i];
								for (var j = 0; j < _emoji.length; j++) {
									facePanel += '<a href="javascript:;" class="muiEditorFaceItem"><img class="muiEditorFaceItemImg" src="data:image/png;base64,'
											+ _emoji[j][2] + '"></a>';
								}
							}
							var dhs = new html._ContentSetter({
								parseContent : true,
								cleanContent : true,
								node : this.faceNode,
								onBegin : function() {
									this.content = this.content.replace(
											/!{panel}/g, facePanel);
									this.inherited("onBegin", arguments);
								}
							});
							dhs.set(tmpl);
							dhs.tearDown();
						},

						show : function() {
							this.inherited(arguments);
							domStyle.set(this.faceNode, {
								'display' : 'block'
							});
							this.defer(function() {
								domStyle.set(this.faceNode, {
									'height' : this.panelHeight
								});
							}, 1);
						},

						hide : function() {
							this.inherited(arguments);
							domStyle.set(this.faceNode, {
								'height' : 0
							});
							this.defer(function() {
								domStyle.set(this.faceNode, {
									'display' : 'none'
								});
							}, 200);
						},

						_faceShow : function(evt) {
							if (this._isShow) {
								this.hide();
								return;
							}

							this._isShow = true;

							if (this._falseIsInit) {
								this.show();
								return;
							}

							this.iconNode = evt.target;

							this.faceNode = domConstruct.create('div', {
								className : 'muiEditorFace'
							}, this.editor.domNode, 'last');

							var t_h = this.editor.domNode.offsetHeight;
							this.panelHeight = '12rem';
							this
									.connect(
											this.faceNode,
											'click',
											lang
													.hitch(
															this,
															function(evt) {
																this.editor.__textNode
																		.blur();
																if (!this
																		._faceFireClick())
																	return;
																var target = evt.target;
																while (target) {
																	if (target.tagName == 'IMG') {
																		var src = domAttr
																				.get(
																						target,
																						'src');
																		this.editor
																				.insertElement(domConstruct
																						.create(
																								'img',
																								{
																									src : src,
																									className : 'muiEditorFaceImg',
																									'data-type' : 'face'
																								}));
																		break;
																	}
																	target = target.parentNode;
																}
															}));
							this._faceBuildPanel();
							this.show();
							this._falseIsInit = true;
						}
					});
		});