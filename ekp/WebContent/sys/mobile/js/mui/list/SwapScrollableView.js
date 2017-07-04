define([
	'dojo/_base/declare', 
	'dojo/_base/lang',
	'dojo/_base/array',
	'dojo/dom-construct',
	'dojo/dom-class',
	'dijit/registry',
	'dijit/_WidgetBase',
	'dijit/_Container',
	"dijit/_Contained",
	'dojox/mobile/SwapView',
	'dojox/mobile/View',
	'dojo/parser',
	'dojo/topic',
	'mui/list/StoreScrollableView',
	], function(declare, lang, array, domCtr, domClass, registry, WidgetBase, Container, _Contained, 
		SwapView, View, parser, topic, ScrollableView) {
	
	var InnerSwap = declare([SwapView], {
			onAfterTransitionIn: function() {
				this.inherited(arguments);
				// 提示：滑动切换并不会触发此方法
				topic.publish('/dojox/mobile/viewChanged', this);
				this.resize();
			}
	});
	
	return declare('mui.list.SwapScrollableView', [WidgetBase, Container, _Contained], {
		
		innerSwapClass: InnerSwap,
		
		stopParser: true,
		
		templateString: null,
		
		refNavBar: null,
		
		currView: null,
		
		postCreate: function() {
			this.inherited(arguments);
			this.subscribe('/dojox/mobile/viewChanged', 'handleViewChanged');
		},
		
		startup: function() {
			if(this._started) {
				return;
			}
			this.inherited(arguments);
			if (!this.templateString) {
				this.templateString = this.domNode.innerHTML;
				this.domNode.innerHTML = '';
			}
		},
		
		handleViewChanged: function(view) {
			if (!(view instanceof SwapView)) {
				return;
			}
			array.forEach(this.getChildren(), function(child) {
				if (child === view) {
					var reloadTime = view.reloadTime || 0;
					var nowTime = new Date().getTime();
					var needLoad = (this.currView != view) && (reloadTime == 0);
					this.currView = view;
					view.containerNode.style.paddingTop = "0";
					this.onSwapViewChanged(view);
					if (needLoad) {
						view.reloadTime = nowTime;
						view.getChildren()[0].reload();
					}
					if (window.localStorage) {
						try {
							localStorage.setItem("swapIndex:" + location.pathname, view.getIndexInParent());
						} catch (e) {
							if(window.console)
								console.log(e.name);
						}
					}
					return false;
				}
			}, this);
		},
		
		onSwapViewChanged: function(view) {
			
		},

		_createScroll: function(item) {
			return new ScrollableView({rel: item});
		},
		
		_createSwap: function() {
			return new this.innerSwapClass();
		},
		
		generateSwapList: function(items) {
			var loadIndex = 0;
			
			array.forEach(items, function(item, i) {
				var swap = this._createSwap();
				this.addChild(swap);
				var scroll = this._createScroll(item);
				swap.addChild(scroll);
				
				item.moveTo = swap.id; // 绑定view跳转
				
				parser.parse(domCtr.create('div', {innerHTML: this.templateString}))
						.then(function(widgetList) {
							array.forEach(widgetList, function(widget, index) {
								scroll.addChild(widget, index + 1);
							});
						});
			}, this);
			
			if (window.localStorage) {
				loadIndex = localStorage.getItem("swapIndex:" + location.pathname);
				if (loadIndex == null) {
					loadIndex = 0;
				} else {
					loadIndex = parseInt(loadIndex);
				}
			}
			
			if (loadIndex == 0) {
				this.handleViewChanged(this.getChildren()[loadIndex]);
			} else {
				var self = this;
				require(['dojox/mobile/TransitionEvent'], function(TransitionEvent) {
					new TransitionEvent(document.body, {moveTo: self.getChildren()[loadIndex].id}).dispatch();
				})
			}

			this.resize();
		},

		resize: function() {
			if(this.domNode.parentNode){
				var node, len, i, _fixedAppFooter;
				for(i = 0, len = this.domNode.parentNode.childNodes.length; i < len; i++){
					node = this.domNode.parentNode.childNodes[i];
					if(node.nodeType === 1){
						var fixed = node.getAttribute("fixed")
							|| node.getAttribute("data-mobile-fixed")
							|| (registry.byNode(node) && registry.byNode(node).fixed);
						if(fixed === "bottom"){
							domClass.add(node, "mblFixedBottomBar");
							_fixedAppFooter = node;
						}
					}
				}
			}

			this.inherited(arguments); // scrollable#resize() will be called
			array.forEach(this.getChildren(), function(child){
				if(child.resize){
					if (!child._fixedAppFooter) {
						child._fixedAppFooter = _fixedAppFooter;
						child.getChildren()[0]._fixedAppFooter = _fixedAppFooter;
					}
					child.resize(); 
				}
			});
		}
	});
});