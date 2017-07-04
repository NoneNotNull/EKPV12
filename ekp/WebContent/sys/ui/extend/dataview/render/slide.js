var element = render.parent.element;
var width = Math.max(element.parent().width(), 160);
var height = Math.max(element.parent().height(), 120);
var target = render.vars.target ? render.vars.target : '_blank';
var stretch = render.vars.stretch == null || render.vars.stretch == 'true';

var htmlCode = "<div id='";
htmlCode += render.cid;
htmlCode += "-slide'><div class='lui_dataview_slide_content' style='";
if (width) {
	htmlCode += ["width:", width, "px;"].join('');
}
if (height) {
	htmlCode += ["height:", height, "px;"].join('');
}
htmlCode += "'>";
var content = data;
var imgCode = "";
// 右下角按钮
var buttonCode = "<ul>";
var context = "";
// 标题
var subjectCode = "";
var bgCode = "<div class='lui_dataview_slide_bg'></div>";
for (var i = 0; i < content.length; i++) {
	context += "<div class='lui_dataview_slide_imgDiv'>";
	imgCode = ['<a href = "', env.fn.formatUrl(content[i].href), '"',
			'target="', target, '">', '<img src="',
			env.fn.formatUrl(content[i].image), '" alt="" ',
			(stretch ? 'style="width:100%; height:100%"' : ''), '/>', '</a>']
			.join('');
	subjectCode = ['<h3>', env.fn.formatText(content[i].text), '</h3>']
			.join('');
	context += imgCode;
	context += subjectCode;
	context += "</div>";
	buttonCode += '<li></li>';
}
buttonCode += "</ul>";
htmlCode += context;
htmlCode += bgCode;
htmlCode += buttonCode;
htmlCode += "</div></div>";
done(htmlCode);

// 渲染完后绑定事件
~~function() {
	var slideCache = [];
	$("#" + render.cid + "-slide ul li").each(function(c) {
				var slide = {};
				slide["cursor"] = $(this);
				this["pos"] = c;
				slideCache[c] = slide;
			});
	$("#" + render.cid + "-slide .lui_dataview_slide_imgDiv").each(function(c) {
				slideCache[c]["a"] = $(this).find('a');
				slideCache[c]["text"] = $(this).find('h3');
			});
	var curpos = 0, timer;
	var slen = slideCache.length, curSlide = null, oSlide = null;
	function autoSlide() {
		if (curpos == slen)
			curpos = 0;
		for (var c = 0; c < slen; c++) {
			if (c == curpos) {
				curSlide = slideCache[c];
				curSlide.cursor.addClass("lui_dataview_slide_on");
				curSlide.text.css('display', 'inline-block');
				curSlide.a.fadeIn();
			} else {
				oSlide = slideCache[c];
				oSlide.cursor.removeClass("lui_dataview_slide_on");
				oSlide.text.hide();
				oSlide.a.hide();
			}
		}
		curpos++;
	}

	autoSlide();
	timer = setInterval(autoSlide, 5000);
	render.parent.onErase(function() {
				clearInterval(timer)
			});
	$("#" + render.cid + "-slide li").bind("click", function() {
				clearInterval(timer);
				timer = setInterval(autoSlide, 5000);
				curpos = this["pos"];
				autoSlide();
			});
	if (!stretch) {
		// 高度垂直居中
		$("#" + render.cid + "-slide img").bind('load', function() {
			var $outerObj = $(this.parentNode), obj = $(this), iheight = $outerObj
					.height();
			if (this.height > 0 && iheight > this.height) {
				obj.css('margin-top', [(iheight - this.height) / 2, 'px']
								.join(''));
			}
		});
	}
	// 减去边框
	var content = $("#" + render.cid + '-slide .lui_dataview_slide_content'), b_w = (content[0].offsetWidth - parseInt(content
			.width()))
			/ 2, b_h = (content[0].offsetHeight - parseInt(content.height()))
			/ 2;

	if (b_w == 0)
		return;
	var w = content.width(), h = content.height()
	content.css({
				'width' : w - 2 * b_w,
				'height' : h - 2 * b_h
			});
}();
