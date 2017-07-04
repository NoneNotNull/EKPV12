package com.landray.kmss.tib.sys.soap.connector.service.spring;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;

/**
 * WEBSERVICE服务配置业务接口实现
 * 
 * @author
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingServiceImp extends BaseServiceImp implements
		ITibSysSoapSettingService {
	private ITibSysSoapSettingService TibSysSoapSettingService;
	
	public void setTibSysSoapSettingService(
			ITibSysSoapSettingService TibSysSoapSettingService) {
		this.TibSysSoapSettingService = TibSysSoapSettingService;
	}
}
