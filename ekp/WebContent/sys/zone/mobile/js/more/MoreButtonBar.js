define( [ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-class",
		"dojo/dom-construct", "dojo/dom-style", "dojo/topic", "dojo/query",
		"mui/panel/SlidePanel", "dojo/_base/lang", "dojo/_base/array"],
		function(declare, WidgetBase, domClass, domConstruct, domStyle, topic,
				query, SlidePanel, lang, array) {

			return declare("sys.zone.mobile.js.more.MoreButtonBar", [ WidgetBase ], {


				baseClass : "mui mui-more",
				
				refNavBar : null,
				
				items : [],
				
				buildRendering : function() {
					this.inherited(arguments);
					domConstruct.create("div", {
						className : 'mui_more_zone_button'
						}, this.domNode);
				},
				postCreate : function() {
					this.inherited(arguments);
					this.connect(this.domNode, "onclick", "_onClick");
					//组装选择项
					this
						.subscribe('/mui/nav/onComplete',
									'handleNavOnComplete');
					//点击选择项事件
					this.subscribe('/mui/panel/slide/click', "_onClickItem");
					
					this.subscribe('/mui/navitem/_selected',
										'handleNavOnSelected');
				},
				startup : function() {
					this.inherited(arguments);
					if (this.domNode.parentNode) {
						var h = this.domNode.parentNode.style.height;
						var styleVar =  {
								'height':h,
								'line-height' : h
							};
						domStyle.set(this.domNode,styleVar);
					}
				},

				_onClick : function(ctx) {
					var titles = this.items;
					var slide = new SlidePanel({
						store : titles,
						dir : "right",
						width : "130"
					});
					domConstruct.place(slide.domNode, document.body, 'last');
					slide.startup();
				},
				
				
				handleNavOnComplete : function(widget, items) {
					this.refNavBar = widget;
					array.forEach(items, function(item, index) {
						var addItem =  {
							text : item.text,
							id : item.id,
							selected : false,
							index :index
						};
						this.items.push(addItem);
					},this);
				},
				
				_onClickItem : function(obj, evt) {
					var nav = this.refNavBar;
					if(evt.index && nav) {
						var clickNavItem = nav.getChildren()[evt.index];
						clickNavItem.beingSelected(clickNavItem.textNode);
					}	                       
				},
				
				handleNavOnSelected : function(obj, evt) {
					if(obj.id) {
						array.forEach(this.items, function(item, index) {
							if(item.id == obj.id) {
								item.selected = true;
							} else {
								item.selected = false;
							}
						},this);
					}
				}
				
			});
		});
