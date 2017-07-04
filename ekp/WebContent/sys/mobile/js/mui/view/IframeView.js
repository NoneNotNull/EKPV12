define( [ "dojo/_base/declare", "dojo/_base/lang", "dijit/_WidgetBase",
		"dojo/dom-construct", "dojo/dom-attr", "dojo/json", "dojo/query",
		"dojo/_base/array", "dojo/html", "mui/util", "mui/rtf/RtfResize",
		"dojo/request" ], function(declare, lang, WidgetBase, domConstruct,
		domAttr, json, query, array, html, util, RtfResize, request) {

	return declare("mui.view.IframeView", [ WidgetBase ], {
		//iframe对应地址
		url : "",

		//计算后的地址
		_iframeUrl : '',

		//相对路径
		_baseUrl : '',

		buildRendering : function() {
			this.inherited(arguments);
			this.containerNode = this.domNode;
		},

		startup : function() {
			this.inherited(arguments);
			var promise = request.post(util.formatUrl(this.url), {
				data : {
					_mobile : '1'
				},
				timeout : 30000
			});
			promise.response.then(lang.hitch(this, function(rep) {
				if (rep.status == 200) {
					var data = {};
					try { //返回iframe地址的情况
						data = json.parse(rep.data);
					} catch (e) { //直接是iframe页面的情况
						data = {};
					}
					if (data.url != null && data.url != '') {
						this._iframeUrl = data.url;
					} else {
						this._iframeUrl = util.formatUrl(this.url);
					}
					var absPath = this._iframeUrl;
					absPath = absPath
							.substring(0, absPath.lastIndexOf("/") + 1);
					this._baseUrl = absPath;
					this._doLoadIframe();
				} else {
					if (window.console)
						window.console
								.error('请求"' + this.url + '"出错，信息：' + rep);
				}
			}), lang.hitch(this, function() {
				if (window.console)
					window.console.error('请求地址"' + this.url + '"出错.');
			}));
		},
		//对于绝对地址处理
		_formatUrl : function(tmpSrc) {
			if (tmpSrc != '' && tmpSrc != null) {
				var tmpUrl = tmpSrc.toLowerCase();
				if (tmpUrl.indexOf("http://") == -1
						&& tmpUrl.indexOf("https://") == -1
						&& tmpUrl.indexOf("/") != 0) {
					return this._baseUrl + tmpSrc;
				}
			}
			return tmpSrc;
		},
		//对于html内容img的src进行处理
		_doContentFilter : function(content) {
			var test = /<img[^>]+src\s*=\s*['"]+([^'"]+)['"]+[^>]*>/gi;
			var strs = null;
			var replaceCfg = [];
			while ((strs = test.exec(content)) != null) {
				var tmpSrc = this._formatUrl(strs[1]);
				if (tmpSrc != strs[1]) {
					var newHtml = strs[0].replace(strs[1], tmpSrc);
					replaceCfg.push( {
						oraginHtml : strs[0],
						newHtml : newHtml
					});
				}
			}
			array.forEach(replaceCfg, lang.hitch( function(data) {
				content = content.replace(data.oraginHtml, data.newHtml);
			}));
			return content;
		},
		//iframe内容绘制之后再次检查img地址，并resize
		_doImgDomFilter : function() {
			array.forEach(query("img", this.containerNode), lang.hitch(this,
					function(imgNode, index) {
						var tmpSrc = domAttr.get(imgNode, "src");
						var newSrc = this._formatUrl(tmpSrc);
						if (tmpSrc != newSrc) {
							domAttr.set(imgNode, "src", newSrc);
						}
					}));
			new RtfResize( {
				containerNode : this.containerNode
			});
		},
		//iframe内容加载
		_doLoadIframe : function() {
			var _self = this;
			require( [ "dojo/text!" + this._iframeUrl ], function(templ) {
				var dhs = new html._ContentSetter( {
					parseContent : true,
					cleanContent : true,
					onBegin : function() {
						this.content = _self._doContentFilter(this.content);
						this.inherited("onBegin", arguments);
					}
				});
				dhs.node = _self.containerNode;
				dhs.set(templ);
				dhs.parseDeferred.then( function() {
					_self._doImgDomFilter();
				});
				dhs.tearDown();
			});
		}
	});
});