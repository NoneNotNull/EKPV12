(function() {
	CKEDITOR.plugins
			.add(
					'pasteimage',
					{
						requires : 'clipboard',
						lang : 'af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en,en-au,en-ca,en-gb,eo,es,et,eu,fa,fi,fo,fr,fr-ca,gl,gu,he,hi,hr,hu,id,is,it,ja,ka,km,ko,ku,lt,lv,mk,mn,ms,nb,nl,no,pl,pt,pt-br,ro,ru,si,sk,sl,sq,sr,sr-latn,sv,th,tr,ug,uk,vi,zh,zh-cn',
						hidpi : true,
						init : function(editor) {
							var config = editor.config, lang = editor.lang.pasteimage;

							// 图片转为64位，因为页面卡不建议使用
							function image2base64(items, loop) {
								for (var i = 0; i < items.length; ++i) {
									var item = items[i];
									if ('file' == items[i].kind
											&& items[i].type.indexOf('image') >= 0) {
										var fileReader = new FileReader();
										fileReader.onloadend = function() {
											var d = this.result
													.substr(this.result
															.indexOf(',') + 1);
											editor
													.insertHtml("<img src='data:image/jpeg;base64,"
															+ d + "'>");
										};
										fileReader.readAsDataURL(item
												.getAsFile());
										if (!loop)
											break;
									}
								}
							}

							// 多图片上传
							function imageUpload(items, loop) {
								for (var i = 0; i < items.length; ++i) {
									var item = items[i];
									if (item.type.indexOf('image') >= 0) {
										var d = new FormData;
										d.append("json", true);
										d.append("NewFile",
												item.getAsFile ? item
														.getAsFile() : item);
										ajax_upload(d);
										if (!loop)
											break;
									}
								}
							}

							// 提交流到后台
							function ajax_upload(d) {
								$
										.ajax({
											url : config
													.getFilebrowserImageUploadUrl(editor),
											data : d,
											contentType : false,
											processData : false,
											type : "POST",
											dataType : 'json',
											success : function(data) {
												if (data && data.status == '1') {
													var src = config.downloadUrl
															+ '?fdId='
															+ data.filekey;
													var elem = editor.document
															.createElement("img");
															elem.setAttribute(
																	"alt", ""),
															elem.setAttribute(
																	"src", src),
															editor
																	.insertElement(elem);
												}
											}
										});
							}

							// 获取提示层
							function getMask() {
								return $(editor.document.$.body).find(
										'[data-lui-mask="mask"]');
							}

							// 隐藏提示层
							function hideMask() {
								getMask().hide();
							}

							// 显示提示层
							function showMask() {
								var doc = $(editor.document.$.body);
								var mask = doc.find('[data-lui-mask="mask"]');
								if (mask.length > 0) {
									mask.show();
									return;
								}
								var mask = $('<div data-lui-mask="mask">');
								mask.css({
									border : '3px dashed #999',
									'z-index' : 100,
									'background-color' : '#fff',
									opacity : 0.6,
									position : 'fixed',
									'border-radius' : 4,
									left : 3,
									right : 3,
									top : 3,
									bottom : 3
								});
								doc.append(mask);
							}

							editor.on('instanceReady', function() {
								var doc = this.document;
								// 禁止内部图片拖动
								doc.$.ondragstart = function() {
									return false;
								};

								// 是否支持拖动上传
								function isSupportDrop(event) {
									return event.dataTransfer
											&& !Com_Parameter.IE;
								}

								doc.on('drop', function(evt) {
									var event = evt.data.$;
									event.stopPropagation();
									event.preventDefault();
									hideMask();
									var items = [];
									if (isSupportDrop(event)) {
										items = event.dataTransfer.files;
										if (!items) {
											items = event.dataTransfer.files;
										}
									} else
										return;
									imageUpload(items, true);
								});

								doc.on('dragover', function(evt) {
									var event = evt.data.$;
									event.stopPropagation();
									event.preventDefault();
									// 修复qq浏览器ie模式下的问题
									if (isSupportDrop(event))
										showMask();

								});
								doc.on('dragleave', function(evt) {
									var event = evt.data.$;
									event.stopPropagation();
									event.preventDefault();
									if ($(event.target).attr('data-lui-mask'))
										hideMask();
								});

								doc.on('paste', function(evt) {
									var items = [];
									if (evt.data.$.clipboardData
											&& evt.data.$.clipboardData.items) {
										items = evt.data.$.clipboardData.items;
									} else
										return;
									imageUpload(items);
								});

							});

							/***************************************************
							 * 加载金格控件--开始
							 **************************************************/

							if (!Com_Parameter.IE)
								return;
							var webOffice;
							// 判断当前页面是否已经存在金格控件
							if (top.JG_GetWebOffice) {
								webOffice = top.JG_GetWebOffice();
							} else {
								webOffice = top.document
										.getElementById("JGWebOffice_ckeditor_upload");
								if (!webOffice) {
									$(top.document.body)
											.append(
													webOffice = $('<object style="display:none" classid="clsid:8B23EA28-2009-402F-92C4-59BE0E063499" id="JGWebOffice_ckeditor_upload"></object>'));
									webOffice.attr('codebase', config.jgPath);
									config.webOffice = webOffice[0];
									config.webOffice.WebUrl = Com_GetCurDnsHost()
											+ Com_Parameter.ContextPath
											+ "sys/attachment/sys_att_main/jg_service.jsp"
									Com_AddEventListener(top, "unload",
											function() {
												try {
													if (config.webOffice)
														config.webOffice
																.WebClose();
												} catch (e) {
													if(window.console)
														console.log('金格控件未安装成功！');
												}

											});
								}
							}
							/***************************************************
							 * 加载金格控件--结束
							 **************************************************/
						}
					});
})();