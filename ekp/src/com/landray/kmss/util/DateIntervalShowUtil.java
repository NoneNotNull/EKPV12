package com.landray.kmss.util;

import java.util.Date;
import java.util.Locale;

public class DateIntervalShowUtil {
	
	
	private final static long second = 1 * 1000; // 秒
	private final static long minute = 60 * second; // 1分钟
	private final static long hour = 60 * minute; // 1小时
	private final static long day = 24 * hour; // 1天
	public final static long tenDay = 10 * day; // 月

	private final static String INTERVAL_DAY = "date.interval.day";
	private final static String INTERVAL_HOUR = "date.interval.hour";
	private final static String INTERVAL_MINUTE = "date.interval.minute";
	private final static String INTERVAL_SECOND = "date.interval.second";
	private final static String INTERVAL_BEFORE = "date.interval.ago";
	private final static String INTERVAL_AFTER = "date.interval.after";


	/**
	 * 返回文字描述的日期
	 */
	public static String convertDateToString(Date date, Locale locale) {

		if (date == null) {
			return null;
		}
		long interval = new Date().getTime() - date.getTime();
		long r = 0;
		String guide = ResourceUtil.getString(interval > 0 ? INTERVAL_BEFORE
				: INTERVAL_AFTER, locale);
		long guide_interval = Math.abs(interval);
		if (guide_interval > tenDay) {
			return DateUtil.convertDateToString(date, DateUtil.TYPE_DATE,
					locale);
		}
		if (guide_interval > day) {
			r = (guide_interval / day);
			return r + ResourceUtil.getString(INTERVAL_DAY, locale) + guide;
		}
		if (guide_interval > hour) {
			r = (guide_interval / hour);
			return r + ResourceUtil.getString(INTERVAL_HOUR, locale) + guide;
		}
		if (guide_interval > minute) {
			r = (guide_interval / minute);
			return r + ResourceUtil.getString(INTERVAL_MINUTE, locale) + guide;
		}
		r = (guide_interval / second);
		return r + ResourceUtil.getString(INTERVAL_SECOND, locale) + guide;
	}
}
