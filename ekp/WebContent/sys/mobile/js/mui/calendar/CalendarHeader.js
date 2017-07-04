define(
		[ "dojo/_base/declare", "dijit/_WidgetBase",
				"mui/calendar/base/CalendarBase",
				"dojo/text!./tmpl/calendar_header.html", "dojo/date",
				"dojo/date/locale", "dojo/topic", "dojo/dom-style",
				"mui/calendar/_HeaderExternalViewMixin", "dojo/dom-class" ],
		function(declare, _WidgetBase, CalendarBase, template, dateClaz,
				locale, topic, domStyle, _HeaderExternalViewMixin, domClass) {
			var claz = declare(
					"mui.calendar.CalendarHeader",
					[ _WidgetBase, CalendarBase, _HeaderExternalViewMixin ],
					{
						leftNode : null,
						// 上个月节点
						monthPreNode : null,
						// 下个月节点
						monthNextNode : null,
						// 当前月节点
						monthNode : null,
						// 今天节点
						todayNode : null,

						rightNode : null,
						// 左边区域按钮
						left : null,
						// 右边区域按钮
						right : null,

						_setLeftAttr : function(left) {
							this.left = left;
						},

						_setRightAttr : function(right) {
							this.right = right;
						},

						templateString : template,

						buildRendering : function() {
							this.inherited(arguments);
							this.bindEvent();
							this
									.subscribe(this.VALUE_CHANGE,
											'monthNodeChange');
							this
									.subscribe(this.VALUE_CHANGE,
											'todayNodeChange');
						},

						startup : function() {
							this.inherited(arguments);
							if (this.right) {
								domClass.add(this.rightNode, this.right.icon
										|| 'mui-listView');
							} else {
								domStyle.set(this.rightNode, 'display', 'none');
							}
							if (this.left) {
								domClass.add(this.leftNode, this.left.icon
										|| 'mui-group');
							} else {
								domStyle.set(this.leftNode, 'display', 'none');
							}

							topic.publish('/mui/calendar/headerComplete', this,
									{
										height : this.domNode.offsetHeight
									});
						},

						resize : function() {
							topic.publish('/mui/calendar/headerComplete', this,
									{
										height : this.domNode.offsetHeight
									});
						},

						todayNodeChange : function() {
							if (!dateClaz.compare(new Date, this.currentDate,
									"date"))
								domStyle.set(this.todayNode, {
									'display' : 'none'
								});
							else
								domStyle.set(this.todayNode, {
									'display' : 'inline-block'
								});

						},

						monthNodeChange : function(fire) {
							this.stuffMonth(this.currentDate, fire);
						},

						bindEvent : function() {
							this
									.connect(this.monthPreNode, 'click',
											'preMonth');
							this.connect(this.monthNextNode, 'click',
									'nextMonth');
							this.connect(this.todayNode, 'click', 'toToday');
						},

						toToday : function() {
							this.set('currentDate', new Date(), true);
						},

						preMonth : function() {
							this.set('currentDate', dateClaz.add(
									this.currentDate, 'month', -1));
						},

						nextMonth : function() {
							this.set('currentDate', dateClaz.add(
									this.currentDate, 'month', 1));
						},

						// 填充头部年月份信息
						stuffMonth : function(_date, fire) {
							if (dateClaz.compare(_date, this.lastDate, "month") != 0
									|| fire) {
								this
										._setText(
												this.monthNode,
												locale
														.format(
																_date,
																{
																	selector : 'time',
																	timePattern : locale
																			._getGregorianBundle()['dateFormatItem-yMM']
																}));
							}
						}
					});
			return claz;
		});