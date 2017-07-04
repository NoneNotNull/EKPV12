define(function(require, exports, module) {
	require("theme!paging");
	var base = require("lui/base");
	var layout = require("lui/view/layout");
	var topic = require('lui/topic');
	var $ = require('lui/jquery');

	var PAGING_DOLAYOUT = "list.changed";
	var PAGING_CHANGED = "paging.changed";

	var PAGING_SIZE = 9;
	var PAGING_LAST = 1;
	var PAGING_FIRST = 1;
	var PAGING_ELLIPSIS = 1;

	var PAGING_MAX_AMOUNT = 500;

	var PAGING_NUM = "data-lui-paging-num";

	var Paging = base.Container.extend({

		initProps : function($super, _config) {
			$super(_config);
			// 是否显示上下页
			this.__disPre = true;
			this.__disNext = true;
			this.currentPage = parseInt(_config.currentPage);
			this.pageSize = parseInt(_config.pageSize);
			this.totalSize = parseInt(_config.totalSize);
			this.viewSize = parseInt(_config.viewSize);
		},

		startup : function($super) {
			if (this.isStartup) {
				return;
			}
			topic.channel(this).subscribe(PAGING_DOLAYOUT, this.draw, this);
			this.isStartup = true;
		},

		draw : function(evt) {
			if (evt && evt['page']) {
				this.currentPage = parseInt(evt['page'].currentPage);
				this.pageSize = parseInt(evt['page'].pageSize);
				this.totalSize = parseInt(evt['page'].totalSize);
			}
			this.totalPage = Math.ceil(this.totalSize / this.pageSize);
			this.hasNext = this.totalPage > this.currentPage && this.__disPre;
			this.hasPre = this.currentPage > 1 && this.__disPre;
			this.cal();
			if (this.isDrawed)
				return this;

			var self = this;
			if (this.totalPage > 0) {
				if (this.layout) {
					this.layout.on("error", function(msg) {
								self.element.append(msg);
							});
					this.layout.get(this, function(obj) {
								self.doLayout(obj);
							});
				}
			} else this.erase();
		},

		doLayout : function(html) {

			var self = this;
			self.erase();
			if (html)
				this.element.html(html);

			this.element.bind({
						'click' : function(evt) {
							var $target = $(evt.target);
							for(; $target.attr('id') != self.id; $target = $target.parent()) {
								// 页码跳转
								if($target.attr("data-lui-mark") == "paging.jump") {
									self.onJump(evt);
									break;
								}
								// 页码切换
								else if ($target.attr(PAGING_NUM)) {
									self.onChange(evt);
									break;
								}
							}
							
						},
						'keydown' : function(evt) {
							self.onKeydown(evt);
						},
						'keyup' : function(evt) {
							self.onKeyUp(evt);
						}
					});

			this.onErase(function() {
						this.element.unbind('click');
						this.element.unbind('keydown');
						this.element.unbind('keyup');
					});
			
			if (this.totalSize > 0) {
				this.element.show();
			}
		},

		onReLayout : function() {

			var pageSize = this.element.find('[data-lui-mark="paging.amount"]')
					.val(), currentPage = this.element
					.find('[data-lui-mark="paging.pageno"]').val();
			pageSize = pageSize > PAGING_MAX_AMOUNT
					? PAGING_MAX_AMOUNT
					: pageSize;
			// 数字校验
			var reg = /^[0-9]+$/;
			if (!reg.test(pageSize) || !reg.test(currentPage))
				return;

			this.pageSize = parseInt(pageSize);
			this.currentPage = parseInt(currentPage);
			var evt = {
				paging : this.id,
				page : [{
							key : 'pageno',
							value : [this.currentPage]
						}, {
							key : 'rowsize',
							value : [this.pageSize]
						}],
				query : [{
							key : "s_raq",
							"value" : [Math.random()]
						}]
			};
			topic.channel(this).publish(PAGING_CHANGED, evt);
		},

		onJump : function(evt) {
			this.onReLayout();
		},

		onChange : function(evt) {
			var $target = $(evt.target);
			if ($target.attr(PAGING_NUM)) {
				this.element.find('[data-lui-mark="paging.pageno"]')
						.val($target.attr(PAGING_NUM));
				this.onReLayout();
			}
		},

		onKeydown : function(evt) {
			var $target = $(evt.target);
			var flag = {
				flag : false
			};
			~~function(flag) {
				var mark = $target.attr('data-lui-mark');
				if (mark == 'paging.amount' || mark == 'paging.pageno') {
					flag.flag = true;
				}
			}(flag);

			if (flag.flag & evt.keyCode == 13) {
				this.onReLayout();
			};
		},

		onKeyUp : function(evt) {
			var $target = $(evt.target);
			var mark = $target.attr('data-lui-mark');
			if (mark == 'paging.amount' || mark == 'paging.pageno')
				// 过滤非数字字符
				$target.val($target.val().replace(/\D/gi, ""));
		},

		// TODO 计算显示信息---待移动
		cal : function() {
			this.marginLeft = false, this.marginRight = false;
			this.range = [].concat([1, this.totalPage]);// 显示页码范围
			if (this.totalPage > PAGING_SIZE) {

				if (this.currentPage > (this.viewSize + PAGING_FIRST
						+ PAGING_ELLIPSIS + 1)) {
					this.marginLeft = true;
					this.range[0] = this.currentPage - this.viewSize;
				}
				if (this.totalPage
						- (this.viewSize + PAGING_LAST + PAGING_ELLIPSIS) > this.currentPage) {
					this.marginRight = true;
					this.range[1] = this.currentPage + this.viewSize;
				}
				// 处理最前跟最后两种情况
				if (this.range[1] - this.range[0] < this.viewSize * 2 + 1) {
					if (this.range[1] >= this.totalPage)
						// 最后
						this.range[0] = this.range[1] - this.viewSize * 2;
					else
						// 最前
						this.range[1] = this.range[0] + this.viewSize * 2;
				}
			}
			return true;
		}
	});

	exports.Paging = Paging;
})