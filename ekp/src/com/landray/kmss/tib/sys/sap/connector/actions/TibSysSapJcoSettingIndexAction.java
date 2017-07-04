/**
 * 
 */
package com.landray.kmss.tib.sys.sap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapJcoSettingService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;

/**
 * @author qiujh
 * @version 1.0 2013-12-10
 */
public class TibSysSapJcoSettingIndexAction extends ExtendAction {
	protected ITibSysSapJcoSettingService tibSysSapJcoSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (tibSysSapJcoSettingService == null)
			tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) getBean("tibSysSapJcoSettingService");
		return tibSysSapJcoSettingService;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysSapJcoSetting.class);
	}
}
