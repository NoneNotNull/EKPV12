package com.landray.kmss.tib.jdbc.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.jdbc.model.TibJdbcDataSet;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;


/**
 * 数据集管理 Action
 * 
 * @author 
 * @version 1.0 2014-04-15
 */
public class TibJdbcDataSetIndexAction extends ExtendAction {
	protected ITibJdbcDataSetService tibJdbcDataSetService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibJdbcDataSetService == null)
			tibJdbcDataSetService = (ITibJdbcDataSetService)getBean("tibJdbcDataSetService");
		return tibJdbcDataSetService;
	}
	
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		if(!StringUtil.isNull(categoryId)){
			String hql=hqlInfo.getWhereBlock();
			hql=StringUtil.linkString(hql, " and ", "tibJdbcDataSet.docCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setWhereBlock(hql);
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
		}
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibJdbcDataSet.class);
	}
}

