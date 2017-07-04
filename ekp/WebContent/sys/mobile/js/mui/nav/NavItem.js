define(
		'mui/nav/NavItem',
		[ "dojo/_base/declare", "dojox/mobile/_ItemBase", "dojox/mobile/Badge",
				"dojo/dom-construct", "dojo/dom-style", "dojo/dom-class",
				"dojo/request", "dojo/topic", "mui/util" ],
		function(declare, ItemBase, Badge, domConstruct, domStyle, domClass,
				request, topic) {
			var NavItem = declare(
					'mui.nav.NavItem',
					ItemBase,
					{

						// 选中class
						_selClass : 'muiNavitemSelected',
						// 选中事件
						topicType : '/mui/navitem/_selected',

						tag : 'li',

						badge : 0,

						buildRendering : function() {
							this.domNode = this.containerNode = this.srcNodeRef
									|| domConstruct.create('li', {
										className : 'muiNavitem'
									});

							this.inherited(arguments);

							if (this.text) {
								this.textNode = domConstruct.create('span', {
									className : 'textEllipsis muiNavitemSpan'
								}, this.domNode);
								this.textNode.innerHTML = this.text;
								if (this.badge == 0 && this.countUrl != ''
										&& this.countUrl != null) {
									var _self = this;
									request.post(this.countUrl, {
										handleAs : 'json'
									}).then(function(data) {
										if (data.count > 0) {
											_self.set('badge', data.count);
										}
									}, function(data) {

									});
								}
							}

							this
									.subscribe(this.topicType,
											'handleItemSelected');
						},

						handleItemSelected : function(srcObj) {
							if(this.getParent() == srcObj.getParent() ){
								domClass.remove(this.domNode, this._selClass);
							}
						},

						startup : function() {
							if (this._started)
								return;
							this.connect(this.textNode, "onclick", '_onClick');
							this.inherited(arguments);
						},

						// 选中
						setSelected : function() {
							this.beingSelected(this.textNode);
						},

						beingSelected : function(target) {
							while (target) {
								if (domClass.contains(target, 'muiNavitem'))
									break;
								target = target.parentNode;
							}
							var left, width;
							if (!target.offsetParent)
								left = 0, width = 0;
							var style = domStyle.getComputedStyle(target), marginLeft = domStyle
									.toPixelValue(target, style.marginLeft), marginRight = domStyle
									.toPixelValue(target, style.marginRight);

							topic.publish(this.topicType, this, {
								width : width == 0 ? 0 : target.offsetWidth
										+ marginRight + marginLeft,
								left : left == 0 ? left : target.offsetLeft
										+ target.offsetParent.offsetLeft
										- marginLeft,
								target : this,
								url : this.url,
								text : this.text
							});
							domClass.add(this.domNode, this._selClass);
						},

						_onClick : function(e) {
							var target = e.target;
							this.beingSelected(target);
							// 默认click事件
							this.defaultClickAction(e);
						},

						userClickAction : function() {
							if (this.moveTo) {
								return true;
							}
							return false; // 修复出现view跳转问题
						},

						_setBadgeAttr : function(value) {
							if (!this.badgeObj) {
								this.badgeObj = new Badge();
								domStyle.set(this.badgeObj.domNode, {
									position : 'absolute',
									left : '80%',
									top : '2px'
								});
							}
							this.badgeObj.setValue(value);
							if (value) {
								this.domNode.appendChild(this.badgeObj.domNode);
							} else {
								if (this.domNode === this.badgeObj.domNode.parentNode) {
									this.domNode
											.removeChild(this.badgeObj.domNode);
								}
							}
						}

					});

			return NavItem;
		});