
/*
 * ! Requires: [kms.js,jquery.js]
 * 
 * Description: kms_accordian.js，手风琴折叠分类概览
 * 
 * 修正：
 * 
 * 新增： 新增分类&显示数目接口
 * 
 * 优化：样式优化，ie7以下兼容，切换停滞----2012-12-11
 * 
 * 使用方式： var accordian = new Accordian($('#accordian'), { width :
 * $('#accordian').width(), dataSource : { url : KMS.basePath +
 * "/common/kms_common_portlet/kmsCommonPortlet.do?method=execute&", data : {
 * s_bean : 'kmsDocknowledgeCategoryPortlet', fdCategoryId : '', s_rowsize : '' } } }]
 * });
 */
;
(function($) {
	// var ie8later = $.browser.msie && parseInt($.browser.version) >= 8;

	// 所有子分类展现寄生平台
	var subcategory = $("<div id='doc-popup-subcategory' class='popup-subcategory hidden'></div>");
	var curCategory = null;
	// 定时器设置停滞时间
	var timeout;
	var interval;
	var enterTimeOut;
	var Accordian = EventTarget.extend({
		constructor : function(container, options) {
			var obj = this;
			this.options = {
				speed : 200,
				defaultActive : 0,
				width : 225,
				cache : true,
				meta : [{
					onCategoryLeave : function(event) {
						var elem = $(this);
						var eventData = event.data;
						var subcategoryList = subcategory.find('#lst-submenu-'
								+ eventData.fdId);
						var target = $(event.target);
						var relatedTarget = $(event.relatedTarget);

						if (enterTimeOut) {
							clearTimeout(enterTimeOut);
							enterTimeOut = undefined;
						}
						if (interval) {
							clearInterval(interval);
							interval = undefined;
						}
						timeout = setTimeout(function() {
							if (timeout) {
								if (!relatedTarget.hasClass('lst-subcategory')) {
									subcategoryList.addClass('hidden');
									elem.removeClass('listhover');
								}
								clearTimeout(timeout);
								timeout = undefined;
							}
						}, 500);
					},
					onDrawEnter : function(elem, event) {
						var elem = $(elem);
						var eventData = event.data;
						var subcategoryList = subcategory.find('#lst-submenu-'
								+ eventData.fdId);
						if (subcategoryList.html() != '') {
							// 计算子菜单的位置
							var el_offset = elem.offset();
							var win_height = $(window).height();
							var ch = subcategoryList.innerHeight();
							var sc_top = $(window).scrollTop();

							var sub_top = win_height - ch - 20 + sc_top;
							sub_top = sub_top > 172 ? sub_top : 172 + 5;
							if (sub_top >= el_offset.top) {
								subcategory.offset({
											top : el_offset.top
										});
							} else if (sub_top + ch - 26 <= el_offset.top) {
								subcategory.offset({
											top : el_offset.top + 26 - ch
										});
							} else {
								subcategory.offset({
											top : sub_top
										});
							}
							subcategory.css('left', el_offset.left + 145)
									.removeClass('hidden');
							subcategoryList.removeClass("hidden");
							elem.addClass('listhover');
							curCategory = {
								"category" : elem,
								"subcategory" : subcategoryList
							};
						}
					},

					onCategoryEnter : function(event) {
						var that = this;
						if (interval) {
							clearInterval(interval);
							interval = undefined;
						}
						if (!timeout) {
							enterTimeOut = setTimeout(function() {
								obj.options.meta[0]['onDrawEnter'](that, event);
							}, 500);

						} else {
							interval = setInterval(function() {
										if (!timeout) {
											clearInterval(interval);
											interval = undefined;
											obj.options.meta[0]['onDrawEnter'](
													that, event);
										}
									}, 500);
						}
					}

				}]
			};
			this.loadStyle();
			this.container = container;
			this.activeAccordian = null;
			this.flag = [0, 0, 0];
			this.accordianList = [];
			this.base(options);
			this.draw();
		},

		draw : function() {
			var accordian = $(document.createElement('div'))
					.addClass('accordian').css('width', this.options.width), metaData = this.options.meta;

			this.accordianElem = accordian;
			if (!metaData || !jQuery.isArray(metaData))
				return;

			// 绘制所有accordian项
			var c = 0, len = metaData.length, accordianMeta, titleBar, content;
			for (var i = 0; i < len; i++) {
				accordianMeta = metaData[i];
				// 添加标题
				// titleBar = $('<div
				// style="background:#F6F6F7;"><span>' +
				// accordianMeta['fdSubject'] + '</span></div>')
				// .addClass('toggle');
				// titleBar.appendTo(accordian);
				// 添加内容
				content = $(document.createElement('div'));
				content.appendTo(accordian);

				this.accordianList[i] = {
					// toggle: titleBar,
					content : content
				};

				// 触发click标题事件
				// titleBar.bind('click', { index: i },
				// this.toggle.bind(this));
			}

			accordian.appendTo(this.container);

			this.activate(this.options.defaultActive);
		},

		toggle : function(event) {
			var ind = event.data['index'];
			this.activate(ind, event.data['meta']);
		},

		activate : function(n) {
			var speed = this.options.speed;
			if (this.activeAccordian) {
				if (this.flag[n] == 0) {
					this.activeAccordian = this.accordianList[n];
					this.activeAccordian['content'].show();
					this.loadAccordianContent(this.activeAccordian['content'],
							n);
					this.flag[n] = 1;
				} else {
					this.activeAccordian = this.accordianList[n];
					this.activeAccordian['content'].hide();
					this.flag[n] = 0;
				}

			} else {
				this.activeAccordian = this.accordianList[0];
				this.activeAccordian['content'].show();
				this.loadAccordianContent(this.activeAccordian['content'], 0);
				this.flag[0] = 1;
				// 可以控制类别显示的最小数量加上下面代码则必须要显示2个大类别
				// this.activeAccordian = this.accordianList[1];
				// this.activeAccordian['content'].show();
				// this.loadAccordianContent(this.activeAccordian['content'],
				// 1);
				// this.flag[1]=1;
			}

		},

		// 无阻塞引入样式表
		loadStyle : function() {
			var thisScript;
			(function(script, me) {
				for (var i in script) {
					if (script[i].src
							&& script[i].src.indexOf('kms_accordian') !== -1)
						thisScript = script[i];
				};
			}(document.getElementsByTagName('script'), thisScript));
			var link = document.createElement('link');
			link.rel = 'stylesheet';
			link.href = KMS.themePath + '/accordian/accordian.css';
			thisScript.parentNode.insertBefore(link, thisScript);
		},

		loadAccordianContent : function(content, n) {
			var metaData = this.options.meta[n];
			var dataSource = metaData['dataSource'];
			var cache = this.options.cache;
			var hasSubcategory = true;
			// var subcategory = metaData['subcategory'];
			var accordian = this.accordianElem;
			subcategory.mouseleave(function(event) {

						if (interval) {
							clearInterval(interval);
							interval = undefined;
						}
						if (timeout) {
							clearTimeout(timeout);
							timeout = undefined;
						}
						timeout = setTimeout(function() {
									if (curCategory) {
										curCategory['category']
												.removeClass('listhover');
										curCategory['subcategory']
												.addClass('hidden');
									}
									clearTimeout(timeout);
									timeout = undefined;
								}, 500);
					});

			subcategory.mouseenter(function(event) {
						if (interval) {
							clearInterval(interval);
							interval = undefined;
						}
						if (timeout) {
							clearTimeout(timeout);
							timeout = undefined;
						}
					});

			if (dataSource['loadComplete'])
				return;
			dataSource['loadComplete'] = false;
			$.ajax({
				type : 'GET',
				cache : cache,
				ifModified : true,
				url : dataSource.url,
				data : dataSource.data,
				success : function(data, textStatus, XMLHttpRequest) {
					if (!jQuery.isArray(data))
						return;
					var listObject = $('<ul class="accordian-list"></ul>');
					var html_template = '<li><span><a {{existHref}} title="{{tagTitle}}">{{text}}<tt id="{{fdId}}"><span></span></tt></a></span></li>';
					for (var i = 0, len = data.length; i < len; i++) {
						var tmp = html_template;
						if (data[i]["fdHref"]) {
							tmp = tmp.replace(/\{\{existHref\}\}/, 'href="'
											+ data[i]["fdHref"]
											+ '" target="_blank"');
						} else {
							tmp = tmp.replace(/\{\{existHref\}\}/,
									'href="javascript:void(0)"');
						}

						if (data[i]["fdText"]) {
							tmp = tmp.replace(/\{\{tagTitle\}\}/,
									data[i]["fdText"]);
							tmp = tmp.replace(/\{\{text\}\}/, resetStrLength(
											data[i]["fdText"], 20));/* 一级级分类名称 */
							tmp = tmp.replace(/\{\{fdId\}\}/, data[i]["fdId"]);/* 一级级分类ID */
						} else {
							tmp = tmp.replace(/\{\{tagTitle\}\}/, '');
							tmp = tmp.replace(/\{\{text\}\}/, '');
							tmp = tmp.replace(/\{\{fdId\}\}/, '');/* 一级级分类ID */
						}

						var listItem = $(tmp);
						(function(category) { // 修复不同主类下的子类不一致的bug by yangf
							// 2011-07-25
							if (hasSubcategory) {
								var params = $.extend({}, dataSource.data, {
											fdTemplateId : data[i]['fdId']
										});
								$.ajax({
									type : 'GET',
									url : dataSource.url,
									data : params,
									success : function(r_data) {
										var html_template = '<a {{existHref}} title="{{tagTitle}}">{{text}}</a>';
										var htmlcode = ['<div class="lst-subcategory hidden" id="lst-submenu-'
												+ category['fdId'] + '">'];
										var tmp;
										for (var i = 0; i < r_data.length; i++) {
											var r_list = r_data[i];
											for (var j = 0; j < r_list.length; j++) {
												if (j == 0) {
													tmp = html_template;
												} else {
													tmp = '<em>'
															+ html_template
															+ '</em>';
												}
												var r_item = r_list[j];
												if (r_item["fdHref"]) {
													tmp = tmp
															.replace(
																	/\{\{existHref\}\}/,
																	'href="'
																			+ r_item["fdHref"]
																			+ '" target="_blank"');
												} else {
													tmp = tmp
															.replace(
																	/\{\{existHref\}\}/,
																	'href="javascript:void(0)"');
												}

												if (r_item["fdText"]) {
													tmp = tmp.replace(
															/\{\{tagTitle\}\}/,
															r_item["fdText"]);
													tmp = tmp
															.replace(
																	/\{\{text\}\}/,
																	resetStrLength(
																			r_item["fdText"],
																			14));/* 二级分类名称 */
												} else {
													tmp = tmp.replace(
															/\{\{tagTitle\}\}/,
															'');
													tmp = tmp.replace(
															/\{\{text\}\}/, '');
												}

												if (j == 0) {
													tmp = '<dl><dt>' + tmp
															+ '</dt><dd>';
												}

												htmlcode.push(tmp);
											}

											htmlcode.push('</dd></dl>');
										}

										htmlcode.push('</div>');
										// 添加子类别
										subcategory
												.append($(htmlcode.join('')));
										if (r_data == "") {
											document.getElementsByTagName("")
											document
													.getElementById(category['fdId']).innerHTML = ""
										}
									}
								});
							}
						}(data[i]));

						var eventData = {
							fdIndex : i,
							fdId : data[i]['fdId'],
							fdHref : data[i]['fdHref']
						};

						// 注册每个list项的click事件
						if (metaData['onCategoryClick']
								&& jQuery
										.isFunction(metaData['onCategoryClick'])) {
							listItem.bind('click', eventData,
									metaData['onCategoryClick']);
						}

						// 注册每个list项的mousemove事件
						if (metaData['onCategoryEnter']
								&& jQuery
										.isFunction(metaData['onCategoryEnter'])) {
							listItem.bind('mouseenter', eventData,
									metaData['onCategoryEnter']);
						}

						// 注册每个list项的mouseleave事件
						if (metaData['onCategoryLeave']
								&& jQuery
										.isFunction(metaData['onCategoryLeave'])) {
							listItem.bind('mouseleave', eventData,
									metaData['onCategoryLeave']);
						}

						listItem.appendTo(listObject);
						if (metaData['onGroupEnter']
								&& jQuery.isFunction(metaData['onGroupEnter'])) {
							// listObject.bind('mouseenter',
							// metaData['onGroupEnter']);
						}

						if (metaData['onGroupLeave']
								&& jQuery.isFunction(metaData['onGroupLeave'])) {
							// listObject.bind('mouseleave',
							// metaData['onGroupLeave']);
						}

					}

					// 显示内容
					content.append(listObject);
					if (hasSubcategory) {
						accordian.append(subcategory);
					}

					dataSource['loadComplete'] = true;
				},

				error : function(XMLHttpRequest, textStatus, errorThrown) {
					alert(errorThrown);
				}
			});
		}

	});

	this.Accordian = Accordian;

}(jQuery));
