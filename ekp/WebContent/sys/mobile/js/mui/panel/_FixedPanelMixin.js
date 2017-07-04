define("mui/panel/_FixedPanelMixin", [ "dojo/dom-construct",
		'dojo/_base/declare', "dojo/dom-style", "dojo/topic",
		"dojo/_base/lang", "dojo/touch" ], function(domConstruct, declare,
		domStyle, topic, lang, touch) {
	return declare('mui.panel._FixedPanelMixin', null, {

		fixed : true,

		runSlide : '/mui/list/_runSlideAnimation',

		// 发布fixed变更事件，对外交互使用
		change : 'mui/panel/fixedChange',

		buildRendering : function() {
			this.inherited(arguments);
			if (this.fixed)
				this.subscribeScroll();
		},

		nav : null,

		topList : [],

		buildTopList : function() {
			this.set('topList', []);
			var children = this.titleList;
			for (var i = 0; i < children.length; i++) {
				var domNode = children[i];
				var top = {
					dom : domNode
				}
				if (this.currentDom && this.currentDom == domNode) {
					top.top = this.nav.offsetTop;
				} else
					top.top = domNode.offsetTop;
				this.topList.push(top);
			}
		},

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

		currentDom : null,

		resetNav : function() {

			if (this.nav) {
				domConstruct.place(this.currentDom, this.nav, "after");
				domStyle.set(this.currentDom, {
					position : 'relative',
				});
				this.nav.parentNode.removeChild(this.nav);
				this.nav = null;
			}
			this.currentDom = null;
		},

		// 主动滚动
		fixedScroll : function(srcObj, evt) {
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
		},

		subscribeScroll : function() {
			this.subscribe(this.runSlide, lang.hitch(this.fixedScroll));

		}

	});
});