package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapSettCategoryTreeServiceImp  implements IXMLDataBean{
	private ITibSysSoapSettCategoryService tibSysSoapSettCategoryService;
	
	public List<Map<String, String>> getDataList(RequestContext requestInfo) throws Exception {
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibSysSoapSettCategory.fdName, tibSysSoapSettCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibSysSoapSettCategory.hbmParent is null");
		} else {
			hqlInfo
					.setWhereBlock("tibSysSoapSettCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<?> result = tibSysSoapSettCategoryService.findList(hqlInfo);
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
	public ITibSysSoapSettCategoryService getTibSysSoapSettCategoryService() {
		return tibSysSoapSettCategoryService;
	}
	public void setTibSysSoapSettCategoryService(
			ITibSysSoapSettCategoryService tibSysSoapSettCategoryService) {
		this.tibSysSoapSettCategoryService = tibSysSoapSettCategoryService;
	}
	
	
	
}
