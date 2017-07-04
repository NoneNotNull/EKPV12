if (data == null || data.length == 0) {
	done();
	return;
}

// 变量赋值
var element = render.parent.element;
var size = render.vars.size ? render.vars.size : '100*100';
var columnNum = render.vars.columnNum ? render.vars.columnNum : '5';
var showTitle = render.vars.showTitle ? render.vars.showTitle : '0';
var slide = render.vars.slide ? render.vars.slide : '0';
var ____width = 100 / columnNum + '%';

// 获取panel皮肤类型
var extend = '';
// var __parent = render.parent.parent.parent.layout;
// if (__parent.param && __parent.param.extend)
// extend = '_' + __parent.param.extend;
var container = $('<div class="lui_dataview_image' + extend + ' clearfloat"/>');
container.attr('id', render.cid + '____image____');
var content = $('<div class="lui_dataview_image' + extend + '_content"/>');
var table = $('<table data-lui-mark="dataview.image.table"/>');
var w2h = size.split('*'), w = w2h[0], h = w2h[1];

// 判断是否进行滑动
function isSlide() {
	if (slide && slide != '0')
		return true;
	return false;
}

function isHorizontSlide() {
	return isSlide() && slide == 1;
}

function isVerticalSlide() {
	return isSlide() && slide == 2;
}

____width = !isSlide() ? ____width : '';
function createImage(url, href) {
	var __img = $('<img />');

	// __img.attr('src', env.fn.formatUrl(url));
	__img.css({
				'width' : w,
				'height' : h
			});
	__img.attr('data-src', env.fn.formatUrl(url));
	var ___a = $('<a target="_blank"/>');
	___a.attr('href', env.fn.formatUrl(href));
	___a.attr('class', 'lui_dataview_image' + extend + '_entity');

	___a.append(__img);
	return ___a;
}

function createText(text, href) {
	var __text = $('<a />');
	__text.attr('href', env.fn.formatUrl(href));
	__text.attr('title', text);
	__text.addClass('com_subject');
	__text.addClass('textEllipsis');
	__text.text(env.fn.formatText(text));
	__text.css('width', w);
	return __text;
}
var __tr = '<tr>', tr__ = '</tr>';
var __td = '<td width="' + ____width + '"'
		+ (!isSlide() ? 'style="padding-left:0;padding-right:0"' : '') + '>', td__ = '</td>';

// 创建td对象
function createTd(grid) {
	var grid_img = createImage(grid['image'], grid['href']);
	var grid_text = createText(grid['text'], grid['href']);
	var div = $('<div/>');

	if (showTitle && showTitle == '0') {
		div.append(grid_img).append(grid_text);
	} else {
		div.append(grid_img);
	}
	return __td + div.html() + td__;
}

// 构建普通图片视图
function ___nomalBuild(html) {
	for (var i = 0; i < data.length; i++) {
		var grid = data[i];
		if (i % columnNum === 0)
			html += __tr;
		html += createTd(grid);
		if (i % columnNum == columnNum - 1)
			html += tr__;
	}
	return html;
}

// 构建水平滚动视图
function ___horizontBuild(html) {
	html += __tr;
	for (var i = 0; i < data.length; i++) {
		var grid = data[i];
		html += createTd(grid);
	}
	html += tr__;
	return html;
}

// 构建垂直滚动视图
function ___verticalBuild(html) {
	for (var i = 0; i < data.length; i++) {
		html += __tr;
		var grid = data[i];
		html += createTd(grid);
		html += tr__;
	}
	return html;
}
var html = '';
if (!isSlide()) {
	html = ___nomalBuild(html);
	container.append(content);
}

if (isHorizontSlide()) {
	container.append($('<div class="lui_dataview_image' + extend + '_left"/>'));// 向左
	container.append(content);
	container
			.append($('<div class="lui_dataview_image' + extend + '_right"/>'));// 向右
	table.css('position', 'absolute');
	content.css('position', 'absolute');
	html += ___horizontBuild(html);
}

if (isVerticalSlide()) {
	container.append($('<div class="lui_dataview_image' + extend + '_top"/>'));// 向上
	container.append(content);
	content.addClass('vertical');
	container
			.append($('<div class="lui_dataview_image' + extend + '_bottom"/>'));// 向下
	html += ___verticalBuild(html);
	table.css('position', 'absolute');
	content.css('position', 'absolute');
}

table.append($(html));
content.append(table);
done(container);

// var time = 2000;

// 刷新滑动按钮状态
function refreshStatus(__1, __2, l, tw, cw) {
	if (cw > tw)// 宽度不够，不需要产生滑动效应
		return;
	var clas = 'hasNext';
	if (l < 0) {
		__1.css('cursor', 'pointer');
		__1.addClass(clas);
	} else {
		__1.css('cursor', 'auto');
		__1.removeClass(clas);
	}
	if (tw - (cw - l) > 0) {
		__2.css('cursor', 'pointer');
		__2.addClass(clas);
	} else {
		__2.css('cursor', 'auto');
		__2.removeClass(clas);
	}
}

