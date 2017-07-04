define(
		[ "dojo/_base/declare", "dijit/_WidgetBase",
				"mui/calendar/base/CalendarScrollable",
				"dojo/text!./tmpl/calendar_bottom.html", "dojo/date",
				"dojo/date/locale", "dojo/string", "dojo/dom-construct",
				"dojo/dom-style", "dojo/dom-geometry", "dojo/query",
				"dijit/registry", "mui/calendar/_BottomEventMixin" ],
		function(declare, _WidgetBase, CalendarScrollable, template, dateClaz,
				locale, string, domConstruct, domStyle, domGeometry, query,
				registry, _BottomEventMixin) {
			var claz = declare(
					"mui.calendar.CalendarBottom",
					[ _WidgetBase, CalendarScrollable, _BottomEventMixin ],
					{
						templateString : template,

						dateNode : null,

						y2mNode : null,

						weekNode : null,

						compNode : null,

						reparent : function() {
							this.tmplNode = domConstruct.create('div');
							var i, idx, len, c;
							var domNode = this.srcNodeRef;
							for (i = 0, idx = 0,
									len = domNode.childNodes.length; i < len; i++) {
								c = domNode.childNodes[idx];
								domConstruct.place(c, this.tmplNode, 'last');
							}
						},

						buildRendering : function() {
							this.reparent();
							this.inherited(arguments);
							domConstruct.place(this.tmplNode, this.domNode,
									'last');
							this.subscribe(this.VALUE_CHANGE, 'nodeChange');
							this.subscribe('/mui/calendar/contentComplete',
									'contentComplete');
							this.subscribe('/mui/calendar/weekComplete',
									'weekComplete');
							this.subscribe('/mui/calendar/headerComplete',
									'headerComplete');
							this.subscribe('/mui/calendar/viewComplete',
									'viewComplete');
						},

						resize : function() {
							var viewNode = query('.mblView', this.domNode)[0];
							domStyle
									.set(
											viewNode,
											'height',
											this.getScreenHeight()
													- (viewNode.offsetTop
															- this.headerHeight - this.contentHeight)
													- this.headerHeight
													- this.weekHeight
													- this.fixedHeaderHeight
													- this.fixedFooterHeight
													+ 'px')
						},

						contentComplete : function(obj, evt) {
							this.contentHeight = evt.height;
						},

						viewComplete : function(obj, evt) {
							this.fixedHeaderHeight = evt.fixedHeaderHeight;
							this.fixedFooterHeight = evt.fixedFooterHeight;
						},
						weekComplete : function(obj, evt) {
							this.weekHeight = evt.height;
						},

						headerComplete : function(obj, evt) {
							this.headerHeight = evt.height;
						},

						nodeChange : function(evt) {
							if (!evt)
								return;
							var date = evt.currentDate,
								dayHTML= date.getDate() > 9? date.getDate() : '0'+date.getDate(),
								monthHTML=	date.getMonth() + 1 >9 ? date.getMonth() + 1: '0'+ (date.getMonth() + 1);
							this.dateNode.innerHTML =dayHTML;
							this.y2mNode.innerHTML = date.getFullYear() + '.' + monthHTML;
							this.dayNames = locale.getNames('days', 'wide',
									'standAlone');
							this.weekNode.innerHTML = this.dayNames[date
									.getUTCDay()];
							var comp = dateClaz.difference(date, null, "day"), absComp = Math
									.abs(comp);
							if (comp > 0)
								absComp += '天前';
							else if (comp == 0)
								absComp = '今天';
							else
								absComp += '天后';
							this.compNode.innerHTML = absComp;
						}
					});
			return claz;
		});