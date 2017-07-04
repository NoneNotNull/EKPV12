/**
 * 
 */
package com.landray.kmss.tib.soap.sync.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncJob;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncJobService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2014-2-20
 */
public class TibSoapSyncJobIndexAction extends ExtendAction {
	protected ITibSoapSyncJobService tibSoapSyncJobService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSoapSyncJobService == null)
			tibSoapSyncJobService = (ITibSoapSyncJobService)getBean("tibSoapSyncJobService");
		return tibSoapSyncJobService;
	}
	
	protected String getFindPageWhereBlock(HttpServletRequest request)
			throws Exception {
		String categoryId=request.getParameter("categoryId");
		String whereBlock=StringUtil.isNotNull(categoryId)?" tibSoapSyncJob.docCategory.fdHierarchyId like '%"+categoryId+"%'":null;
		return whereBlock;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSoapSyncJob.class);
	}
}
