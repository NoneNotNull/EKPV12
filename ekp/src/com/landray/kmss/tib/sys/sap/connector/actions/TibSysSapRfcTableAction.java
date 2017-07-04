package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcTableService;


/**
 * 表参数配置 Action
 * 
 * @author 
 * @version 1.0 2011-10-25
 */
public class TibSysSapRfcTableAction extends ExtendAction {
	protected ITibSysSapRfcTableService tibSysSapRfcTableService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysSapRfcTableService == null)
			tibSysSapRfcTableService = (ITibSysSapRfcTableService)getBean("tibSysSapRfcTableService");
		return tibSysSapRfcTableService;
	}
}

