package com.landray.kmss.tib.common.log.constant;

public interface TibCommonLogConstant {
	
	/**
	 * 1为错误日志
	 */
	public final static String TIB_COMMON_LOG_TYPE_ERROR="1";
	/**
	 * 0为成功日志
	 */
	public final static String TIB_COMMON_LOG_TYPE_SUCCESS="0";
	/**
	 * 2业务失败日志
	 */
	public final static String TIB_COMMON_LOG_TYPE_BIERROR="2";
	
    /**
     * 日志级别 基本
     */
	public final static Integer TIB_COMMON_LOG_LEVEL_BASE=1;
	 /**
     * 日志级别 高级
     */
	public final static Integer TIB_COMMON_LOG_LEVEL_TOP=2;
	
	 /**
     * 日志级别 默认
     */
	public final static Integer TIB_COMMON_LOG_LEVEL_DEFAULT=0;
	

}
