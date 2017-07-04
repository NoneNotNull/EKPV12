/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2013-12-30
 */
public class TibSysSoapMainIndexAction extends ExtendAction {
	protected ITibSysSoapMainService TibSysSoapMainService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (TibSysSoapMainService == null)
			TibSysSoapMainService = (ITibSysSoapMainService) getBean("tibSysSoapMainService");
		return TibSysSoapMainService;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		String hql=hqlInfo.getWhereBlock();
		hql=StringUtil.linkString(hql, " and ", "tibSysSoapMain.docIsNewVersion = :docIsNewVersion");
		hqlInfo.setParameter("docIsNewVersion", true);
		if(!StringUtil.isNull(categoryId)){
			hql=StringUtil.linkString(hql, " and ", "tibSysSoapMain.docCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
		}
		hqlInfo.setWhereBlock(hql);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysSoapMain.class);
		
	}
	
}
