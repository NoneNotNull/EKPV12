define(
		[ "dojo/_base/declare", "dijit/_WidgetBase",
				"mui/calendar/base/CalendarBase",
				"mui/calendar/_ContentEventMixin",
				"dojo/text!./tmpl/calendar_content.html", "dojo/date",
				"dojo/date/locale", "dojo/string", "dojo/_base/lang",
				"dojo/_base/array", "dojo/topic", "dojo/dom-class",
				"dojo/dom-style", "dojox/mobile/_css3", "dojo/dom-construct",
				"dojo/query", "dojo/dom-attr" ],
		function(declare, _WidgetBase, CalendarBase,_ContentEventMixin,template, dateClaz,
				locale, string, lang, array, topic, domClass, domStyle, css3,
				domConstruct, query, domAttr) {
			var claz = declare(
					"mui.calendar.CalendarContent",
					[ _WidgetBase, CalendarBase ],
					{

						// 容器节点
						tableNode : null,
						// 日期信息节点
						dateNode : null,
						datesNode : [],

						templateString : template,

						thTemplate : '<th><span >${d}</span></th>',
						tdTemplate : '<td><span data-dojo-attach-point="datesNode"></span></td>',
						trTemplate : '<tr class="">${d}${d}${d}${d}${d}${d}${d}</tr>',

						buildRendering : function() {
							this.dayNames = locale.getNames('days', 'narrow',
									'standAlone');
							this._buildTable();
							this.inherited(arguments);
							this.stuffDate();
							this.bindEvent();
							this.subscribe(this.VALUE_CHANGE, 'valueChange');
							this.subscribe(this.MONTH_CHANGE, 'monthChange');
							this.subscribe(this.NOTIFY, 'processEvent');
							this.subscribe('/mui/calendar/bottomStatus',
									'processEventOfMonth');
							this.subscribe('/mui/calendar/bottomScroll',
									'scale');
						},

						scale : function(obj, evt) {
							if (!evt)
								return;
							domStyle
									.set(
											this.domNode,
											css3
													.add(css3
															.add(
																	{},
																	{
																		transform : 'scale('
																				+ (1 - Math
																						.abs(evt.y)
																						/ (this.domNode.offsetHeight * 3))
																				+ ')'
																	})));
						},

						monthChange : function() {
							this.stuffDate();
							topic.publish(this.DATA_CHANGE, this, {
								lastDate : this.lastDate,
								startDate : this.startDate,
								currentDate : this.currentDate,
								endDate : this.endDate
							});
						},

						// 哪天有日程(key,value形式...key=日期,value=true|false是否存在日程)
						haveEvent : null,
						processEvent : function(haveEvent) {
							if (haveEvent) {
								this.haveEvent = haveEvent;
							}
							query('.muiCalendarNotify',this.domNode).remove();// 清空小红点
							for (var i = 0; i < this.datesNode.length; i++) {
								var key = domAttr
										.get(this.datesNode[i], "date");
								if (this.haveEvent && this.haveEvent[key]) {
									domConstruct.create("i", {
										className : "muiCalendarNotify"
									}, this.datesNode[i].parentNode);
								}
							}
						},

						processEventOfMonth : function(obj, evt) {
							// status=true:月模式
							if (evt && evt.status)
								this.processEvent(null);
						},
							
						valueChange : function(){
							var dates = this.datesNode;
							array.forEach(array.filter(dates, function(item) {
								return domClass.contains(item, 'selected');
							}), function(item, index) {
								domClass.toggle(item, 'selected', false);
							}, this);
							
							array.map(dates, function(item) {
								var _c=locale.format(this.currentDate,{
									selector : 'time',
									timePattern : 'yyyy-MM-dd'
								})
								if(_c == domAttr.get(item,'date') ){
									domClass.toggle(item, 'selected', true);
								}
							}, this);
						},
						
						bindEvent : function() {

							for (var i = 0; i < this.datesNode.length; i++) {
								this.connect(this.datesNode[i], 'click',
										'onDateClick');
							}
							// this.connect(this.dateNode, 'click',
							// 'onDateClick');
						},

						onDateClick : function(evt) {
							var target = evt.target;
							while (target) {
								if (domClass
										.contains(target, 'muiCalendarDate')) {
									this.triggleSelected(target)
									break;
								}
								target = target.parentNode;
							}
						},

						lastSelected : function(node) {
							var date = dateClaz.add(this.currentDate, 'month',
									-1);
							date.setDate(node.innerHTML);
							this.set('currentDate', date);
						},

						nextSelected : function(node) {
							var date = dateClaz.add(this.currentDate, 'month',
									1);
							date.setDate(node.innerHTML);
							this.set('currentDate', date);
						},

						currSelected : function(node) {
							var dates = this.datesNode;
							array.forEach(array.filter(dates, function(item) {
								return domClass.contains(item, 'selected');
							}), function(item, index) {
								domClass.toggle(item, 'selected', false);
							}, this);

							array.map(dates, function(item) {
								if (item == node) {
									var date = new Date(this.currentDate);
									date.setDate(node.innerHTML);
									this.set('currentDate', date);
									domClass.toggle(item, 'selected', true);
								}
							}, this);
						},

						triggleSelected : function(node) {
							if (domClass.contains(node, 'muiCalendarDatePre'))
								// 上个月
								this.lastSelected(node);
							else if (domClass.contains(node,
									'muiCalendarDateNext'))
								// 下个月
								this.nextSelected(node);
							else
								// 当前月
								this.currSelected(node);
						},

						// 填充日期
						stuffDate : function() {
							var month = new Date(this.currentDate), today = new Date();
							month.setDate(1);
							// 本月第一天星期几
							var firstDay = (month.getDay()
									- this.firstDayInWeek + 7) % 7;

							var daysInPreviousMonth = dateClaz
									.getDaysInMonth(dateClaz.add(month,
											"month", -1));
							// 本月多少天
							var daysInMonth = dateClaz.getDaysInMonth(month);
							array
									.forEach(
											this.datesNode,
											function(node, idx) {

												var number, className = 'muiCalendarDate muiCalendarDate', sym;
												var date = new Date(month);
												if (idx < firstDay) {// 前
													number = daysInPreviousMonth
															- firstDay
															+ idx
															+ 1;
													className += sym = 'Pre';
												} else if (idx >= (firstDay + daysInMonth)) {// 下
													number = idx - firstDay
															- daysInMonth + 1;
													className += sym = 'Next';
												} else {// 当前
													number = idx - firstDay + 1;
													className += sym = 'Curr';
												}
												

												if (sym == 'Pre')
													date = dateClaz.add(date,
															"month", -1);
												if (sym == 'Next')
													date = dateClaz.add(date,
															"month", 1);
												date.setDate(number);
												
												if (idx == 0) {
													this.startDate = date;
												}
												if (idx == this.datesNode.length - 1) {
													this.endDate = date;
												}

												if (!dateClaz.compare(date,
														today, "date")) {
													className = "muiCalendarCurrentDate "
															+ className;
												}

												if (!dateClaz.compare(date,
														this.currentDate,
														"date")) {
													className = " selected "
															+ className;
												}
												
												//周六、日字体显示为蓝色
												if(date.getDay()==0 || date.getDay()==6){
													className+=" muiCalendarHoliday";
												}
												
												this._setText(node, number);
												node.className = className;
												domAttr
														.set(
																node,
																'date',
																locale.format(date,{
																		selector : 'time',
																		timePattern : 'yyyy-MM-dd'
																	}));
											}, this);
						},

						// 构建表格
						_buildTable : function() {
							var d = this.thTemplate, i = 7;
							// 构建日历星期表头
							this.weekHtml = string
									.substitute(
											[ d, d, d, d, d, d, d ].join(''),
											{
												d : ""
											},
											lang
													.hitch(
															this,
															function() {
																var r = this.dayNames[(i + this.firstDayInWeek) % 7]
																i++;
																return r;
															}));

							// 构建内容
							var r = string.substitute(this.trTemplate, {
								d : this.tdTemplate
							});
							this.dateHtml = [ r, r, r, r, r, r ].join("");
						},

						resize : function() {
							topic.publish('/mui/calendar/contentComplete',
									this, {
										height : this.domNode.offsetHeight
									})
						},
						
						startup:function(){
							topic.publish(this.DATA_CHANGE, this, {
								lastDate : this.lastDate,
								startDate : this.startDate,
								currentDate : this.currentDate,
								endDate : this.endDate
							});
						}
						
					});
			return claz;
		});