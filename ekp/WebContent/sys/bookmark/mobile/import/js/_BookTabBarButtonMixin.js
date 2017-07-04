define(	["dojo/_base/declare", "dojo/_base/lang", "dojo/request", "mui/util",
				"dojo/dom-class", "mui/dialog/Tip"], function(declare, lang,
				req, util, domClass, Tip) {

			return declare("mui.tabbar._BookTabBarButtonMixin", null, {
				// 判断是否已经收藏过
				isBookedUrl : '/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=isBooked',
				// 新增收藏
				addBookedUrl : '/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=save&forward=lui-source',
				// 取消收藏
				delBookedUrl : '/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=deleteBookmark',

				isBooked : false,

				subject : null,

				url : null,

				modelId : null,

				modelName : null,

				lock : true,

				fdId : null,

				scaleClass : 'muiBookMaskScale',

				bookedClass : 'mui-star-on',

				unBookedClass : 'mui-star-off',

				buildRendering : function() {
					this.inherited(arguments);
				},

				_setSubjectAttr : function(subject) {
					this.subject = this.getBookmarkSubject(subject);
				},

				startup : function() {
					if (this._started)
						return;
					this.inherited(arguments);

					this.url = this.getBookmarkUrl();
					// 更换是否已经收藏过图标
					req(util.formatUrl(this.isBookedUrl), {
								handleAs : 'json',
								method : 'post',
								data : {
									url : this.url
								}
							}).then(lang.hitch(this, function(data) {
								if (data && data.isBooked)
									this.toggleBooked(data);
								this.set("lock", false);
							}));
				},

				replaceClass : function(flag) {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					var class1 = flag ? this.bookedClass : this.unBookedClass, class2 = flag
							? this.unBookedClass
							: this.bookedClass;
					domClass.replace(i1, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
					domClass.replace(i2, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
				},

				removeScaleClass : function() {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					this.defer(lang.hitch(this, function() {
										domClass.remove(i1, this.scaleClass);
										domClass.remove(i2, this.scaleClass);
									}), 300);
				},

				toggleBooked : function(data) {
					if (data.isBooked)
						this.set('fdId', data.fdId);
					else
						this.set('isBooked', false);
					this.replaceClass(data.isBooked);
					this.removeScaleClass();
					this.set('isBooked', data.isBooked);
					this.set('lock', false);
				},

				rq : function(url, data, handleAs, callback) {
					req(util.formatUrl(url), {
								handleAs : handleAs,
								method : 'post',
								data : data
							}).then(lang.hitch(this, callback));
				},

				// 切换收藏
				onClick : function(evt) {
					if (this.lock)
						return false;

					this.set('lock', true);
					if (!this.isBooked)
						this.rq(this.addBookedUrl, {
									fdId : this.fdId,
									docSubject : this.subject,
									fdModelId : this.modelId,
									fdUrl : this.url,
									fdModelName : this.modelName
								}, 'json', function(data) {
									this.toggleBooked({
												isBooked : true,
												fdId : data.fdId
											});
									Tip.tip({
												icon : 'mui '
														+ this.bookedClass,
												text : '添加收藏'
											});

								});
					else
						this.rq(this.delBookedUrl, {
									bookmarkId : this.fdId
								}, 'json', function(data) {
									this.toggleBooked({
												isBooked : false
											});
									Tip.tip({
												icon : 'mui '
														+ this.unBookedClass,
												text : '取消收藏'
											});
								});
					return false;
				},

				// 获取当前文档标题
				getBookmarkSubject : function(subject) {
					if (subject.length < 1) {
						var title = document.getElementsByTagName("title");
						if (title != null && title.length > 0) {
							subject = title[0].text;
							if (subject == null) {
								subject = "";
							} else {
								subject = subject.replace(/(^\s*)|(\s*$)/g, "");
							}
						}
					}
					return subject;
				},

				// 获取当前文档url
				getBookmarkUrl : function() {
					var context = dojoConfig.baseUrl.substring(0,
							dojoConfig.baseUrl.length - 1);
					var url = window.location.href;
					url = url.substring(url.indexOf('//') + 2, url.length);
					url = url.substring(url.indexOf('/'), url.length);
					if (context.length > 1) {
						url = url.substring(context.length, url.length);
					}
					// 去除移动端特有标志
					var re = new RegExp();
					re.compile("([\\?&]forward=)[^&]*", "i");
					if (re.test(url))
						url = url.replace(re, "");
					return url;
				}
			});
		});