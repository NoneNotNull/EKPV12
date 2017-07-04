define([ "dojo/_base/declare", "dojox/mobile/ScrollableView", "dojo/topic" ],
		function(declare, ScrollableView, topic) {
			var claz = declare("mui.calendar.CalendarListScrollableView",
					[ ScrollableView ], {
						scrollBar : false,
						weight : 0,
						type : '/mui/calendar/listScrollableTop',

						buildRendering : function() {
							this.inherited(arguments);
							this.subscribe('/mui/calendar/bottomStatus',
									'statusChange');
						},

						disableTouchScroll : true,

						adjustDestination : function(to) {
							if (to.y >= 0)
								this.defer(function() {
									topic.publish(this.type, this, to);
								}, 1000);
							else
								topic.publish(this.type, this, to);
							return true;
						},
						statusChange : function(obj, evt) {
							this.disableTouchScroll = evt.status;
						}
					});
			return claz;
		});