/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.StringUtil;

/**
 * @author qiujh
 * @version 1.0 2013-12-31
 */
public class TibSysSoapSettingIndexAction extends ExtendAction {
	protected ITibSysSoapSettingService TibSysSoapSettingService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (TibSysSoapSettingService == null)
			TibSysSoapSettingService = (ITibSysSoapSettingService) getBean("tibSysSoapSettingService");
		return TibSysSoapSettingService;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String categoryId = request.getParameter("categoryId");
		String hql=hqlInfo.getWhereBlock();
		//hql=StringUtil.linkString(hql, " and ", "tibSysSoapSetting.docIsNewVersion = :docIsNewVersion");
		//hqlInfo.setParameter("docIsNewVersion", true);
		if(!StringUtil.isNull(categoryId)){
			hql=StringUtil.linkString(hql, " and ", "tibSysSoapSetting.settCategory.fdHierarchyId like :fdHierarchyId ");
			hqlInfo.setParameter("fdHierarchyId", "%"+categoryId+"%");
		}
		hqlInfo.setWhereBlock(hql);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysSoapSetting.class);
	}
}
