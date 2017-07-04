/**
 * CK 图片表格宽度压缩
 */
Com_RegisterFile("ckeditor/ckresize.js");
Com_IncludeFile("jquery.js");
Com_IncludeFile("ckresize_lang.jsp", "ckeditor/");
Com_IncludeFile("ckresize.css", Com_Parameter.ContextPath
		+ "resource/ckeditor/resource/", "css", true);
CKResize = new Object();
CKResize.propertyNames = [];
CKResize.drawed = false;
CKResize.addPropertyName = function(property) {
	CKResize.propertyNames.push(property);
}
CKResize.top = top;
try {
	CKResize.top['seajs'];
} catch (e) {
	CKResize.top = window;
}
CKResize.____ckresize____ = function(imgReader) {
	if (CKResize.drawed)
		return;
	for (var i = 0; i < CKResize.propertyNames.length; i++) {
		var name = CKResize.propertyNames[i];
		CKResize.____resetWidth____(name, imgReader);
	}
	;
	CKResize.drawed = true;
}

CKResize.____resetWidth____ = function(name, imgReader) {

	var $temp = $(document.getElementById('_____rtf__temp_____' + name)), w = $temp
			.width();
	var $rtf = $(document.getElementById('_____rtf_____' + name));
	if (w == 0) {
		setTimeout(function() {
			CKResize.____resetWidth____(name, imgReader);
		}, 100);
		return;
	}

	CKResize[name] = {};

	CKResize[name].tables = $rtf.find('table');

	CKResize[name].tables
			.each(function(i) {
				var ___css = {};

				if (this.width && this.width > w
						|| parseInt($(this).css('width')) > w) {
					___css.width = '100%';
					___css.height = 'auto';
				}

				$(this).css(___css);

			});

	CKResize[name].imgs = $([]);

	if (CKResize.extendImage)
		CKResize[name].imgs = $(CKResize.extendImage);

	CKResize[name]._tmplImgs = [];
	$rtf.find("img[contentEditable!='false']").each(
			function() {
				var src = $(this).attr('src');
				// 过滤表情
				if (src.indexOf('/images/smiley/wangwang/') < 0
						&& $(this).attr('data-type') != 'face')
					CKResize[name]._tmplImgs.push($(this)[0]);
			});

	CKResize[name].imgs = $
			.merge(CKResize[name].imgs, CKResize[name]._tmplImgs);
	// 获取鼠标位置
	function getMousePos(evt) {
		if (evt.pageX || evt.pageY)
			return {
				x : evt.pageX,
				y : evt.pageY
			};
	}

	// 获取对象高宽
	function getW2H(obj) {
		return {
			x : $(obj).width(),
			y : $(obj).height()
		}
	}

	function getOuterW2H(obj) {
		return {
			x : $(obj).outerWidth(),
			y : $(obj).outerHeight()
		}
	}

	// 获取对象位置
	function getPosition(obj) {
		return {
			x : $(obj).position().left,
			y : $(obj).position().top
		};
	}

	// 确定拖拽边缘
	function contain(evt, x2y_m, w2h, __w2h) {
		var x2y = getMousePos(evt);
		var css = {};

		var isW = w2h.x > __w2h.x, isH = w2h.y > __w2h.y;

		if (x2y.x - x2y_m.x > 0) {
			if (isW)
				css.left = 0;
			if (isH)
				css.top = x2y.y - x2y_m.y;
		}

		if (x2y.y - x2y_m.y > 0) {
			if (isW)
				css.left = css.left === 0 ? 0 : x2y.x - x2y_m.x;
			if (isH)
				css.top = 0;
		}

		if (w2h.y - __w2h.y < -(x2y.y - x2y_m.y)) {
			if (isH) {
				css.top = '';
				css.bottom = 0;
			}
			if (isW)
				css.left = css.left === 0 ? 0 : x2y.x - x2y_m.x;
		}

		if (w2h.x - __w2h.x < -(x2y.x - x2y_m.x)) {
			if (isW) {
				css.right = 0;
				css.left = '';
			}
			if (isH)
				css.top = css.top === 0 ? 0 : css.top === '' ? '' : x2y.y
						- x2y_m.y;
		}

		if (x2y.x - x2y_m.x <= 0 && x2y.y - x2y_m.y <= 0
				&& w2h.y - __w2h.y >= -(x2y.y - x2y_m.y)
				&& w2h.x - __w2h.x >= -(x2y.x - x2y_m.x)) {
			if (isW)
				css.left = x2y.x - x2y_m.x;
			if (isH)
				css.top = x2y.y - x2y_m.y;
		}

		return css;
	}

	// 缩略图确定拖拽边缘
	function __contain(evt, x2y_m, w2h, ___w2h, __pos, __w2h) {
		var x2y = getMousePos(evt);
		var pos = getPosition($(evt.target));
		// 是否已显示区域比图片宽或高
		var isW = w2h.x > ___w2h.x, isH = w2h.y > ___w2h.y;
		var css = {};
		if (isW) {
			css.left = pos.x;
		} else {
			if (x2y.x - x2y_m.x <= __pos.x) {
				css.right = '';
				css.left = __pos.x;
			}
			if (x2y.x - x2y_m.x + w2h.x + 6 >= __pos.x + ___w2h.x) {
				css.right = __w2h.x - (__pos.x + ___w2h.x);
				css.left = '';
			}
		}
		if (isH) {
			css.top = pos.y;
		} else {
			if (x2y.y - x2y_m.y <= __pos.y) {
				css.top = __pos.y;
				css.bottom = '';
			}
			if (x2y.y - x2y_m.y + w2h.y + 6 >= __pos.y + ___w2h.y) {
				css.bottom = __w2h.y - (__pos.y + ___w2h.y);
				css.top = '';
			}
		}
		if (!css.top && css.top != 0 && !css.bottom && css.bottom != 0)
			css.top = x2y.y - x2y_m.y;
		if (!css.left && css.left != 0 && !css.right && css.right != 0)
			css.left = x2y.x - x2y_m.x;
		return css;
	}

	// 重置图片位置~~垂直水平居中
	function __resizeImg(__img, w, h) {
		var iw = parseInt(w) - 60;
		var ih = parseInt(h);
		var __width = __img.width(), __height = __img.height();
		if (__width === 0 && __height === 0) {
			setTimeout(function() {
				__resizeImg(__img, w, h);
			}, 1);
			return;
		}

		__img.css({
			'left' : (iw - __width) / 2,
			'top' : (ih - __height) / 2
		});
		__img.on({
			'mousedown' : function(evt) {
				var $target = $(evt.target);
				var x2y = getMousePos(evt);
				var pos = getPosition($target);
				x2y_m = {
					x : x2y.x - pos.x,
					y : x2y.y - pos.y
				};
				__w2h = getW2H($target.parents('.ckeditor_kanban'));
				w2h = getW2H($target);
				$target.css('cursor', 'move');
				CKResize.status = true;
			},
			'mouseup' : function(evt) {
				CKResize.status = false;
				$(evt.target).css('cursor', 'default');
				moveSelected();
			},
			'mousemove' : function(evt) {
				if (!CKResize.status)
					return false;
				var $target = $(evt.target);
				$target.css(contain(evt, x2y_m, w2h, __w2h));
				return false;
			}
		});
	}

	// 构建缩略图显示区域
	function buildSelected(timg) {
		var $container = $('.ckeditor_container');
		var bdiv = $container.find('.ckeditor_bdiv'), bimg = bdiv.find('img');
		var w2h = getW2H(bimg), __w2h = getW2H(bdiv);
		var width = w2h.x, height = w2h.y, __width = __w2h.x, __height = __w2h.y;
		var i2d_w_rate = width / __width, i2d_h_rate = height / __height;
		var selected = $('<div class="ckeditor_selected" />');
		var ___w2h = getW2H(timg), ___x2y = getPosition(timg);
		var t2l = getSelected(timg, bimg);
		selected.css({
			'width' : ___w2h.x / i2d_w_rate - 6,
			'height' : ___w2h.y / i2d_h_rate - 6,
			'top' : t2l.top,
			'left' : t2l.left
		});
		$container.find('.ckeditor_thumb').append(selected);
		selectedBind(selected);
	}

	// 绑定显示区域拖动事件
	function selectedBind(selected) {
		var $selected = $(selected);
		var t_x2y_m, t___w2h, t_w2h, t__w2h, t___pos, t__pos;
		$selected.on({
			'mousedown' : function(evt) {
				var $target = $(evt.target);
				var x2y = getMousePos(evt);
				var pos = getPosition($target);
				t_x2y_m = {
					x : x2y.x - pos.x,
					y : x2y.y - pos.y
				};
				var img = $target.prev('.ckeditor_thumb_img');
				t__w2h = getW2H($target.parents('.ckeditor_thumb'));
				t___pos = getPosition(img);
				t___w2h = getW2H(img);
				t__pos = getPosition($target);
				t_w2h = getOuterW2H($target);
				$target.css('cursor', 'move');
				CKResize.t_status = true;
			},
			'mouseup' : function(evt) {
				CKResize.t_status = false;
				$(evt.target).css('cursor', 'default');
				__moveSelected(evt, t__pos);
			},
			'mousemove' : function(evt) {
				if (!CKResize.t_status)
					return false;
				var $target = $(evt.target);
				$target.css(__contain(evt, t_x2y_m, t_w2h, t___w2h, t___pos,
						t__w2h));
				return false;
			}
		});
	}

	function getSelected(timg, bimg) {
		var x2y = getPosition(bimg), ___w2h = getW2H(timg), ___x2y = getPosition(timg), w2h = getW2H(bimg);
		var left = -x2y.x, top = -x2y.y;
		var w_rate = w2h.x / ___w2h.x, h_rate = w2h.y / ___w2h.y;
		return {
			top : top / h_rate + ___x2y.y,
			left : left / w_rate + ___x2y.x
		};
	}

	function __getSelected(timg, bimg, selected, t__pos) {
		var x2y = getPosition(bimg), ___w2h = getW2H(timg), ___x2y = getPosition(selected), w2h = getW2H(bimg);
		var w_rate = w2h.x / ___w2h.x, h_rate = w2h.y / ___w2h.y;
		return {
			top : (t__pos.y - ___x2y.y) * h_rate + x2y.y,
			left : (t__pos.x - ___x2y.x) * w_rate + x2y.x
		};
	}

	// 移动缩略图显示区域
	function moveSelected() {
		var $container = $('.ckeditor_container');
		var t2l = getSelected($container.find('.ckeditor_thumb_img'),
				$container.find('.ckeditor_bdiv img'));
		$container.find('.ckeditor_selected').css(t2l);
	}

	function __moveSelected(evt, t__pos) {
		var $container = $('.ckeditor_container');
		var t2l = __getSelected($container.find('.ckeditor_thumb_img'),
				$container.find('.ckeditor_bdiv img'), $container
						.find('.ckeditor_selected'), t__pos);
		$container.find('.ckeditor_bdiv img').css(t2l);
	}

	function showThumb(src, name) {
		if (!getIsMagnify(name))
			return;
		var ___tdiv = $('.ckeditor_container .ckeditor_thumb');
		if (!___tdiv.html()) {
			var ___timg = $("<img src=\"" + src
					+ "\"  border=0 class='ckeditor_thumb_img' >");
			___tdiv.append(___timg);
			___timg.load(function() {
				buildSelected(this);
			});
		}
		___tdiv.show();
	}

	function hideThumb() {
		$('.ckeditor_container .ckeditor_thumb').hide();
	}

	function destroyThumb() {
		$('.ckeditor_container .ckeditor_thumb').html('');
		$('.ckeditor_container .ckeditor_thumb').hide();
	}

	function showToolbar() {
		$('.ckeditor_container .ckeditor_toolbar').show();
	}

	function hideToolbar() {
		$('.ckeditor_container .ckeditor_toolbar').hide();
	}

	// 重置缩略图
	function resetThumb(src, name) {
		destroyThumb();
		showThumb(src, name)
	}

	function showImg(img, src) {
		if (src)
			img.attr('src', src);
		imgUnbind(img);
	}

	// 重置图片
	function resetImg(img, src) {
		showImg(img, src);
		imgBind(img);
	}

	// 绑定拖拽事件
	function imgBind(img) {
		__resizeImg(img, CKResize.dialog_width, CKResize.dialog_height);
	}

	// 解绑拖拽事件
	function imgUnbind(img) {
		img.off();
	}

	function getCurrentImage(name) {
		return CKResize[name].imgs[CKResize.top.$('.ckeditor_container').attr(
				CKResize.INDEX)];
	}

	function setIsMagnify(type, name) {
		CKResize[name].imgs[CKResize.top.$('.ckeditor_container').attr(
				CKResize.INDEX)].isMagnify = type;
	}

	function clearMagnify(name) {
		for (var i = 0; i < CKResize[name].imgs.length; i++) {
			CKResize[name].imgs[i].isMagnify = false;
		}
	}

	function getIsMagnify(name) {
		return CKResize[name].imgs[CKResize.top.$('.ckeditor_container').attr(
				CKResize.INDEX)].isMagnify;
	}

	CKResize.INDEX = "data-ckeditor-imgs-index";
	CKResize.rotate = 0;
	CKResize.plugins = [ {
		'currentClass' : 'magnify',
		'toggleClass' : 'shrink',
		'event' : function(evt, nn) {
			var $target = $(evt.target);
			var className = $target.attr('data-ckeditor-toggle-class');
			if (!getIsMagnify(nn)) {
				setIsMagnify(true, nn);
				magnifyBimg();
				// 绑定图片拖动事件
				// resetImg(CKResize.___bimg, getCurrentImage(nn).src);
				// showThumb(getCurrentImage(nn).src, nn);
			} else {
				setIsMagnify(false, nn);
				shrinkBimg();
				// imgUnbind(CKResize.___bimg);
				// hideThumb();
			}
		}
	} ];

	function magnifyBimg(___bdiv, ___bimg) {
		if (!___bdiv && !___bimg)
			___bdiv = CKResize.top.$('.ckeditor_container .ckeditor_bdiv'),
					___bimg = ___bdiv.find('img');
		___bimg.css({
			'max-height' : '',
			'max-width' : ''
		});
		___bdiv.removeClass('nomal');

	}

	function shrinkBimg(___bdiv, ___bimg) {
		if (!___bdiv && !___bimg)
			___bdiv = CKResize.top.$('.ckeditor_container .ckeditor_bdiv'),
					___bimg = ___bdiv.find('img');
		___bdiv.css({
			'line-height' : CKResize.dialog_height + 'px'
		});
		___bimg.css({
			'max-height' : CKResize.dialog_height,
			'max-width' : CKResize.dialog_width - 60
		});
		___bdiv.addClass('nomal');
	}

	function clearToolbar() {
		clearMagnify(name);
		CKResize.___toolbarPlugins.find('div').each(function() {
			$(this).removeClass($(this).attr('data-ckeditor-toggle-class'));
			$(this).attr('title', Ckresize_lang.size);
		});
	}

	function hideScroll() {
		$('body').css('overflow-y', 'hidden');
	}

	function showScroll() {
		$('body').css('overflow-y', 'auto');
	}

	// 显示“跳转到第一页”提示
	function showBackTip() {
		var time = 1000;
		var $tip = CKResize.top.$('.ckeditor_tip');
		if ($tip.length == 0)
			$tip = $(
					'<div class="ckeditor_tip"><span>' + Ckresize_lang.tip
							+ '</span></div>').appendTo(
					CKResize.top.$('.ckeditor_kanban'));
		$tip.show();
		setTimeout(function() {
			$tip.slideUp(time);
		}, 1000);
	}
	;

	function formatSrc(imgSrc) {
		// 排除base64生成的图片
		if (imgSrc.indexOf("data:image") > -1) {
		} else if (imgSrc.indexOf("?") > -1) {
			imgSrc += "&original=true";
		} else {
			imgSrc += "?original=true";
		}
		return imgSrc;
	}

	CKResize[name].imgs
			.each(function(i) {
				var ___css = {
					'max-width' : w
				};

				if (this.width && this.width > w
						|| parseInt($(this).css('width')) > w) {
					___css.width = 'auto';
					___css.height = 'auto';
				}

				$(this).css(___css);

				if (!imgReader)
					return true;
				$(this).css('cursor', 'pointer');
				// 绑定图片点击事件
				$(this)
						.on(
								'click',
								function() {
									hideScroll();

									// 定义弹出框高宽信息
									CKResize.dialog_width = $(top).width(),
											CKResize.dialog_height = $(top)
													.height();

									var __i = 0, len = CKResize[name].imgs.length;
									for (var i = 0; i < len; i++) {
										if (CKResize[name].imgs[i] == this) {
											__i = i;
											break;
										}
									}
									var MOUSEUP = "data-ckeditor-mouseup";
									var ___pos = {};
									var ___container = $('<div class="ckeditor_container" '
											+ MOUSEUP
											+ '="ckeditor_container_up"/>');
									___container.attr(CKResize.INDEX, __i);
									var ___kanban = $('<div class="ckeditor_kanban" />');
									CKResize.___bdiv = $('<div class="ckeditor_bdiv"/>');
									var imgSrc = this.src;
									CKResize.___bimg = $("<img src=\""
											+ formatSrc(imgSrc)
											+ "\"  border=0 >");
									var ___left = $('<a href="javascript:;" class="ckeditor_left" />');
									var ___right = $('<a href="javascript:;" class="ckeditor_right" />');
									// var ___tdiv = $('<div
									// class="ckeditor_thumb"/>');

									clearMagnify(name);
									shrinkBimg(CKResize.___bdiv,
											CKResize.___bimg);

									// 工具栏
									CKResize.___toolbar = $('<div class="ckeditor_toolbar"/>');
									CKResize.___toolbarPlugins = $('<div class="ckeditor_toolbar_plugins" />')

									for (var j = 0; j < CKResize.plugins.length; j++) {
										var plugin = $('<div class="'
												+ CKResize.plugins[j].currentClass
												+ '" data-ckeditor-toggle-class="'
												+ CKResize.plugins[j].toggleClass
												+ '" title="'
												+ Ckresize_lang.size + '"/>');

										~~function(jj, nn) {
											plugin
													.click(function(evt) {
														CKResize.plugins[jj]
																.event(evt, nn);
														var $target = $(evt.target);
														var toggleClass = $target
																.attr('data-ckeditor-toggle-class');
														if ($target
																.hasClass(toggleClass)) {
															$target
																	.removeClass(toggleClass);
															$target
																	.attr(
																			'title',
																			Ckresize_lang.size);
														} else {
															$target
																	.addClass(toggleClass);
															$target
																	.removeAttr('title');
														}
													});
										}(j, name);
										CKResize.___toolbarPlugins
												.append(plugin);
									}
									;

									CKResize.close = $('<div class="ckeditor_close" title="'
											+ Ckresize_lang.close + ' "/>');

									___container
											.append(
													___kanban
															.append(CKResize.___bdiv
																	.append(
																			CKResize.___bimg)
																	.append(
																			CKResize.close)
																	.append(
																			CKResize.___toolbarPlugins)))
											.append(___left).append(___right);

									// 显示隐藏左右箭头
									___container.on({
										'mouseover' : function() {
											$(this).addClass(
													$(this).attr(MOUSEUP));
											// showThumb(self.src, name);
											// showToolbar();
										},
										'mouseleave' : function() {
											$(this).removeClass(
													$(this).attr(MOUSEUP));
											// hideThumb();
											// hideToolbar();
										}
									});

									var x2y_m, __w2h, w2h;
									// 是否处于拖动状态
									CKResize.status = false;

									~~function(nn) {
										___left
												.on(
														'click',
														function() {
															var parents = $(
																	this)
																	.parents(
																			'['
																					+ CKResize.INDEX
																					+ ']');
															var __index = parseInt(parents
																	.attr(''
																			+ CKResize.INDEX
																			+ ''));
															if (__index >= 1) {
																shrinkBimg(
																		CKResize.___bdiv,
																		CKResize.___bimg);
																clearToolbar();
																// 重置原图信息
																showImg(
																		CKResize.___bimg,
																		formatSrc(CKResize[nn].imgs[__index - 1].src));
																// 设置当前阅读图片序号
																parents
																		.attr(
																				CKResize.INDEX,
																				__index - 1);
																// 重置缩略图信息
																resetThumb(
																		CKResize[nn].imgs[__index - 1].src,
																		nn);

															}
														});

										___right
												.on(
														'click',
														function() {
															var parents = $(
																	this)
																	.parents(
																			'['
																					+ CKResize.INDEX
																					+ ']');
															var __index = parseInt(parents
																	.attr(''
																			+ CKResize.INDEX
																			+ ''));
															if (__index >= len - 1) {
																__index = -1;
																// 跳转到第一页
																showBackTip();
															}
															shrinkBimg(
																	CKResize.___bdiv,
																	CKResize.___bimg);
															clearToolbar()
															showImg(
																	CKResize.___bimg,
																	formatSrc(CKResize[nn].imgs[__index + 1].src));
															parents
																	.attr(
																			CKResize.INDEX,
																			__index + 1);
															resetThumb(
																	CKResize[nn].imgs[__index + 1].src,
																	nn);

														});
									}(name);

									CKResize.top.seajs
											.use(
													'lui/dialog',
													function(__dialog) {
														var $dialog = __dialog
																.build(
																		{
																			config : {
																				width : CKResize.dialog_width,
																				height : CKResize.dialog_height,
																				lock : true,
																				cache : false,
																				content : {
																					type : "Element",
																					elem : ___container
																				}
																			}
																		})
																.show();
														$dialog
																.on(
																		'show',
																		function() {
																			$dialog.element
																					.find(
																							'.lui_dialog_frame')
																					.css(
																							'border',
																							'none');
																		})

														CKResize.close
																.on(
																		'click',
																		function() {
																			$dialog
																					.hide();
																			showScroll();
																		});
													});
								});
			});

	var n = $rtf[0].firstChild;
	if (n) {
		var r = [];
		for (; n; n = n.nextSibling) {
			if (n.nodeType === 1 || n.nodeType === 3) {
				r.push(n);
			}
		}
		for (var i = r.length - 1; i >= 0; i--) {
			$(r[i]).insertAfter($temp);
		}
	}

	$rtf.remove();
	$temp.remove();
};
