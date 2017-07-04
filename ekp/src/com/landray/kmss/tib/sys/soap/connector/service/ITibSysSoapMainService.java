package com.landray.kmss.tib.sys.soap.connector.service;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;

/**
 * WEBSERVCIE服务函数业务对象接口
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public interface ITibSysSoapMainService extends IBaseService {
	
	/**
	 * 根据fdID 查找已经激活的service
	 * @param fdId
	 * @return
	 * @throws Exception
	 */
	public TibSysSoapMain findEnableServiceById(String fdId) throws Exception;

}
