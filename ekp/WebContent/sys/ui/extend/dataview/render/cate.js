var ___data = data;

var ___href = render.vars.href, ___target = render.vars.target;

var element = render.parent.element;
var __render = render;
function createItem_l() {
	var item__l = $("<div class='lui_dataview_cate_item_left' />");
	return item__l;
}

function createItem_r() {
	var item__r = $("<div class='lui_dataview_cate_item_right' />");
	return item__r;
}

function createItem_c() {
	var item__c = $("<div class='lui_dataview_cate_item_content'/>");
	return item__c;
}

function createItem_s() {
	var item__s = $("<div class='lui_dataview_cate_item_sign'>"
			+ "<i class='lui_dataview_cate_item_sign_mtr1'></i>"
			+ "<i class='lui_dataview_cate_item_sign_mtr2'></i>" + "</div>");
	return item__s;
}

function createItem_t() {
	var item__t = $("<div class='lui_dataview_cate_item_txt' />");
	return item__t;
}

function createFrame() {
	var frame = $("<div class='lui_dataview_cate'/>");
	return frame;
}

function createBox() {
	var box = $('<ul class="lui_dataview_cate_all_box" />');
	return box;
}
var __frame = createFrame();
seajs.use(['lui/data/source', 'lui/util/str', 'lui/jquery', 'lui/base',
				'lui/view/render', 'lui/popup'], function(source, strutil, $,
				base, render, popup) {
			var __box = createBox();
			__frame.append(__box);

			for (var i = 0; i < ___data.length; i++) {

				// 文本
				var __t = createItem_t();
				__t.html(___data[i].text);
				__t.attr('title', ___data[i].text);
				var __l = createItem_l();
				var __r = createItem_r();
				var __c = createItem_c();
				var __s = createItem_s();
				__l.append(__r.append(__c.append(__t).append(__s)));

				var li = $('<li></li>');
				var div = $('<div data-lui-switch-class="lui_icon_on" class="lui_dataview_cate_item"/>');

				~~function(i) {
					return function() {
						div.click(function(evt) {
									window
											.open(
													env.fn
															.formatUrl(strutil
																	.variableResolver(
																			___href
																					|| ___data[i].href,
																			data[i])),
													___target
															|| ___data[i].target);
								});
					}();
				}(i);
				li.append(div.append(__l));
				__box.append(li);
				// 弹出框
				var dataview = new base.DataView();
				var url = strutil.variableResolver(__render.parent.source._url,
						{
							value : ___data[i].value
						});

				var __static = new source.Static({
							datas : ___data[i].children || [],
							parent : dataview
						});
				dataview.setSource(__static);
				__static.startup();

				// 取消多次请求数据
				// dataview.setSource(new source.AjaxJson({
				// url : url,
				// parent : dataview
				// }));

				dataview.setRender(new render.Template({
							src : '/sys/ui/extend/dataview/render/treemenu2.tmpl#',
							param : {
								extend : 'cate'
							},
							parent : dataview,
							vars : {
								target : ___target || ___data[i].target
							}
						}));
				dataview.render.startup();
				dataview.startup();

				var popDiv = $('<div>')
						.attr('class', 'lui_dataview_cate_popup');
				var _____height = $(window).height() - 6;
				popDiv.css('max-height', _____height);
				popDiv.append(dataview.element);
				var cfg = {
					"align" : "right-top"
				};

				if (__render.parent.parent)
					cfg.parent = __render.parent.parent;
				var pp = popup.build(div, popDiv, cfg);
				dataview.popup = pp;
				pp.addChild(dataview);

				(function(popDiv, dataview) {
					return function() {
						dataview.on('load', function() {
									if (dataview.data
											&& dataview.data.length > 0)
										popDiv.css('width', 600);
									if (popDiv.height() >= _____height) {
										popDiv.css('overflow-y', 'auto');
									}
								});
						dataview.load = function() {
							var __ = {
								___ : li
							};
							this.source.get(function(data) {
								if (data && data.length == 0) {
									redrawPopItem(__);
								} else {
									for (var k = 0; k < data.length; k++) {
										data[k].href = strutil
												.variableResolver(
														___href
																|| data[k].href
																|| 'javascript:;',
														data[k]);
										var children = data[k].children || [];
										for (var j = 0; j < children.length; j++) {
											children[j].href = strutil
													.variableResolver(
															___href
																	|| children[j].href
																	|| 'javascript:;',
															children[j]);
										}
									}
								}
								return data;
							});
						};
						dataview.draw();
					}();
				}(popDiv, dataview));

			}
		});

// 移除下级数据箭头标志
function redrawPopItem(__) {
	if (!__.___)
		return;
	__.___.find(".lui_dataview_cate_item_sign").remove();
}
done(__frame);