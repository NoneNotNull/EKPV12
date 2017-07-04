package com.landray.kmss.tib.sap.sync.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncCategory;
import com.landray.kmss.tib.sap.sync.service.ITibSapSyncCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibSapSyncCategoryTreeServiceImp implements IXMLDataBean  {
	
	private ITibSapSyncCategoryService tibSapSyncCategoryService;

	public List getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();

		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibSapSyncCategory.hbmParent is null");

		} else {
			hqlInfo.setWhereBlock("tibSapSyncCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			hqlInfo.setOrderBy("tibSapSyncCategory.fdOrder");
			List result = tibSapSyncCategoryService.findList(hqlInfo);

			List<Map<String,String>> rtnValue = new ArrayList<Map<String,String>>();
			for (int i = 0; i < result.size(); i++) {
				TibSapSyncCategory tibSapSyncCategory = (TibSapSyncCategory) result.get(i);
				Map<String,String> node = new HashMap<String,String>();
				node.put("text", tibSapSyncCategory.getFdName());
				node.put("value", tibSapSyncCategory.getFdId());
				node.put("href",requestInfo.getContextPath()+"/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=list&categoryId="+tibSapSyncCategory.getFdId());
				rtnValue.add(node);
			}

			return rtnValue;
		} else {
			return null;
		}
	}

	public ITibSapSyncCategoryService getTibSapSyncCategoryService() {
		return tibSapSyncCategoryService;
	}

	public void setTibSapSyncCategoryService(
			ITibSapSyncCategoryService tibSapSyncCategoryService) {
		this.tibSapSyncCategoryService = tibSapSyncCategoryService;
	}
	
	



}
