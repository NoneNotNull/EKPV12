var extend = (param != null && param.extend != null)
		? ('_' + param.extend)
		: '';

function createContent(content) {
	var b = $("<div class='lui_accordionpanel_slide_content_frame'></div>");
	var h = $("<div class='lui_accordionpanel_slide" + extend
			+ "_header_l'><div class='lui_accordionpanel_slide" + extend
			+ "_header_r'><div class='lui_accordionpanel_slide" + extend
			+ "_header_c'></div></div></div>");
	var c = $("<div class='lui_accordionpanel_slide" + extend
			+ "_content_l'><div class='lui_accordionpanel_slide" + extend
			+ "_content_r'><div class='lui_accordionpanel_slide" + extend
			+ "_content_c' data-lui-mark='panel.content'></div></div></div>");
	var f = $("<div class='lui_accordionpanel_slide" + extend
			+ "_footer_l'><div class='lui_accordionpanel_slide" + extend
			+ "_footer_r'><div class='lui_accordionpanel_slide" + extend
			+ "_footer_c'></div></div></div>");

	var n = $("<div class='lui_accordionpanel_slide"
			+ extend
			+ "_nav_l' data-lui-mark='panel.nav.head'><div class='lui_accordionpanel_slide"
			+ extend + "_nav_r'><div class='lui_accordionpanel_slide" + extend
			+ "_nav_c'></div></div></div>");

	var nav = n.find("div:last");
	var header = h.find("div:last");
	var body = c.find("div:last");

	header.append(n);
	b.append(h).append(c).append(f);

	// 添加标题
	var toggle = $("<span data-lui-mark='panel.nav.toggle' class='lui_accordionpanel_slide_toggle_up' data-lui-switch-class='lui_accordionpanel_slide_toggle_down'>&nbsp;</span>");
	nav.append(toggle);
	nav
			.append("<span class='lui_accordionpanel_slide_nav_text' data-lui-mark='panel.nav.text' data-lui-switch-class='lui_accordionpanel_slide_text_down'>"
					+ content.title + "</span>");

	// 添加内容
	body.append(content.element);
	return b;
}
var dom = $("<div class='lui_accordionpanel_slide" + extend + "_frame'></div>");
// 内容
for (var i = 0; i < layout.parent.contents.length; i++) {
	var ni = createContent(layout.parent.contents[i]);
	dom.append(ni);
}
layout.on("addContent", function(content) {
			var nic = createContent(content);
			// 获取标题的mark;
			layout.parent.parseTextMark(nic);
			// 解析toggle的mark
			layout.accordionpanel.parseToggleMark(nic);
			// 解析content的mark
			layout.accordionpanel.parseContentMark(nic);
			dom.append(nic);
		});
layout.on("removeContent", function(content) {
			content.element
					.parents("div.lui_accordionpanel_slide_content_frame")
					.remove();
		});
done(dom);