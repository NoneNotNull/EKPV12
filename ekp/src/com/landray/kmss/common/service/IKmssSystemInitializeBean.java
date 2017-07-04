package com.landray.kmss.common.service;

import com.landray.kmss.util.KmssMessages;

public interface IKmssSystemInitializeBean {
	/**
	 * 系统初始化数据接口
	 * 
	 * @return KmssMessages
	 */
	public abstract KmssMessages initializeData();
}
