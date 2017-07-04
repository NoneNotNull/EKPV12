package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.jdbc.service.ITibJdbcDataSetCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibJdbcDataSetCategoryTreeServiceImp implements IXMLDataBean {
	private ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService;

	public ITibJdbcDataSetCategoryService getTibJdbcDataSetCategoryService() {
		return tibJdbcDataSetCategoryService;
	}

	public void setTibJdbcDataSetCategoryService(
			ITibJdbcDataSetCategoryService tibJdbcDataSetCategoryService) {
		this.tibJdbcDataSetCategoryService = tibJdbcDataSetCategoryService;
	}


	public List getDataList(RequestContext requestInfo) throws Exception {

		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setSelectBlock("tibJdbcDataSetCategory.fdName, tibJdbcDataSetCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibJdbcDataSetCategory.hbmParent is null");
		} else {
			hqlInfo
					.setWhereBlock("tibJdbcDataSetCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<?> result = tibJdbcDataSetCategoryService.findList(hqlInfo);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			node.put("text", obj[0].toString());
			node.put("value", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;

	}
}
