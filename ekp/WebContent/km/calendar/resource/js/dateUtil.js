define(function(require, exports, module) {
	
	var dateUtil={};
	
	var HOUR_MS = 3600000;
	
	var parseISO8601=function(s) {
		var m = s.match(/^([0-9]{4})(-([0-9]{2})(-([0-9]{2})([T ]([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?(Z|(([-+])([0-9]{2})(:?([0-9]{2}))?))?)?)?)?$/);
		if (!m) {
			return null;
		}
		var date = new Date(m[1], 0, 1);
		if (!m[13]) {
			var check = new Date(m[1], 0, 1, 9, 0);
			if (m[3]) {
				date.setMonth(m[3] - 1);
				check.setMonth(m[3] - 1);
			}
			if (m[5]) {
				date.setDate(m[5]);
				check.setDate(m[5]);
			}
			fixDate(date, check);
			if (m[7]) {
				date.setHours(m[7]);
			}
			if (m[8]) {
				date.setMinutes(m[8]);
			}
			if (m[10]) {
				date.setSeconds(m[10]);
			}
			if (m[12]) {
				date.setMilliseconds(Number("0." + m[12]) * 1000);
			}
			fixDate(date, check);
		}else{
			date.setUTCFullYear(
				m[1],
				m[3] ? m[3] - 1 : 0,
				m[5] || 1
			);
			date.setUTCHours(
				m[7] || 0,
				m[8] || 0,
				m[10] || 0,
				m[12] ? Number("0." + m[12]) * 1000 : 0
			);
			if (m[14]) {
				var offset = Number(m[16]) * 60 + (m[18] ? Number(m[18]) : 0);
				offset *= m[15] == '-' ? 1 : -1;
				date = new Date(+date + (offset * 60 * 1000));
			}
		}
		return date;
	};

	var fixDate=function(d, check) {
		if (+d) {
			while (d.getDate() != check.getDate()) {
				d.setTime(+d + (d < check ? 1 : -1) * HOUR_MS);
			}
		}
	};
	
	
	dateUtil.parseDate=function(s) {
		if (typeof s == 'object') {
			return s;
		}
		if (typeof s == 'number') {
			return new Date(s * 1000);
		}
		if (typeof s == 'string') {
			if (s.match(/^\d+(\.\d+)?$/)) {
				return new Date(parseFloat(s) * 1000);
			}
			return parseISO8601(s) || (s ? new Date(s) : null);
		}
		return null;
	};
	
	var  iso8601Week=function(date) {
		var time;
		var checkDate = new Date(date.getTime());
		checkDate.setDate(checkDate.getDate() + 4 - (checkDate.getDay() || 7));
		time = checkDate.getTime();
		checkDate.setMonth(0); 
		checkDate.setDate(1);
		return Math.floor(Math.round((time - checkDate) / 86400000) / 7) + 1;
	};
	
	var  zeroPad=function(n) {
		return (n < 10 ? '0' : '') + n;
	};
	
	var o={
		weekNumberCalculation: 'iso',
		monthNames: ['January','February','March','April','May','June','July','August','September','October','November','December'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
		dayNames: ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
		dayNamesShort: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
	};
	
	var dateFormatters = {
			s	: function(d)	{ return d.getSeconds() },
			ss	: function(d)	{ return zeroPad(d.getSeconds()) },
			m	: function(d)	{ return d.getMinutes() },
			mm	: function(d)	{ return zeroPad(d.getMinutes()) },
			h	: function(d)	{ return d.getHours() % 24 || 24 },
			hh	: function(d)	{ return zeroPad(d.getHours() % 24 || 24) },
			H	: function(d)	{ return d.getHours() },
			HH	: function(d)	{ return zeroPad(d.getHours()) },
			d	: function(d)	{ return d.getDate() },
			dd	: function(d)	{ return zeroPad(d.getDate()) },
			ddd	: function(d)	{ return o.dayNamesShort[d.getDay()] },
			dddd: function(d)	{ return o.dayNames[d.getDay()] },
			M	: function(d)	{ return d.getMonth() + 1 },
			MM	: function(d)	{ return zeroPad(d.getMonth() + 1) },
			MMM	: function(d)	{ return o.monthNamesShort[d.getMonth()] },
			MMMM: function(d)	{ return o.monthNames[d.getMonth()] },
			yy	: function(d)	{ return (d.getFullYear()+'').substring(2) },
			yyyy: function(d)	{ return d.getFullYear() },
			t	: function(d)	{ return d.getHours() < 12 ? 'a' : 'p' },
			tt	: function(d)	{ return d.getHours() < 12 ? 'am' : 'pm' },
			T	: function(d)	{ return d.getHours() < 12 ? 'A' : 'P' },
			TT	: function(d)	{ return d.getHours() < 12 ? 'AM' : 'PM' },
			u	: function(d)	{ return formatDate(d, "yyyy-MM-dd'T'HH:mm:ss'Z'") },
			S	: function(d)	{
				var date = d.getDate();
				if (date > 10 && date < 20) {
					return 'th';
				}
				return ['st', 'nd', 'rd'][date%10-1] || 'th';
			},
			w   : function(d) { // local
				return o.weekNumberCalculation(d);
			},
			W   : function(d) { // ISO
				return iso8601Week(d);
			}
	};
	
	var formatDates=function(date1, date2, format) {
		var date = date1,
			otherDate = date2,
			i, len = format.length, c,
			i2, formatter,
			res = '';
		for (i=0; i<len; i++) {
			c = format.charAt(i);
			if (c == "'") {
				for (i2=i+1; i2<len; i2++) {
					if (format.charAt(i2) == "'") {
						if (date) {
							if (i2 == i+1) {
								res += "'";
							}else{
								res += format.substring(i+1, i2);
							}
							i = i2;
						}
						break;
					}
				}
			}
			else if (c == '(') {
				for (i2=i+1; i2<len; i2++) {
					if (format.charAt(i2) == ')') {
						var subres = formatDate(date, format.substring(i+1, i2));
						if (parseInt(subres.replace(/\D/, ''), 10)) {
							res += subres;
						}
						i = i2;
						break;
					}
				}
			}
			else if (c == '[') {
				for (i2=i+1; i2<len; i2++) {
					if (format.charAt(i2) == ']') {
						var subformat = format.substring(i+1, i2);
						var subres = formatDate(date, subformat);
						if (subres != formatDate(otherDate, subformat)) {
							res += subres;
						}
						i = i2;
						break;
					}
				}
			}
			else if (c == '{') {
				date = date2;
				otherDate = date1;
			}
			else if (c == '}') {
				date = date1;
				otherDate = date2;
			}
			else {
				for (i2=len; i2>i; i2--) {
					if (formatter = dateFormatters[format.substring(i, i2)]) {
						if (date) {
							res += formatter(date);
						}
						i = i2 - 1;
						break;
					}
				}
				if (i2 == i) {
					if (date) {
						res += c;
					}
				}
			}
		}
		return res;
	};
	
	dateUtil.formatDate=function(date, format) {
		return formatDates(date, null, format);
	};

	
	var clearTime=function(d) {
		d.setHours(0);
		d.setMinutes(0);
		d.setSeconds(0); 
		d.setMilliseconds(0);
		return d;
	};
	
	dateUtil.cloneDate=function (d, dontKeepTime) {
		if (dontKeepTime) {
			return clearTime(new Date(+d));
		}
		return new Date(+d);
	};
	
	dateUtil.clearTime=clearTime;
	
	module.exports = dateUtil;
	
	
});