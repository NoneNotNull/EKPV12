package com.landray.kmss.tib.sap.mapping.plugins.controls.list.service.spring;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.dao.ITibSapMappingListControlMainDao;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.service.ITibSapMappingListControlMainService;

/**
 * 主文档业务接口实现
 * 
 * @author 
 * @version 1.0 2013-04-17
 */
public class TibSapMappingListControlMainServiceImp extends BaseServiceImp implements ITibSapMappingListControlMainService {

	public void clearSapData()  throws Exception {
		((ITibSapMappingListControlMainDao)getBaseDao()).clearSapData();
	}

}
