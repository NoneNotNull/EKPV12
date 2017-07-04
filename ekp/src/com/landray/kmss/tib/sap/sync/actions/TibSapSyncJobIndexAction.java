/**
 * 
 */
package com.landray.kmss.tib.sap.sync.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncJob;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncJobService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2013-12-11
 */
public class TibSapSyncJobIndexAction extends ExtendAction {
	protected ITibSapSyncJobService tibSapSyncJobService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSapSyncJobService == null)
			tibSapSyncJobService = (ITibSapSyncJobService)getBean("tibSapSyncJobService");
		return tibSapSyncJobService;
	}
	
	protected String getFindPageWhereBlock(HttpServletRequest request)
			throws Exception {
		String categoryId=request.getParameter("categoryId");
		String whereBlock=StringUtil.isNotNull(categoryId)?" tibSapSyncJob.docCategory.fdHierarchyId like '%"+categoryId+"%'":null;
		return whereBlock;
	}

	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSapSyncJob.class);
	}
	
}
