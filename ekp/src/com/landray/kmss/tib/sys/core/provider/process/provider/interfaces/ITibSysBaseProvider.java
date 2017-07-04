package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces;

import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;

public interface ITibSysBaseProvider {
	/**
	 * 执行
	 * 
	 * @param coreFace
	 * @param data
	 * @return
	 */
	public abstract Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception;
}
