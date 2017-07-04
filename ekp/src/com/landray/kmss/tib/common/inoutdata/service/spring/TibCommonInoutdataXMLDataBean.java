/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataService;
import com.landray.kmss.util.DateUtil;

/**
 * 导入后显示数据信息
 * @author 邱建华
 * @version 1.0 2013-1-7
 */
public class TibCommonInoutdataXMLDataBean implements IXMLDataBean {
	private ITibCommonInoutdataService tibCommonInoutdataService;

	public void setTibCommonInoutdataService(ITibCommonInoutdataService tibCommonInoutdataService) {
		this.tibCommonInoutdataService = tibCommonInoutdataService;
	}

	public List<Map<String, Object>> getDataList(RequestContext requestInfo)
			throws Exception {
		TibCommonProcessRuntime runtime = tibCommonInoutdataService.getProcessRuntime();
		Locale locale = requestInfo.getLocale();
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		Map<String, Object> value = new HashMap<String, Object>();
		value.put("currentTime", DateUtil.convertDateToString(new Date(),
				DateUtil.TYPE_DATETIME, locale));
		value.put("startTime", DateUtil.convertDateToString(runtime
				.getStartTime(), DateUtil.TYPE_DATETIME, locale));
		value.put("endTime", DateUtil.convertDateToString(runtime.getEndTime(),
				DateUtil.TYPE_DATETIME, locale));
		value.put("status", runtime.getStatus());
		value.put("processCount", runtime.getProcessCount());
		value.put("successCount", runtime.getSuccessCount());
		value.put("ignoreCount", runtime.getIgnoreCount());
		value.put("addCount", runtime.getAddCount());
		value.put("updateCount", runtime.getUpdateCount());
		value.put("failureCount", runtime.getFailureCount());
		value.put("errorFile", runtime.getErrorFile());
		rtnList.add(value);
		return rtnList;
	}

}
