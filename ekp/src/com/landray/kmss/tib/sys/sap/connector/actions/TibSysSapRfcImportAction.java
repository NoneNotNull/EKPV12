package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcImportService;


/**
 * 传入参数配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcImportAction extends ExtendAction {
	protected ITibSysSapRfcImportService tibSysSapRfcImportService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysSapRfcImportService == null)
			tibSysSapRfcImportService = (ITibSysSapRfcImportService)getBean("tibSysSapRfcImportService");
		return tibSysSapRfcImportService;
	}
}

