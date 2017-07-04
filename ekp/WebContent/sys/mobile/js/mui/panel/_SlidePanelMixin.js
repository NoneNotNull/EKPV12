define([ 'dojo/_base/declare', "dojo/_base/array", "dijit/_WidgetBase",
		"mui/panel/SlidePanel", "dojo/query", "dojo/dom-class",
		"dojo/dom-construct", "dojo/topic", "dojox/mobile/viewRegistry" ],
		function(declare, array, _WidgetBase, SlidePanel, query, domClass,
				domConstruct, topic, viewRegistry) {
			return declare('mui.panel._SliderPanelMixin', null, {

				slide : true,

				SLIDE_PANEL_CLICK : '/mui/panel/slide/click',

				TOTOP : '/mui/list/toTop',

				startup : function() {
					this.inherited(arguments);
					if (!this.slide)
						return;
					this.slidePanel();
					this.subscribe(this.SLIDE_PANEL_CLICK, 'onSlideChange');
					this.buildTopList();
				},

				onSlideChange : function(obj, evt) {
					var top = this.topList[evt.index];
					topic.publish(this.TOTOP, this, {
						y : -top.top
					});
				},

				// 滑动快捷菜单
				slidePanel : function() {
					var titles = [];
					array.forEach(this.contentList, function(item) {
						titles.push(item.claz.title)
					});
					this.bindSlide();
				},

				bindSlide : function() {
					var view = viewRegistry.getEnclosingView(this.domNode);
					this.connect(view.domNode, 'onclick', 'slideClick');
				},

				slideClick : function(evt) {
					var target = evt.target;
					if (!domClass.contains(target, 'mui')
							|| !domClass.contains(target.parentNode,
									'muiAccordionPanelTitle'))
						return;
					var titles = [];
					array.forEach(this.topList, function(item) {
						var domNode = item.dom;
						var title = {
							text : query('div', domNode).text(),
							selected : false,
							icon : 'mui-meeting_path'
						};
						if (target.parentNode == domNode)
							title.selected = true;
						titles.push(title);
					}, this);
					var slide = new SlidePanel({
						store : titles
					});
					domConstruct.place(slide.domNode, document.body, 'last');
					slide.startup();
				}

			});
		});