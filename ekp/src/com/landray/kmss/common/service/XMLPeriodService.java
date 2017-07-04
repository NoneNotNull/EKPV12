package com.landray.kmss.common.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.model.PeriodModel;
import com.landray.kmss.common.model.PeriodTypeModel;
import com.landray.kmss.util.KmssMessage;

public class XMLPeriodService implements IXMLDataBean {
	public List getDataList(RequestContext requestContext) {
		try {
			String type = requestContext.getParameter("periodType");
			int itype = PeriodTypeModel.PERIOD_TYPE_MONTH;
			if (type != null && type.trim().length() > 0) {
				itype = Integer.parseInt(type);
			}
			String id = requestContext.getParameter("id");
			Date date = new Date();
			// 周类型，如果有ID则按照id的时间取值，如果没有ID则在当前日期做判断
			if (id != null && id.trim().length() > 0) {
				date = PeriodTypeModel.getSinglePeriod(id,
						requestContext.getRequest().getLocale()).getFdStart();
			} else {
				if (itype == PeriodTypeModel.PERIOD_TYPE_WEEK) {
					int startDate = PeriodTypeModel.getWeekStartDate();
					// 如果起始日为周日则正常取值，如果起始日为其他，则判断传入时间早于起始时间则减-7，否则会取下周为当前周
					if (startDate != Calendar.SUNDAY) {
						Calendar cal = Calendar.getInstance();
						cal.setTime(date);
						cal.set(Calendar.DAY_OF_WEEK, startDate);
						if (date.before(cal.getTime())) {
							cal.add(Calendar.DATE, -7);
							date = cal.getTime();
						}
					}
				}
			}
			PeriodTypeModel intervalType = PeriodTypeModel.createInstance(
					itype, requestContext.getRequest().getLocale());
			List periods = intervalType.getPeriods(date, 10, requestContext
					.getRequest().getLocale());
			List retval = new ArrayList();
			for (int i = 0; i < periods.size(); i++) {
				PeriodModel period = (PeriodModel) periods.get(i);
				HashMap map = new HashMap();
				map.put("id", String.valueOf(period.getFdId()));
				map.put("name", period.getFdName());
				retval.add(map);
			}
			return retval;
		} catch (Exception e) {
			throw new KmssRuntimeException(new KmssMessage("errors.date"), e);
		}
	}
}
