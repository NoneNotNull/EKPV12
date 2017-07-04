package com.landray.kmss.common.model;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.text.MessageFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 区间
 * 
 * @author 孙真
 */
public class PeriodTypeModel implements Serializable {

	public static int PERIOD_TYPE_MONTH = 1;

	public static int PERIOD_TYPE_DOUBLE_MONTH = 2;

	public static int PERIOD_TYPE_QUARTER = 3;

	public static int PERIOD_TYPE_HALF_YEAR = 4;

	public static int PERIOD_TYPE_YEAR = 5;

	public static int PERIOD_TYPE_DAY = 6;

	public static int PERIOD_TYPE_WEEK = 7;

	public static String PERIOD_MONTH_NAME_KEY = "resource.period.month.name";

	public static String PERIOD_DOUBLE_MONTHNAME_KEY = "resource.period.double.month.name";

	public static String PERIOD_QUARTER_NAME_KEY = "resource.period.quarter.name";

	public static String PERIOD_HALF_YEAR_FIRST_NAME_KEY = "resource.period.half.year.first.name";

	public static String PERIOD_HALF_YEAR_NEXT_NAME_KEY = "resource.period.half.year.next.name";

	public static String PERIOD_YEAR_NAME_KEY = "resource.period.year.name";

	public static String PERIOD_DAY_NAME_KEY = "resource.period.day.name";

	public static String PERIOD_WEEK_NAME_KEY = "resource.period.week.name";

	public static String PERIOD_TYPE_MONTH_NAME_KEY = "resource.period.type.month.name";

	public static String PERIOD_TYPE_DOUBLE_MONTHNAME_KEY = "resource.period.type.double.month.name";

	public static String PERIOD_TYPE_QUARTER_NAME_KEY = "resource.period.type.quarter.name";

	public static String PERIOD_TYPE_HALF_YEAR_NAME_KEY = "resource.period.type.half.year.name";

	public static String PERIOD_TYPE_YEAR_NAME_KEY = "resource.period.type.year.name";

	public static String PERIOD_TYPE_DAY_NAME_KEY = "resource.period.type.day.name";

	public static String PERIOD_TYPE_WEEK_NAME_KEY = "resource.period.type.week.name";

	/**
	 * 根据指定类型和时间，生成时间所属的区间模型
	 * 
	 * @param periodType
	 *            类型，有：PERIOD_TYPE_MONTH、PERIOD_TYPE_DOUBLE_MONTH、
	 *            PERIOD_TYPE_QUARTER、PERIOD_TYPE_HALF_YEAR、PERIOD_TYPE_YEAR
	 * @param date
	 *            指定时间
	 * @param locale
	 *            本地信息，为空时返回的区间模型中描述等信息为空
	 * @return
	 * @throws ParseException
	 */
	public static PeriodModel getPeriodModel(int periodType, Date date,
			Locale locale) throws ParseException {
		PeriodTypeModel type = PeriodTypeModel.createInstance(periodType,
				locale);
		if (periodType == PeriodTypeModel.PERIOD_TYPE_WEEK) {
			int startDate = getWeekStartDate();
			// 如果起始日为周日则正常取值，如果起始日为其他，则判断传入时间早于起始时间则减-7，否则会取下周为当前周
			if (startDate != Calendar.SUNDAY) {
				Calendar cal = Calendar.getInstance();
				if (date == null) {
					date = new Date();
				}
				cal.setTime(date);
				cal.set(Calendar.DAY_OF_WEEK, startDate);
				if (date.before(cal.getTime())) {
					cal.add(Calendar.DATE, -7);
					date = cal.getTime();
				}
			}
		}
		List periods = type.getPeriods(date, 1, locale);
		return (PeriodModel) periods.get(0);
	}

	public static List getPeriods(int periodType, Date date, Locale locale)
			throws ParseException {
		PeriodTypeModel type = PeriodTypeModel.createInstance(periodType,
				locale);
		if (periodType == PeriodTypeModel.PERIOD_TYPE_WEEK) {
			int startDate = getWeekStartDate();
			// 如果起始日为周日则正常取值，如果起始日为其他，则判断传入时间早于起始时间则减-7，否则会取下周为当前周
			if (startDate != Calendar.SUNDAY) {
				Calendar cal = Calendar.getInstance();
				if (date == null) {
					date = new Date();
				}
				cal.setTime(date);
				cal.set(Calendar.DAY_OF_WEEK, startDate);
				if (date.before(cal.getTime())) {
					cal.add(Calendar.DATE, -7);
					date = cal.getTime();
				}
			}
		}
		List periods = type.getPeriods(date, 10, locale);
		return periods;
	}

	public List getPeriods(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		if (getFdId() != null) {
			long id = getFdId().longValue();
			if (id == PERIOD_TYPE_MONTH) {
				return getMonthPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_DOUBLE_MONTH) {
				return getDoubleMonthPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_QUARTER) {
				return getQuarterPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_HALF_YEAR) {
				return getHalfYearPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_YEAR) {
				return getYearPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_DAY) {
				return getDayPeriod(baseDate, lenght, locale);
			} else if (id == PERIOD_TYPE_WEEK) {
				return getWeekPeriod(baseDate, lenght, locale);
			}
		}
		return new ArrayList();
	}

