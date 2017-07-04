/**
 * 
 */
package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapServerSettingService;

/**
 * @author qiujh
 * @version 1.0 2013-12-9
 */
public class TibSysSapServerSettingIndexAction extends ExtendAction {
	protected ITibSysSapServerSettingService tibSysSapServerSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapServerSettingService == null)
			tibSysSapServerSettingService = (ITibSysSapServerSettingService) getBean("tibSysSapServerSettingService");
		return tibSysSapServerSettingService;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		//CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
		//		TibSysSapServerSetting.class);
	}
}
