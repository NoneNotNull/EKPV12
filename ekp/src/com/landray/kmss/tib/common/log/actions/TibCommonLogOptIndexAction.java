/**
 * 
 */
package com.landray.kmss.tib.common.log.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.log.model.TibCommonLogOpt;
import com.landray.kmss.tib.common.log.service.ITibCommonLogOptService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;

/**
 * @author qiujh
 * @version 1.0 2013-12-9
 */
public class TibCommonLogOptIndexAction extends ExtendAction {
	protected ITibCommonLogOptService tibCommonLogOptService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibCommonLogOptService == null)
			tibCommonLogOptService = (ITibCommonLogOptService)getBean("tibCommonLogOptService");
		return tibCommonLogOptService;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibCommonLogOpt.class);
	}
}
