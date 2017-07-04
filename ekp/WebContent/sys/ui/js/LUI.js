( function() {
	if (window.LUI != null)
		return;

	LUI = function(id) {
		if (Object.isString(id))
			return LUI.cachedInstances[id];
		else if (id.id)
			return LUI.cachedInstances[id.id];
		return null;
	};
	LUI.cachedInstances = {};
	LUI.syncAjax = function(requestUrl) {
		var http = {};
		if (window.XMLHttpRequest) {
			http = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			http = new ActiveXObject("Microsoft.XMLHTTP");
		}
		http.open("GET", requestUrl, false);
		http.setRequestHeader("Accept", "text/plain");
		http.setRequestHeader("Content-Type", "text/plain; charset=utf-8");
		http.send(null);
		return http.responseText;
	};
	LUI.toJSON = function(str) {
		return (new Function("return (" + str + ");"))();
	};
	LUI.stringify = function(val) {
		return domain.stringify(val);
	};
	var zindex = 50;
	LUI.zindex = function() {
		zindex = zindex + 10;
		return zindex;
	};
	LUI._ready = [];

	LUI.ready = function(fn) {
		if (!LUI._ready)
			LUI._ready = [];
		LUI._ready.push(fn);
	};
	LUI.placeholder = function(dom) {
		if (document.documentMode != null && document.documentMode < 10) {
			seajs
					.use(
							[ 'lui/jquery' ],
							function($) {
								dom = $(dom);
								var base = seajs.data.base;
								dom
										.find("[placeholder]")
										.each(
												function() {
													var obj = $(this);
													placeh();
													obj.focus(placeh);
													obj.blur(placeh);
													obj.keyup(placeh);
													obj.change(placeh);
													function placeh() {
														if (obj.val() == "") {
															obj.isBack = true;
															obj
																	.css(
																			"background-image",
																			"url('"
																					+ base
																					+ "/resource/placeholder.jsp?text="
																					+ encodeURIComponent(obj
																							.attr("placeholder"))
																					+ "')");
															obj
																	.css(
																			"background-repeat",
																			"no-repeat");
															obj
																	.css(
																			"background-position",
																			"left center");
														} else {
															if (obj.isBack) {
																obj
																		.css(
																				"background-image",
																				"");
																obj
																		.css(
																				"background-repeat",
																				"");
															}
														}
													}
												});
							});
		}
	}

	//跨域事件处理
	domain.register("fireEvent", function(event) {
		if (event.type == 'event') {
			seajs.use( [ 'lui/base' ], function(base) {
				var evented = base.byId(event.target);
				if (evented) {
					evented.emit(event.name, event.data);
				}
			});
		} else if (event.type == 'topic') {
			seajs.use( [ 'lui/topic' ], function(topic) {
				if (event.target) {
					topic.group(event.target).publish(event.name, event);
				} else {
					topic.publish(event.name, event);
				}
			});
		}
	});
	var dialogAgent = function(luiid){
		this.luiid = luiid;
	};
	dialogAgent.prototype.hide =  function(data) {
		domain.call(window.parent,"dialogAgentCall",[this.luiid,"hide",data]);
	};
	domain.register("dialogAgent",function(luiid){
		window['$dialog'] = new dialogAgent(luiid);
	});
	domain.register("dialogAgentCall",function(luiid,method,data){
		LUI(luiid)[method](data);
	});
	LUI.fire = function(event, win) {
		if (win && window != win) {
			domain.call(win, 'fireEvent', [ event ]);
		} else {
			// {type:"event", target:"id", name="selectChanged", data{}}
			if (event.type == 'event') {
				seajs.use( [ 'lui/base' ], function(base) {
					var evented = base.byId(event.target);
					evented.emit(event.name, event.data);
				});
			} else if (event.type == 'topic') {
				seajs.use( [ 'lui/topic' ], function(topic) {
					if (event.target) {
						topic.group(event.target).publish(event.name, event);
					} else {
						topic.publish(event.name, event);
					}
				});
			}
		}
	};
	// 判断返回的内容里面是否包含密码域
	var regLoginPage = /<input[^>]+type=(\"|\')?password(\"|\')?[^>]*>/gi;
	LUI.ajaxComplete = function(xhr) {
		if (xhr.getResponseHeader("isloginpage") != null
				&& xhr.getResponseHeader("isloginpage") == "true") {
			//window.top.location.reload();
		} else {
			if (xhr.responseText && xhr.responseText.search && xhr.responseText.search(regLoginPage) > 0) {
				//debugger;
				//window.top.location.reload();
			}
		}
	};
	
	LUI.person = function(event, element, id){
		seajs.use(['sys/zone/resource/zoneInfo.js'], function(zoneInfo){
			zoneInfo.buildZoneInfo(event, element, id);
		});
	};
	
	// 浏览器兼容检测
	if (navigator.userAgent.indexOf("MSIE") > -1
			&& document.documentMode == null || document.documentMode < 8) {
		function use(url, isCss) {
			var type = isCss ? 'link' : 'script';
			var node = document.createElement(type), head = document
					.getElementsByTagName("head")[0];
			if (isCss) {
				node.rel = "stylesheet"
				node.href = url
			} else {
				node.src = url
			}
			node.src = url;
			head.appendChild(node);
		}
		use(Com_Parameter.ContextPath + 'resource/js/jquery.js', false);
		use(Com_Parameter.ContextPath + 'sys/ui/extend/theme/default/style/common.css', true);
		use(Com_Parameter.ContextPath + 'sys/ui/extend/theme/default/style/icon.css', true);
		window.onload = function(){
			var $tip = $(
					'<div>您正在使用 Internet Explorer 低版本的IE浏览器。为更好的浏览本页，建议您将浏览器升级到IE8以上或以下浏览器：Firefox/Chrome/Safari/Opera</div>')
					.appendTo($(document.body))
					.addClass('browserTip');
			var $close = $(
					'<div class="lui_icon_s_icon_16 lui_icon_s" title="关闭提示">')
					.click(function(evt) {
						$tip.remove();
					});
			$tip.append($close);
			window.onscroll = function() {
				$tip.css('top', $('body,html')
						.scrollTop()
						+ 'px');
			}
		};
	}
})();