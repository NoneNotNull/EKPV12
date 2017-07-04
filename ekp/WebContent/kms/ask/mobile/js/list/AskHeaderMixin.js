define(
		[ "dojo/_base/declare", "mui/nav/MobileCfgNavBar", "dojo/request",
				"mui/util", "dojo/text!./tmpl/header.html", "dojo/string",
				"dojo/dom-construct", "dojo/Deferred", "dojo/when",
				"dojo/_base/lang", "dojo/_base/json", "dojo/_base/array",
				"dojo/dom-style", "dojox/mobile/_css3", "dojo/dom-attr",
				"dojo/topic" ],
		function(declare, Nav, request, util, tmpl, string, domConstruct,
				Deferred, when, lang, json, array, domStyle, css3, domAttr,
				topic) {

			return declare(
					"kms.ask.AskHeaderMixin",
					null,
					{

						navCount : 3,

						SCROLL_UP : '/kms/ask/scrollup',
						SCROLL_DOWN : '/kms/ask/scrolldown',

						li : '<li data-index="${index}"><div><h3>${count}</h3><h4>${text}</h4></div></li>',

						buildRendering : function() {
							this.inherited(arguments);
							this.subscribe('/mui/nav/onComplete', 'onComplete');

							this.subscribe(this.SCROLL_UP, 'scrollup');
							this.subscribe(this.SCROLL_DOWN, 'scrolldown')
						},

						scrollup : function(obj, evt) {
							domStyle.set(this.headerNode, {
								'height' : 0
							});

							domStyle.set(this.navNode, {
								'height' : '3.8rem'
							});
						},

						scrolldown : function(obj, evt) {
							domStyle.set(this.headerNode, {
								'height' : window._header_height + 'px'
							});

							domStyle.set(this.navNode, {
								'height' : 0
							});
						},

						onComplete : function(obj, items) {
							if (!items)
								return;
							when(this.requestNav(items), lang.hitch(this,
									this.buildNav));
						},

						buildNav : function() {
							var ls = [];
							array.forEach(this.navSource,
									function(item, index) {
										ls.push(string.substitute(this.li, {
											count : item['count'],
											text : item['text'],
											index : index
										}))
									}, this);

							this.headerNode = domConstruct.toDom(string
									.substitute(tmpl, {
										name : this.name,
										imgUrl : this.imgUrl,
										bgUrl : this.bgUrl,
										nav : ls.join('')
									}));

							domConstruct.place(this.headerNode, this.domNode,
									'last');
							this.navNode = domConstruct.create('div', {
								className : 'muiAskHeaderNav'
							}, this.domNode);

							var children = this.getChildren();
							array.forEach(children, function(item) {
								domConstruct.place(item.domNode, this.navNode,
										'last');
							}, this);
							window._header_height = this.domNode.offsetHeight;

							// 切换nav标签事件
							this.connect(this.headerNode, 'click',
									'_onNavClick');
						},

						_onNavClick : function(evt) {
							var target = evt.target;
							while (target) {
								var index = domAttr.get(target, 'data-index');
								if (index) {
									topic.publish(this.SCROLL_UP, this, {});
									var navItem = this.getNav().getChildren()[index];
									navItem.setSelected();
									navItem.defaultClickAction(evt);
									break;
								}
								target = target.parentNode;
							}
						},

						getNav : function() {
							if (this.navClaz)
								return this.navClaz;
							var children = this.getChildren();
							for (var i = 0; i < children.length; i++) {
								if (children[i] instanceof Nav)
									return this.navClaz = children[i];
							}
						},

						navIndex : 0,

						requestNav : function(items) {
							this.nav_leng = Math.min(items.length,
									this.navCount);
							this.deferred = new Deferred();
							this.navSource = [];
							for (var i = 0; i < this.nav_leng; i++) {
								var item = items[i];
								var text = item['text'];
								var url = item['url'];
								this.navSource.push({
									text : text
								});
								var count = this.ajaxRequest(
										util.setUrlParameter(url, 'method',
												'count'), i);
							}
							return this.deferred.promise;
						},

						ajaxRequest : function(url, i) {
							var self = this;
							var promise = request.get(util.formatUrl(url), {
								handleAs : 'json'
							}).response.then(function(data) {
								if (data.status == 200) {
									self.navIndex++;
									self.navSource[i].count = json
											.fromJson(data.text)['count'];
									if (self.nav_leng == self.navIndex)
										self.deferred.resolve();
								}
							});
						},

						startup : function() {
							this.inherited(arguments);
							window.___header_height = this.domNode.offsetHeight;
						},

						makeTranslateStr : function(to) {
							var y = to.y;
							return "translate3d(0," + y + ",0px)";
						},

						// 让惯性变得平滑
						smooth : function(dom) {
							var cssKey = css3['transition'];
							domStyle.set(dom, cssKey,
									' -webkit-transform 100ms linear');
							this.defer(function() {
								domStyle.set(dom, cssKey, '')
							}, 100);
						},

						scrollTo : function(dom, to, smooth) {
							if (smooth)
								this.smooth(dom);
							var s = dom.style;
							s[css3.name("transform")] = this
									.makeTranslateStr(to);
						}

					});
		});