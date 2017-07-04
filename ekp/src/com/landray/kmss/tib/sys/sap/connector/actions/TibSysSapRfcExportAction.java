package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcExportService;


/**
 * 传出参数配置 Action
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcExportAction extends ExtendAction {
	protected ITibSysSapRfcExportService tibSysSapRfcExportService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysSapRfcExportService == null)
			tibSysSapRfcExportService = (ITibSysSapRfcExportService)getBean("tibSysSapRfcExportService");
		return tibSysSapRfcExportService;
	}
}

