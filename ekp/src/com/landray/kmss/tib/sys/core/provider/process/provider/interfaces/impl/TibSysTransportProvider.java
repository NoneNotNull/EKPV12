package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl;

import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;


/**
 * 自定义提供者信息类
 * @author fat_tian
 *
 */
public class TibSysTransportProvider extends TibSysBaseProvider {

	@Override
	public Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		return data;
	}
	
}
