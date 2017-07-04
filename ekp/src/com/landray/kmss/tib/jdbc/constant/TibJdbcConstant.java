package com.landray.kmss.tib.jdbc.constant;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author qiujh
 *
 * @version 1.0 
 */
public abstract class TibJdbcConstant {
	// 日志同步的操作类型
	public static final String ADD = "ADD";
	public static final String DELETE = "DELETE";
	public static final String UPDATE = "UPDATE";
	
	//TibJdbc 定时任务bean
	public final static String TIBSYSSAP_SERVICEBEAN = "tibJdbcSyncUniteQuartzService";
	//使用定时任务bean 的method
	public final static String TIBSYSSAP_SERVICEMETHOD = "methodJob";
	
	// 批次处理
	public static final int batchSize=3000;
	
	// 数据迁移固定初始值，函数列表
	public static List<Map<String, String>> EXPRESSION_LIST = new ArrayList<Map<String, String>>();
	public static Map<String, Short> SWITCH_MAP = new HashMap<String, Short>();
	public static final short EXPRESSION_FDID = 1;
	public static final short EXPRESSION_CUR_DATETIME = 2;
	public static final short EXPRESSION_CUR_DATE=3;
	
	static {
		
		Map<String, String> curFdIdMap = new HashMap<String, String>(); 
		curFdIdMap.put("text", "生成主键");
		curFdIdMap.put("value", "$生成主键$()");
		curFdIdMap.put("isAutoFetch", "0");
		EXPRESSION_LIST.add(curFdIdMap);
		SWITCH_MAP.put("$生成主键$()", EXPRESSION_FDID);
		
		Map<String, String> curDateTimeMap = new HashMap<String, String>(); 
		curDateTimeMap.put("text", "当前日期时间");
		curDateTimeMap.put("value", "$日期时间.当前日期时间$()");
		curDateTimeMap.put("isAutoFetch", "0");
		EXPRESSION_LIST.add(curDateTimeMap);
		SWITCH_MAP.put("$日期时间.当前日期时间$()", EXPRESSION_CUR_DATETIME);
		
		Map<String, String> curDateMap = new HashMap<String, String>(); 
		curDateMap.put("text", "当前日期");
		curDateMap.put("value", "$日期.当前日期$()");
		curDateMap.put("isAutoFetch", "0");
		EXPRESSION_LIST.add(curDateMap);
		SWITCH_MAP.put("$日期.当前日期$()", EXPRESSION_CUR_DATE);
	}

}