/*******************************************************************************
 * 图片延迟加载简单处理
 */

// 获取位置信息
function getPosition(obj) {
	return {
		l : obj.offset().left,
		t : obj.offset().top,
		w : obj.width(),
		h : obj.height()
	};
}

// 是否交集
function intersect(o1, o2) {
	var lc1 = o1.l + o1.w / 2, lc2 = o2.l + o2.w / 2, tc1 = o1.t + o1.h / 2, tc2 = o2.t
			+ o2.h / 2, w1 = (o1.w + o2.w) / 2, h1 = (o1.h + o2.h) / 2;
	return Math.abs(lc1 - lc2) < w1 && Math.abs(tc1 - tc2) < h1;
}

function lazyload(__ctn) {
	var ctn = getPosition(__ctn);
	__ctn.find('img').each(function() {
				var img = getPosition($(this));
				if (intersect(ctn, img))
					if ($(this).attr('data-src')) {
						$(this).attr('src', $(this).attr('data-src'));
						$(this).removeAttr('data-src');
					}
			});
}

/** ***************************************************************************** */

// 滑动
function horizontSlide() {
	var ____image____ = $('#' + render.cid + '____image____');
	var ____table____ = ____image____
			.find('[data-lui-mark="dataview.image.table"]');
	var tw = ____table____.width();
	var c = ____image____.find('.lui_dataview_image_content');
	var cw = c.width();
	var tdw = ____table____.find('td').outerWidth();
	var num = parseInt(cw / tdw);
	var w = tdw * num;
	var ____left = ____image____.find('.lui_dataview_image' + extend + '_left'), ____right = ____image____
			.find('.lui_dataview_image' + extend + '_right');
	refreshStatus(____left, ____right, 0, tw, cw);
	lazyload(c);
	____image____.bind('click', function(evt) {
				var $parent = $(evt.target);
				while ($parent.length > 0) {
					if ($parent.hasClass('lui_dataview_image' + extend
							+ '_left')) {
						var l = parseInt(____table____.css('left'));
						var _l = (l + w) <= 0 ? (l + w) : 0;
						____table____.animate({
									left : _l
								}, function() {
									lazyload(c);
								});
						refreshStatus(____left, ____right, _l, tw, cw);
						break;
					}
					if ($parent.hasClass('lui_dataview_image' + extend
							+ '_right')) {
						// 图片so little
						if (tw <= cw)
							return;

						var l = parseInt(____table____.css('left'));
						var _l = (w - l) <= (tw - cw) ? (l - w) : cw - tw;
						____table____.animate({
									left : _l
								}, function() {
									lazyload(c);
								});
						refreshStatus(____left, ____right, _l, tw, cw);
						break;
					}
					$parent = $parent.parent();
				}
			});
}

function verticalSlide() {
	var ____image____ = $('#' + render.cid + '____image____');
	var ____table____ = ____image____
			.find('[data-lui-mark="dataview.image.table"]');
	var c = ____image____.find('.lui_dataview_image_content');
	var ch = c.height();
	var tdh = ____table____.find('td').outerHeight();
	var num = parseInt(ch / tdh);
	var h = tdh * num;
	var th = ____table____.height();
	var ____top = ____image____.find('.lui_dataview_image' + extend + '_top'), ____bottom = ____image____
			.find('.lui_dataview_image' + extend + '_bottom');
	refreshStatus(____top, ____bottom, 0, th, ch);
	lazyload(c);
	____image____.bind('click', function(evt) {
				var $parent = $(evt.target);
				while ($parent.length > 0) {
					if ($parent
							.hasClass('lui_dataview_image' + extend + '_top')) {
						var t = parseInt(____table____.css('top'));
						var _t = (t + h) <= 0 ? (t + h) : 0
						____table____.animate({
									top : _t
								}, function() {
									lazyload(c);
								});
						refreshStatus(____top, ____bottom, _t, th, ch);
						break;
					}
					if ($parent.hasClass('lui_dataview_image' + extend
							+ '_bottom')) {
						// 图片so little
						if (th <= ch)
							return;

						var t = parseInt(____table____.css('top'));
						var _t = (h - t) <= (th - ch) ? (t - h) : ch - th;
						____table____.animate({
									top : _t
								}, function() {
									lazyload(c);
								});
						refreshStatus(____top, ____bottom, _t, th, ch);
						break;
					}
					$parent = $parent.parent();
				}
			});
}

var width = element.parent().width();
var height = element.parent().height();

if (isHorizontSlide()) {
	height = Math.max(height, 132);
	table.css('height', '100%');
	content.css('height', height);
	container.css('height', height);
	container.addClass('border');
	horizontSlide();
}

if (isVerticalSlide()) {
	height = Math.max(height, 320);
	width = Math.max(width, 110);
	content.css('width', width);
	table.css('width', '100%');
	container.css('height', height);
	container.addClass('border');
	verticalSlide();
}

if (!isSlide()) {
	content.css('width', width);
	table.css('width', '100%');
	var c = $('#' + render.cid + '____image____ .lui_dataview_image_content');
	lazyload(c);
}
