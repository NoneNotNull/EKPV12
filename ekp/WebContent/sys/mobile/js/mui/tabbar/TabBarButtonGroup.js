define(	["dojo/_base/declare", "mui/tabbar/TabBarButton", "dojo/dom-class",
				"dojo/dom-style", "dojox/mobile/Tooltip", "dojo/dom-construct",
				"dijit/registry", "dojo/_base/lang"], function(declare,
				TabBarButton, domClass, domStyle, Tooltip, domConstruct,
				registry, lang) {

			return declare("mui.tabbar.TabBarButtonGroup", [TabBarButton], {

				align : 'right',

				// 列表滚动事件，用于隐藏弹出层
				adjustDestination : '/mui/list/adjustDestination',

				buildRendering : function() {
					// 构建弹出层
					this.openerContainer = new Tooltip();
					domConstruct.place(this.openerContainer.domNode,
							document.body, "last");
					domClass
							.add(this.openerContainer.domNode, 'muiNavBarGroup');
					var cover = this.openerContainer.containerNode;

					this.tabGroupContainer = domConstruct.create('div', {
								className : 'muiNavBarGroupContainer'
							}, cover);
					var children = this.srcNodeRef.children;
					while (children.length > 0) {
						domConstruct.place(children[0], this.tabGroupContainer,
								"last");
					}

					this.inherited(arguments);
					if (!this.label)
						domClass.add(this.getParent().domNode,
								'muiNavBarButton');

				},
				startup : function() {
					if (this._started)
						return;

					if (this.align != 'center')
						domStyle.set(this.iconDivNode, {
									"float" : this.align
								});
					
					this.subscribe(this.adjustDestination, lang.hitch(this,
									this.hideOpener));
					this.inherited(arguments);
				},

				// 点击打开Opener
				_onClick : function(evt) {
					var opener = this.openerContainer;
					if (opener.resize)
						this.hideOpener(this);
					else
						opener.show(this.iconDivNode?this.iconDivNode:this.domNode, ['above']);
					this.defaultClickAction(evt);
					this.handle = this.connect(document.body, 'touchend', 'unClick');
				},

				hideOpener : function(srcObj) {
					this.openerContainer.hide();
				},

				// 点击页面其他地方隐藏弹出层
				unClick : function(evt) {
					var target = evt.target, isHide = true;
					while (target) {
						if (target == this.domNode) {
							isHide = false;
							break;
						}
						target = target.parentNode;
					}
					if (isHide) 
						this.defer(function() {
							this.hideOpener();
						}, 400);
					this.disconnect(this.handle);
				}
			});
		});