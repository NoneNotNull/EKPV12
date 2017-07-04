package com.landray.kmss.tib.sys.sap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibSysSapRfcCategoryTreeServiceImp implements IXMLDataBean {
	private ITibSysSapRfcCategoryService tibSysSapRfcCategoryService = null;

	public List getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		String flag = requestInfo.getParameter("flag");
		HQLInfo hqlInfo = new HQLInfo();

		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibSysSapRfcCategory.hbmParent is null");

		} else {
			hqlInfo.setWhereBlock("tibSysSapRfcCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		if (StringUtil.isNotNull(hqlInfo.getWhereBlock())) {
			hqlInfo.setOrderBy("tibSysSapRfcCategory.fdOrder");
			List result = tibSysSapRfcCategoryService.findList(hqlInfo);

			List rtnValue = new ArrayList();
			for (int i = 0; i < result.size(); i++) {
				TibSysSapRfcCategory tibSysSapRfcCategory = (TibSysSapRfcCategory) result.get(i);
				Map node = new HashMap();
				node.put("text", tibSysSapRfcCategory.getFdName());
				node.put("value", tibSysSapRfcCategory.getFdId());
				rtnValue.add(node);
			}

			return rtnValue;
		} else {
			return null;
		}
	}

	public ITibSysSapRfcCategoryService getTibSysSapRfcCategoryService() {
		return tibSysSapRfcCategoryService;
	}

	public void setTibSysSapRfcCategoryService(
			ITibSysSapRfcCategoryService tibSysSapRfcCategoryService) {
		this.tibSysSapRfcCategoryService = tibSysSapRfcCategoryService;
	}

}
