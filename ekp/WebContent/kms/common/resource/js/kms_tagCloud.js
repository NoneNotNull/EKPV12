/*
 * ! Requires: [kms.js,jquery.js,dialog.js,common.js] Description:
 * 主页标签云显示，之前iframe结构，因为注入安全被过滤所以更改 kms_tagCloud.js
 */
;
(function($) {
	// var ie8later = $.browser.msie && parseInt($.browser.version) >= 8;

	var TagCloud = EventTarget.extend({
		constructor : function(container, options) {
			this.options = {
				// cache : true,
				// serviceBean:''
				url : KMS.contextPath
						+ 'sys/tag/sys_tag_top/SphereTag.swf?date='
						+ (new Date()).getTime(),
				flashDiv : 'divflash',
				object : 'TagApplication_SWFObjectName',
				embed : 'TagApplication_SWFObjectName_other',
				flashDiv_width : 198,
				flashDiv_height : 200
			}
			this.container = container;
			this.base(options);
			this.draw();
		},
		// 绘制标签云flash控件
		draw : function() {
			if (this.container.size() > 0) {
				var flashArray = new Array();
				flashArray
						.push('<div id="'
								+ this.options.flashDiv
								+ '" style="margin: 1%; align: center; valign: center;">')
				flashArray
						.push('<div style="width: 100%; height: 100%; border: none">')
				flashArray
						.push('<object id="'
								+ this.options.object
								+ '" name="'
								+ this.options.object
								+ '" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%">');
				flashArray.push('<param name="movie" value="'
						+ this.options.url + '" />');
				flashArray.push('<param name="quality" value="high" />');
				flashArray.push('<param name="wmode" value="opaque" />');
				flashArray.push('<embed id="' + this.options.embed + '" ');
				flashArray.push('src="' + this.options.url + '" ');
				flashArray.push('wmode="opaque" ');
				flashArray
						.push('quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" ');
				flashArray
						.push('type="application/x-shockwave-flash" style="width: 100%; height: 200px;" allowFullScreen=true>');
				flashArray.push('</embed>');
				flashArray.push('</object>');
				flashArray.push('</div>');
				flashArray.push('</div>');
				var object = flashArray.join('');
				$(this.container).html(object);
				this.request();
			}
		},

		// 请求后端标签数据
		request : function() {
			var data = new KMSSData();
			var url = this.options.serviceBean;
			data.SendToBean(url, this.render.binding(this));
			// var height = window.document.body.clientHeight;
			// var width = window.document.body.clientWidth;
			var divflash_ = document.getElementById(this.options.flashDiv); // 获取对象
			divflash_.style.width = this.options.flashDiv_width;
			divflash_.style.height = this.options.flashDiv_height;
		},

		// 渲染
		render : function(rtnData) {
			var id = this.options.object;
			if (!Com_Parameter.IE) {
				id = this.options.embed;
			}
			var that = this;
			// 判断flash是否加载完毕
			var itv = setInterval(function() {
						var flash = document.getElementById(id); // 获取对象
						if (flash) {
							clearInterval(itv);
							var divflash = document
									.getElementById(that.options.flashDiv); // 获取flash
							// div对象
							if (rtnData.GetHashMapArray().length >= 1) {
								var obj = rtnData.GetHashMapArray()[0];
								var count = obj['count'];
								var xml = obj['xml'];
								if (flash && flash.SphereTag_setConfigToAS) {
									if (count == 0) {
										flash.SphereTag_setTagsDataToAS(xml); // 标签名称
										return;
									} else if (count > 10) { // 设置球大小
										flash
												.SphereTag_setConfigToAS(that
														.anlyXml("4F7BA7",
																"30", "130",
																"130", "30",
																"10", "30"));
									} else {
										flash
												.SphereTag_setConfigToAS(that
														.anlyXml("4F7BA7",
																"30", "130",
																"130", "30",
																"10", "30"));
									}
									flash.SphereTag_setTagsDataToAS(xml); // 标签名称
								}

							}
						}
					}, 500);

		},

		anlyXml : function(tagColor, colorDepth, userDistaice, sphereRadius,
				frameSpeed, baseSpeed, centerAreaRadius) {
			var configXml = "<config" + " tagColor='" + tagColor + "'"
					+ " colorDepth='" + colorDepth + "'" + " userDistaice='"
					+ userDistaice + "'" + " sphereRadius='" + sphereRadius
					+ "'" + " frameSpeed='" + frameSpeed + "'" + " baseSpeed='"
					+ baseSpeed + "'" + " centerAreaRadius='"
					+ centerAreaRadius + "'/>";
			return configXml;
		}
	})
	this.TagCloud = TagCloud;
}(jQuery));

// 点击标签跳转页面

function SphereTag_TagClick(tagName) {
	var href = KMS.contextPath
			+ "sys/tag/sys_tag_main/sysTagMain.do?method=searchMain";
	href = href + "&queryString=" + encodeURI(tagName) + "&queryType=normal";
	window.open(href, "_blank");
}