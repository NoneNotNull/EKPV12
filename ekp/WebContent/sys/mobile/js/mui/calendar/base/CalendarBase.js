define([ "dojo/_base/declare", "dojo/topic", "dijit/_TemplatedMixin",
		"dojo/date", "dojo/_base/window","dojo/dom-attr","dojo/dom-construct" ], function(declare, topic,
		_TemplatedMixin, dateClaz, win, domAttr, domConstruct) {
	var claz = declare("mui.calendar.CalendarBase", [ _TemplatedMixin ], {

		/**
		 * 发布数据改变事件--对外 事件数据包： lastDate :// 上次点击时间 startDate :// 本月第一天
		 * currentDate :// 当前选中时间 endDate :// 本月最后一天
		 */
		DATA_CHANGE : '/mui/calendar/dataChange',

		/**
		 * 发布值改变事件--对外 事件数据包： lastDate :// 上次点击时间 currentDate :// 当前选中时间
		 */
		VALUE_CHANGE : '/mui/calendar/valueChange',

		/**
		 * 接受通知事件 事件数据包： [date1,date2]
		 */
		NOTIFY : '/mui/calendar/notify',
		
		/**
		 * 设置每个星期的第一天是周几，取admin.do里的值,如果为空默认为1
		 */
		firstDayInWeek:isNaN(dojoConfig.calendar.firstDayInWeek)?
						1:dojoConfig.calendar.firstDayInWeek,

		// 月发生改变
		MONTH_CHANGE : 'mui/calendar/_weekChange',
		_setText : function(node, text) {
			node.innerHTML = text;
		},

		buildRendering : function() {
			this.inherited(arguments);
			this.subscribe(this.VALUE_CHANGE, 'synDate');
		},

		// 同步日期
		synDate : function(evt) {
			if (!evt)
				return;
			this.lastDate = evt.lastDate;
			this.currentDate = evt.currentDate;
		},

		// 当前日期
		currentDate : new Date(),

		// 上一点击日期
		lastDate : new Date(),

		_setCurrentDateAttr : function(date, fire) {
			var isSameMonth = false;
			if (dateClaz.difference(date, this.currentDate, "month") == 0)
				isSameMonth = true;
			this.lastDate = new Date(this.currentDate);
			this.currentDate = date;
			// 绑定日期点击事件
			topic.publish(this.VALUE_CHANGE, this, {
				currentDate : this.currentDate,
				lastDate : this.lastDate
			});
			// 不同个月发布事件重新渲染面板
			if (!isSameMonth || fire)
				topic.publish(this.MONTH_CHANGE, this);
		},

		getScreenHeight : function() {
			return win.global.innerHeight
					|| win.doc.documentElement.clientHeight
					|| win.doc.documentElement.offsetHeight;
		}
	});
	return claz;
});