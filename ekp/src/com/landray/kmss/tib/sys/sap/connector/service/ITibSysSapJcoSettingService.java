package com.landray.kmss.tib.sys.sap.connector.service;

import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;

/**
 * jco配置业务对象接口
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public interface ITibSysSapJcoSettingService extends IBaseService {

	public String testConnection(IExtendForm paramIExtendForm) throws Exception;

}
