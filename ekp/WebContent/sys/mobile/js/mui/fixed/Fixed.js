define("mui/fixed/Fixed", [ "dojo/dom-construct", 'dojo/_base/declare',
		"dojo/dom-class", "dojo/dom-style", "dojo/topic", "dojo/_base/lang",
		"dijit/_WidgetBase", "dijit/_Contained", "dijit/_Container",
		"mui/fixed/FixedItem" ], function(domConstruct, declare, domClass,
		domStyle, topic, lang, WidgetBase, Contained, Container, FixedItem) {
	return declare('mui.fixed.Fixed', [ WidgetBase, Contained, Container ], {

		runSlide : '/mui/list/_runSlideAnimation',

		buildRendering : function() {
			this.inherited(arguments);
			this.subscribeScroll();
		},

		nav : null,

		topList : [],

		// 构建fixedItem位置列表
		buildTopList : function() {
			this.set('topList', []);
			var children = this.getChildren();
			for (var i = 0; i < children.length; i++) {
				if (children[i] instanceof FixedItem) {
					var domNode = children[i].domNode;
					var top = {
						dom : domNode
					}
					if (this.currentDom && this.currentDom == domNode) {
						top.top = this.nav.offsetTop;
					} else
						top.top = domNode.offsetTop;
					this.topList.push(top);
				}
			}
		},

		// 比对当前位置处于fixedItem的区域，参考维基库
		compara : function(y) {
			if (y < this.topList[0].top)
				return null;

			var max = this.topList.length - 1, min = 0;
			while (min <= max) {
				var middle = parseInt((max + min) / 2);

				if (y == this.topList[middle].top)
					return this.topList[middle].dom;

				else if (y > this.topList[middle].top)
					min = middle + 1;
				if (y < this.topList[middle].top)
					max = middle - 1;
			}
			return this.topList[min - 1].dom;
		},

		// 监听滚动事件
		subscribeScroll : function() {
			this.subscribe(this.runSlide, lang.hitch(function(srcObj, evt) {
				
				if(this.getParent()!=srcObj)
					return;
				
				this.buildTopList();
				if (this.lock)
					return;
				this.lock = true;

				var y = evt.to.y;

				// 由于滑动惯性到达顶部销毁fixed对象
				if (y >= 0) {
					this.resetNav();
					this.lock = false;
					return;
				}

				y = Math.abs(y);

				var dom = this.compara(y);

				// 不在fixed区域中销毁fixed对象
				if (!dom) {
					this.resetNav();
					this.lock = false;
					return;
				}

				// 在fixed 区域中且当前fixed对象跟之前不一样时重置fixed状态
				if (dom && this.currentDom != dom) {
					this.resetNav();
					this.currentDom = dom;
					this.nav = lang.clone(dom);
					domConstruct.place(this.nav, dom, "after");
					domStyle.set(dom, {
						position : 'absolute',
						top : 0,
						left : 0,
						right : 0
					});

					domConstruct.place(dom, srcObj.domNode, 'last');

					topic.publish(this.change, this, {
						dom : dom
					});
				}
				this.lock = false;
			}));
		},

		resetNav : function() {

			if (this.nav) {
				domConstruct.place(this.currentDom, this.nav, "after");
				domStyle.set(this.currentDom, {
					position : 'static',
				});
				this.nav.parentNode.removeChild(this.nav);
				this.nav = null;
			}
			this.currentDom = null;
		},

		startup : function() {
			if (this._started)
				return;
			this.inherited(arguments);
		}
	});
});