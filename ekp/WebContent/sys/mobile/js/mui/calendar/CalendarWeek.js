define(
		[ "dojo/_base/declare", "dijit/_WidgetBase",
				"mui/calendar/base/CalendarScrollable",
				"dojo/text!./tmpl/calendar_week.html", "dojo/date",
				"dojo/date/locale", "dojo/string", "dojo/topic",
				"dojo/dom-construct", "dojo/dom-style", "dojo/_base/array",
				"dojo/_base/lang", "dojo/dom-class", "dojo/query",
				"dojo/dom-attr" ],
		function(declare, _WidgetBase, CalendarScrollable, template, dateClaz,
				locale, string, topic, domConstruct, domStyle, array, lang,
				domClass, query, domAttr) {
			var claz = declare(
					"mui.calendar.CalendarWeek",
					[ _WidgetBase, CalendarScrollable ],
					{

						// 容器节点
						tableNode : null,
						// 日期信息节点
						dateNode : null,
						datesNode : [],
						weekNode : null,

						templateString : template,

						thTemplate : '<th><span >${d}</span></th>',

						trTemplate : '<tr>${d}${d}${d}${d}${d}${d}${d}</tr>',

						tdTemplate : '<td><span data-dojo-attach-point="datesNode"></span></td>',

						buildRendering : function() {
							this.dayNames = locale.getNames('days', 'narrow',
									'standAlone');

							var i = 7, d = this.thTemplate;
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
																// return
																// this.dayNames[i++
																// % 7];
															}));

							// 构建内容
							var r = string.substitute(this.trTemplate, {
								d : this.tdTemplate
							});
							this.dateHtml = r;

							this.inherited(arguments);

							this.subscribe(this.VALUE_CHANGE, 'valueChange');
							this.subscribe(this.NOTIFY, 'processEvent');
							this.subscribe('/mui/calendar/bottomStatus',
									'processEventOfWeek');
							this.subscribe('/mui/calendar/bottomScroll',
									'translate');

							this.stuffDate();
							this.bindEvent();
						},

						translate : function(obj, evt) {
							if (!evt)
								return;
							var top = evt.top;
							this.scrollTo({
								y : '-' + top
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

						processEventOfWeek : function(obj, evt) {
							// status=false:周模式
							if (!evt || !evt.status)
								this.processEvent(null);
						},

						valueChange : function() {
							this.stuffDate();
							this.processEvent(null);
						},

						stuffDate : function() {
							var date = this.currentDate.getDate(),today = new Date();
							// var day = this.currentDate.getDay();
							var day = (this.currentDate.getDay()
									- this.firstDayInWeek + 7) % 7;

							array
									.forEach(
											this.datesNode,
											function(node, idx) {
												var className = 'muiCalendarDate muiCalendarDateCurr';
												var d = new Date(
														this.currentDate);
												d.setDate(date - day + idx);
												//选中日
												if (day == idx)
													className += ' selected';
												//今天
												if (!dateClaz.compare(d,
														today, "date")) {
													className = "muiCalendarCurrentDate "
															+ className;
												}
												
												var diff=dateClaz.difference(this.currentDate,d,'month');
												//上个月 
												if(diff<0){
													className += ' muiCalendarDatePre';
												}
												//下个月
												if(diff>0){
													className += ' muiCalendarDateNext';
												}
												//周六、日字体显示为蓝色
												if(d.getDay()==0 || d.getDay()==6){
													className+=" muiCalendarHoliday";
												}
												
												this
														._setText(node, d
																.getDate());
												node.className = className;
												domAttr
														.set(
																node,
																'date',
																locale
																		.format(
																				d,
																				{
																					selector : 'time',
																					timePattern : 'yyyy-MM-dd'
																				}));
											}, this);
						},

						bindEvent : function() {
							for (var i = 0; i < this.datesNode.length; i++) {
								this.connect(this.datesNode[i], 'click',
										'onDateClick');
							}
//							this
//									.connect(this.tableNode, 'click',
//											'onDateClick');
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

						triggleSelected : function(node) {
							var dates = this.datesNode;
							array.forEach(array.filter(dates, function(item) {
								return domClass.contains(item, 'selected');
							}), function(item, index) {
								domClass.toggle(item, 'selected', false);
							}, this);
							array.map(dates, function(item) {
								if (item == node) {
									var date = new Date(this.currentDate);
									if (domClass.contains(node, 'muiCalendarDatePre')){
										// 上个月
										date = dateClaz.add(date, 'month',-1);
									}else if (domClass.contains(node,'muiCalendarDateNext')){
										// 下个月
										date = dateClaz.add(date, 'month',1);
									}
									date.setDate(node.innerHTML);
									this.set('currentDate', date, false);
									domClass.toggle(item, 'selected', true);
								}
							}, this);
						},

						resize : function() {
							topic.publish('/mui/calendar/weekComplete', this, {
								height : this.domNode.offsetHeight
							});
						}

					});
			return claz;
		});