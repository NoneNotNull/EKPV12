package com.landray.kmss.common.service;

/**
 * 系统初始化数据接口
 * 
 * @author 易荣烽
 * 
 */
public interface IKmssSystemInitBean extends IKmssSystemInitializeBean {
	/**
	 * 初始化任务名称
	 * 
	 * @return String
	 */
	public abstract String initName();
}
