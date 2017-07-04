define(function(require, exports, module) {
	var toolbar = require('lui/toolbar');
	var topic = require('lui/topic');
	var $ = require('lui/jquery');
	var element = require("lui/element");

	var SORTCHANGED = 'sort.changed';

	var CLASS_DOWN = 'lui_icon_s_on_filter', CLASS_UP = 'lui_icon_s_up_filter', CLASS_DE = 'lui_icon_s_default_filter';

	var Sort = toolbar.AbstractButton.extend({

		initProps : function($super, _config) {
			$super(_config);
			this.text = _config.text;
			this.property = _config.property;
			this.group = _config.group;
			this.poolIndex = 0;
			this.textContent = null;
			this.iconContent = null;
			this.channel = _config.channel;
			this.value = _config.value || 'default';
		},

		startup : function() {
			if (this.text != null && this.textContent == null) {
				var textVar = new element.Text({
							'text' : $.trim(this.config.text)
						});
				if (textVar.startup)
					textVar.startup();
				this.onErase(function() {
							textVar.destroy();
						});
				this.textContent = textVar.element;
			}
			this.iconContent = $('<div/>').addClass('lui_widget_btn_icon')
					.append(this.iconInside = $('<div/>')
							.addClass("lui_icon_s"));
			if (this.textContent != null)
				this.textContent.addClass("lui_widget_btn_txt");

			var self = this;

			topic.subscribe('sort.change', function(data) {
						self._subscribeEvent(data);
					});

			// 触发初始排序事件
			this._initListView(this.value);
		},

		getOrderTypeMap : function() {
			return {
				'default' : 2,
				'up' : 0,
				'down' : 1
			}
		},

		getPool : function() {
			var self = this;
			var pool = [function() {
						self.orderByType('up');
						self.setUpStyle();
					}, function() {
						self.orderByType('down');
						self.setDownStyle();
					}, function() {
						self.orderByType(false);
						self.setDefaultStyle();
					}];
			return pool;
		},

		getStylePool : function() {
			var self = this;
			var stylePool = [function() {
						self.setUpStyle();
					}, function() {
						self.setDownStyle();
					}, function() {
						self.setDefaultStyle();
					}];
			return stylePool;
		},

		isDefaultOrderType : function(value) {
			return 'default' === value
		},

		_initListView : function(value) {
			this.poolIndex = this.getOrderTypeMap()[value];
			var evt = {
				sort : this.id,
				sorts : []
			};
			evt['sorts'].push({
						key : 'orderby',
						value : [this.property]
					})
			var sort = {
				key : 'ordertype'
			}
			sort['value'] = [value];
			evt['sorts'].push(sort);
			if (this.isDefaultOrderType(value)) {
				return;
			}
			topic.channel(this).publish(SORTCHANGED, evt);
		},

		setLayout : function(domObj) {
			this.isDrawed = false;
			this.layoutDom = domObj;
		},

		addChild : function($super, obj) {
			if (obj instanceof element.Text) {
				this.textContent = obj.element;
			}
			$super(obj);
		},

		draw : function() {
			if (!this.isDrawed) {
				var contentElement = this.element;
				if (this.layoutDom != null) {
					contentElement = this.layoutDom
							.find('div[data-lui-mark="toolbar_button_content"]');
				}

				if (this.textContent != null)
					contentElement.append(this.textContent);
				contentElement.append(this.iconContent);
				var tmpContent = this.element
						.find('div[data-lui-mark="toolbar_button_inner"]');
				if (tmpContent.length > 0) {
					tmpContent.remove();
				}
				this.element.append(this.layoutDom.children());
				if (this.layoutDom != null) {
					this.layoutDom.append(this.element);
				}
				this.initStyle();
				this.bindEvent(this.element).addClass(this.element)
						.fireEvent(this.element);
				if (this.text != null)
					this.element.attr('title', this.text);
			}
			this.isDrawed = true;
			this.element.show();
		},

		initStyle : function() {

			var pool = this.getStylePool();
			pool[this.poolIndex]();
			if (this.isDefaultOrderType()) {
				return;
			}
			this.poolIndex = this.poolIndex + 1 >= pool.length
					? 0
					: this.poolIndex + 1;
		},

		addClass : function(elem) {
			elem.addClass('lui_widget_btn');
			return this;
		},

		bindEvent : function(elem) {
			var self = this;

			elem.click(function(evt) {
						self.onClick(evt);
					});
			return this;
		},

		orderByType : function(type) {
			var evt = {
				sort : this.id,
				sorts : []
			};

			if (type) {
				evt['sorts'].push({
							key : 'orderby',
							value : [this.property]
						})
				var sort = {
					key : 'ordertype'
				}
				sort['value'] = [type];
				evt['sorts'].push(sort);
			}
			topic.channel(this).publish(SORTCHANGED, evt);
		},

		setDefaultStyle : function() {
			this.iconInside.removeClass(CLASS_DOWN);
			this.iconInside.removeClass(CLASS_UP);
			this.iconInside.addClass(CLASS_DE);
		},

		setDownStyle : function() {
			this.iconInside.removeClass(CLASS_DE);
			this.iconInside.removeClass(CLASS_UP);
			this.iconInside.addClass(CLASS_DOWN);
		},

		setUpStyle : function() {
			this.iconInside.removeClass(CLASS_DE);
			this.iconInside.removeClass(CLASS_DOWN);
			this.iconInside.addClass(CLASS_UP);
		},

		onChange : function(type) {
			if (type) {
				this.poolIndex = this.getOrderTypeMap()[type];
			}
			this.pool = this.getPool();
			this.pool[this.poolIndex]();
			this.poolIndex = this.poolIndex + 1 >= this.pool.length
					? 0
					: this.poolIndex + 1;
			topic.publish('sort.change', {
						"group" : this.group,
						"cid" : this.cid
					});
		},

		onClick : function(evt) {
			this.onChange(false);
		},

		_subscribeEvent : function(data) {
			var arguGroup = null;
			var arguId = null;
			if (data != null) {
				arguGroup = data.group;
				arguId = data.cid;
				if (arguGroup != null) {
					if (this.group == arguGroup) {
						if (this.cid == arguId && data.cid != null) {
						} else {
							this.setDefaultStyle();
							this.poolIndex = 0;
						}
					}
				}
			}
		},

		fireEvent : function(elem) {
			return this;
		}

	});

	exports.Sort = Sort;

})