	public static List getPeriods(Long start, Long end, Locale locale)
			throws Exception {
		String typeStr = start.toString().substring(0, 1);
		String typeStr2 = end.toString().substring(0, 1);
		if (!typeStr.equals(typeStr2)) {
			throw new Exception("Start Type not Equals End Type.");
		}
		PeriodTypeModel type = PeriodTypeModel.createInstance(Integer
				.parseInt(typeStr), locale);
		PeriodModel startModel = type.getSinglePeriod(start, locale);
		PeriodModel endModel = type.getSinglePeriod(end, locale);
		boolean seq = endModel.getFdId() >= startModel.getFdId();
		if (!seq) {
			PeriodModel tmp = endModel;
			endModel = startModel;
			startModel = tmp;
		}
		ArrayList list = new ArrayList();
		int maxSize = 10000;// 最大1000个
		int count = 0;
		while (!startModel.getFdId().equals(endModel.getFdId())
				&& count++ < maxSize
				&& startModel.getFdStart().before(endModel.getFdStart())) {
			list.add(startModel.getFdId());
			startModel = type.getNextSinglePeriod(startModel.getFdId()
					.toString(), locale);
		}
		list.add(endModel.getFdId());
		return list;
	}

	public static Date getDate(Date date) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy/MM/dd/HH:mm:ss");
		String sdate = dateFormat.format(date);
		return dateFormat.parse(sdate);
	}

	public static PeriodTypeModel createInstance(int type, Locale locale) {
		if (type == PERIOD_TYPE_MONTH) {
			return createMonthType(locale);
		} else if (type == PERIOD_TYPE_DOUBLE_MONTH) {
			return createDoubleMonthType(locale);
		} else if (type == PERIOD_TYPE_QUARTER) {
			return createQuarterType(locale);
		} else if (type == PERIOD_TYPE_HALF_YEAR) {
			return createHalfYearType(locale);
		} else if (type == PERIOD_TYPE_YEAR) {
			return createYearType(locale);
		} else if (type == PERIOD_TYPE_DAY) {
			return createDayType(locale);
		} else if (type == PERIOD_TYPE_WEEK) {
			return createWeekType(locale);
		}

		return null;
	}

	public static List getPrevSinglePeriodInQuarter(String id)
			throws ParseException {
		PeriodTypeModel htype = PeriodTypeModel.createInstance(Integer
				.parseInt(id.substring(0, 1)), null);
		return htype.getPrevSinglePeriodInQuarter(id, null);
	}

	public List getPrevSinglePeriodInQuarter(String id, Locale locale)
			throws ParseException {
		List periods = new ArrayList();
		PeriodModel period = getSinglePeriod(id, locale);
		GregorianCalendar cal = getCalandar(locale);
		cal.setTime(getDate(period.getFdStart()));
		int month = cal.get(Calendar.MONTH);
		int count = month - (month / 3) * 3;
		for (int i = 1; i < count + 1; i++) {
			cal.set(Calendar.MONTH, month - i);
			Long fdId = new Long(Integer.parseInt(id.substring(0, 1))
					+ (String.valueOf(cal.get(Calendar.YEAR))
							+ getMonth(cal.get(Calendar.MONTH)) + getDay(0)));
			period = getPeriod(fdId, cal.get(Calendar.YEAR), cal
					.get(Calendar.MONTH), 0, locale);
			periods.add(period);
		}
		return periods;
	}

	public static PeriodModel getPrevSinglePeriod(String id)
			throws ParseException {
		PeriodTypeModel htype = PeriodTypeModel.createInstance(Integer
				.parseInt(id.substring(0, 1)), null);
		return htype.getPrevSinglePeriod(id, null);
	}

	public PeriodModel getPrevSinglePeriod(String id, Locale locale)
			throws ParseException {
		PeriodModel period = getSinglePeriod(id, locale);
		GregorianCalendar cal = getCalandar(locale);
		cal.setTime(period.getFdStart());
		cal.add(Calendar.MONTH, -getStep(Integer.parseInt(id.substring(0, 1))));
		cal.add(Calendar.DATE,
				-getDayStep(Integer.parseInt(id.substring(0, 1))));
		Long fdId = new Long(Integer.parseInt(id.substring(0, 1))
				+ (String.valueOf(cal.get(Calendar.YEAR))
						+ getMonth(cal.get(Calendar.MONTH)) + getDay(cal
						.get(Calendar.DATE) - 1)));
		return getPeriod(fdId, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH),
				cal.get(Calendar.DATE) - 1, locale);
	}

	private int getDayStep(int type) {
		int itype = type;
		if (itype > 10)
			itype = Integer.parseInt(String.valueOf(type).substring(0, 1));
		switch (type) {
		case 6:
			return 1;
		case 7:
			return 7;
		default:
			return 0;
		}
	}

	public static int getStep(int type) {
		int itype = type;
		if (itype > 10)
			itype = Integer.parseInt(String.valueOf(type).substring(0, 1));
		switch (type) {
		case 1:
			return 1;
		case 2:
			return 2;
		case 3:
			return 3;
		case 4:
			return 6;
		case 5:
			return 12;
		case 6:
		case 7:
			return 0;
		default:
			return 1;
		}
	}

	public static PeriodModel getNextSinglePeriod(String id)
			throws ParseException {
		PeriodTypeModel htype = PeriodTypeModel.createInstance(Integer
				.parseInt(id.substring(0, 1)), null);
		return htype.getNextSinglePeriod(id, null);
	}

	public PeriodModel getNextSinglePeriod(String id, Locale locale)
			throws ParseException {
		PeriodModel period = getSinglePeriod(id, locale);
		GregorianCalendar cal = getCalandar(locale);
		cal.setTime(period.getFdStart());
		cal.add(Calendar.MONTH, getStep(Integer.parseInt(id.substring(0, 1))));
		cal
				.add(Calendar.DATE, getDayStep(Integer.parseInt(id.substring(0,
						1))));
		Long fdId = new Long(Integer.parseInt(id.substring(0, 1))
				+ (String.valueOf(cal.get(Calendar.YEAR))
						+ getMonth(cal.get(Calendar.MONTH)) + getDay(cal
						.get(Calendar.DATE) - 1)));

		return getPeriod(fdId, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH),
				cal.get(Calendar.DATE) - 1, locale);
	}

	public static PeriodModel getSinglePeriod(String id)
			throws NumberFormatException, ParseException {
		return getSinglePeriod(id, null);
	}

	public static PeriodModel getSinglePeriod(Long id, Locale locale)
			throws NumberFormatException, ParseException {
		return getSinglePeriod(String.valueOf(id), locale);
	}

	public static PeriodModel getSinglePeriod(Long id)
			throws NumberFormatException, ParseException {
		return getSinglePeriod(id, null);
	}

	public static PeriodModel getSinglePeriod(String id, Locale locale)
			throws NumberFormatException, ParseException {
		String fdId = id;
		String type = "1";

		String year = "1970";
		String month = "01";
		String day = "01";
		if (fdId.length() > 6) {
			type = fdId.substring(0, 1);
			year = fdId.substring(1, 5);
			month = fdId.substring(5, 7);
			if (fdId.length() > 7) {
				day = fdId.substring(7);
			} else {
				day = "00";
			}
		}
		PeriodTypeModel htype = PeriodTypeModel.createInstance(Integer
				.parseInt(type), locale);

		return htype.getPeriod(new Long(id), Integer.parseInt(year), Integer
				.parseInt(month), Integer.parseInt(day), locale);
	}

	public PeriodModel getPeriod(Long id, int year, int month, int day,
			Locale locale) throws ParseException {
		if (getFdId() != null) {
			long modelid = getFdId().longValue();
			if (modelid == PERIOD_TYPE_MONTH) {
				return getSingleMonthPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_DOUBLE_MONTH) {
				return getSingleDoubleMonthPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_QUARTER) {
				return getSingleQuarterPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_HALF_YEAR) {
				return getSingleHalfYearPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_YEAR) {
				return getSingleYearPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_DAY) {
				return getSingleDayPeriod(id, year, month, day, locale);
			} else if (modelid == PERIOD_TYPE_WEEK) {
				return getSingleWeekPeriod(id, year, month, day, locale);
			}
		}
		return null;
	}

	public PeriodModel getSingleYearPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, 0);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		// params.add(String.valueOf(cal.get(Calendar.MONTH)/6+1));
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.YEAR, 1);
		// end.add(Calendar.DATE, -1);
		// params.add(String.valueOf(end.get(end.YEAR)));
		String lblStr = ResourceUtil.getString(PERIOD_YEAR_NAME_KEY, locale);

		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(new Long(PERIOD_TYPE_YEAR
				+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
						.get(Calendar.MONTH)))
				+ getDay(cal.get(Calendar.DATE) - 1)));
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		period.setFdEnd(getPreDate(end.getTime()));
		return period;
	}

	public PeriodModel getSingleHalfYearPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);

		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		// params.add(String.valueOf(cal.get(Calendar.MONTH)/6+1));
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.MONTH, 6);
		// end.add(Calendar.DATE, -1);
		// params.add(String.valueOf(end.get(end.YEAR)));
		String lblStr = "";
		if (cal.get(Calendar.MONTH) < 6) {
			lblStr = ResourceUtil.getString(PERIOD_HALF_YEAR_FIRST_NAME_KEY,
					locale);
		} else {
			lblStr = ResourceUtil.getString(PERIOD_HALF_YEAR_NEXT_NAME_KEY,
					locale);
		}
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(new Long(PERIOD_TYPE_HALF_YEAR
				+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
						.get(Calendar.MONTH)))
				+ getDay(cal.get(Calendar.DATE) - 1)));
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		period.setFdEnd(getPreDate(end.getTime()));
		return period;
	}

	public PeriodModel getSingleQuarterPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		params.add(String.valueOf(cal.get(Calendar.MONTH) / 3 + 1));
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.MONTH, 3);
		// end.add(Calendar.DATE, -1);
		// params.add(String.valueOf(end.get(end.YEAR)));
		String lblStr = ResourceUtil.getString(PERIOD_QUARTER_NAME_KEY, locale);
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(new Long(PERIOD_TYPE_QUARTER
				+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
						.get(Calendar.MONTH)))
				+ getDay(cal.get(Calendar.DATE) - 1)));
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		period.setFdEnd(getPreDate(end.getTime()));
		return period;
	}

	public PeriodModel getSingleMonthPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		params.add(String.valueOf(cal.get(Calendar.MONTH) + 1));
		String lblStr = ResourceUtil.getString(PERIOD_MONTH_NAME_KEY, locale);
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(id);
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.MONTH, 1);
		// end.add(Calendar.DATE, -1);
		period.setFdEnd(getPreDate(end.getTime()));

		return period;
	}

	public PeriodModel getSingleDayPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		params.add(String.valueOf(getMonth(cal.get(Calendar.MONTH) + 1)));
		params.add(String.valueOf(getDay(cal.get(Calendar.DATE))));
		String lblStr = ResourceUtil.getString(PERIOD_DAY_NAME_KEY, locale);
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(id);
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.DATE, 1);
		// end.add(Calendar.DATE, -1);
		period.setFdEnd(getPreDate(end.getTime()));

		return period;
	}

	public PeriodModel getSingleWeekPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		// cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.DATE, 7);
		end.setTime(getPreDate(end.getTime()));
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		params.add(String.valueOf(getMonth(cal.get(Calendar.MONTH) + 1)));
		params.add(String.valueOf(getDay(cal.get(Calendar.DATE))));
		params.add(String.valueOf(end.get(Calendar.YEAR)));
		params.add(String.valueOf(getMonth(end.get(Calendar.MONTH) + 1)));
		params.add(String.valueOf(getDay(end.get(Calendar.DATE))));
		String lblStr = ResourceUtil.getString(PERIOD_WEEK_NAME_KEY, locale);
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(id);
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		period.setFdEnd(end.getTime());

		return period;
	}

	public static Date getPreDate(Date date) {
		// SimpleDateFormat sdf = new SimpleDateFormat("yyy/MM/dd HH:mm:ss");
		// System.out.println("旧日期："+sdf.format(date)+" |"+date.getTime());
		long ldate = date.getTime();
		ldate = ldate - 1;
		Date newDate = new Date(ldate);
		// System.out.println("新日期："+sdf.format(newDate)+"
		// |"+newDate.getTime());
		return newDate;
	}

	public PeriodModel getSingleDoubleMonthPeriod(Long id, int year, int month,
			int day, Locale locale) throws ParseException {
		GregorianCalendar cal = getCalandar(locale);
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DATE, day + 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		ArrayList params = new ArrayList();
		params.add(String.valueOf(cal.get(Calendar.YEAR)));
		params.add(String.valueOf(cal.get(Calendar.MONTH) + 1));
		GregorianCalendar end = getCalandar(locale);
		end.setTime(cal.getTime());
		end.add(Calendar.MONTH, 2);
		end.add(Calendar.DATE, -1);
		params.add(String.valueOf(end.get(Calendar.MONTH) + 1));
		String lblStr = ResourceUtil.getString(PERIOD_DOUBLE_MONTHNAME_KEY,
				locale);
		MessageFormat form = new MessageFormat(lblStr);
		String lbl = form.format(params.toArray());
		PeriodModel period = new PeriodModel();
		period.setFdId(new Long(PERIOD_TYPE_DOUBLE_MONTH
				+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
						.get(Calendar.MONTH)))
				+ getDay(cal.get(Calendar.DATE) - 1)));
		period.setFdStart(cal.getTime());
		period.setFdName(lbl);
		period.setPeriodType(this);
		end.add(Calendar.DATE, 1);
		period.setFdEnd(getPreDate(end.getTime()));
		return period;
	}

	/**
	 * 取得年的基准月上下10个记录的列表，返回的列表包含Hrkpiperiod对象的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getYearPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		int flenght = lenght;
		List periods = new ArrayList();
		while (flenght-- > -lenght) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseDate);
			cal.set(Calendar.MONTH, 0);
			cal.add(Calendar.YEAR, -flenght);
			cal.set(Calendar.DATE, 1);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			// params.add(String.valueOf(cal.get(Calendar.MONTH)/6+1));
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.YEAR, 1);
			// end.add(Calendar.DATE, -1);
			// params.add(String.valueOf(end.get(end.YEAR)));
			String lblStr = ResourceUtil
					.getString(PERIOD_YEAR_NAME_KEY, locale);

			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_YEAR
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得半年的基准月上下10个记录的列表，返回的列表包含Hrkpiperiod对象的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getHalfYearPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		// System.out.println("baseDate:"+baseDate.toString());
		GregorianCalendar baseMonthCal = getCalandar(locale);
		baseMonthCal.setTime(baseDate);
		int baseMonth = baseMonthCal.get(Calendar.MONTH);
		// System.out.println("baseMonth:"+baseMonth);
		int halfyear = baseMonth / 6;
		// System.out.println("halfyear:"+halfyear);
		baseMonthCal.set(Calendar.MONTH, halfyear * 6);
		int flenght = lenght * 6;
		List periods = new ArrayList();
		int monthLengh = lenght * 6;
		while ((flenght = flenght - 6) >= -monthLengh) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseMonthCal.getTime());
			cal.add(Calendar.MONTH, -flenght);
			cal.set(Calendar.DATE, 1);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			// params.add(String.valueOf(cal.get(Calendar.MONTH)/6+1));
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.MONTH, 6);
			// end.add(Calendar.DATE, -1);
			// params.add(String.valueOf(end.get(end.YEAR)));
			String lblStr = "";
			if (cal.get(Calendar.MONTH) < 6) {
				lblStr = ResourceUtil.getString(
						PERIOD_HALF_YEAR_FIRST_NAME_KEY, locale);
			} else {
				lblStr = ResourceUtil.getString(PERIOD_HALF_YEAR_NEXT_NAME_KEY,
						locale);
			}
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_HALF_YEAR
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得季度的基准月上下10个记录的列表，返回的列表包含Hrkpiperiod对象的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getQuarterPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		GregorianCalendar baseMonthCal = getCalandar(locale);
		baseMonthCal.setTime(baseDate);
		int baseMonth = baseMonthCal.get(Calendar.MONTH);
		int quarter = baseMonth / 3;
		baseMonthCal.set(Calendar.MONTH, quarter * 3);
		int flenght = lenght * 3;
		List periods = new ArrayList();
		int monthLengh = lenght * 3;
		while ((flenght = flenght - 3) >= -monthLengh) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseMonthCal.getTime());
			cal.add(Calendar.MONTH, -flenght);
			cal.set(Calendar.DATE, 1);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			params.add(String.valueOf(cal.get(Calendar.MONTH) / 3 + 1));
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.MONTH, 3);
			// end.add(Calendar.DATE, -1);
			// params.add(String.valueOf(end.get(end.YEAR)));
			String lblStr = ResourceUtil.getString(PERIOD_QUARTER_NAME_KEY,
					locale);
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_QUARTER
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得基准月上下10个月的列表，返回的列表包含Hrkpiperiod对象的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getMonthPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		if (baseDate == null)
			baseDate = new Date();
		int flenght = lenght;
		List periods = new ArrayList();
		while (flenght-- > -lenght) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseDate);
			cal.add(Calendar.MONTH, -flenght);
			cal.set(Calendar.DATE, 1);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			params.add(String.valueOf(cal.get(Calendar.MONTH) + 1));
			String lblStr = ResourceUtil.getString(PERIOD_MONTH_NAME_KEY,
					locale);
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_MONTH
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.MONTH, 1);
			// end.add(Calendar.DATE, -1);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得双月的基准月上下10个记录的列表，返回的列表包含Hrkpiperiod对象的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getDoubleMonthPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		// 取得起始月
		GregorianCalendar baseMonthCal = getCalandar(locale);
		baseMonthCal.setTime(baseDate);
		int baseMonth = baseMonthCal.get(Calendar.MONTH);
		// System.out.println("===============");
		// System.out.println(baseMonth/2*2);

		baseMonthCal.set(Calendar.MONTH, (baseMonth) / 2 * 2);

		int flenght = lenght * 2;
		List periods = new ArrayList();
		while ((flenght = flenght - 2) >= -(lenght * 2)) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseMonthCal.getTime());
			// System.out.println("flenght:" + flenght);
			// System.out.println("cal pre month:" + cal.get(Calendar.YEAR)+"
			// "+cal.get(Calendar.MONTH));
			cal.add(Calendar.MONTH, -flenght);
			// System.out.println("cal end month:" + cal.get(Calendar.YEAR)+"
			// "+cal.get(Calendar.MONTH));
			cal.set(Calendar.DATE, 1);
			cal.set(Calendar.HOUR, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			params.add(String.valueOf(cal.get(Calendar.MONTH) + 1));
			// System.out.println("字符:" + cal.get(Calendar.YEAR)+"
			// "+String.valueOf(cal.get(Calendar.MONTH)+1));
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.MONTH, 2);
			end.add(Calendar.DATE, -1);
			params.add(String.valueOf(end.get(Calendar.MONTH) + 1));
			String lblStr = ResourceUtil.getString(PERIOD_DOUBLE_MONTHNAME_KEY,
					locale);
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_DOUBLE_MONTH
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			end.add(Calendar.DATE, 1);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得日的基准日上下10个记录的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getDayPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		if (baseDate == null)
			baseDate = new Date();
		int flenght = lenght;
		List periods = new ArrayList();
		while (flenght-- > -lenght) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(baseDate);
			cal.set(Calendar.DATE, cal.get(Calendar.DATE) - flenght);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			params.add(String.valueOf(getMonth(cal.get(Calendar.MONTH) + 1)));
			params.add(String.valueOf(getDay(cal.get(Calendar.DATE))));
			String lblStr = ResourceUtil.getString(PERIOD_DAY_NAME_KEY, locale);
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_DAY
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.DATE, 1);
			period.setFdEnd(getPreDate(end.getTime()));
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 取得周的基准周上下10个记录的列表
	 * 
	 * @param baseDate
	 * @param lenght
	 * @param locale
	 * @return
	 * @throws ParseException
	 */
	protected List getWeekPeriod(Date baseDate, int lenght, Locale locale)
			throws ParseException {
		if (baseDate == null)
			baseDate = new Date();
		int flenght = lenght;
		List periods = new ArrayList();
		int startDate = getWeekStartDate();
		GregorianCalendar basecal = getCalandar(locale);
		basecal.setTime(baseDate);
		basecal.set(Calendar.DAY_OF_WEEK, startDate);
		basecal.set(Calendar.HOUR_OF_DAY, 0);
		basecal.set(Calendar.MINUTE, 0);
		basecal.set(Calendar.SECOND, 0);
		basecal.set(Calendar.MILLISECOND, 0);
		while (flenght-- > -lenght) {
			GregorianCalendar cal = getCalandar(locale);
			cal.setTime(basecal.getTime());
			cal.set(Calendar.DATE, basecal.get(Calendar.DATE) - flenght * 7);
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 0);
			cal.set(Calendar.MILLISECOND, 0);
			GregorianCalendar end = getCalandar(locale);
			end.setTime(cal.getTime());
			end.add(Calendar.DATE, 7);
			end.setTime(getPreDate(end.getTime()));
			ArrayList params = new ArrayList();
			params.add(String.valueOf(cal.get(Calendar.YEAR)));
			params.add(String.valueOf(getMonth(cal.get(Calendar.MONTH) + 1)));
			params.add(String.valueOf(getDay(cal.get(Calendar.DATE))));
			params.add(String.valueOf(end.get(Calendar.YEAR)));
			params.add(String.valueOf(getMonth(end.get(Calendar.MONTH) + 1)));
			params.add(String.valueOf(getDay(end.get(Calendar.DATE))));
			String lblStr = ResourceUtil
					.getString(PERIOD_WEEK_NAME_KEY, locale);
			MessageFormat form = new MessageFormat(lblStr);
			String lbl = form.format(params.toArray());
			PeriodModel period = new PeriodModel();
			period.setFdId(new Long(PERIOD_TYPE_WEEK
					+ (String.valueOf(cal.get(Calendar.YEAR)) + getMonth(cal
							.get(Calendar.MONTH)))
					+ getDay(cal.get(Calendar.DATE) - 1)));
			period.setFdStart(cal.getTime());
			period.setFdName(lbl);
			period.setPeriodType(this);
			period.setFdEnd(end.getTime());
			periods.add(period);
		}
		return periods;
	}

	/**
	 * 获取周起始日
	 * 
	 * @return
	 */
	public static int getWeekStartDate() {
		// 周起始日配置参数
		String startDateString = ResourceUtil
				.getKmssConfigString("kmss.period.type.week.startdate");
		// 默认起始日为星期日
		int startDate = Calendar.SUNDAY;
		if (StringUtil.isNotNull(startDateString)) {
			startDate = Integer.parseInt(startDateString);
		}
		return startDate;
	}

	protected String getMonth(int month) {
		if (month < 10) {
			return "0" + String.valueOf(month);
		} else {
			return String.valueOf(month);
		}
	}

	protected String getDay(int day) {
		if (day < 10) {
			return "0" + String.valueOf(day);
		} else {
			return String.valueOf(day);
		}
	}

	public static PeriodTypeModel createYearType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_YEAR));
		type
				.setFname(ResourceUtil.getString(PERIOD_TYPE_YEAR_NAME_KEY,
						locale));
		return type;
	}

	public static PeriodTypeModel createYearType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_YEAR));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_YEAR_NAME_KEY));
		return type;
	}

	public static PeriodTypeModel createHalfYearType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_HALF_YEAR));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_HALF_YEAR_NAME_KEY,
				locale));
		return type;
	}

	public static PeriodTypeModel createHalfYearType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_HALF_YEAR));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_HALF_YEAR_NAME_KEY));
		return type;
	}

	public static PeriodTypeModel createQuarterType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_QUARTER));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_QUARTER_NAME_KEY,
				locale));
		return type;
	}

	public static PeriodTypeModel createQuarterType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_QUARTER));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_QUARTER_NAME_KEY));
		return type;
	}

	public static PeriodTypeModel createDoubleMonthType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_DOUBLE_MONTH));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_DOUBLE_MONTHNAME_KEY,
				locale));
		return type;
	}

	public static PeriodTypeModel createDoubleMonthType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_DOUBLE_MONTH));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_DOUBLE_MONTHNAME_KEY));
		return type;
	}

	public static PeriodTypeModel createMonthType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_MONTH));
		type.setFname(ResourceUtil
				.getString(PERIOD_TYPE_MONTH_NAME_KEY, locale));
		return type;
	}

	public static PeriodTypeModel createMonthType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_MONTH));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_MONTH_NAME_KEY));
		return type;
	}

	public static PeriodTypeModel createDayType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_DAY));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_DAY_NAME_KEY, locale));
		return type;
	}

	public static PeriodTypeModel createDayType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_DAY));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_DAY_NAME_KEY));
		return type;
	}

	public static PeriodTypeModel createWeekType(Locale locale) {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_WEEK));
		type
				.setFname(ResourceUtil.getString(PERIOD_TYPE_WEEK_NAME_KEY,
						locale));
		return type;
	}

	public static PeriodTypeModel createWeekType() {
		PeriodTypeModel type = new PeriodTypeModel();
		type.setFdId(new Long(PERIOD_TYPE_WEEK));
		type.setFname(ResourceUtil.getString(PERIOD_TYPE_WEEK_NAME_KEY));
		return type;
	}

	/*
	 * 类型名称
	 */
	protected java.lang.String fname;

	public PeriodTypeModel() {
		super();
	}

	/**
	 * @return 返回 类型名称
	 */
	public java.lang.String getFname() {
		return fname;
	}

	/**
	 * @param fname
	 *            要设置的 类型名称
	 */
	public void setFname(java.lang.String fname) {
		this.fname = fname;
	}

	protected GregorianCalendar getCalandar(Locale locale)
			throws ParseException {
		GregorianCalendar gc = null;
		if (locale == null) {
			gc = new GregorianCalendar();
		} else {
			gc = new GregorianCalendar(locale);
		}

		gc.setTime(getDate(new Date()));

		return gc;
	}

	public static void main(String[] args) throws Exception {
		SimpleDateFormat dformat = new SimpleDateFormat(ResourceUtil
				.getString("date.format.time.sec"));
		Date today = new Date();
		System.out.println("today:" + today.getTime() + " "
				+ dformat.format(today));
		try {
			today = getDate(today);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		System.out.println("today2:" + today.getTime() + " "
				+ dformat.format(today));
		SimpleDateFormat format = new SimpleDateFormat(ResourceUtil
				.getString("date.format.time.sec"));
		List list = getPrevSinglePeriodInQuarter("120061100");
		for (int i = 0; i < list.size(); i++) {
			PeriodModel period = (PeriodModel) list.get(i);
			System.out.println(period.getFdId() + " "
					+ format.format(period.getFdStart()) + " "
					+ format.format(period.getFdEnd()));
			System.out.println(period.getFdId() + " "
					+ period.getFdStart().getTime() + " "
					+ period.getFdEnd().getTime());
		}
		System.out.println("----测试前一个区间--------");
		PeriodModel period = getPrevSinglePeriod("720100227");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()));
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		System.out.println("----测试后一个区间--------");
		period = getNextSinglePeriod("720100220");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()));
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());

		// 测试单月
		System.out.println("----测试单月--------");
		period = (PeriodModel) getSinglePeriod("120060500");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试双月
		System.out.println("----测试双月--------");
		period = (PeriodModel) getSinglePeriod("220060400");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试季度
		System.out.println("----测试季度--------");
		period = (PeriodModel) getSinglePeriod("320060300");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试半年
		System.out.println("----测试半年--------");
		period = (PeriodModel) getSinglePeriod("420060000");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试年
		System.out.println("----测试年--------");
		period = (PeriodModel) getSinglePeriod("520060000");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试日
		System.out.println("----测试日--------");
		period = (PeriodModel) getSinglePeriod("620060002");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试周
		System.out.println("----测试周--------");
		period = (PeriodModel) getSinglePeriod("720100220");
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		Date testDate = new Date();
		// SimpleDateFormat testformat = new SimpleDateFormat("yyyyMMdd");
		// testDate = testformat.parse("20100311");

		// 测试根据时间生成月id
		System.out.println("----根据时间生成月id--------");
		period = (PeriodModel) getPeriodModel(
				PeriodTypeModel.PERIOD_TYPE_MONTH, testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		System.out.println("----根据时间生成月id---取上下10个-----");
		List periods = getPeriods(PeriodTypeModel.PERIOD_TYPE_MONTH, testDate,
				null);
		for (int i = 0; i < periods.size(); i++) {
			period = (PeriodModel) periods.get(i);
			System.out.println(period.getFdId() + " "
					+ format.format(period.getFdStart()) + " "
					+ format.format(period.getFdEnd()) + " "
					+ period.getFdName());
			System.out.println(period.getFdId() + " "
					+ period.getFdStart().getTime() + " "
					+ period.getFdEnd().getTime());
		}
		// 测试根据时间生成双月id
		System.out.println("----根据时间生成双月id--------");
		period = (PeriodModel) getPeriodModel(
				PeriodTypeModel.PERIOD_TYPE_DOUBLE_MONTH, testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试根据时间生成季id
		System.out.println("----根据时间生成季id--------");
		period = (PeriodModel) getPeriodModel(
				PeriodTypeModel.PERIOD_TYPE_QUARTER, testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试根据时间生成半年id
		System.out.println("----根据时间生成半年id--------");
		period = (PeriodModel) getPeriodModel(
				PeriodTypeModel.PERIOD_TYPE_HALF_YEAR, testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		// 测试根据时间生成月id
		System.out.println("----根据时间生成年id--------");
		period = (PeriodModel) getPeriodModel(PeriodTypeModel.PERIOD_TYPE_YEAR,
				testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		System.out.println("----根据时间生成年id---取上下10个-----");
		periods = getPeriods(PeriodTypeModel.PERIOD_TYPE_YEAR, testDate, null);
		for (int i = 0; i < periods.size(); i++) {
			period = (PeriodModel) periods.get(i);
			System.out.println(period.getFdId() + " "
					+ format.format(period.getFdStart()) + " "
					+ format.format(period.getFdEnd()) + " "
					+ period.getFdName());
			System.out.println(period.getFdId() + " "
					+ period.getFdStart().getTime() + " "
					+ period.getFdEnd().getTime());
		}
		// 测试根据时间生成日id
		System.out.println("----根据时间生成日id--------");
		period = (PeriodModel) getPeriodModel(PeriodTypeModel.PERIOD_TYPE_DAY,
				testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		System.out.println("----根据时间生成日id---取上下10个-----");
		periods = getPeriods(PeriodTypeModel.PERIOD_TYPE_DAY, testDate, null);
		for (int i = 0; i < periods.size(); i++) {
			period = (PeriodModel) periods.get(i);
			System.out.println(period.getFdId() + " "
					+ format.format(period.getFdStart()) + " "
					+ format.format(period.getFdEnd()) + " "
					+ period.getFdName());
			System.out.println(period.getFdId() + " "
					+ period.getFdStart().getTime() + " "
					+ period.getFdEnd().getTime());
		}
		// 测试根据时间生成星期id
		System.out.println("----根据时间生成星期id--------");
		period = (PeriodModel) getPeriodModel(PeriodTypeModel.PERIOD_TYPE_WEEK,
				testDate, null);
		System.out.println(period.getFdId() + " "
				+ format.format(period.getFdStart()) + " "
				+ format.format(period.getFdEnd()) + " " + period.getFdName());
		System.out.println(period.getFdId() + " "
				+ period.getFdStart().getTime() + " "
				+ period.getFdEnd().getTime());
		System.out.println("----根据时间生成星期id---取上下10个-----");
		periods = getPeriods(PeriodTypeModel.PERIOD_TYPE_WEEK, new Date(), null);
		for (int i = 0; i < periods.size(); i++) {
			period = (PeriodModel) periods.get(i);
			System.out.println(period.getFdId() + " "
					+ format.format(period.getFdStart()) + " "
					+ format.format(period.getFdEnd()) + " "
					+ period.getFdName());
			System.out.println(period.getFdId() + " "
					+ period.getFdStart().getTime() + " "
					+ period.getFdEnd().getTime());
		}
		// 测
		System.out.println("----根据时间段生成月id--------");
		List plist = PeriodTypeModel.getPeriods(Long.valueOf(120061100), Long
				.valueOf(120080600), null);
		for (int i = 0; i < plist.size(); i++) {
			System.out.println(plist.get(i));

		}
	}

	private static long hashCodeIndex = 1;

	protected Long fdId;

	public Long getFdId() {
		return fdId;
	}

	public void setFdId(Long id) {
		this.fdId = id;
	}

	/**
	 * 覆盖toString方法，使用列出域模型中的所有get方法返回的值（不获取返回值类型为非java.lang.*的值）
	 * 
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		try {
			Method[] methodList = this.getClass().getMethods();
			ToStringBuilder rtnVal = new ToStringBuilder(this,
					ToStringStyle.MULTI_LINE_STYLE);
			for (int i = 0; i < methodList.length; i++) {
				String methodName = methodList[i].getName();
				if (methodList[i].getParameterTypes().length > 0
						|| !methodName.startsWith("get")
						|| methodName.equals("getClass"))
					continue;
				methodName = methodList[i].getReturnType().toString();
				if ((methodName.startsWith("class") || methodName
						.startsWith("interface"))
						&& !(methodName.startsWith("class java.lang.") || methodName
								.startsWith("interface java.lang.")))
					continue;
				try {
					rtnVal.append(methodList[i].getName().substring(3),
							methodList[i].invoke(this, null));
				} catch (Exception e) {
				}
			}
			return rtnVal.toString().replaceAll("@[^\\[]+\\[\\r\\n", "[\r\n");
		} catch (Exception e) {
			return super.toString();
		}
	}

	/**
	 * 覆盖equals方法，仅比较类型是否相等以及关键字是否相等
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object object) {
		if (this == object)
			return true;
		if (object == null)
			return false;
		if (!ModelUtil.getModelClassName(object).equals(
				ModelUtil.getModelClassName(this)))
			return false;
		BaseModel objModel = (BaseModel) object;
		return ObjectUtil.equals(objModel.getFdId(), this.getFdId(), false);
	}

	/**
	 * 覆盖hashCode方法，通过模型中类名和ID构建哈希值
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() {
		HashCodeBuilder rtnVal = new HashCodeBuilder(-426830461, 631494429);
		rtnVal.append(ModelUtil.getModelClassName(this));
		long id = 0;
		if (getFdId() == null) {
			hashCodeIndex++;
			if (hashCodeIndex > 100000000)
				hashCodeIndex = 0;
			id = hashCodeIndex;
		} else {
			id = getFdId().longValue() + 100000000;
		}
		rtnVal.append(new Long(id));
		return rtnVal.toHashCode();
	}
}
