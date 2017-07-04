package com.landray.kmss.tib.jdbc.util;

import java.util.HashMap;
import java.util.Map;

public class JdbcRunSyncType {
	public static String SYNCTYPE_FULL = "1";
	public static String SYNCTYPE_INCREMENT = "2";
	public static String SYNCTYPE_LOG = "3";
	public static Map<String, String> syncTypeMap = new HashMap<String, String>();
	static {
		syncTypeMap.put(SYNCTYPE_FULL, "tibJdbcTaskRunFullSync");
		syncTypeMap.put(SYNCTYPE_INCREMENT, "tibJdbcTaskRunIncrementSync");
		syncTypeMap.put(SYNCTYPE_LOG, "tibJdbcTaskRunLogSync");
	}
	
}
