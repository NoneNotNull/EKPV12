package com.landray.kmss.common.test;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TimeCounter {
	private static final Log logger = LogFactory.getLog(TimeCounter.class);

	private static ThreadLocal threadMap = new ThreadLocal();

	public static void logCurrentTime(String key, boolean isStart, Class cls) {
		if (!logger.isDebugEnabled())
			return;
		Map timeMap = (Map) threadMap.get();
		if (timeMap == null) {
			timeMap = new HashMap();
			threadMap.set(timeMap);
		}

		String mapKey = cls.getName() + ":" + key;
		Date curDate = new Date();
		if (isStart) {
			timeMap.put(mapKey, curDate);
		} else {
			Date lastDate = (Date) timeMap.get(mapKey);
			if (lastDate != null) {
				timeMap.remove(mapKey);
				StringBuffer logInfo = new StringBuffer("===== 开始：")
						.append(lastDate);
				logInfo.append("，结束：").append(curDate);
				logInfo.append("，间隔：").append(
						curDate.getTime() - lastDate.getTime());
				logInfo.append("，（位置：").append(cls.getName());
				logInfo.append("，内容：").append(key).append(") =====");
				logger.debug(logInfo);
			}
		}
	}
}
