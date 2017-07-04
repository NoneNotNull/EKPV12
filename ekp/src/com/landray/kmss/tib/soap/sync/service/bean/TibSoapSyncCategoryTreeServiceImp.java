package com.landray.kmss.tib.soap.sync.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncCategory;
import com.landray.kmss.tib.soap.sync.service.ITibSoapSyncCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibSoapSyncCategoryTreeServiceImp implements IXMLDataBean  {
	
	private ITibSoapSyncCategoryService tibSoapSyncCategoryService;

	public List getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();

		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibSoapSyncCategory.hbmParent is null");

		} else {
			hqlInfo.setWhereBlock("tibSoapSyncCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			hqlInfo.setOrderBy("tibSoapSyncCategory.fdOrder");
			List result = tibSoapSyncCategoryService.findList(hqlInfo);

			List<Map<String,String>> rtnValue = new ArrayList<Map<String,String>>();
			for (int i = 0; i < result.size(); i++) {
				TibSoapSyncCategory tibSoapSyncCategory = (TibSoapSyncCategory) result.get(i);
				Map<String,String> node = new HashMap<String,String>();
				node.put("text", tibSoapSyncCategory.getFdName());
				node.put("value", tibSoapSyncCategory.getFdId());
				node.put("href",requestInfo.getContextPath()+"/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=list&categoryId="+tibSoapSyncCategory.getFdId());
				rtnValue.add(node);
			}

			return rtnValue;
		} else {
			return null;
		}
	}

	public ITibSoapSyncCategoryService getTibSoapSyncCategoryService() {
		return tibSoapSyncCategoryService;
	}

	public void setTibSoapSyncCategoryService(
			ITibSoapSyncCategoryService tibSoapSyncCategoryService) {
		this.tibSoapSyncCategoryService = tibSoapSyncCategoryService;
	}
	
	



}
